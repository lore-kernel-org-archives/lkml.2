Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1BEO30 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:29:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1BEOVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SBuyKqJswdKfOc/8v6KRLQRVIxc2GQSiJYIhGjUahupnQ3h8wbkypGVNDo2aAwBy4g
         X16yBXfXG9qeaps3t67gIzxBnJ8Ya/EZVofa9aYaAiAKbycVljhiIqRn+aGP6dMlRtSY
         2c/l1UCBI/YRqXdTifjhoFpmCejTn+hvYdjnc=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 16/52] kstrtox: convert drivers/edac/
Date: Sat,  5 Feb 2011 16:20:19 +0200
Message-Id: <1296915654-7458-16-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/edac/amd64_edac_inj.c |  135 +++++++++++++++++------------------------
 drivers/edac/edac_mc_sysfs.c  |   20 +++---
 drivers/edac/i7core_edac.c    |   41 +++++++------
 drivers/edac/mce_amd_inj.c    |   28 ++++-----
 4 files changed, 101 insertions(+), 123 deletions(-)

diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
index 688478d..180a498 100644
--- a/drivers/edac/amd64_edac_inj.c
+++ b/drivers/edac/amd64_edac_inj.c
@@ -16,21 +16,18 @@ static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
 					  const char *data, size_t count)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	unsigned long value;
-	int ret = 0;
-
-	ret = strict_strtoul(data, 10, &value);
-	if (ret != -EINVAL) {
-
-		if (value > 3) {
-			amd64_warn("%s: invalid section 0x%lx\n", __func__, value);
-			return -EINVAL;
-		}
-
-		pvt->injection.section = (u32) value;
-		return count;
+	u32 value;
+	int ret;
+
+	ret = kstrtou32(data, 10, &value);
+	if (ret < 0)
+		return ret;
+	if (value > 3) {
+		amd64_warn("%s: invalid section 0x%x\n", __func__, value);
+		return -EINVAL;
 	}
-	return ret;
+	pvt->injection.section = value;
+	return count;
 }
 
 static ssize_t amd64_inject_word_show(struct mem_ctl_info *mci, char *buf)
@@ -49,21 +46,18 @@ static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
 					const char *data, size_t count)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	unsigned long value;
-	int ret = 0;
-
-	ret = strict_strtoul(data, 10, &value);
-	if (ret != -EINVAL) {
-
-		if (value > 8) {
-			amd64_warn("%s: invalid word 0x%lx\n", __func__, value);
-			return -EINVAL;
-		}
-
-		pvt->injection.word = (u32) value;
-		return count;
+	u32 value;
+	int ret;
+
+	ret = kstrtou32(data, 10, &value);
+	if (ret < 0)
+		return ret;
+	if (value > 8) {
+		amd64_warn("%s: invalid word 0x%x\n", __func__, value);
+		return -EINVAL;
 	}
-	return ret;
+	pvt->injection.word = value;
+	return count;
 }
 
 static ssize_t amd64_inject_ecc_vector_show(struct mem_ctl_info *mci, char *buf)
@@ -81,22 +75,19 @@ static ssize_t amd64_inject_ecc_vector_store(struct mem_ctl_info *mci,
 					     const char *data, size_t count)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	unsigned long value;
-	int ret = 0;
-
-	ret = strict_strtoul(data, 16, &value);
-	if (ret != -EINVAL) {
-
-		if (value & 0xFFFF0000) {
-			amd64_warn("%s: invalid EccVector: 0x%lx\n",
+	u32 value;
+	int ret;
+
+	ret = kstrtou32(data, 16, &value);
+	if (ret < 0)
+		return ret;
+	if (value & 0xFFFF0000) {
+		amd64_warn("%s: invalid EccVector: 0x%x\n",
 				   __func__, value);
-			return -EINVAL;
-		}
-
-		pvt->injection.bit_map = (u32) value;
-		return count;
+		return -EINVAL;
 	}
-	return ret;
+	pvt->injection.bit_map = value;
+	return count;
 }
 
 /*
@@ -107,29 +98,22 @@ static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
 					const char *data, size_t count)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	unsigned long value;
 	u32 section, word_bits;
-	int ret = 0;
-
-	ret = strict_strtoul(data, 10, &value);
-	if (ret != -EINVAL) {
 
-		/* Form value to choose 16-byte section of cacheline */
-		section = F10_NB_ARRAY_DRAM_ECC |
-				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
-		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
+	/* Form value to choose 16-byte section of cacheline */
+	section = F10_NB_ARRAY_DRAM_ECC |
+		SET_NB_ARRAY_ADDRESS(pvt->injection.section);
+	pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
 
-		word_bits = SET_NB_DRAM_INJECTION_READ(pvt->injection.word,
-						pvt->injection.bit_map);
+	word_bits = SET_NB_DRAM_INJECTION_READ(pvt->injection.word,
+			pvt->injection.bit_map);
 
-		/* Issue 'word' and 'bit' along with the READ request */
-		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
+	/* Issue 'word' and 'bit' along with the READ request */
+	pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
 
-		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
+	debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
 
-		return count;
-	}
-	return ret;
+	return count;
 }
 
 /*
@@ -140,29 +124,22 @@ static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
 					const char *data, size_t count)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	unsigned long value;
 	u32 section, word_bits;
-	int ret = 0;
-
-	ret = strict_strtoul(data, 10, &value);
-	if (ret != -EINVAL) {
 
-		/* Form value to choose 16-byte section of cacheline */
-		section = F10_NB_ARRAY_DRAM_ECC |
-				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
-		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
+	/* Form value to choose 16-byte section of cacheline */
+	section = F10_NB_ARRAY_DRAM_ECC |
+		SET_NB_ARRAY_ADDRESS(pvt->injection.section);
+	pci_write_config_dword(pvt->F3, F10_NB_ARRAY_ADDR, section);
 
