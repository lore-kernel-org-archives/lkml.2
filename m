Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab2IEKX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:23:56 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:45382 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418Ab2IEKXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:23:54 -0400
Subject: [PATCH 2/3] x86/mce: Pack boolean MCE flags into a structure
To: tony.luck@intel.com, andi@firstfloor.org, bp@amd64.org
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: gong.chen@linux.intel.com, ananth@in.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, gregkh@suse.de, linux-edac@vger.kernel.org
Date: Wed, 05 Sep 2012 15:52:01 +0530
Message-ID: <20120905102201.9423.46671.stgit@localhost.localdomain>
In-Reply-To: <20120905102049.9423.6413.stgit@localhost.localdomain>
References: <20120905102049.9423.6413.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12090510-8256-0000-0000-0000040948B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many MCE flags are boolean in nature, but are declared as integers
currently. We can pack these into a bitfield to save some space.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/x86/include/asm/mce.h                |    2 -
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    9 +++
 arch/x86/kernel/cpu/mcheck/mce.c          |   88 +++++++++++++++++++----------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |    2 -
 4 files changed, 67 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index a3ac52b..4576930 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -169,8 +169,6 @@ DECLARE_PER_CPU(struct device *, mce_device);
 #define MAX_NR_BANKS 32
 
 #ifdef CONFIG_X86_MCE_INTEL
-extern int mce_cmci_disabled;
-extern int mce_ignore_ce;
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
 void cmci_reenable(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 6a05c1d..9a165a2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -11,6 +11,15 @@ enum severity_level {
 	MCE_PANIC_SEVERITY,
 };
 
+struct mce_config {
+	__u32	cmci_disabled		: 1,
+		ignore_ce		: 1,
+		dont_log_ce		: 1,
+		__pad			: 29;
+};
+
+extern struct mce_config mce_cfg;
+
 #define ATTR_LEN		16
 
 /* One object for each MCE bank, shared by all CPUs */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bf276eb..cbdef73 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -79,11 +79,10 @@ static int			rip_msr			__read_mostly;
 static int			mce_bootlog		__read_mostly = -1;
 static int			monarch_timeout		__read_mostly = -1;
 static int			mce_panic_timeout	__read_mostly;
-static int			mce_dont_log_ce		__read_mostly;
-int				mce_cmci_disabled	__read_mostly;
-int				mce_ignore_ce		__read_mostly;
 int				mce_ser			__read_mostly;
 
+struct mce_config		mce_cfg			__read_mostly;
+
 struct mce_bank                *mce_banks		__read_mostly;
 
 /* User mode helper program triggered by machine check event */
@@ -630,7 +629,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
 		 */
-		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce)
+		if (!(flags & MCP_DONTLOG) && !mce_cfg.dont_log_ce)
 			mce_log(&m);
 
 		/*
@@ -1634,7 +1633,7 @@ static void mce_start_timer(unsigned int cpu, struct timer_list *t)
 
 	__this_cpu_write(mce_next_interval, iv);
 
-	if (mce_ignore_ce || !iv)
+	if (mce_cfg.ignore_ce || !iv)
 		return;
 
 	t->expires = round_jiffies(jiffies + iv);
@@ -1958,11 +1957,11 @@ static int __init mcheck_enable(char *str)
 	if (!strcmp(str, "off"))
 		mce_disabled = 1;
 	else if (!strcmp(str, "no_cmci"))
-		mce_cmci_disabled = 1;
+		mce_cfg.cmci_disabled = 1;
 	else if (!strcmp(str, "dont_log_ce"))
-		mce_dont_log_ce = 1;
+		mce_cfg.dont_log_ce = 1;
 	else if (!strcmp(str, "ignore_ce"))
-		mce_ignore_ce = 1;
+		mce_cfg.ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
 	else if (isdigit(str[0])) {
@@ -2129,6 +2128,34 @@ static ssize_t set_trigger(struct device *s, struct device_attribute *attr,
 	return strlen(mce_helper) + !!p;
 }
 
+static ssize_t get_dont_log_ce(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", mce_cfg.dont_log_ce);
+}
+
+static ssize_t set_dont_log_ce(struct device *s,
+			       struct device_attribute *attr,
+			       const char *buf, size_t size)
+{
+	u64 new;
+
+	if (strict_strtoull(buf, 0, &new) < 0)
+		return -EINVAL;
+
+	mce_cfg.dont_log_ce = !!new;
+
+	return size;
+}
+
+static ssize_t get_ignore_ce(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", mce_cfg.ignore_ce);
+}
+
 static ssize_t set_ignore_ce(struct device *s,
 			     struct device_attribute *attr,
 			     const char *buf, size_t size)
@@ -2138,21 +2165,28 @@ static ssize_t set_ignore_ce(struct device *s,
 	if (strict_strtoull(buf, 0, &new) < 0)
 		return -EINVAL;
 
-	if (mce_ignore_ce ^ !!new) {
+	if (mce_cfg.ignore_ce ^ !!new) {
 		if (new) {
 			/* disable ce features */
 			mce_timer_delete_all();
 			on_each_cpu(mce_disable_cmci, NULL, 1);
