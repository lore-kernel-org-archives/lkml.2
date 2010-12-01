Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0LAAVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:21:02 -0500
Received: from mga03.intel.com ([143.182.124.21]:3755 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab0LAAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:21:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="355255498"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: ying.huang@intel.com
Subject: [RFC] persistent store (version 2) (part 2 of 2)
Date: Tue, 30 Nov 2010 16:20:59 -0800
Message-Id: <4cf594eb167978312c@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the changes to ERST to use the persistent store.

-Tony

---

diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index fca34cc..e91680c 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -1,5 +1,6 @@
 config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
+	select PSTORE
 	depends on X86
 	help
 	  APEI allows to report errors (for example from the chipset)
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 1211c03..2a49015 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -34,6 +34,7 @@
 #include <linux/cper.h>
 #include <linux/nmi.h>
 #include <linux/hardirq.h>
+#include <linux/pstore.h>
 #include <acpi/apei.h>
 
 #include "apei-internal.h"
@@ -781,6 +782,111 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
 	return 0;
 }
 
+#define CPER_CREATOR_MCE						\
+	UUID_LE(0x75a574e3, 0x5052, 0x4b29, 0x8a, 0x8e, 0xbe, 0x2c,	\
+		0x64, 0x90, 0xb8, 0x9d)
+#define CPER_SECTION_TYPE_DMESG						\
+	UUID_LE(0xc197e04e, 0xd545, 0x4a70, 0x9c, 0x17, 0xa5, 0x54,	\
+		0x94, 0x19, 0xeb, 0x12)
+#define CPER_SECTION_TYPE_MCE						\
+	UUID_LE(0xfe08ffbe, 0x95e4, 0x4be7, 0xbc, 0x73, 0x40, 0x96,	\
+		0x04, 0x4a, 0x38, 0xfc)
+
+struct cper_mce_record {
+	struct cper_record_header hdr;
+	struct cper_section_descriptor sec_hdr;
+	char data[];
+} __packed;
+
+static int
+erst_reader(u64 *id, int *type, void *buf, unsigned long *size)
+{
+	int rc;
+	ssize_t len;
+	unsigned long flags;
+	u64 record_id;
+	struct cper_mce_record *rcd = buf;
+
+	if (erst_disable)
+		return -ENODEV;
+
+	spin_lock_irqsave(&erst_lock, flags);
+	rc = __erst_get_next_record_id(&record_id);
+	if (rc) {
+		spin_unlock_irqrestore(&erst_lock, flags);
+		return rc;
+	}
+	/* no more record */
+	if (record_id == APEI_ERST_INVALID_RECORD_ID) {
+		spin_unlock_irqrestore(&erst_lock, flags);
+		return 0;
+	}
+
+	len = __erst_read(record_id, &rcd->hdr, sizeof (struct cper_mce_record) +
+			  erst_erange.size);
+	spin_unlock_irqrestore(&erst_lock, flags);
+
+	*id = record_id;
+	if (uuid_le_cmp(rcd->sec_hdr.section_type, CPER_SECTION_TYPE_DMESG) == 0)
+		*type = PSTORE_TYPE_DMESG;
+	else if (uuid_le_cmp(rcd->sec_hdr.section_type, CPER_SECTION_TYPE_MCE) == 0)
+		*type = PSTORE_TYPE_MCE;
+	else
+		*type = PSTORE_TYPE_MCE + 1;
+	*size = len - sizeof (struct cper_mce_record);
+
+	return len;
+}
+
+static int
+erst_writer(int type, void *buf, unsigned long size)
+{
+	struct cper_mce_record *rcd = buf;
+
+	memset(rcd, 0, sizeof(*rcd));
+	memcpy(rcd->hdr.signature, CPER_SIG_RECORD, CPER_SIG_SIZE);
+	rcd->hdr.revision = CPER_RECORD_REV;
+	rcd->hdr.signature_end = CPER_SIG_END;
+	rcd->hdr.section_count = 1;
+	rcd->hdr.error_severity = CPER_SEV_FATAL;
+	/* timestamp, platform_id, partition_id are all invalid */
+	rcd->hdr.validation_bits = 0;
+	rcd->hdr.record_length = sizeof(*rcd) + size;
+	rcd->hdr.creator_id = CPER_CREATOR_MCE;
+	rcd->hdr.notification_type = CPER_NOTIFY_MCE;
+	rcd->hdr.record_id = cper_next_record_id();
+	rcd->hdr.flags = CPER_HW_ERROR_FLAGS_PREVERR;
+
+	rcd->sec_hdr.section_offset = sizeof(*rcd);
+	rcd->sec_hdr.section_length = size;
+	rcd->sec_hdr.revision = CPER_SEC_REV;
+	/* fru_id and fru_text is invalid */
+	rcd->sec_hdr.validation_bits = 0;
+	rcd->sec_hdr.flags = CPER_SEC_PRIMARY;
+	switch (type) {
+	case PSTORE_TYPE_DMESG:
+		rcd->sec_hdr.section_type = CPER_SECTION_TYPE_DMESG;
+		break;
+	case PSTORE_TYPE_MCE:
+		rcd->sec_hdr.section_type = CPER_SECTION_TYPE_MCE;
+		break;
+	default:
+		return -EINVAL;
+	}
+	rcd->sec_hdr.section_severity = CPER_SEV_FATAL;
+
+	return erst_write(&rcd->hdr);
+}
+
+static struct pstore_info erst_info = {
+	.header_size	= sizeof (struct cper_mce_record),
+	.data_size	= 0, /* initialized in erst_init() */
+	.footer_size	= 0,
+	.reader		= erst_reader,
+	.writer		= erst_writer,
+	.eraser		= erst_clear
+};
+
 static int __init erst_init(void)
 {
 	int rc = 0;
@@ -854,6 +960,10 @@ static int __init erst_init(void)
 	if (!erst_erange.vaddr)
 		goto err_release_erange;
 
+	erst_info.data_size = erst_erange.size - sizeof (struct cper_mce_record);
+	if (pstore_register(&erst_info))
+		pr_info(ERST_PFX "Could not register with persistent store\n");
+
 	pr_info(ERST_PFX
 	"Error Record Serialization Table (ERST) support is initialized.\n");
 
