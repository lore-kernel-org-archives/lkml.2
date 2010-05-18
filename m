Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0ERGgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:36:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:12048 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab0ERGfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:35:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,253,1272870000"; 
   d="scan'208";a="622545446"
From: Huang Ying <ying.huang@intel.com>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org,
       linux-acpi@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH -v5 12/14] ACPI, APEI, Use ERST for persistent storage of MCE
Date: Tue, 18 May 2010 14:35:22 +0800
Message-Id: <1274164524-6092-13-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274164524-6092-1-git-send-email-ying.huang@intel.com>
References: <1274164524-6092-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Traditionally, fatal MCE will cause Linux print error log to console
then reboot. Because MCE registers will preserve their content after
warm reboot, the hardware error can be logged to disk or network after
reboot. But system may fail to warm reboot, then you may lose the
hardware error log. ERST can help here. Through saving the hardware
error log into flash via ERST before go panic, the hardware error log
can be gotten from the flash after system boot successful again.

The fatal MCE processing procedure with ERST involved is as follow:

- Hardware detect error, MCE raised
- MCE read MCE registers, check error severity (fatal), prepare error record
- Write MCE error record into flash via ERST
- Go panic, then trigger system reboot
- System reboot, /sbin/mcelog run, it reads /dev/mcelog to check flash
  for error record of previous boot via ERST, and output and clear
  them if available
- /sbin/mcelog logs error records into disk or network

ERST only accepts CPER record format, but there is no pre-defined CPER
section can accommodate all information in struct mce, so a customized
section type is defined to hold struct mce inside a CPER record as an
error section.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-apei.c     |   86 ++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   23 ++++++++
 arch/x86/kernel/cpu/mcheck/mce.c          |   79 +++++++++++++++++++++++----
 3 files changed, 177 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce-apei.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-apei.c
@@ -8,6 +8,9 @@
  * the error memory page can be offlined by /sbin/mcelog if the error
  * count for one page is beyond the threshold.
  *
+ * For fatal MCE, save MCE record into persistent storage via ERST, so
+ * that the MCE record can be logged after reboot via ERST.
+ *
  * Copyright 2010 Intel Corp.
  *   Author: Huang Ying <ying.huang@intel.com>
  *
@@ -50,3 +53,86 @@ void apei_mce_report_mem_error(int corre
 	mce_notify_irq();
 }
 EXPORT_SYMBOL_GPL(apei_mce_report_mem_error);
+
+#define CPER_CREATOR_MCE						\
+	UUID_LE(0x75a574e3, 0x5052, 0x4b29, 0x8a, 0x8e, 0xbe, 0x2c,	\
+		0x64, 0x90, 0xb8, 0x9d)
+#define CPER_SECTION_TYPE_MCE						\
+	UUID_LE(0xfe08ffbe, 0x95e4, 0x4be7, 0xbc, 0x73, 0x40, 0x96,	\
+		0x04, 0x4a, 0x38, 0xfc)
+
+/*
+ * CPER specification (in UEFI specification 2.3 appendix N) requires
+ * byte-packed.
+ */
+struct cper_mce_record {
+	struct cper_record_header hdr;
+	struct cper_section_descriptor sec_hdr;
+	struct mce mce;
+} __packed;
+
+int apei_write_mce(struct mce *m)
+{
+	struct cper_mce_record rcd;
+
+	memset(&rcd, 0, sizeof(rcd));
+	memcpy(rcd.hdr.signature, CPER_SIG_RECORD, CPER_SIG_SIZE);
+	rcd.hdr.revision = CPER_RECORD_REV;
+	rcd.hdr.signature_end = CPER_SIG_END;
+	rcd.hdr.section_count = 1;
+	rcd.hdr.error_severity = CPER_SER_FATAL;
+	/* timestamp, platform_id, partition_id are all invalid */
+	rcd.hdr.validation_bits = 0;
+	rcd.hdr.record_length = sizeof(rcd);
+	rcd.hdr.creator_id = CPER_CREATOR_MCE;
+	rcd.hdr.notification_type = CPER_NOTIFY_MCE;
+	rcd.hdr.record_id = cper_next_record_id();
+	rcd.hdr.flags = CPER_HW_ERROR_FLAGS_PREVERR;
+
+	rcd.sec_hdr.section_offset = (void *)&rcd.mce - (void *)&rcd;
+	rcd.sec_hdr.section_length = sizeof(rcd.mce);
+	rcd.sec_hdr.revision = CPER_SEC_REV;
+	/* fru_id and fru_text is invalid */
+	rcd.sec_hdr.validation_bits = 0;
+	rcd.sec_hdr.flags = CPER_SEC_PRIMARY;
+	rcd.sec_hdr.section_type = CPER_SECTION_TYPE_MCE;
+	rcd.sec_hdr.section_severity = CPER_SER_FATAL;
+
+	memcpy(&rcd.mce, m, sizeof(*m));
+
+	return erst_write(&rcd.hdr);
+}
+
+ssize_t apei_read_mce(struct mce *m, u64 *record_id)
+{
+	struct cper_mce_record rcd;
+	ssize_t len;
+
+	len = erst_read_next(&rcd.hdr, sizeof(rcd));
+	if (len <= 0)
+		return len;
+	/* Can not skip other records in storage via ERST unless clear them */
+	else if (len != sizeof(rcd) ||
+		 uuid_le_cmp(rcd.hdr.creator_id, CPER_CREATOR_MCE)) {
+		if (printk_ratelimit())
+			pr_warning(
+			"MCE-APEI: Can not skip the unknown record in ERST");
+		return -EIO;
+	}
+
+	memcpy(m, &rcd.mce, sizeof(*m));
+	*record_id = rcd.hdr.record_id;
+
+	return sizeof(*m);
+}
+
+/* Check whether there is record in ERST */
+int apei_check_mce(void)
+{
+	return erst_get_record_count();
+}
+
+int apei_clear_mce(u64 record_id)
+{
+	return erst_clear(record_id);
+}
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -28,3 +28,26 @@ extern int mce_ser;
 
 extern struct mce_bank *mce_banks;
 
