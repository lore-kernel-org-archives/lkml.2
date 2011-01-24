Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1AXSIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:08:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab1AXSH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:07:58 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 07/16] KVM-GST: Implement wallclock over KVM - KVM Virtual Memory
Date: Mon, 24 Jan 2011 13:06:28 -0500
Message-Id: <1295892397-11354-8-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a proof of concept to KVM - Kernel Virtual Memory, this patch
implements wallclock grabbing on top of it. At first, it may seem
as a waste of work to just redo it, since it is working well. But over the
time, other MSRs were added - think ASYNC_PF - and more will probably come.
After this patch, we won't need to ever add another virtual MSR to KVM.

If the hypervisor fails to register the memory area, we switch back to legacy
behavior on things that were already present - like kvm clock.

This patch contains the hypervisor guest implementation for it. I am keeping it
separate to facilitate backports to people who wants to backport
the kernel part but not the hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/kvmclock.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index f98d3ea..b8809f0 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -31,6 +31,7 @@
 static int kvmclock = 1;
 static int msr_kvm_system_time = MSR_KVM_SYSTEM_TIME;
 static int msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK;
+static int kvm_memory_area_available = 0;
 
 static int parse_no_kvmclock(char *arg)
 {
@@ -43,6 +44,27 @@ early_param("no-kvmclock", parse_no_kvmclock);
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct pvclock_vcpu_time_info, hv_clock);
 static struct pvclock_wall_clock wall_clock;
 
+static int kvm_register_mem_area(u64 base, int type, int size)
+{
+	int low, high;
+
+	struct kvm_memory_area mem;
+
+	if (!kvm_memory_area_available)
+		return 1;
+
+	mem.base = base;
+	mem.size = size;
+	mem.type = type;
+
+	low = (int)__pa_symbol(&mem);
+	high = ((u64)__pa_symbol(&mem) >> 32);
+
+	native_write_msr(MSR_KVM_REGISTER_MEM_AREA, low, high);
+	return mem.result;
+}
+
+
 /*
  * The wallclock is the time of day when we booted. Since then, some time may
  * have elapsed since the hypervisor wrote the data. So we try to account for
@@ -53,11 +75,17 @@ static unsigned long kvm_get_wallclock(void)
 	struct pvclock_vcpu_time_info *vcpu_time;
 	struct timespec ts;
 	int low, high;
-
-	low = (int)__pa_symbol(&wall_clock);
-	high = ((u64)__pa_symbol(&wall_clock) >> 32);
-
-	native_write_msr(msr_kvm_wall_clock, low, high);
+	u64 addr = __pa_symbol(&wall_clock);
+	int ret;
+	
+	ret = kvm_register_mem_area(addr, KVM_AREA_WALLCLOCK,
+				    sizeof(wall_clock));
+	if (ret != 0) {
+		low = (int)addr;
+		high = ((u64)addr >> 32);
+
+		native_write_msr(msr_kvm_wall_clock, low, high);
+	}
 
 	vcpu_time = &get_cpu_var(hv_clock);
 	pvclock_read_wallclock(&wall_clock, vcpu_time, &ts);
@@ -179,6 +207,9 @@ void __init kvmclock_init(void)
 	if (!kvm_para_available())
 		return;
 
+	if (kvm_para_has_feature(KVM_FEATURE_MEMORY_AREA))
+		kvm_memory_area_available = 1;
+
 	if (kvmclock && kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
 		msr_kvm_system_time = MSR_KVM_SYSTEM_TIME_NEW;
 		msr_kvm_wall_clock = MSR_KVM_WALL_CLOCK_NEW;
-- 
1.7.2.3

