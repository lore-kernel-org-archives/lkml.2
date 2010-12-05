Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0LERvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:51:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab0LERu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cJv25XaDvHhqvXWHCi2QKQy3CDVcbcwcIOHyubFGmCBGIuyUcPX3XyeXwgM2jpdIly
         yxAGOevZD+E6vg1NHeipqZjIdZfI7c97oaOROKvTC2fcFv9POynC1efZ2d5Tcb9PIXge
         SaTzpBnXB72JYjY6oI2Tap+WIz/pVcKjOkFi0=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 18/45] kstrtox: convert drivers/edac/
Date: Sun,  5 Dec 2010 19:49:15 +0200
Message-Id: <1291571382-2719-18-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In amd64_edac_inj.c, make "inject_write", "inject_read" attributes write-only.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/edac/amd64_edac_inj.c |  144 ++++++++++++++++-------------------------
 drivers/edac/edac_mc_sysfs.c  |   23 +++----
 drivers/edac/i7core_edac.c    |   41 ++++++------
 drivers/edac/mce_amd_inj.c    |   33 ++++------
 4 files changed, 104 insertions(+), 137 deletions(-)

diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
index 29f1f7a..c66556c 100644
--- a/drivers/edac/amd64_edac_inj.c
+++ b/drivers/edac/amd64_edac_inj.c
@@ -16,23 +16,19 @@ static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
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
-			amd64_printk(KERN_WARNING,
-				     "%s: invalid section 0x%lx\n",
-				     __func__, value);
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
+		amd64_printk(KERN_ERR, "%s: invalid section 0x%x\n",
+			     __func__, value);
+		return -EINVAL;
 	}
-	return ret;
+	pvt->injection.section = value;
+	return count;
 }
 
 static ssize_t amd64_inject_word_show(struct mem_ctl_info *mci, char *buf)
@@ -51,23 +47,19 @@ static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
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
-			amd64_printk(KERN_WARNING,
-				     "%s: invalid word 0x%lx\n",
-				     __func__, value);
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
+		amd64_printk(KERN_ERR, "%s: invalid word 0x%x\n",
+			     __func__, value);
+		return -EINVAL;
 	}
-	return ret;
+	pvt->injection.word = value;
+	return count;
 }
 
 static ssize_t amd64_inject_ecc_vector_show(struct mem_ctl_info *mci, char *buf)
@@ -85,23 +77,19 @@ static ssize_t amd64_inject_ecc_vector_store(struct mem_ctl_info *mci,
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
-			amd64_printk(KERN_WARNING,
-				     "%s: invalid EccVector: 0x%lx\n",
-				     __func__, value);
-			return -EINVAL;
-		}
-
-		pvt->injection.bit_map = (u32) value;
-		return count;
+	u32 value;
+	int ret;
+
+	ret = kstrtou32(data, 16, &value);
+	if (ret < 0)
+		return ret;
+	if (value & 0xFFFF0000) {
+		amd64_printk(KERN_ERR, "%s: invalid EccVector: 0x%x\n",
+			     __func__, value);
+		return -EINVAL;
 	}
-	return ret;
+	pvt->injection.bit_map = value;
+	return count;
 }
 
 /*
@@ -112,31 +100,22 @@ static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
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
-		pci_write_config_dword(pvt->misc_f3_ctl,
-					F10_NB_ARRAY_ADDR, section);
+	/* Form value to choose 16-byte section of cacheline */
+	section = F10_NB_ARRAY_DRAM_ECC |
+		  SET_NB_ARRAY_ADDRESS(pvt->injection.section);
+	pci_write_config_dword(pvt->misc_f3_ctl, F10_NB_ARRAY_ADDR, section);
 
-		word_bits = SET_NB_DRAM_INJECTION_READ(pvt->injection.word,
-						pvt->injection.bit_map);
+	word_bits = SET_NB_DRAM_INJECTION_READ(pvt->injection.word,
+					       pvt->injection.bit_map);
 
-		/* Issue 'word' and 'bit' along with the READ request */
-		pci_write_config_dword(pvt->misc_f3_ctl,
-					F10_NB_ARRAY_DATA, word_bits);
+	/* Issue 'word' and 'bit' along with the READ request */
+	pci_write_config_dword(pvt->misc_f3_ctl, F10_NB_ARRAY_DATA, word_bits);
 
-		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
+	debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
 
-		return count;
-	}
-	return ret;
+	return count;
 }
 
 /*
@@ -147,31 +126,22 @@ static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
 					const char *data, size_t count)
 {
 	struct amd64_pvt *pvt = mci->pvt_info;
-	unsigned long value;
 	u32 section, word_bits;
-	int ret = 0;
 
-	ret = strict_strtoul(data, 10, &value);
-	if (ret != -EINVAL) {
+	/* Form value to choose 16-byte section of cacheline */
+	section = F10_NB_ARRAY_DRAM_ECC |
+		  SET_NB_ARRAY_ADDRESS(pvt->injection.section);
+	pci_write_config_dword(pvt->misc_f3_ctl, F10_NB_ARRAY_ADDR, section);
 