-		word_bits = SET_NB_DRAM_INJECTION_WRITE(pvt->injection.word,
-						pvt->injection.bit_map);
+	word_bits = SET_NB_DRAM_INJECTION_WRITE(pvt->injection.word,
+			pvt->injection.bit_map);
 
-		/* Issue 'word' and 'bit' along with the READ request */
-		pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
+	/* Issue 'word' and 'bit' along with the READ request */
+	pci_write_config_dword(pvt->F3, F10_NB_ARRAY_DATA, word_bits);
 
-		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
+	debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
 
-		return count;
-	}
-	return ret;
+	return count;
 }
 
 /*
@@ -197,17 +174,15 @@ struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
 	{
 		.attr = {
 			.name = "inject_write",
-			.mode = (S_IRUGO | S_IWUSR)
+			.mode = S_IWUSR,
 		},
-		.show = NULL,
 		.store = amd64_inject_write_store,
 	},
 	{
 		.attr = {
 			.name = "inject_read",
-			.mode = (S_IRUGO | S_IWUSR)
+			.mode = S_IWUSR,
 		},
-		.show = NULL,
 		.store = amd64_inject_read_store,
 	},
 };
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 39d97cf..c8cb71d 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -48,16 +48,16 @@ int edac_mc_get_poll_msec(void)
 
 static int edac_set_poll_msec(const char *val, struct kernel_param *kp)
 {
-	long l;
+	unsigned int l;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
 
-	ret = strict_strtol(val, 0, &l);
-	if (ret == -EINVAL || ((int)l != l))
-		return -EINVAL;
-	*((int *)kp->arg) = l;
+	ret = kstrtouint(val, 0, &l);
+	if (ret < 0)
+		return ret;
+	*(unsigned int *)kp->arg = l;
 
 	/* notify edac_mc engine to reset the poll period */
 	edac_mc_reset_delay_period(l);
@@ -448,14 +448,16 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
 					  const char *data, size_t count)
 {
-	unsigned long bandwidth = 0;
+	u32 bandwidth;
 	int new_bw = 0;
+	int rv;
 
 	if (!mci->set_sdram_scrub_rate)
 		return -EINVAL;
 
-	if (strict_strtoul(data, 10, &bandwidth) < 0)
-		return -EINVAL;
+	rv = kstrtou32(data, 10, &bandwidth);
+	if (rv < 0)
+		return rv;
 
 	new_bw = mci->set_sdram_scrub_rate(mci, bandwidth);
 	if (new_bw >= 0) {
@@ -463,7 +465,7 @@ static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
 		return count;
 	}
 
-	edac_printk(KERN_DEBUG, EDAC_MC, "Error setting scrub rate to: %lu\n", bandwidth);
+	edac_printk(KERN_DEBUG, EDAC_MC, "Error setting scrub rate to: %u\n", bandwidth);
 	return -EINVAL;
 }
 
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 81154ab..8dcdfaf 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -774,17 +774,19 @@ static ssize_t i7core_inject_section_store(struct mem_ctl_info *mci,
 					   const char *data, size_t count)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
-	unsigned long value;
+	u32 value;
 	int rc;
 
 	if (pvt->inject.enable)
 		disable_inject(mci);
 
-	rc = strict_strtoul(data, 10, &value);
-	if ((rc < 0) || (value > 3))
+	rc = kstrtou32(data, 10, &value);
+	if (rc < 0)
+		return rc;
+	if (value > 3)
 		return -EIO;
 
