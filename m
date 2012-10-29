Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab2J2OMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:12:30 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38059 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2J2OM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:12:27 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Date: Mon, 29 Oct 2012 19:37:18 +0530
Message-Id: <20121029140717.15448.83182.sendpatchset@codeblue>
In-Reply-To: <20121029140621.15448.92083.sendpatchset@codeblue>
References: <20121029140621.15448.92083.sendpatchset@codeblue>
Subject: [PATCH V2 RFC 3/3] kvm: Check system load and handle different commit cases accordingly
x-cbid: 12102914-5816-0000-0000-0000051B02EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

The patch indroduces a helper function that calculates the system load
(idea borrowed from loadavg calculation). The load is normalized to
2048 i.e., return value (threshold) of 2048 implies an approximate 1:1
committed guest.

In undercommit cases (threshold/2) we simply return from PLE handler.
In overcommit cases (1.75 * threshold) we do a yield(). The rationale is to
allow other VMs of the host to run instead of burning the cpu cycle.

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
Idea of yielding in overcommit cases (especially in large number of small guest
cases was
Acked-by: Rik van Riel <riel@redhat.com>
Andrew Theurer also has stressed the importance of reducing yield_to
overhead and using yield().

(let threshold = 2048)
Rationale for using threshold/2 for undercommit limit:
 Having a load below (0.5 * threshold) is used to avoid (the concern rasied by Rik)
scenarios where we still have lock holder preempted vcpu waiting to be
scheduled. (scenario arises when rq length is > 1 even when we are under
committed)

Rationale for using (1.75 * threshold) for overcommit scenario:
This is a heuristic where we should probably see rq length > 1
and a vcpu of a different VM is waiting to be scheduled.

 virt/kvm/kvm_main.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e376434..28bbdfb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1697,15 +1697,43 @@ bool kvm_vcpu_eligible_for_directed_yield(struct kvm_vcpu *vcpu)
 }
 #endif
 
+/*
+ * A load of 2048 corresponds to 1:1 overcommit
+ * undercommit threshold is half the 1:1 overcommit
+ * overcommit threshold is 1.75 times of 1:1 overcommit threshold
+ */
+#define COMMIT_THRESHOLD (FIXED_1)
+#define UNDERCOMMIT_THRESHOLD (COMMIT_THRESHOLD >> 1)
+#define OVERCOMMIT_THRESHOLD ((COMMIT_THRESHOLD << 1) - (COMMIT_THRESHOLD >> 2))
+
+unsigned long kvm_system_load(void)
+{
+	unsigned long load;
+
+	load = avenrun[0] + FIXED_1/200;
+	load = load / num_online_cpus();
+
+	return load;
+}
+
 void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 {
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
 	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
 	int yielded = 0;
+	unsigned long load;
 	int pass;
 	int i;
 
+	load = kvm_system_load();
+	/*
+	 * When we are undercomitted let us not waste time in
+	 * iterating over all the VCPUs.
+	 */
+	if (load < UNDERCOMMIT_THRESHOLD)
+		return;
+
 	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
@@ -1735,6 +1763,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 				break;
 		}
 	}
+	/*
+	 * If we are not able to yield especially in overcommit cases
+	 * let us be courteous to other VM's VCPUs waiting to be scheduled.
+	 */
+	if (!yielded && load > OVERCOMMIT_THRESHOLD)
+		yield();
+
 	kvm_vcpu_set_in_spin_loop(me, false);
 
 	/* Ensure vcpu is not eligible during next spinloop */

