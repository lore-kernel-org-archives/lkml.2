Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2GRNkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:40:22 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38249 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab2GRNkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:40:16 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 18 Jul 2012 19:07:46 +0530
Message-Id: <20120718133746.5321.74543.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
References: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V5 2/3] kvm: Note down when cpu relax intercepted or pause loop exited
x-cbid: 12071803-0260-0000-0000-00000186E0C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Noting pause loop exited vcpu or cpu relax intercepted helps in
filtering right candidate to yield. Wrong selection of vcpu;
i.e., a vcpu that just did a pl-exit or cpu relax intercepted may
contribute to performance degradation.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
V2 was:
Reviewed-by: Rik van Riel <riel@redhat.com>

 include/linux/kvm_host.h |   34 ++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      |    5 +++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c446435..34ce296 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -183,6 +183,18 @@ struct kvm_vcpu {
 	} async_pf;
 #endif
 
+#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
+	/*
+	 * Cpu relax intercept or pause loop exit optimization
+	 * in_spin_loop: set when a vcpu does a pause loop exit
+	 *  or cpu relax intercepted.
+	 * dy_eligible: indicates whether vcpu is eligible for directed yield.
+	 */
+	struct {
+		bool in_spin_loop;
+		bool dy_eligible;
+	} spin_loop;
+#endif
 	struct kvm_vcpu_arch arch;
 };
 
@@ -890,5 +902,27 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 	}
 }
 
+#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
+
+static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
+{
+	vcpu->spin_loop.in_spin_loop = val;
+}
+static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
+{
+	vcpu->spin_loop.dy_eligible = val;
+}
+
+#else /* !CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
+
+static inline void kvm_vcpu_set_in_spin_loop(struct kvm_vcpu *vcpu, bool val)
+{
+}
+
+static inline void kvm_vcpu_set_dy_eligible(struct kvm_vcpu *vcpu, bool val)
+{
+}
+
+#endif /* CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT */
 #endif
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7e14068..3d6ffc8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -236,6 +236,9 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	}
 	vcpu->run = page_address(page);
 
+	kvm_vcpu_set_in_spin_loop(vcpu, false);
+	kvm_vcpu_set_dy_eligible(vcpu, false);
+
 	r = kvm_arch_vcpu_init(vcpu);
 	if (r < 0)
 		goto fail_free_run;
@@ -1577,6 +1580,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	int pass;
 	int i;
 
+	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
 	 * currently running, because it got preempted by something
@@ -1602,6 +1606,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 			}
 		}
 	}
+	kvm_vcpu_set_in_spin_loop(me, false);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 