-	pvt->inject.section = (u32) value;
+	pvt->inject.section = value;
 	return count;
 }
 
@@ -807,17 +809,19 @@ static ssize_t i7core_inject_type_store(struct mem_ctl_info *mci,
 					const char *data, size_t count)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
-	unsigned long value;
+	u32 value;
 	int rc;
 
 	if (pvt->inject.enable)
 		disable_inject(mci);
 
-	rc = strict_strtoul(data, 10, &value);
-	if ((rc < 0) || (value > 7))
+	rc = kstrtou32(data, 10, &value);
+	if (rc < 0)
+		return rc;
+	if (value > 7)
 		return -EIO;
 
-	pvt->inject.type = (u32) value;
+	pvt->inject.type = value;
 	return count;
 }
 
@@ -842,17 +846,14 @@ static ssize_t i7core_inject_eccmask_store(struct mem_ctl_info *mci,
 					const char *data, size_t count)
 {
 	struct i7core_pvt *pvt = mci->pvt_info;
-	unsigned long value;
 	int rc;
 
 	if (pvt->inject.enable)
 		disable_inject(mci);
 
-	rc = strict_strtoul(data, 10, &value);
+	rc = kstrtou32(data, 10, &pvt->inject.eccmask);
 	if (rc < 0)
-		return -EIO;
-
-	pvt->inject.eccmask = (u32) value;
+		return rc;
 	return count;
 }
 
@@ -880,7 +881,7 @@ static ssize_t i7core_inject_store_##param(			\
 		const char *data, size_t count)			\
 {								\
 	struct i7core_pvt *pvt;					\
-	long value;						\
+	u32 value;						\
 	int rc;							\
 								\
 	debugf1("%s()\n", __func__);				\
@@ -892,8 +893,10 @@ static ssize_t i7core_inject_store_##param(			\
 	if (!strcasecmp(data, "any") || !strcasecmp(data, "any\n"))\
 		value = -1;					\
 	else {							\
-		rc = strict_strtoul(data, 10, &value);		\
-		if ((rc < 0) || (value >= limit))		\
+		rc = kstrtou32(data, 10, &value);		\
+		if (rc < 0)					\
+			return rc;				\
+		if (value >= limit)				\
 			return -EIO;				\
 	}							\
 								\
@@ -990,9 +993,9 @@ static ssize_t i7core_inject_enable_store(struct mem_ctl_info *mci,
 	if (!pvt->pci_ch[pvt->inject.channel][0])
 		return 0;
 
-	rc = strict_strtoul(data, 10, &enable);
-	if ((rc < 0))
-		return 0;
+	rc = kstrtoul(data, 10, &enable);
+	if (rc < 0)
+		return rc;
 
 	if (enable) {
 		pvt->inject.enable = 1;
diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 733a7e7..ecade92 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -39,15 +39,13 @@ static ssize_t edac_inject_##reg##_store(struct kobject *kobj,		\
 					 struct edac_mce_attr *attr,	\
 					 const char *data, size_t count)\
 {									\
-	int ret = 0;							\
-	unsigned long value;						\
+	int ret;							\
 									\
-	ret = strict_strtoul(data, 16, &value);				\
-	if (ret < 0)							\
+	ret = kstrtou64(data, 16, &i_mce.reg);				\
+	if (ret < 0) {							\
 		printk(KERN_ERR "Error writing MCE " #reg " field.\n");	\
-									\
-	i_mce.reg = value;						\
-									\
+		return ret;						\
+	}								\
 	return count;							\
 }
 
@@ -79,22 +77,22 @@ static ssize_t edac_inject_bank_store(struct kobject *kobj,
 				      struct edac_mce_attr *attr,
 				      const char *data, size_t count)
 {
-	int ret = 0;
-	unsigned long value;
+	u8 bank;
+	int ret;
 
-	ret = strict_strtoul(data, 10, &value);
+	ret = kstrtou8(data, 10, &bank);
 	if (ret < 0) {
 		printk(KERN_ERR "Invalid bank value!\n");
-		return -EINVAL;
+		return ret;
 	}
 
-	if (value > 5)
-		if (boot_cpu_data.x86 != 0x15 || value > 6) {
-			printk(KERN_ERR "Non-existant MCE bank: %lu\n", value);
+	if (bank > 5)
+		if (boot_cpu_data.x86 != 0x15 || bank > 6) {
+			printk(KERN_ERR "Non-existant MCE bank: %hhu\n", bank);
 			return -EINVAL;
 		}
 
-	i_mce.bank = value;
+	i_mce.bank = bank;
 
 	amd_decode_mce(NULL, 0, &i_mce);
 
-- 
1.7.3.4

