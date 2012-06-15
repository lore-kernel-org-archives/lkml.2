Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2FOQwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 12:52:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44948 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2FOQwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 12:52:13 -0400
Date: Fri, 15 Jun 2012 18:52:31 +0200
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120615165231.GA9169@aftab.osrc.amd.com>
References: <20120612172352.GA4802@aftab.osrc.amd.com>
 <1339521996.31548.95.camel@twins>
 <20120612173506.GB4802@aftab.osrc.amd.com>
 <20120613010413.GA28174@khazad-dum.debian.net>
 <20120613065119.GB15661@aftab.osrc.amd.com>
 <20120613123649.GA26012@khazad-dum.debian.net>
 <20120613161139.GA18450@aftab.osrc.amd.com>
 <20120615123749.GC6083@aftab.osrc.amd.com>
 <1339764161.2559.63.camel@twins>
 <20120615125240.GD6083@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615125240.GD6083@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:52:40PM +0200, Borislav Petkov wrote:
> Actually, the BSP thing was more-or-less an arbitrary deal. What we want as an
> endresult is to do:
> 
> $ echo 1 > /sys/devices/system/cpu/microcode/reload
> 
> (notice this is in the toplevel "cpu" directory in sysfs)
> 
> and do the system-wide reload there.

Actually, that was easier than I thought, see below. And it seems to
workie too.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 15 Jun 2012 18:46:05 +0200
Subject: [PATCH] x86, microcode: Make reload interface per system

The reload interface should be per-system so that a full system ucode
reload happens (on each core) when doing

echo 1 > /sys/devices/system/cpu/microcode/reload

Move it to the cpu subsys directory instead of it being per-cpu.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_core.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 24b852b61be3..4c6f3b37ed3c 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -351,7 +351,6 @@ static DEVICE_ATTR(version, 0400, version_show, NULL);
 static DEVICE_ATTR(processor_flags, 0400, pf_show, NULL);
 
 static struct attribute *mc_default_attrs[] = {
-	&dev_attr_reload.attr,
 	&dev_attr_version.attr,
 	&dev_attr_processor_flags.attr,
 	NULL
@@ -528,6 +527,16 @@ static const struct x86_cpu_id microcode_id[] = {
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
@@ -559,9 +568,17 @@ static int __init microcode_init(void)
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
@@ -571,7 +588,11 @@ static int __init microcode_init(void)
 
 	return 0;
 
-out_driver:
+ out_ucode_group:
+	sysfs_remove_group(&cpu_subsys.dev_root->kobj,
+			   &cpu_root_microcode_group);
+
+ out_driver:
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
@@ -580,7 +601,7 @@ out_driver:
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
 
-out_pdev:
+ out_pdev:
 	platform_device_unregister(microcode_pdev);
 	return error;
 
@@ -596,6 +617,9 @@ static void __exit microcode_exit(void)
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
 	unregister_syscore_ops(&mc_syscore_ops);
 
+	sysfs_remove_group(&cpu_subsys.dev_root->kobj,
+			   &cpu_root_microcode_group);
+
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
 
-- 
1.7.11.rc1



-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
