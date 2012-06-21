Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab2FUMHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:07:43 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51749 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab2FUMHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:07:22 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH -v2 2/2] x86, microcode: Make reload interface per system
Date: Thu, 21 Jun 2012 14:07:17 +0200
Message-Id: <1340280437-7718-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1340280437-7718-1-git-send-email-bp@amd64.org>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The reload interface should be per-system so that a full system ucode
reload happens (on each core) when doing

echo 1 > /sys/devices/system/cpu/microcode/reload

Move it to the cpu subsys directory instead of it being per-cpu.

Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_core.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 24b852b61be3..947e4c64b1d8 100644
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
 
-- 
1.7.11.rc1

