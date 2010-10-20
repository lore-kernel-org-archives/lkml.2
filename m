Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0JTBiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:38:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:62723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab0JTBhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:37:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="565620658"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org
Subject: [PATCH 7/9] ACPI, APEI, Use ERST for hardware error persisting before panic
Date: Wed, 20 Oct 2010 09:36:58 +0800
Message-Id: <1287538620-7442-8-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrected/Recoverable hardware errors can usually be saved into disk
and/or sent to network for logging.  But if uncorrected/fatal hardware
errors occur, system may not reliable enough for desk and/or network
accessing and needs to go panic as soon as possible for error
containment.  In this situation, ERST can be used to save the valuable
error records into some persistent storage such as flash.

This patch implements herr_persist interface using ERST.  So that
hardware error device core can use ERST to save hardware error record
before panic.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/Kconfig |    1 
 drivers/acpi/apei/cper.c  |   19 +++++
 drivers/acpi/apei/erst.c  |  169 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cper.h      |    1 
 4 files changed, 190 insertions(+)

--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -29,6 +29,25 @@
 #include <linux/time.h>
 #include <linux/cper.h>
 #include <linux/acpi.h>
+#include <linux/herror_record.h>
+
+int herr_severity_to_cper(int herr_severity)
+{
+	switch (herr_severity) {
+	case HERR_SEV_NONE:
+		return CPER_SEV_INFORMATIONAL;
+	case HERR_SEV_CORRECTED:
+		return CPER_SEV_CORRECTED;
+	case HERR_SEV_RECOVERABLE:
+		return CPER_SEV_RECOVERABLE;
+	case HERR_SEV_FATAL:
+		return CPER_SEV_FATAL;
+	default:
+		BUG();
+		return CPER_SEV_FATAL;
+	}
+}
+EXPORT_SYMBOL_GPL(herr_severity_to_cper);
 
 /*
  * CPER record ID need to be unique even after reboot, because record
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -33,6 +33,7 @@
 #include <linux/uaccess.h>
 #include <linux/cper.h>
 #include <linux/nmi.h>
+#include <linux/herror.h>
 #include <linux/hardirq.h>
 #include <acpi/apei.h>
 
@@ -88,6 +89,12 @@ static struct erst_erange {
  */
 static DEFINE_SPINLOCK(erst_lock);
 
