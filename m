Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab0L1U1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:27:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:22841 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0L1U1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:27:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,240,1291622400"; 
   d="scan'208";a="691458187"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        "Borislav Petkov" <bp@alien8.de>, "David Miller" <davem@davemloft.net>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Jim Keniston" <jkenisto@linux.vnet.ibm.com>,
        "Kyungmin Park" <kmpark@infradead.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2of2] pstore: X86 platform interface using ACPI/APEI/ERST
Date: Tue, 28 Dec 2010 12:27:46 -0800
Message-Id: <4d1a4842577485fcc@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'error record serialization table' in ACPI provides a suitable
amount of persistent storage for use by the pstore filesystem.

Signed-off-by: Tony Luck <tony.luck@intel.com>

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
index 5850d32..f54cab6 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -34,6 +34,7 @@
 #include <linux/cper.h>
 #include <linux/nmi.h>
 #include <linux/hardirq.h>
+#include <linux/pstore.h>
 #include <acpi/apei.h>
 
 #include "apei-internal.h"
@@ -781,6 +782,125 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
 	return 0;
 }
 
+static size_t erst_reader(u64 *id, enum pstore_type_id *type,
+		       struct timespec *time);
+static u64 erst_writer(enum pstore_type_id type, size_t size);
+
+static struct pstore_info erst_info = {
+	.owner		= THIS_MODULE,
+	.name		= "erst",
+	.read		= erst_reader,
+	.write		= erst_writer,
+	.erase		= erst_clear
+};
+
+#define CPER_CREATOR_PSTORE						\
+	UUID_LE(0x75a574e3, 0x5052, 0x4b29, 0x8a, 0x8e, 0xbe, 0x2c,	\
+		0x64, 0x90, 0xb8, 0x9d)
+#define CPER_SECTION_TYPE_DMESG						\
+	UUID_LE(0xc197e04e, 0xd545, 0x4a70, 0x9c, 0x17, 0xa5, 0x54,	\
+		0x94, 0x19, 0xeb, 0x12)
+#define CPER_SECTION_TYPE_MCE						\
+	UUID_LE(0xfe08ffbe, 0x95e4, 0x4be7, 0xbc, 0x73, 0x40, 0x96,	\
+		0x04, 0x4a, 0x38, 0xfc)
+
+struct cper_pstore_record {
+	struct cper_record_header hdr;
+	struct cper_section_descriptor sec_hdr;
+	char data[];
+} __packed;
+
+static size_t erst_reader(u64 *id, enum pstore_type_id *type,
+		       struct timespec *time)
+{
+	int rc;
+	ssize_t len;
+	unsigned long flags;
+	u64 record_id;
+	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
+					(erst_info.buf - sizeof(*rcd));
+
+	if (erst_disable)
+		return -ENODEV;
+
+	raw_spin_lock_irqsave(&erst_lock, flags);
+	rc = __erst_get_next_record_id(&record_id);
+	if (rc) {
+		raw_spin_unlock_irqrestore(&erst_lock, flags);
+		return rc;
+	}
+	/* no more record */
+	if (record_id == APEI_ERST_INVALID_RECORD_ID) {
+		raw_spin_unlock_irqrestore(&erst_lock, flags);
+		return 0;
+	}
+
+	len = __erst_read(record_id, &rcd->hdr, sizeof(*rcd) +
+			  erst_erange.size);
+	raw_spin_unlock_irqrestore(&erst_lock, flags);
+
+	*id = record_id;
+	if (uuid_le_cmp(rcd->sec_hdr.section_type,
+			CPER_SECTION_TYPE_DMESG) == 0)
+		*type = PSTORE_TYPE_DMESG;
+	else if (uuid_le_cmp(rcd->sec_hdr.section_type,
+			     CPER_SECTION_TYPE_MCE) == 0)
+		*type = PSTORE_TYPE_MCE;
+	else
+		*type = PSTORE_TYPE_UNKNOWN;
+
+	if (rcd->hdr.validation_bits & CPER_VALID_TIMESTAMP)
+		time->tv_sec = rcd->hdr.timestamp;
+	else
+		time->tv_sec = 0;
+	time->tv_nsec = 0;
+
+	return len - sizeof(*rcd);
+}
+
+static u64 erst_writer(enum pstore_type_id type, size_t size)
+{
+	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
+					(erst_info.buf - sizeof(*rcd));
+
+	memset(rcd, 0, sizeof(*rcd));
+	memcpy(rcd->hdr.signature, CPER_SIG_RECORD, CPER_SIG_SIZE);
+	rcd->hdr.revision = CPER_RECORD_REV;
+	rcd->hdr.signature_end = CPER_SIG_END;
+	rcd->hdr.section_count = 1;
+	rcd->hdr.error_severity = CPER_SEV_FATAL;
+	/* timestamp valid. platform_id, partition_id are invalid */
+	rcd->hdr.validation_bits = CPER_VALID_TIMESTAMP;
+	rcd->hdr.timestamp = get_seconds();
+	rcd->hdr.record_length = sizeof(*rcd) + size;
+	rcd->hdr.creator_id = CPER_CREATOR_PSTORE;
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
+	erst_write(&rcd->hdr);
+
+	return rcd->hdr.record_id;
+}
+
 static int __init erst_init(void)
 {
 	int rc = 0;
@@ -788,6 +908,7 @@ static int __init erst_init(void)
 	struct apei_exec_context ctx;
 	struct apei_resources erst_resources;
 	struct resource *r;
+	char *buf;
 
 	if (acpi_disabled)
 		goto err;
@@ -854,6 +975,18 @@ static int __init erst_init(void)
 	if (!erst_erange.vaddr)
 		goto err_release_erange;
 
+	buf = kmalloc(erst_erange.size, GFP_KERNEL);
+	mutex_init(&erst_info.buf_mutex);
+	if (buf) {
+		erst_info.buf = buf + sizeof(struct cper_pstore_record);
+		erst_info.bufsize = erst_erange.size -
+				    sizeof(struct cper_pstore_record);
+		if (pstore_register(&erst_info)) {
+			pr_info(ERST_PFX "Could not register with persistent store\n");
+			kfree(buf);
+		}
+	}
+
 	pr_info(ERST_PFX
 	"Error Record Serialization Table (ERST) support is initialized.\n");
 
