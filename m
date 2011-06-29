Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab1F2PiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab1F2PiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:38:00 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v3 5/9] KVM-HV: use schedstats to calculate steal time
Date: Wed, 29 Jun 2011 11:29:44 -0400
Message-Id: <1309361388-30163-6-git-send-email-glommer@redhat.com>
In-Reply-To: <1309361388-30163-1-git-send-email-glommer@redhat.com>
References: <1309361388-30163-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCHEDSTATS provide a precise source of information about time tasks
spent on a runqueue, but not running (among other things). It is
specially useful for the steal time implementation, because it doesn't
record halt time at all.

To avoid a hard dependency on schedstats, since it is possible one won't
want to record statistics about all processes running, the previous method
of time measurement on put/load vcpu is kept  for !SCHEDSTATS.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <aliguori@us.ibm.com>
CC: Eric B Munson <emunson@mgebm.net>
CC: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df9d274..7e87159 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1502,7 +1502,13 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		&vcpu->arch.st.steal, sizeof(struct kvm_steal_time))))
 		return;
 
-	delta = (get_kernel_ns() - vcpu->arch.st.this_time_out);
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+	if (likely(sched_info_on())) {
+		delta = current->sched_info.run_delay - vcpu->arch.st.this_time_out;
+		vcpu->arch.st.this_time_out = current->sched_info.run_delay;
+	} else 
+#endif
+		delta = (get_kernel_ns() - vcpu->arch.st.this_time_out);
 
 	vcpu->arch.st.steal.steal += delta;
 	vcpu->arch.st.steal.version += 2;
@@ -1607,9 +1613,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 							data & KVM_STEAL_VALID_BITS))
 			return 1;
 
-		vcpu->arch.st.this_time_out = get_kernel_ns();
-		record_steal_time(vcpu);
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+		if (likely(sched_info_on()))
+			vcpu->arch.st.this_time_out = current->sched_info.run_delay;
+		else
+#endif
+			vcpu->arch.st.this_time_out = get_kernel_ns();
 
+		record_steal_time(vcpu);
 		break;
 
 	case MSR_IA32_MCG_CTL:
@@ -2220,7 +2231,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
 	kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
-	vcpu->arch.st.this_time_out = get_kernel_ns();
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+	if (unlikely(!sched_info_on()))
+#endif
+		vcpu->arch.st.this_time_out = get_kernel_ns();
 }
 
 static int is_efer_nx(void)
-- 
1.7.3.4

