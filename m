Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab2KNJob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:44:31 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:59961 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833Ab2KNJmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:42:32 -0500
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [RFC PATCH 06/10] s390/pci: CHSC PCI support for error and availability events
Date: Wed, 14 Nov 2012 10:41:38 +0100
Message-Id: <4d72dd60418fe8dc886049e64dfc180ec918e628.1352719878.git.jang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
In-Reply-To: <cover.1352719877.git.jang@linux.vnet.ibm.com>
References: <cover.1352719877.git.jang@linux.vnet.ibm.com>
x-cbid: 12111409-0542-0000-0000-0000039280AE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CHSC store-event-information support for PCI (notfication type 2)
and report error and availability events to the PCI architecture layer.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
---
 arch/s390/include/asm/pci.h |   4 ++
 arch/s390/pci/Makefile      |   3 +-
 arch/s390/pci/pci_event.c   |  93 ++++++++++++++++++++++++++
 drivers/s390/cio/chsc.c     | 156 +++++++++++++++++++++++++++++++-------------
 4 files changed, 211 insertions(+), 45 deletions(-)
 create mode 100644 arch/s390/pci/pci_event.c

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index ca48caf..3dc2cb6 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -127,6 +127,10 @@ void zpci_teardown_msi_irq(struct zpci_dev *, struct msi_desc *);
 int zpci_msihash_init(void);
 void zpci_msihash_exit(void);
 
+/* Error handling and recovery */
+void zpci_event_error(void *);
+void zpci_event_availability(void *);
+
 /* Helpers */
 struct zpci_dev *get_zdev(struct pci_dev *);
 struct zpci_dev *get_zdev_by_fid(u32);
diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
index 4590596..7e36f42 100644
--- a/arch/s390/pci/Makefile
+++ b/arch/s390/pci/Makefile
@@ -2,4 +2,5 @@
 # Makefile for the s390 PCI subsystem.
 #
 
-obj-$(CONFIG_PCI)	+= pci.o pci_dma.o pci_clp.o pci_msi.o
+obj-$(CONFIG_PCI)	+= pci.o pci_dma.o pci_clp.o pci_msi.o \
+			   pci_event.o
diff --git a/arch/s390/pci/pci_event.c b/arch/s390/pci/pci_event.c
new file mode 100644
index 0000000..dbed8cd
--- /dev/null
+++ b/arch/s390/pci/pci_event.c
@@ -0,0 +1,93 @@
+/*
+ *  Copyright IBM Corp. 2012
+ *
+ *  Author(s):
+ *    Jan Glauber <jang@linux.vnet.ibm.com>
+ */
+
+#define COMPONENT "zPCI"
+#define pr_fmt(fmt) COMPONENT ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+
+/* Content Code Description for PCI Function Error */
+struct zpci_ccdf_err {
+	u32 reserved1;
+	u32 fh;				/* function handle */
+	u32 fid;			/* function id */
+	u32 ett		:  4;		/* expected table type */
+	u32 mvn		: 12;		/* MSI vector number */
+	u32 dmaas	:  8;		/* DMA address space */
+	u32		:  6;
+	u32 q		:  1;		/* event qualifier */
+	u32 rw		:  1;		/* read/write */
+	u64 faddr;			/* failing address */
+	u32 reserved3;
+	u16 reserved4;
+	u16 pec;			/* PCI event code */
+} __packed;
+
+/* Content Code Description for PCI Function Availability */
+struct zpci_ccdf_avail {
+	u32 reserved1;
+	u32 fh;				/* function handle */
+	u32 fid;			/* function id */
+	u32 reserved2;
+	u32 reserved3;
+	u32 reserved4;
+	u32 reserved5;
+	u16 reserved6;
+	u16 pec;			/* PCI event code */
+} __packed;
+
+static void zpci_event_log_err(struct zpci_ccdf_err *ccdf)
+{
+	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
+
+	dev_err(&zdev->pdev->dev, "event code: 0x%x\n", ccdf->pec);
+}
+
+static void zpci_event_log_avail(struct zpci_ccdf_avail *ccdf)
+{
+	struct zpci_dev *zdev = get_zdev_by_fid(ccdf->fid);
+
+	pr_err("%s%s: availability event: fh: 0x%x  fid: 0x%x  event code: 0x%x  reason:",
+		(zdev) ? dev_driver_string(&zdev->pdev->dev) : "?",
+		(zdev) ? dev_name(&zdev->pdev->dev) : "?",
+		ccdf->fh, ccdf->fid, ccdf->pec);
+	print_hex_dump(KERN_CONT, "ccdf", DUMP_PREFIX_OFFSET,
+		       16, 1, ccdf, sizeof(*ccdf), false);
+
+	switch (ccdf->pec) {
+	case 0x0301:
+		zpci_enable_device(zdev);
+		break;
+	case 0x0302:
+		clp_add_pci_device(ccdf->fid, ccdf->fh, 0);
+		break;
+	case 0x0306:
+		clp_find_pci_devices();
+		break;
+	default:
+		break;
+	}
+}
+
+void zpci_event_error(void *data)
+{
+	struct zpci_ccdf_err *ccdf = data;
+	struct zpci_dev *zdev;
+
+	zpci_event_log_err(ccdf);
+	zdev = get_zdev_by_fid(ccdf->fid);
+	if (!zdev) {
+		pr_err("Error event for unknown fid: %x", ccdf->fid);
+		return;
+	}
+}
+
+void zpci_event_availability(void *data)
+{
+	zpci_event_log_avail(data);
+}
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 4d51a7c..68e80e2 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -1,7 +1,7 @@
 /*
  *   S/390 common I/O routines -- channel subsystem call
  *
- *    Copyright IBM Corp. 1999, 2010
+ *    Copyright IBM Corp. 1999,2012
  *    Author(s): Ingo Adlung (adlung@de.ibm.com)
  *		 Cornelia Huck (cornelia.huck@de.ibm.com)
  *		 Arnd Bergmann (arndb@de.ibm.com)
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/pci.h>
 
 #include <asm/cio.h>
 #include <asm/chpid.h>
@@ -260,26 +261,45 @@ __get_chpid_from_lir(void *data)
 	return (u16) (lir->indesc[0]&0x000000ff);
 }
 
-struct chsc_sei_area {
-	struct chsc_header request;
+struct chsc_sei_nt0_area {
+	u8  flags;
+	u8  vf;				/* validity flags */
+	u8  rs;				/* reporting source */
+	u8  cc;				/* content code */
+	u16 fla;			/* full link address */
+	u16 rsid;			/* reporting source id */
 	u32 reserved1;
 	u32 reserved2;
