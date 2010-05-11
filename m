Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab0EKUvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:51:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:57990 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757959Ab0EKUuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:50:52 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/4] ibft: Update iBFT handling for v1.03 of the spec.
Date: Tue, 11 May 2010 18:04:14 +0000
Message-Id: <1273601057-5907-2-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273601057-5907-1-git-send-email-konrad@kernel.org>
References: <1273601057-5907-1-git-send-email-konrad@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 May 2010 20:49:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Jones <pjones@redhat.com>

- Use struct acpi_table_ibft instead of struct ibft_table_header
- Don't do reserve_ibft_region() on UEFI machines (section 1.4.3.1)
- If ibft_addr isn't initialized when ibft_init() is called, check for
  ACPI-based tables.
- Fix compiler error when CONFIG_ACPI is not defined.

Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
Signed-off-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/firmware/iscsi_ibft.c      |   30 ++++++++++++++++++------------
 drivers/firmware/iscsi_ibft_find.c |   35 ++++++++++++++++++++++++++++++-----
 include/linux/iscsi_ibft.h         |   12 ++----------
 3 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index ed2801c..b3ab24f 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright 2007 Red Hat, Inc.
+ *  Copyright 2007-2010 Red Hat, Inc.
  *  by Peter Jones <pjones@redhat.com>
  *  Copyright 2008 IBM, Inc.
  *  by Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
@@ -19,6 +19,9 @@
  *
  * Changelog:
  *
+ *  06 Jan 2010 - Peter Jones <pjones@redhat.com>
+ *    New changelog entries are in the git log from now on.  Not here.
+ *
  *  14 Mar 2008 - Konrad Rzeszutek <ketuzsezr@darnok.org>
  *    Updated comments and copyrights. (v0.4.9)
  *
@@ -78,9 +81,10 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/acpi.h>
 
-#define IBFT_ISCSI_VERSION "0.4.9"
-#define IBFT_ISCSI_DATE "2008-Mar-14"
+#define IBFT_ISCSI_VERSION "0.5.0"
+#define IBFT_ISCSI_DATE "2010-Feb-25"
 
 MODULE_AUTHOR("Peter Jones <pjones@redhat.com> and \
 Konrad Rzeszutek <ketuzsezr@darnok.org>");
