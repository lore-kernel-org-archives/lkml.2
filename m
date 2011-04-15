Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1DOPVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:21:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53129 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab1DOPU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:20:59 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 3/4] EDAC, MCE, AMD: Add hw_inject and cpu sysfs attrs
Date: Fri, 15 Apr 2011 17:20:26 +0200
Message-Id: <1302880827-22457-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1302880827-22457-1-git-send-email-bp@amd64.org>
References: <1302880827-22457-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add sysfs handlers for the 'hw_inject' and 'cpu' attrs.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd_inj.c |   78 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index eb36e15..3a50e0c 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -67,8 +67,11 @@ static ssize_t edac_inject_##reg##_store(struct kobject *kobj,		\
 	unsigned long value;						\
 									\
 	ret = strict_strtoul(data, 16, &value);				\
-	if (ret < 0)							\
-		printk(KERN_ERR "Error writing MCE " #reg " field.\n");	\
+	if (ret < 0) {							\
+		printk(KERN_ERR "%s: Error parsing MCE " #reg " field.\n",\
+				__func__);				\
+		return ret;						\
+	}								\
 									\
 	i_mce.reg = value;						\
 									\
@@ -96,6 +99,68 @@ EDAC_MCE_ATTR(misc, 0644, edac_inject_misc_show, edac_inject_misc_store);
 EDAC_MCE_ATTR(addr, 0644, edac_inject_addr_show, edac_inject_addr_store);
 
 /*
+ * HW or SW injection
+ */
+static ssize_t edac_hw_inject_show(struct kobject *kobj,
+				   struct edac_mce_attr *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", !!(i_mce.inject_flags & MCJ_HW_INJECT));
+}
+
+static ssize_t edac_hw_inject_store(struct kobject *kobj,
+				    struct edac_mce_attr *attr,
+				    const char *data, size_t count)
+{
+	switch (data[0]) {
+	case '0':
+		i_mce.inject_flags &= (u8)~MCJ_HW_INJECT;
+		break;
+	case '1':
+		i_mce.inject_flags |= MCJ_HW_INJECT;
+		break;
+	default:
+		printk(KERN_ERR "%s: Only 0 or 1 allowed!\n", __func__);
+		return -EINVAL;
+	}
+	return count;
+}
+
+EDAC_MCE_ATTR(hw_inject, 0644, edac_hw_inject_show, edac_hw_inject_store);
+
+/*
+ * On which CPU to inject?
+ */
+static ssize_t edac_cpu_show(struct kobject *kobj, struct edac_mce_attr *attr,
+			     char *buf)
+{
+	return sprintf(buf, "%d\n", i_mce.extcpu);
+}
+
+static ssize_t edac_cpu_store(struct kobject *kobj, struct edac_mce_attr *attr,
+			      const char *data, size_t count)
+{
+	int ret = 0;
+	unsigned long value;
+
+	ret = strict_strtoul(data, 10, &value);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: Unable to parse CPU value!\n", __func__);
+		return ret;
+	}
+
+	if (value > num_online_cpus()) {
+		printk(KERN_ERR "%s: Non-existant CPU: %lu\n", __func__, value);
+		return -EINVAL;
+	}
+
+	i_mce.extcpu = value;
+
+	return count;
+}
+
+EDAC_MCE_ATTR(cpu, 0644, edac_cpu_show, edac_cpu_store);
+
+/*
  * This denotes into which bank we're injecting and triggers
  * the injection, at the same time.
  */
@@ -133,8 +198,13 @@ static ssize_t edac_inject_bank_show(struct kobject *kobj,
 
 EDAC_MCE_ATTR(bank, 0644, edac_inject_bank_show, edac_inject_bank_store);
 
-static struct edac_mce_attr *sysfs_attrs[] = { &mce_attr_status, &mce_attr_misc,
-					       &mce_attr_addr, &mce_attr_bank
+static struct edac_mce_attr *sysfs_attrs[] = {
+	&mce_attr_status,
+	&mce_attr_misc,
+	&mce_attr_addr,
+	&mce_attr_bank,
+	&mce_attr_hw_inject,
+	&mce_attr_cpu,
 };
 
 static int __init edac_init_mce_inject(void)
-- 
1.7.4.rc2

