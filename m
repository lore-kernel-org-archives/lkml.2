Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab0HUEna (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 00:43:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:39732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0HUEn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 00:43:27 -0400
Date: Sat, 21 Aug 2010 04:43:03 GMT
From: tip-bot for Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        Joerg.Roedel@amd.com, maciej.rutecki@gmail.com, fenghua.yu@intel.com,
        sergey.senozhatsky@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Joerg.Roedel@amd.com, maciej.rutecki@gmail.com, fenghua.yu@intel.com,
        sergey.senozhatsky@gmail.com, tglx@linutronix.de
In-Reply-To: <20100820073634.GB5209@swordfish.minsk.epam.com>
References: <20100820073634.GB5209@swordfish.minsk.epam.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, hwmon: Fix unsafe smp_processor_id() in thermal_throttle_add_dev
Message-ID: <tip-51e3c1b558b31b11bf5fc66d3c6f5adacf3573f7@git.kernel.org>
Git-Commit-ID: 51e3c1b558b31b11bf5fc66d3c6f5adacf3573f7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 21 Aug 2010 04:43:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51e3c1b558b31b11bf5fc66d3c6f5adacf3573f7
Gitweb:     http://git.kernel.org/tip/51e3c1b558b31b11bf5fc66d3c6f5adacf3573f7
Author:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
AuthorDate: Fri, 20 Aug 2010 10:36:34 +0300
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Aug 2010 19:56:00 -0700

x86, hwmon: Fix unsafe smp_processor_id() in thermal_throttle_add_dev

Fix BUG: using smp_processor_id() in preemptible thermal_throttle_add_dev.
We know the cpu number when calling thermal_throttle_add_dev, so we can
remove smp_processor_id call in thermal_throttle_add_dev by supplying
the cpu number as argument.

This should resolve kernel bugzilla 16615/16629.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
LKML-Reference: <20100820073634.GB5209@swordfish.minsk.epam.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index c2a8b26..d9368ee 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -202,10 +202,11 @@ static int therm_throt_process(bool new_event, int event, int level)
 
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device: */
-static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
+static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
+				unsigned int cpu)
 {
 	int err;
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	err = sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
 	if (err)
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