-	u32 reserved3;
-	struct chsc_header response;
-	u32 reserved4;
-	u8  flags;
-	u8  vf;		/* validity flags */
-	u8  rs;		/* reporting source */
-	u8  cc;		/* content code */
-	u16 fla;	/* full link address */
-	u16 rsid;	/* reporting source id */
-	u32 reserved5;
-	u32 reserved6;
-	u8 ccdf[4096 - 16 - 24];	/* content-code dependent field */
 	/* ccdf has to be big enough for a link-incident record */
-} __attribute__ ((packed));
-
-static void chsc_process_sei_link_incident(struct chsc_sei_area *sei_area)
+	u8  ccdf[PAGE_SIZE - 24 - 16];	/* content-code dependent field */
+} __packed;
+
+struct chsc_sei_nt2_area {
+	u8  flags;			/* p and v bit */
+	u8  reserved1;
+	u8  reserved2;
+	u8  cc;				/* content code */
+	u32 reserved3[13];
+	u8  ccdf[PAGE_SIZE - 24 - 56];	/* content-code dependent field */
+} __packed;
+
+#define CHSC_SEI_NT0	0ULL
+#define CHSC_SEI_NT2	(1ULL << 61)
+
+struct chsc_sei {
+	struct chsc_header request;
+	u32 reserved1;
+	u64 ntsm;			/* notification type mask */
+	struct chsc_header response;
+	u32 reserved2;
+	union {
+		struct chsc_sei_nt0_area nt0_area;
+		struct chsc_sei_nt2_area nt2_area;
+		u8 nt_area[PAGE_SIZE - 24];
+	} u;
+} __packed;
+
+static void chsc_process_sei_link_incident(struct chsc_sei_nt0_area *sei_area)
 {
 	struct chp_id chpid;
 	int id;
@@ -298,7 +318,7 @@ static void chsc_process_sei_link_incident(struct chsc_sei_area *sei_area)
 	}
 }
 
-static void chsc_process_sei_res_acc(struct chsc_sei_area *sei_area)
+static void chsc_process_sei_res_acc(struct chsc_sei_nt0_area *sei_area)
 {
 	struct chp_link link;
 	struct chp_id chpid;
@@ -330,7 +350,7 @@ static void chsc_process_sei_res_acc(struct chsc_sei_area *sei_area)
 	s390_process_res_acc(&link);
 }
 
-static void chsc_process_sei_chp_avail(struct chsc_sei_area *sei_area)
+static void chsc_process_sei_chp_avail(struct chsc_sei_nt0_area *sei_area)
 {
 	struct channel_path *chp;
 	struct chp_id chpid;
@@ -366,7 +386,7 @@ struct chp_config_data {
 	u8 pc;
 };
 
-static void chsc_process_sei_chp_config(struct chsc_sei_area *sei_area)
+static void chsc_process_sei_chp_config(struct chsc_sei_nt0_area *sei_area)
 {
 	struct chp_config_data *data;
 	struct chp_id chpid;
@@ -398,7 +418,7 @@ static void chsc_process_sei_chp_config(struct chsc_sei_area *sei_area)
 	}
 }
 
