Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1AXSIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:08:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab1AXSIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:08:07 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 14/16] KVM-GST: KVM Steal time registration
Date: Mon, 24 Jan 2011 13:06:35 -0500
Message-Id: <1295892397-11354-15-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register steal time within KVM. Everytime we sample the steal time
information, we update a local variable that tells what was the
last time read. We then account the difference.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/kvmclock.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index c304fdb..c0b0522 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -22,6 +22,7 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <linux/percpu.h>
+#include <linux/sched.h>
 
 #include <asm/x86_init.h>
 #include <asm/reboot.h>
@@ -42,7 +43,9 @@ early_param("no-kvmclock", parse_no_kvmclock);
 
 /* The hypervisor will put information about time periodically here */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct pvclock_vcpu_time_info, hv_clock);
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct kvm_steal_time, steal_time);
 static struct pvclock_wall_clock wall_clock;
+static DEFINE_PER_CPU(u64, steal_info);
 
 static int kvm_register_mem_area(u64 base, int type, int size)
 {
@@ -153,14 +156,43 @@ static struct clocksource kvm_clock = {
 	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+static cputime_t kvm_account_steal_time(void)
+{
+	u64 delta = 0;
+	u64 *last_steal_info, this_steal_info;
+	struct kvm_steal_time *src;
+	cputime_t cpu;
+
+	src = &get_cpu_var(steal_time);
+	this_steal_info = src->steal;
+	put_cpu_var(steal_time);
+
+	last_steal_info = &get_cpu_var(steal_info);
+
+	delta = this_steal_info - *last_steal_info;
+
+	*last_steal_info = this_steal_info;
+	put_cpu_var(steal_info);
+
+	cpu = usecs_to_cputime(delta / 1000);
+
+	return cpu;
+}
+
 int kvm_register_clock(char *txt)
 {
 	int cpu = smp_processor_id();
 	int low, high, ret;
 	struct pvclock_vcpu_time_info *vcpu_time;
+	struct kvm_steal_time *stime;
 	static int warned;
 
 	vcpu_time = &per_cpu(hv_clock, cpu);
+	stime = &per_cpu(steal_time, cpu);
+
+	ret = kvm_register_mem_area(__pa(stime), KVM_AREA_STEAL_TIME, sizeof(*stime));
+	if (ret == 0)
+		hypervisor_steal_time = kvm_account_steal_time;
 
 	ret = kvm_register_mem_area(__pa(vcpu_time), KVM_AREA_SYSTIME,
 				    sizeof(*vcpu_time));
-- 
1.7.2.3

