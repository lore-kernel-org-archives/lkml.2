Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1AXSIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:08:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab1AXSII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:08:08 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 10/16] KVM-GST: Implement kvmclock systemtime over KVM - KVM Virtual Memory
Date: Mon, 24 Jan 2011 13:06:31 -0500
Message-Id: <1295892397-11354-11-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a proof of concept to KVM - Kernel Virtual Memory, this patch
implements kvmclock per-vcpu systime grabbing on top of it. At first, it
may seem as a waste of work to just redo it, since it is working well. But over
the time, other MSRs were added - think ASYNC_PF - and more will probably come.
After this patch, we won't need to ever add another virtual MSR to KVM.

If the hypervisor fails to register the memory area, we switch back to legacy
behavior on things that were already present - like kvm clock.

This patch contains the guest part for it. I am keeping it separate to facilitate
backports to people who wants to backport the kernel part but not the
hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/kvmclock.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index b8809f0..c304fdb 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -157,12 +157,28 @@ int kvm_register_clock(char *txt)
 {
 	int cpu = smp_processor_id();
 	int low, high, ret;
-
-	low = (int)__pa(&per_cpu(hv_clock, cpu)) | 1;
-	high = ((u64)__pa(&per_cpu(hv_clock, cpu)) >> 32);
-	ret = native_write_msr_safe(msr_kvm_system_time, low, high);
-	printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
-	       cpu, high, low, txt);
+	struct pvclock_vcpu_time_info *vcpu_time;
+	static int warned;
+
+	vcpu_time = &per_cpu(hv_clock, cpu);
+
+	ret = kvm_register_mem_area(__pa(vcpu_time), KVM_AREA_SYSTIME,
+				    sizeof(*vcpu_time));
+	if (ret == 0) {
+		printk(KERN_INFO "kvm-clock: cpu %d, mem_area %lx %s\n",
+		       cpu, __pa(vcpu_time), txt);
+	} else {
+		low = (int)__pa(vcpu_time) | 1;
+		high = ((u64)__pa(vcpu_time) >> 32);
+		ret = native_write_msr_safe(msr_kvm_system_time, low, high);
+
+		if (!warned++)
+			printk(KERN_INFO "kvm-clock: Using msrs %x and %x",
+				msr_kvm_system_time, msr_kvm_wall_clock);
+
+		printk(KERN_INFO "kvm-clock: cpu %d, msr %x:%x, %s\n",
+		       cpu, high, low, txt);
+	}
 
 	return ret;
 }
@@ -216,9 +232,6 @@ void __init kvmclock_init(void)
 	} else if (!(kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE)))
 		return;
 
-	printk(KERN_INFO "kvm-clock: Using msrs %x and %x",
-		msr_kvm_system_time, msr_kvm_wall_clock);
-
 	if (kvm_register_clock("boot clock"))
 		return;
 	pv_time_ops.sched_clock = kvm_clock_read;
-- 
1.7.2.3