-		/* Form value to choose 16-byte section of cacheline */
-		section = F10_NB_ARRAY_DRAM_ECC |
-				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
-		pci_write_config_dword(pvt->misc_f3_ctl,
-					F10_NB_ARRAY_ADDR, section);
-
-		word_bits = SET_NB_DRAM_INJECTION_WRITE(pvt->injection.word,
+	word_bits = SET_NB_DRAM_INJECTION_WRITE(pvt->injection.word,
 						pvt->injection.bit_map);
 
-		/* Issue 'word' and 'bit' along with the READ request */
-		pci_write_config_dword(pvt->misc_f3_ctl,
-					F10_NB_ARRAY_DATA, word_bits);
+	/* Issue 'word' and 'bit' along with the READ request */
+	pci_write_config_dword(pvt->misc_f3_ctl, F10_NB_ARRAY_DATA, word_bits);
 
-		debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
+	debugf0("section=0x%x word_bits=0x%x\n", section, word_bits);
 
-		return count;
-	}
-	return ret;
+	return count;
 }
 
 /*
@@ -206,7 +176,7 @@ struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
 	{
 		.attr = {
 			.name = "inject_write",
-			.mode = (S_IRUGO | S_IWUSR)
+			.mode = S_IWUSR,
 		},
 		.show = NULL,
 		.store = amd64_inject_write_store,
@@ -214,7 +184,7 @@ struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
 	{
 		.attr = {
 			.name = "inject_read",
-			.mode = (S_IRUGO | S_IWUSR)
+			.mode = S_IWUSR,
 		},
 		.show = NULL,
 		.store = amd64_inject_read_store,
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index dce61f7..644a5b6 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -48,19 +48,17 @@ int edac_mc_get_poll_msec(void)
 
 static int edac_set_poll_msec(const char *val, struct kernel_param *kp)
 {
-	long l;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
 
-	ret = strict_strtol(val, 0, &l);
-	if (ret == -EINVAL || ((int)l != l))
-		return -EINVAL;
-	*((int *)kp->arg) = l;
+	ret = kstrtoint(val, 0, (int *)kp->arg);
+	if (ret < 0)
+		return ret;
 
 	/* notify edac_mc engine to reset the poll period */
-	edac_mc_reset_delay_period(l);
+	edac_mc_reset_delay_period(*(int *)kp->arg);
 
 	return 0;
 }
@@ -440,7 +438,7 @@ static ssize_t mci_reset_counters_store(struct mem_ctl_info *mci,
 static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
 					  const char *data, size_t count)
 {
-	unsigned long bandwidth = 0;
+	u32 bandwidth;
 	int err;
 
 	if (!mci->set_sdram_scrub_rate) {
@@ -449,18 +447,19 @@ static ssize_t mci_sdram_scrub_rate_store(struct mem_ctl_info *mci,
 		return -EINVAL;
 	}
 
-	if (strict_strtoul(data, 10, &bandwidth) < 0)
-		return -EINVAL;
+	err = kstrtou32(data, 10, &bandwidth);
+	if (err < 0)
+		return err;
 
-	err = mci->set_sdram_scrub_rate(mci, (u32)bandwidth);
+	err = mci->set_sdram_scrub_rate(mci, bandwidth);
 	if (err) {
 		edac_printk(KERN_DEBUG, EDAC_MC,
-			    "Failed setting scrub rate to %lu\n", bandwidth);
+			    "Failed setting scrub rate to %u\n", bandwidth);
 		return -EINVAL;
 	}
 	else {
 		edac_printk(KERN_DEBUG, EDAC_MC,
-			    "Scrub rate set to: %lu\n", bandwidth);
+			    "Scrub rate set to: %u\n", bandwidth);
 		return count;
 	}
 }
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 362861c..3e580e0 100644
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
 
@@ -892,8 +893,10 @@ static ssize_t i7core_inject_store_##param(			\
 	if (!strcasecmp(data, "any") || !strcasecmp(data, "any\n"))\
 		value = -1;					\
 	else {							\
-		rc = strict_strtoul(data, 10, &value);		\
-		if ((rc < 0) || (value >= limit))		\
+		rc = kstrtoul(data, 10, &value);		\
+		if (rc < 0)					\
+			return rc;				\
+		if (value >= limit)				\
 			return -EIO;				\
 	}							\
 								\
@@ -985,14 +988,14 @@ static ssize_t i7core_inject_enable_store(struct mem_ctl_info *mci,
 	u32 injectmask;
 	u64 mask = 0;
 	int  rc;
-	long enable;
+	unsigned long enable;
 
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
index 39faded..794be1a 100644
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
 
@@ -79,21 +77,18 @@ static ssize_t edac_inject_bank_store(struct kobject *kobj,
 				      struct edac_mce_attr *attr,
 				      const char *data, size_t count)
 {
-	int ret = 0;
-	unsigned long value;
-
-	ret = strict_strtoul(data, 10, &value);
-	if (ret < 0) {
-		printk(KERN_ERR "Invalid bank value!\n");
-		return -EINVAL;
-	}
-
-	if (value > 5) {
-		printk(KERN_ERR "Non-existant MCE bank: %lu\n", value);
+	u8 bank;
+	int ret;
+
+	ret = kstrtou8(data, 10, &bank);
+	if (ret < 0)
+		return ret;
+	if (bank > 5) {
+		printk(KERN_ERR "Non-existant MCE bank: %hhu\n", bank);
 		return -EINVAL;
 	}
 
-	i_mce.bank = value;
+	i_mce.bank = bank;
 
 	amd_decode_mce(NULL, 0, &i_mce);
 
-- 
1.7.2.2

