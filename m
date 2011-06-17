Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab1FQIow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:44:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53386 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1FQIot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:44:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFB13E2.4080909@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 17:44:18 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH 4/8] x86, mce: rename bootparam parser
References: <4DFB1242.90404@jp.fujitsu.com>
In-Reply-To: <4DFB1242.90404@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename them with comprehensible prefix mcheck_setup.
(at least it looks better than current misleading name)
And relocate to put together setup codes.

	Before:			After:
	 mcheck_enable		 mcheck_setup
	 mcheck_disable		 mcheck_setup_old

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   91 +++++++++++++++++++-------------------
 1 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index c3dad64..ad0e9fb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1662,50 +1662,6 @@ static struct miscdevice mce_chrdev_device = {
 	&mce_chrdev_ops,
 };
 
-/*
- * mce=off Disables machine check
- * mce=no_cmci Disables CMCI
- * mce=dont_log_ce Clears corrected events silently, no log created for CEs.
- * mce=ignore_ce Disables polling and CMCI, corrected events are not cleared.
- * mce=TOLERANCELEVEL[,monarchtimeout] (number, see above)
- *	monarchtimeout is how long to wait for other CPUs on machine
- *	check, or 0 to not wait
- * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
- * mce=nobootlog Don't log MCEs from before booting.
- */
-static int __init mcheck_enable(char *str)
-{
-	if (*str == 0) {
-		enable_p5_mce();
-		return 1;
-	}
-	if (*str == '=')
-		str++;
-	if (!strcmp(str, "off"))
-		mce_disabled = 1;
-	else if (!strcmp(str, "no_cmci"))
-		mce_cmci_disabled = 1;
-	else if (!strcmp(str, "dont_log_ce"))
-		mce_dont_log_ce = 1;
-	else if (!strcmp(str, "ignore_ce"))
-		mce_ignore_ce = 1;
-	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
-		mce_bootlog = (str[0] == 'b');
-	else if (isdigit(str[0])) {
-		get_option(&str, &tolerant);
-		if (*str == ',') {
-			++str;
-			get_option(&str, &monarch_timeout);
-		}
-	} else {
-		printk(KERN_INFO "mce argument %s ignored. Please use /sys\n",
-		       str);
-		return 0;
-	}
-	return 1;
-}
-__setup("mce", mcheck_enable);
-
 int __init mcheck_init(void)
 {
 	mcheck_intel_therm_init();
@@ -2120,14 +2076,57 @@ static __init int mcheck_init_device(void)
 device_initcall(mcheck_init_device);
 
 /*
+ * mce=off Disables machine check
+ * mce=no_cmci Disables CMCI
+ * mce=dont_log_ce Clears corrected events silently, no log created for CEs.
+ * mce=ignore_ce Disables polling and CMCI, corrected events are not cleared.
+ * mce=TOLERANCELEVEL[,monarchtimeout] (number, see above)
+ *	monarchtimeout is how long to wait for other CPUs on machine
+ *	check, or 0 to not wait
+ * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
+ * mce=nobootlog Don't log MCEs from before booting.
+ */
+static int __init mcheck_setup(char *str)
+{
+	if (*str == 0) {
+		enable_p5_mce();
+		return 1;
+	}
+	if (*str == '=')
+		str++;
+	if (!strcmp(str, "off"))
+		mce_disabled = 1;
+	else if (!strcmp(str, "no_cmci"))
+		mce_cmci_disabled = 1;
+	else if (!strcmp(str, "dont_log_ce"))
+		mce_dont_log_ce = 1;
+	else if (!strcmp(str, "ignore_ce"))
+		mce_ignore_ce = 1;
+	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
+		mce_bootlog = (str[0] == 'b');
+	else if (isdigit(str[0])) {
+		get_option(&str, &tolerant);
+		if (*str == ',') {
+			++str;
+			get_option(&str, &monarch_timeout);
+		}
+	} else {
+		pr_info("mce argument %s ignored. Please use /sys\n", str);
+		return 0;
+	}
+	return 1;
+}
+__setup("mce", mcheck_setup);
+
+/*
  * Old style boot options parsing. Only for compatibility.
  */
-static int __init mcheck_disable(char *str)
+static int __init mcheck_setup_old(char *str)
 {
 	mce_disabled = 1;
 	return 1;
 }
-__setup("nomce", mcheck_disable);
+__setup("nomce", mcheck_setup_old);
 
 #ifdef CONFIG_DEBUG_FS
 struct dentry *mce_get_debugfs_dir(void)
-- 
1.7.1


