Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0HRJMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:12:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48751 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0HRJMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:12:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bqhhDv/PgixBxB4S+7Kr06/PS9yugGsqC5w8OKXAuUXaZ48sdDw9nnRhv5A/fYiKog
         5QpjcmP5GA/kIog51HwlRRF2+5DmZZbUSgW1IeyPUGGJ30fx6dpVJrDFR3OBAuAflB6K
         oy1pVAOQtylqTIvAOpYHrGFRxM4m/oSAjWu+8=
Date: Wed, 18 Aug 2010 12:11:58 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org
Subject: fix BUG: using smp_processor_id() in preemptible code (resend)
Message-ID: <20100818091157.GA5238@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

[  100.666169] lockdep: fixing up alternatives.
[  100.666183] SMP alternatives: switching to UP code
[  106.942505] BUG: using smp_processor_id() in preemptible [00000000] code: bash/5165
[  106.942541] caller is thermal_throttle_add_dev+0x20/0xa4
[  106.942548] Pid: 5165, comm: bash Not tainted 2.6.36-rc1-dbg-git1-00187-g358afc9-dirty #132
[  106.942553] Call Trace:
[  106.942565]  [<ffffffff811f6c01>] debug_smp_processor_id+0xc9/0xe4
[  106.942571]  [<ffffffff8136d377>] thermal_throttle_add_dev+0x20/0xa4
[  106.942578]  [<ffffffff8136d44d>] thermal_throttle_cpu_callback+0x52/0xb5
[  106.942587]  [<ffffffff810573f8>] notifier_call_chain+0x32/0x5e
[  106.942595]  [<ffffffff8103c840>] ? cpu_maps_update_begin+0x12/0x14
[  106.942602]  [<ffffffff81057443>] __raw_notifier_call_chain+0x9/0xb
[  106.942609]  [<ffffffff8103c703>] __cpu_notify+0x1b/0x2d
[  106.942616]  [<ffffffff8136f57d>] _cpu_up+0x6b/0xe9
[  106.942622]  [<ffffffff8136f645>] cpu_up+0x4a/0x57
[  106.942629]  [<ffffffff81363f77>] store_online+0x41/0x6e
[  106.942637]  [<ffffffff81291b4f>] sysdev_store+0x1b/0x1d
[  106.942644]  [<ffffffff81132186>] sysfs_write_file+0x103/0x13f
[  106.942653]  [<ffffffff810db026>] vfs_write+0xb0/0x14f
[  106.942659]  [<ffffffff810db2c2>] sys_write+0x45/0x6c
[  106.942668]  [<ffffffff81002002>] system_call_fastpath+0x16/0x1b


I have several solutions. Please kindly review.
The first one is:

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index c2a8b26..1269661 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -205,7 +205,9 @@ static int therm_throt_process(bool new_event, int event, int level)
 static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
 {
 	int err;
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+	int cpu = get_cpu();
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	put_cpu();
 
 	err = sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
 	if (err)



Should we call smp_processor_id/get_cpu in thermal_throttle_add_dev?
We know the cpu when calling thermal_throttle_add_dev (in thermal_throttle_cpu_callback and
thermal_throttle_init_device) so we can pass the cpu number when calling it.

My second solution is:

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index c2a8b26..bcd8499 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -202,11 +202,12 @@ static int therm_throt_process(bool new_event, int event, int level)
 
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device: */
-static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
+static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
+				unsigned int cpu)
 {
 	int err;
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
-
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	
 	err = sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
 	if (err)
 		return err;
@@ -251,7 +252,7 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&therm_cpu_lock);
-		err = thermal_throttle_add_dev(sys_dev);
+		err = thermal_throttle_add_dev(sys_dev, cpu);
 		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
@@ -287,7 +288,7 @@ static __init int thermal_throttle_init_device(void)
 #endif
 	/* connect live CPUs to sysfs */
 	for_each_online_cpu(cpu) {
-		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu));
+		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu), cpu);
 		WARN_ON(err);
 	}
 #ifdef CONFIG_HOTPLUG_CPU