-static void chsc_process_sei_scm_change(struct chsc_sei_area *sei_area)
+static void chsc_process_sei_scm_change(struct chsc_sei_nt0_area *sei_area)
 {
 	int ret;
 
@@ -412,13 +432,26 @@ static void chsc_process_sei_scm_change(struct chsc_sei_area *sei_area)
 			      " failed (rc=%d).\n", ret);
 }
 
-static void chsc_process_sei(struct chsc_sei_area *sei_area)
+static void chsc_process_sei_nt2(struct chsc_sei_nt2_area *sei_area)
 {
-	/* Check if we might have lost some information. */
-	if (sei_area->flags & 0x40) {
-		CIO_CRW_EVENT(2, "chsc: event overflow\n");
-		css_schedule_eval_all();
+#ifdef CONFIG_PCI
+	switch (sei_area->cc) {
+	case 1:
+		zpci_event_error(sei_area->ccdf);
+		break;
+	case 2:
+		zpci_event_availability(sei_area->ccdf);
+		break;
+	default:
+		CIO_CRW_EVENT(2, "chsc: unhandled sei content code %d\n",
+			      sei_area->cc);
+		break;
 	}
+#endif
+}
+
+static void chsc_process_sei_nt0(struct chsc_sei_nt0_area *sei_area)
+{
 	/* which kind of information was stored? */
 	switch (sei_area->cc) {
 	case 1: /* link incident*/
@@ -443,9 +476,51 @@ static void chsc_process_sei(struct chsc_sei_area *sei_area)
 	}
 }
 
+static int __chsc_process_crw(struct chsc_sei *sei, u64 ntsm)
+{
+	do {
+		memset(sei, 0, sizeof(*sei));
+		sei->request.length = 0x0010;
+		sei->request.code = 0x000e;
+		sei->ntsm = ntsm;
+
+		if (chsc(sei))
+			break;
+
+		if (sei->response.code == 0x0001) {
+			CIO_CRW_EVENT(2, "chsc: sei successful\n");
+
+			/* Check if we might have lost some information. */
+			if (sei->u.nt0_area.flags & 0x40) {
+				CIO_CRW_EVENT(2, "chsc: event overflow\n");
+				css_schedule_eval_all();
+			}
+
+			switch (sei->ntsm) {
+			case CHSC_SEI_NT0:
+				chsc_process_sei_nt0(&sei->u.nt0_area);
+				return 1;
+			case CHSC_SEI_NT2:
+				chsc_process_sei_nt2(&sei->u.nt2_area);
+				return 1;
+			default:
+				CIO_CRW_EVENT(2, "chsc: unhandled nt (nt=%08Lx)\n",
+					      sei->ntsm);
+				return 0;
+			}
+		} else {
+			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x)\n",
+				      sei->response.code);
+			break;
+		}
+	} while (sei->u.nt0_area.flags & 0x80);
+
+	return 0;
+}
+
 static void chsc_process_crw(struct crw *crw0, struct crw *crw1, int overflow)
 {
-	struct chsc_sei_area *sei_area;
+	struct chsc_sei *sei;
 
 	if (overflow) {
 		css_schedule_eval_all();
@@ -459,25 +534,18 @@ static void chsc_process_crw(struct crw *crw0, struct crw *crw1, int overflow)
 		return;
 	/* Access to sei_page is serialized through machine check handler
 	 * thread, so no need for locking. */
-	sei_area = sei_page;
+	sei = sei_page;
 
 	CIO_TRACE_EVENT(2, "prcss");
-	do {
-		memset(sei_area, 0, sizeof(*sei_area));
-		sei_area->request.length = 0x0010;
-		sei_area->request.code = 0x000e;
-		if (chsc(sei_area))
-			break;
 
-		if (sei_area->response.code == 0x0001) {
-			CIO_CRW_EVENT(4, "chsc: sei successful\n");
-			chsc_process_sei(sei_area);
-		} else {
-			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x)\n",
-				      sei_area->response.code);
-			break;
-		}
-	} while (sei_area->flags & 0x80);
+	/*
+	 * The ntsm does not allow to select NT0 and NT2 together. We need to
+	 * first check for NT2, than additionally for NT0...
+	 */
+#ifdef CONFIG_PCI
+	if (!__chsc_process_crw(sei, CHSC_SEI_NT2))
+#endif
+		__chsc_process_crw(sei, CHSC_SEI_NT0);
 }
 
 void chsc_chp_online(struct chp_id chpid)
-- 
1.7.12.4