@@ -238,7 +242,7 @@ static const char *ibft_initiator_properties[] =
  */
 
 struct ibft_kobject {
-	struct ibft_table_header *header;
+	struct acpi_table_ibft *header;
 	union {
 		struct ibft_initiator *initiator;
 		struct ibft_nic *nic;
@@ -536,12 +540,13 @@ static int __init ibft_check_device(void)
 	u8 *pos;
 	u8 csum = 0;
 
-	len = ibft_addr->length;
+	len = ibft_addr->header.length;
 
 	/* Sanity checking of iBFT. */
-	if (ibft_addr->revision != 1) {
+	if (ibft_addr->header.revision != 1) {
 		printk(KERN_ERR "iBFT module supports only revision 1, " \
-				"while this is %d.\n", ibft_addr->revision);
+				"while this is %d.\n",
+				ibft_addr->header.revision);
 		return -ENOENT;
 	}
 	for (pos = (u8 *)ibft_addr; pos < (u8 *)ibft_addr + len; pos++)
@@ -558,7 +563,7 @@ static int __init ibft_check_device(void)
 /*
  * Helper function for ibft_register_kobjects.
  */
-static int __init ibft_create_kobject(struct ibft_table_header *header,
+static int __init ibft_create_kobject(struct acpi_table_ibft *header,
 				       struct ibft_hdr *hdr,
 				       struct list_head *list)
 {
@@ -596,7 +601,7 @@ static int __init ibft_create_kobject(struct ibft_table_header *header,
 	default:
 		printk(KERN_ERR "iBFT has unknown structure type (%d). " \
 				"Report this bug to %.6s!\n", hdr->id,
-				header->oem_id);
+				header->header.oem_id);
 		rc = 1;
 		break;
 	}
@@ -649,7 +654,7 @@ out_invalid_struct:
  * found add them on the passed-in list. We do not support the other
  * fields at this point, so they are skipped.
  */
-static int __init ibft_register_kobjects(struct ibft_table_header *header,
+static int __init ibft_register_kobjects(struct acpi_table_ibft *header,
 					  struct list_head *list)
 {
 	struct ibft_control *control = NULL;
@@ -660,7 +665,7 @@ static int __init ibft_register_kobjects(struct ibft_table_header *header,
 
 	control = (void *)header + sizeof(*header);
 	end = (void *)control + control->hdr.length;
-	eot_offset = (void *)header + header->length - (void *)control;
+	eot_offset = (void *)header + header->header.length - (void *)control;
 	rc = ibft_verify_hdr("control", (struct ibft_hdr *)control, id_control,
 			     sizeof(*control));
 
@@ -672,7 +677,8 @@ static int __init ibft_register_kobjects(struct ibft_table_header *header,
 	}
 	for (ptr = &control->initiator_off; ptr < end; ptr += sizeof(u16)) {
 		offset = *(u16 *)ptr;
-		if (offset && offset < header->length && offset < eot_offset) {
+		if (offset && offset < header->header.length &&
+						offset < eot_offset) {
 			rc = ibft_create_kobject(header,
 						 (void *)header + offset,
 						 list);
diff --git a/drivers/firmware/iscsi_ibft_find.c b/drivers/firmware/iscsi_ibft_find.c
index d6470ef..dd85555 100644
--- a/drivers/firmware/iscsi_ibft_find.c
+++ b/drivers/firmware/iscsi_ibft_find.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright 2007 Red Hat, Inc.
+ *  Copyright 2007-2010 Red Hat, Inc.
  *  by Peter Jones <pjones@redhat.com>
  *  Copyright 2007 IBM, Inc.
  *  by Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
@@ -22,6 +22,7 @@
 #include <linux/blkdev.h>
 #include <linux/ctype.h>
 #include <linux/device.h>
+#include <linux/efi.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/limits.h>
@@ -30,13 +31,15 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/acpi.h>
+#include <linux/iscsi_ibft.h>
 
 #include <asm/mmzone.h>
 
 /*
  * Physical location of iSCSI Boot Format Table.
  */
-struct ibft_table_header *ibft_addr;
+struct acpi_table_ibft *ibft_addr;
 EXPORT_SYMBOL_GPL(ibft_addr);
 
 #define IBFT_SIGN "iBFT"
@@ -46,6 +49,13 @@ EXPORT_SYMBOL_GPL(ibft_addr);
 #define VGA_MEM 0xA0000 /* VGA buffer */
 #define VGA_SIZE 0x20000 /* 128kB */
 
+#ifdef CONFIG_ACPI
+static int __init acpi_find_ibft(struct acpi_table_header *header)
+{
+	ibft_addr = (struct acpi_table_ibft *)header;
+	return 0;
+}
+#endif /* CONFIG_ACPI */
 
 /*
  * Routine used to find the iSCSI Boot Format Table. The logical
@@ -59,6 +69,11 @@ unsigned long __init find_ibft_region(unsigned long *sizep)
 
 	ibft_addr = NULL;
 
+	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
+	 * only use ACPI for this */
+	if (efi_enabled)
+		return 0;
+
 	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
 		/* The table can't be inside the VGA BIOS reserved space,
 		 * so skip that area */
@@ -72,14 +87,24 @@ unsigned long __init find_ibft_region(unsigned long *sizep)
 			/* if the length of the table extends past 1M,
 			 * the table cannot be valid. */
 			if (pos + len <= (IBFT_END-1)) {
-				ibft_addr = (struct ibft_table_header *)virt;
+				ibft_addr = (struct acpi_table_ibft *)virt;
 				break;
 			}
 		}
 	}
+#ifdef CONFIG_ACPI
+	/*
+	 * One spec says "IBFT", the other says "iBFT". We have to check
+	 * for both.
+	 */
+	if (!ibft_addr)
+		acpi_table_parse(ACPI_SIG_IBFT, acpi_find_ibft);
+	if (!ibft_addr)
+		acpi_table_parse("iBFT", acpi_find_ibft);
+#endif /* CONFIG_ACPI */
 	if (ibft_addr) {
-		*sizep = PAGE_ALIGN(len);
-		return pos;
+		*sizep = PAGE_ALIGN(ibft_addr->header.length);
+		return (u64)isa_virt_to_bus(ibft_addr);
 	}
 
 	*sizep = 0;
diff --git a/include/linux/iscsi_ibft.h b/include/linux/iscsi_ibft.h
index d2e4042..8ba7e5b 100644
--- a/include/linux/iscsi_ibft.h
+++ b/include/linux/iscsi_ibft.h
@@ -21,21 +21,13 @@
 #ifndef ISCSI_IBFT_H
 #define ISCSI_IBFT_H
 
-struct ibft_table_header {
-	char signature[4];
-	u32 length;
-	u8 revision;
-	u8 checksum;
-	char oem_id[6];
-	char oem_table_id[8];
-	char reserved[24];
-} __attribute__((__packed__));
+#include <acpi/acpi.h>
 
 /*
  * Logical location of iSCSI Boot Format Table.
  * If the value is NULL there is no iBFT on the machine.
  */
-extern struct ibft_table_header *ibft_addr;
+extern struct acpi_table_ibft *ibft_addr;
 
 /*
  * Routine used to find and reserve the iSCSI Boot Format Table. The
-- 
1.7.1