+static void *erst_buf;
+static unsigned int erst_buf_len;
+
+/* Prevent erst_buf from being accessed simultaneously */
+static DEFINE_MUTEX(erst_buf_mutex);
+
 static inline int erst_errno(int command_status)
 {
 	switch (command_status) {
@@ -774,6 +781,12 @@ static int __erst_write_to_nvram(const s
 	return -ENOSYS;
 }
 
+static int __erst_write_herr_record_to_nvram(const struct herr_record *ercd)
+{
+	/* do not print message, because printk is not safe for NMI */
+	return -ENOSYS;
+}
+
 static int __erst_read_to_erange_from_nvram(u64 record_id, u64 *offset)
 {
 	pr_unimpl_nvram();
@@ -910,6 +923,156 @@ out:
 }
 EXPORT_SYMBOL_GPL(erst_clear);
 
+#define CPER_CREATOR_ERST						\
+	UUID_LE(0xEACBBA0C, 0x803A, 0x4096, 0xB1, 0x1D, 0xC3, 0xC7,	\
+		0x6E, 0xE7, 0x94, 0xF9)
+
+#define CPER_SEC_HERR_RECORD						\
+	UUID_LE(0x633AB656, 0x6703, 0x11DF, 0x87, 0xCF, 0x00, 0x19,	\
+		0xD1, 0x2A, 0x29, 0xEF)
+
+static ssize_t erst_herr_record_to_cper(struct cper_record_header *crcd,
+					size_t buf_size,
+					const struct herr_record *ercd)
+{
+	struct cper_section_descriptor *csec;
+	unsigned int crcd_len;
+	void *csec_data;
+
+	crcd_len = sizeof(*crcd) + sizeof(*csec) + ercd->length;
+	if (crcd_len > buf_size)
+		return crcd_len;
+
+	memset(crcd, 0, crcd_len);
+	memcpy(crcd->signature, CPER_SIG_RECORD, CPER_SIG_SIZE);
+	crcd->revision = CPER_RECORD_REV;
+	crcd->signature_end = CPER_SIG_END;
+	crcd->error_severity = herr_severity_to_cper(ercd->severity);
+	/* timestamp, platform_id, partition_id is invalid */
+	crcd->validation_bits = 0;
+	crcd->creator_id = CPER_CREATOR_ERST;
+	crcd->section_count = 1;
+	crcd->record_length = crcd_len;
+	crcd->record_id = ercd->id;
+
+	csec = (struct cper_section_descriptor *)(crcd + 1);
+	csec_data = csec + 1;
+
+	csec->section_length = ercd->length;
+	csec->revision = CPER_SEC_REV;
+	csec->section_type = CPER_SEC_HERR_RECORD;
+	csec->section_severity = crcd->error_severity;
+	csec->section_offset = (void *)csec_data - (void *)crcd;
+
+	memcpy(csec_data, ercd, ercd->length);
+
+	return crcd_len;
+}
+
+static int erst_write_herr_record(const struct herr_record *ercd)
+{
+	struct cper_record_header *crcd;
+	ssize_t crcd_len;
+	unsigned long flags;
+	int rc;
+
+	if (!spin_trylock_irqsave(&erst_lock, flags))
+		return -EBUSY;
+
+	if (erst_erange.attr & ERST_RANGE_NVRAM) {
+		rc = __erst_write_herr_record_to_nvram(ercd);
+		goto out;
+	}
+
+	rc = -EINVAL;
+	crcd_len = erst_herr_record_to_cper(erst_erange.vaddr,
+					    erst_erange.size, ercd);
+	if (crcd_len > erst_erange.size)
+		goto out;
+	crcd = erst_erange.vaddr;
+	/* signature for serialization system */
+	memcpy(&crcd->persistence_information, "ER", 2);
+	rc = __erst_write_to_storage(0);
+out:
+	spin_unlock_irqrestore(&erst_lock, flags);
+
+	return rc;
+}
+
+static ssize_t erst_persist_peek_user(u64 *record_id, char __user *ubuf,
+				      size_t usize)
+{
+	int rc, pos;
+	ssize_t len, clen;
+	u64 id;
+	struct cper_record_header *crcd;
+	struct cper_section_descriptor *csec;
+	struct herr_record *ercd;
+
+	if (mutex_lock_interruptible(&erst_buf_mutex) != 0)
+		return -EINTR;
+	erst_get_record_id_begin(&pos);
+retry_next:
+	len = 0;
+	rc = erst_get_record_id_next(&pos, &id);
+	if (rc)
+		goto out;
+	/* no more record */
+	if (id == APEI_ERST_INVALID_RECORD_ID)
+		goto out;
+retry:
+	rc = clen = erst_read(id, erst_buf, erst_buf_len);
+	/* someone else has cleared the record, try next one */
+	if (rc == -ENOENT)
+		goto retry_next;
+	else if (rc < 0)
+		goto out;
+	else if (clen > erst_buf_len) {
+		void *p;
+		rc = -ENOMEM;
+		p = kmalloc(clen, GFP_KERNEL);
+		if (!p)
+			goto out;
+		kfree(erst_buf);
+		erst_buf = p;
+		erst_buf_len = clen;
+		goto retry;
+	}
+
+	crcd = erst_buf;
+	csec = (struct cper_section_descriptor *)(crcd + 1);
+	if (crcd->section_count != 1 ||
+	    uuid_le_cmp(crcd->creator_id, CPER_CREATOR_ERST) ||
+	    uuid_le_cmp(csec->section_type, CPER_SEC_HERR_RECORD))
+		goto retry_next;
+
+	ercd = (struct herr_record *)(csec + 1);
+	len = ercd->length;
+
+	rc = -EINVAL;
+	if (len > usize)
+		goto out;
+
+	ercd->flags |= HERR_RCD_PREV | HERR_RCD_PERSIST;
+
+	rc = -EFAULT;
+	if (copy_to_user(ubuf, ercd, len))
+		goto out;
+	*record_id = id;
+	rc = 0;
+out:
+	erst_get_record_id_end();
+	mutex_unlock(&erst_buf_mutex);
+	return rc ? rc : len;
+}
+
+static struct herr_persist erst_persist = {
+	.name		= "ERST",
+	.in		= erst_write_herr_record,
+	.peek_user	= erst_persist_peek_user,
+	.clear		= erst_clear,
+};
+
 static int __init setup_erst_disable(char *str)
 {
 	erst_disable = 1;
@@ -1007,11 +1170,17 @@ static int __init erst_init(void)
 	if (!erst_erange.vaddr)
 		goto err_release_erange;
 
+	rc = herr_persist_register(&erst_persist);
+	if (rc)
+		goto err_unmap_erange;
+
 	pr_info(ERST_PFX
 	"Error Record Serialization Table (ERST) support is initialized.\n");
 
 	return 0;
 
+err_unmap_erange:
+	iounmap(erst_erange.vaddr);
 err_release_erange:
 	release_mem_region(erst_erange.base, erst_erange.size);
 err_unmap_reg:
--- a/include/linux/cper.h
+++ b/include/linux/cper.h
@@ -309,6 +309,7 @@ struct cper_sec_mem_err {
 /* Reset to default packing */
 #pragma pack()
 
+int herr_severity_to_cper(int herr_severity);
 u64 cper_next_record_id(void);
 
 #endif
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -1,6 +1,7 @@
 config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
 	depends on X86
+	select HERR_DEV_CORE
 	help
 	  APEI allows to report errors (for example from the chipset)
 	  to the operating system. This improves NMI handling
