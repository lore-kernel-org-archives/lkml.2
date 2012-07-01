Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab2GATgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 15:36:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47002 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab2GATgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 15:36:32 -0400
Date: Sun, 1 Jul 2012 12:35:58 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-3d8986bc7f309483ee09c7a02888bab09072c19b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, hmh@hmh.eng.br,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <1340280437-7718-3-git-send-email-bp@amd64.org>
References: <1340280437-7718-3-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode:
  Make reload interface per system
Git-Commit-ID: 3d8986bc7f309483ee09c7a02888bab09072c19b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 01 Jul 2012 12:36:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d8986bc7f309483ee09c7a02888bab09072c19b
Gitweb:     http://git.kernel.org/tip/3d8986bc7f309483ee09c7a02888bab09072c19b
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 21 Jun 2012 14:07:17 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 1 Jul 2012 10:24:09 -0700

x86, microcode: Make reload interface per system

The reload interface should be per-system so that a full system ucode
reload happens (on each core) when doing

echo 1 > /sys/devices/system/cpu/microcode/reload

Move it to the cpu subsys directory instead of it being per-cpu.

Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1340280437-7718-3-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/microcode_core.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 24b852b..947e4c6 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -301,10 +301,6 @@ static ssize_t reload_store(struct device *dev,
 	int cpu;
 	ssize_t ret = 0, tmp_ret;
 
-	/* allow reload only from the BSP */
-	if (boot_cpu_data.cpu_index != dev->id)
-		return -EINVAL;
-
 	ret = kstrtoul(buf, 0, &val);
 	if (ret)
 		return ret;
@@ -351,7 +347,6 @@ static DEVICE_ATTR(version, 0400, version_show, NULL);
 static DEVICE_ATTR(processor_flags, 0400, pf_show, NULL);
 
 static struct attribute *mc_default_attrs[] = {
-	&dev_attr_reload.attr,
 	&dev_attr_version.attr,
 	&dev_attr_processor_flags.attr,
 	NULL
@@ -528,6 +523,16 @@ static const struct x86_cpu_id microcode_id[] = {
 MODULE_DEVICE_TABLE(x86cpu, microcode_id);
 #endif
 
+static struct attribute *cpu_root_microcode_attrs[] = {
+	&dev_attr_reload.attr,
+	NULL
+};
+
+static struct attribute_group cpu_root_microcode_group = {
+	.name  = "microcode",
+	.attrs = cpu_root_microcode_attrs,
+};
+
 static int __init microcode_init(void)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
@@ -559,9 +564,17 @@ static int __init microcode_init(void)
 	if (error)
 		goto out_pdev;
 
+	error = sysfs_create_group(&cpu_subsys.dev_root->kobj,
+				   &cpu_root_microcode_group);
+
+	if (error) {
+		pr_err("Error creating microcode group!\n");
+		goto out_driver;
+	}
+
 	error = microcode_dev_init();
 	if (error)
-		goto out_driver;
+		goto out_ucode_group;
 
 	register_syscore_ops(&mc_syscore_ops);
 	register_hotcpu_notifier(&mc_cpu_notifier);
@@ -571,7 +584,11 @@ static int __init microcode_init(void)
 
 	return 0;
 
-out_driver:
+ out_ucode_group:
+	sysfs_remove_group(&cpu_subsys.dev_root->kobj,
+			   &cpu_root_microcode_group);
+
+ out_driver:
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
@@ -580,7 +597,7 @@ out_driver:
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
-out_pdev:
+ out_pdev:
 	platform_device_unregister(microcode_pdev);
 	return error;
 
@@ -596,6 +613,9 @@ static void __exit microcode_exit(void)
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
 	unregister_syscore_ops(&mc_syscore_ops);
 
+	sysfs_remove_group(&cpu_subsys.dev_root->kobj,
+			   &cpu_root_microcode_group);
+
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
