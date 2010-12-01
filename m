Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0LAQXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:23:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab0LAQXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:23:54 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com
Subject: [PATCH] do not try to register kvmclock if the host does not support it.
Date: Wed,  1 Dec 2010 11:20:55 -0500
Message-Id: <1291220455-29483-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new Async PF code, some of our initiation code was moved to
kvm.c. With that, code that was being issued conditional to kvmclock
successful registration (primary cpu registering), started being
issued unconditionally.

This patch proposes that we protect all registrations inside
kvm_register_clock, re-using the kvmclock-enabled parameter for that.
This fixes this specific bug, and should protect us from similar
changes in the future.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kernel/kvmclock.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index f98d3ea..fcdea34 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -130,6 +130,9 @@ int kvm_register_clock(char *txt)
 	int cpu = smp_processor_id();
 	int low, high, ret;
 
+	if (!kvmclock)
+		return 0;
+
 	low = (int)__pa(&per_cpu(hv_clock, cpu)) | 1;
 	high = ((u64)__pa(&per_cpu(hv_clock, cpu)) >> 32);
 	ret = native_write_msr_safe(msr_kvm_system_time, low, high);
@@ -182,14 +185,19 @@ void __init kvmclock_init(void)
 	if (kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
 		msr_kvm_system_time = MSR_KVM_SYSTEM_TIME_NEW;
 		msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK_NEW;
-	} else if (!(kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)))
+	} else if (!(kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE))) {
+		kvmclock = 0;
 		return;
+	}
 
 	printk(KERN_INFO "kvm-clock: Using msrs %x and %x",
 		msr_kvm_system_time, msr_kvm_wall_clock);
 
-	if (kvm_register_clock("boot clock"))
+	if (kvm_register_clock("boot clock")) {
+		kvmclock = 0;
 		return;
+	}
+
 	pv_time_ops.sched_clock = kvm_clock_read;
 	x86_platform.calibrate_tsc = kvm_get_tsc_khz;
 	x86_platform.get_wallclock = kvm_get_wallclock;
-- 
1.6.2.5