+#ifdef CONFIG_ACPI_APEI
+int apei_write_mce(struct mce *m);
+ssize_t apei_read_mce(struct mce *m, u64 *record_id);
+int apei_check_mce(void);
+int apei_clear_mce(u64 record_id);
+#else
+static inline int apei_write_mce(struct mce *m)
+{
+	return -EINVAL;
+}
+static inline ssize_t apei_read_mce(struct mce *m, u64 *record_id)
+{
+	return 0;
+}
+static inline int apei_check_mce(void)
+{
+	return 0;
+}
+static inline int apei_clear_mce(u64 record_id)
+{
+	return -EINVAL;
+}
+#endif
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -264,7 +264,7 @@ static void wait_for_panic(void)
 
 static void mce_panic(char *msg, struct mce *final, char *exp)
 {
-	int i;
+	int i, apei_err = 0;
 
 	if (!fake_panic) {
 		/*
@@ -287,8 +287,11 @@ static void mce_panic(char *msg, struct
 		struct mce *m = &mcelog.entry[i];
 		if (!(m->status & MCI_STATUS_VAL))
 			continue;
-		if (!(m->status & MCI_STATUS_UC))
+		if (!(m->status & MCI_STATUS_UC)) {
 			print_mce(m);
+			if (!apei_err)
+				apei_err = apei_write_mce(m);
+		}
 	}
 	/* Now print uncorrected but with the final one last */
 	for (i = 0; i < MCE_LOG_LEN; i++) {
@@ -297,11 +300,17 @@ static void mce_panic(char *msg, struct
 			continue;
 		if (!(m->status & MCI_STATUS_UC))
 			continue;
-		if (!final || memcmp(m, final, sizeof(struct mce)))
+		if (!final || memcmp(m, final, sizeof(struct mce))) {
 			print_mce(m);
+			if (!apei_err)
+				apei_err = apei_write_mce(m);
+		}
 	}
-	if (final)
+	if (final) {
 		print_mce(final);
+		if (!apei_err)
+			apei_err = apei_write_mce(final);
+	}
 	if (cpu_missing)
 		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
 	print_mce_tail();
@@ -1493,6 +1502,43 @@ static void collect_tscs(void *data)
 	rdtscll(cpu_tsc[smp_processor_id()]);
 }
 
+static int mce_apei_read_done;
+
+/* Collect MCE record of previous boot in persistent storage via APEI ERST. */
+static int __mce_read_apei(char __user **ubuf, size_t usize)
+{
+	int rc;
+	u64 record_id;
+	struct mce m;
+
+	if (usize < sizeof(struct mce))
+		return -EINVAL;
+
+	rc = apei_read_mce(&m, &record_id);
+	/* Error or no more MCE record */
+	if (rc <= 0) {
+		mce_apei_read_done = 1;
+		return rc;
+	}
+	rc = -EFAULT;
+	if (copy_to_user(*ubuf, &m, sizeof(struct mce)))
+		return rc;
+	/*
+	 * In fact, we should have cleared the record after that has
+	 * been flushed to the disk or sent to network in
+	 * /sbin/mcelog, but we have no interface to support that now,
+	 * so just clear it to avoid duplication.
+	 */
+	rc = apei_clear_mce(record_id);
+	if (rc) {
+		mce_apei_read_done = 1;
+		return rc;
+	}
+	*ubuf += sizeof(struct mce);
+
+	return 0;
+}
+
 static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 			loff_t *off)
 {
@@ -1506,15 +1552,19 @@ static ssize_t mce_read(struct file *fil
 		return -ENOMEM;
 
 	mutex_lock(&mce_read_mutex);
+
+	if (!mce_apei_read_done) {
+		err = __mce_read_apei(&buf, usize);
+		if (err || buf != ubuf)
+			goto out;
+	}
+
 	next = rcu_dereference_check_mce(mcelog.next);
 
 	/* Only supports full reads right now */
-	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
-		mutex_unlock(&mce_read_mutex);
-		kfree(cpu_tsc);
-
-		return -EINVAL;
-	}
+	err = -EINVAL;
+	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce))
+		goto out;
 
 	err = 0;
 	prev = 0;
@@ -1562,10 +1612,15 @@ timeout:
 			memset(&mcelog.entry[i], 0, sizeof(struct mce));
 		}
 	}
+
+	if (err)
+		err = -EFAULT;
+
+out:
 	mutex_unlock(&mce_read_mutex);
 	kfree(cpu_tsc);
 
-	return err ? -EFAULT : buf - ubuf;
+	return err ? err : buf - ubuf;
 }
 
 static unsigned int mce_poll(struct file *file, poll_table *wait)
@@ -1573,6 +1628,8 @@ static unsigned int mce_poll(struct file
 	poll_wait(file, &mce_wait, wait);
 	if (rcu_dereference_check_mce(mcelog.next))
 		return POLLIN | POLLRDNORM;
+	if (!mce_apei_read_done && apei_check_mce())
+		return POLLIN | POLLRDNORM;
 	return 0;
 }
 
