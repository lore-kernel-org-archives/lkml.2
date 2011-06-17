Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab1FQIqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:46:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34332 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab1FQIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:46:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFB1438.3030504@jp.fujitsu.com>
Date: Fri, 17 Jun 2011 17:45:44 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: [PATCH 5/8] x86, mce: introduce mce_sysdev_init()
References: <4DFB1242.90404@jp.fujitsu.com>
In-Reply-To: <4DFB1242.90404@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a one of mce_sysdev_ family, coordinate a single function that
initializes sysfs hierarchy here.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   65 ++++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ad0e9fb..0424299 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1953,6 +1953,39 @@ static __cpuinit void mce_sysdev_remove(unsigned int cpu)
 	cpumask_clear_cpu(cpu, mce_sysdev_initialized);
 }
 
+static __init int mce_sysdev_init(void)
+{
+	int err, i;
+
+	zalloc_cpumask_var(&mce_sysdev_initialized, GFP_KERNEL);
+
+	/* init attributes for each mce_banks */
+	for (i = 0; i < banks; i++) {
+		struct mce_bank *b = &mce_banks[i];
+		struct sysdev_attribute *a = &b->attr;
+
+		sysfs_attr_init(&a->attr);
+		a->attr.name	= b->attrname;
+		snprintf(b->attrname, ATTR_LEN, "bank%d", i);
+
+		a->attr.mode	= 0644;
+		a->show		= show_bank;
+		a->store	= set_bank;
+	}
+
+	err = sysdev_class_register(&mce_sysdev_class);
+	if (err)
+		return err;
+
+	for_each_online_cpu(i) {
+		err = mce_sysdev_create(i);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
 /* Make sure there are no machine checks on offlined CPUs. */
 static void __cpuinit mce_disable_cpu(void *h)
 {
@@ -2025,46 +2058,18 @@ static struct notifier_block mce_cpu_notifier __cpuinitdata = {
 	.notifier_call = mce_cpu_callback,
 };
 
-static __init void mce_init_banks(void)
-{
-	int i;
-
-	for (i = 0; i < banks; i++) {
-		struct mce_bank *b = &mce_banks[i];
-		struct sysdev_attribute *a = &b->attr;
-
-		sysfs_attr_init(&a->attr);
-		a->attr.name	= b->attrname;
-		snprintf(b->attrname, ATTR_LEN, "bank%d", i);
-
-		a->attr.mode	= 0644;
-		a->show		= show_bank;
-		a->store	= set_bank;
-	}
-}
-
 static __init int mcheck_init_device(void)
 {
 	int err;
-	int i = 0;
 
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	zalloc_cpumask_var(&mce_sysdev_initialized, GFP_KERNEL);
-
-	mce_init_banks();
-
-	err = sysdev_class_register(&mce_sysdev_class);
+	/* register sysfs interface */
+	err = mce_sysdev_init();
 	if (err)
 		return err;
 
-	for_each_online_cpu(i) {
-		err = mce_sysdev_create(i);
-		if (err)
-			return err;
-	}
-
 	register_syscore_ops(&mce_syscore_ops);
 	register_hotcpu_notifier(&mce_cpu_notifier);
 
-- 
1.7.1