-			mce_ignore_ce = 1;
+			mce_cfg.ignore_ce = 1;
 		} else {
 			/* enable ce features */
-			mce_ignore_ce = 0;
+			mce_cfg.ignore_ce = 0;
 			on_each_cpu(mce_enable_ce, (void *)1, 1);
 		}
 	}
 	return size;
 }
 
+static ssize_t get_cmci_disabled(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", mce_cfg.cmci_disabled);
+}
+
 static ssize_t set_cmci_disabled(struct device *s,
 				 struct device_attribute *attr,
 				 const char *buf, size_t size)
@@ -2162,14 +2196,14 @@ static ssize_t set_cmci_disabled(struct device *s,
 	if (strict_strtoull(buf, 0, &new) < 0)
 		return -EINVAL;
 
-	if (mce_cmci_disabled ^ !!new) {
+	if (mce_cfg.cmci_disabled ^ !!new) {
 		if (new) {
 			/* disable cmci */
 			on_each_cpu(mce_disable_cmci, NULL, 1);
-			mce_cmci_disabled = 1;
+			mce_cfg.cmci_disabled = 1;
 		} else {
 			/* enable cmci */
-			mce_cmci_disabled = 0;
+			mce_cfg.cmci_disabled = 0;
 			on_each_cpu(mce_enable_ce, NULL, 1);
 		}
 	}
@@ -2188,32 +2222,24 @@ static ssize_t store_int_with_restart(struct device *s,
 static DEVICE_ATTR(trigger, 0644, show_trigger, set_trigger);
 static DEVICE_INT_ATTR(tolerant, 0644, tolerant);
 static DEVICE_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
-static DEVICE_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
+static DEVICE_ATTR(dont_log_ce, 0644, get_dont_log_ce, set_dont_log_ce);
+static DEVICE_ATTR(ignore_ce, 0644, get_ignore_ce, set_ignore_ce);
+static DEVICE_ATTR(cmci_disabled, 0644, get_cmci_disabled, set_cmci_disabled);
 
 static struct dev_ext_attribute dev_attr_check_interval = {
 	__ATTR(check_interval, 0644, device_show_int, store_int_with_restart),
 	&check_interval
 };
 
-static struct dev_ext_attribute dev_attr_ignore_ce = {
-	__ATTR(ignore_ce, 0644, device_show_int, set_ignore_ce),
-	&mce_ignore_ce
-};
-
-static struct dev_ext_attribute dev_attr_cmci_disabled = {
-	__ATTR(cmci_disabled, 0644, device_show_int, set_cmci_disabled),
-	&mce_cmci_disabled
-};
-
 /* Use this _only_ for per-cpu attributes */
 static struct device_attribute *mce_device_attrs[] = {
 	&dev_attr_tolerant.attr,
 	&dev_attr_check_interval.attr,
 	&dev_attr_trigger,
 	&dev_attr_monarch_timeout.attr,
-	&dev_attr_dont_log_ce.attr,
-	&dev_attr_ignore_ce.attr,
-	&dev_attr_cmci_disabled.attr,
+	&dev_attr_dont_log_ce,
+	&dev_attr_ignore_ce,
+	&dev_attr_cmci_disabled,
 	NULL
 };
 
@@ -2223,9 +2249,9 @@ static struct attribute *mce_device_global_attrs[] = {
 	&dev_attr_check_interval.attr.attr,
 	&dev_attr_trigger.attr,
 	&dev_attr_monarch_timeout.attr.attr,
-	&dev_attr_dont_log_ce.attr.attr,
-	&dev_attr_ignore_ce.attr.attr,
-	&dev_attr_cmci_disabled.attr.attr,
+	&dev_attr_dont_log_ce.attr,
+	&dev_attr_ignore_ce.attr,
+	&dev_attr_cmci_disabled.attr,
 	NULL
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 098386f..a6c028d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -53,7 +53,7 @@ static int cmci_supported(int *banks)
 {
 	u64 cap;
 
-	if (mce_cmci_disabled || mce_ignore_ce)
+	if (mce_cfg.cmci_disabled || mce_cfg.ignore_ce)
 		return 0;
 
 	/*

