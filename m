Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2JQLOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:14:38 -0400
Received: from mail.x86-64.org ([217.9.48.20]:49961 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261Ab2JQLOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:14:00 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/5] x86, MCA: Convert the next three variables batch
Date: Wed, 17 Oct 2012 13:13:54 +0200
Message-Id: <1350472435-29307-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc2.4.g42e55a5
In-Reply-To: <1350472435-29307-1-git-send-email-bp@amd64.org>
References: <1350472435-29307-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Move them into the mca_config struct and adjust code touching them
accordingly.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h             |  6 ++++--
 arch/x86/kernel/cpu/mcheck/mce.c       | 35 ++++++++++++++++------------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c |  2 +-
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 73ba1853951a..a711e3f4fbc7 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -122,13 +122,17 @@ struct mce_log {
 
 struct mca_config {
 	bool dont_log_ce;
+	bool cmci_disabled;
+	bool ignore_ce;
 	u8 banks;
 	s8 bootlog;
 	int tolerant;
 	int monarch_timeout;
+	int panic_timeout;
 	u32 rip_msr;
 };
 
+extern struct mca_config mca_cfg;
 extern void mce_register_decode_chain(struct notifier_block *nb);
 extern void mce_unregister_decode_chain(struct notifier_block *nb);
 
@@ -169,8 +173,6 @@ DECLARE_PER_CPU(struct device *, mce_device);
 #define MAX_NR_BANKS 32
 
 #ifdef CONFIG_X86_MCE_INTEL
-extern int mce_cmci_disabled;
-extern int mce_ignore_ce;
 extern int mce_bios_cmci_threshold;
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
 void cmci_clear(void);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 37695ac8b894..a66b1c2321d6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -66,9 +66,6 @@ atomic_t mce_entry;
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
-static int			mce_panic_timeout	__read_mostly;
-int				mce_cmci_disabled	__read_mostly;
-int				mce_ignore_ce		__read_mostly;
 int				mce_ser			__read_mostly;
 int				mce_bios_cmci_threshold	__read_mostly;
 
@@ -302,7 +299,7 @@ static void wait_for_panic(void)
 	while (timeout-- > 0)
 		udelay(1);
 	if (panic_timeout == 0)
-		panic_timeout = mce_panic_timeout;
+		panic_timeout = mca_cfg.panic_timeout;
 	panic("Panicing machine check CPU died");
 }
 
@@ -360,7 +357,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		pr_emerg(HW_ERR "Machine check: %s\n", exp);
 	if (!fake_panic) {
 		if (panic_timeout == 0)
-			panic_timeout = mce_panic_timeout;
+			panic_timeout = mca_cfg.panic_timeout;
 		panic(msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
@@ -1600,7 +1597,7 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 	if (cfg->monarch_timeout < 0)
 		cfg->monarch_timeout = 0;
 	if (cfg->bootlog != 0)
-		mce_panic_timeout = 30;
+		cfg->panic_timeout = 30;
 
 	return 0;
 }
@@ -1645,7 +1642,7 @@ static void mce_start_timer(unsigned int cpu, struct timer_list *t)
 
 	__this_cpu_write(mce_next_interval, iv);
 
-	if (mce_ignore_ce || !iv)
+	if (mca_cfg.ignore_ce || !iv)
 		return;
 
 	t->expires = round_jiffies(jiffies + iv);
@@ -1972,11 +1969,11 @@ static int __init mcheck_enable(char *str)
 	if (!strcmp(str, "off"))
 		mce_disabled = 1;
 	else if (!strcmp(str, "no_cmci"))
-		mce_cmci_disabled = 1;
+		cfg->cmci_disabled = true;
 	else if (!strcmp(str, "dont_log_ce"))
 		cfg->dont_log_ce = true;
 	else if (!strcmp(str, "ignore_ce"))
-		mce_ignore_ce = 1;
+		cfg->ignore_ce = true;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		cfg->bootlog = (str[0] == 'b');
 	else if (!strcmp(str, "bios_cmci_threshold"))
@@ -2154,15 +2151,15 @@ static ssize_t set_ignore_ce(struct device *s,
 	if (strict_strtoull(buf, 0, &new) < 0)
 		return -EINVAL;
 
-	if (mce_ignore_ce ^ !!new) {
+	if (mca_cfg.ignore_ce ^ !!new) {
 		if (new) {
 			/* disable ce features */
 			mce_timer_delete_all();
 			on_each_cpu(mce_disable_cmci, NULL, 1);
-			mce_ignore_ce = 1;
+			mca_cfg.ignore_ce = true;
 		} else {
 			/* enable ce features */
-			mce_ignore_ce = 0;
+			mca_cfg.ignore_ce = false;
 			on_each_cpu(mce_enable_ce, (void *)1, 1);
 		}
 	}
@@ -2178,14 +2175,14 @@ static ssize_t set_cmci_disabled(struct device *s,
 	if (strict_strtoull(buf, 0, &new) < 0)
 		return -EINVAL;
 
-	if (mce_cmci_disabled ^ !!new) {
+	if (mca_cfg.cmci_disabled ^ !!new) {
 		if (new) {
 			/* disable cmci */
 			on_each_cpu(mce_disable_cmci, NULL, 1);
-			mce_cmci_disabled = 1;
+			mca_cfg.cmci_disabled = true;
 		} else {
 			/* enable cmci */
-			mce_cmci_disabled = 0;
+			mca_cfg.cmci_disabled = false;
 			on_each_cpu(mce_enable_ce, NULL, 1);
 		}
 	}
@@ -2212,13 +2209,13 @@ static struct dev_ext_attribute dev_attr_check_interval = {
 };
 
 static struct dev_ext_attribute dev_attr_ignore_ce = {
-	__ATTR(ignore_ce, 0644, device_show_int, set_ignore_ce),
-	&mce_ignore_ce
+	__ATTR(ignore_ce, 0644, device_show_bool, set_ignore_ce),
+	&mca_cfg.ignore_ce
 };
 
 static struct dev_ext_attribute dev_attr_cmci_disabled = {
-	__ATTR(cmci_disabled, 0644, device_show_int, set_cmci_disabled),
-	&mce_cmci_disabled
+	__ATTR(cmci_disabled, 0644, device_show_bool, set_cmci_disabled),
+	&mca_cfg.cmci_disabled
 };
 
 static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 5f88abf07e9c..1acd8ecba1c3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -53,7 +53,7 @@ static int cmci_supported(int *banks)
 {
 	u64 cap;
 
-	if (mce_cmci_disabled || mce_ignore_ce)
+	if (mca_cfg.cmci_disabled || mca_cfg.ignore_ce)
 		return 0;
 
 	/*
-- 
1.8.0.rc2.4.g42e55a5

