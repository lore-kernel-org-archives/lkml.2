Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab2GLTUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:20:20 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38280 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab2GLTUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:20:14 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 13 Jul 2012 00:48:01 +0530
Message-Id: <20120712191800.30440.16406.sendpatchset@codeblue>
In-Reply-To: <20120712191712.30440.68944.sendpatchset@codeblue>
References: <20120712191712.30440.68944.sendpatchset@codeblue>
Subject: [PATCH RFC V3 2/3] kvm: Note down when cpu relax intercepted or pause loop exited
x-cbid: 12071209-7014-0000-0000-0000018CD8DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Noting pause loop exited or cpu relax intercepted vcpu helps in
filtering right candidate to yield. Wrong selection of vcpu;
i.e., a vcpu that just did a pl-exit or cpu relax intercepted may
contribute to performance degradation.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
v2 patches were
Reviewed-by: Rik van Riel <riel@redhat.com>

 include/linux/kvm_host.h |   12 ++++++++++++
 virt/kvm/kvm_main.c      |    4 ++++
 2 files changed, 16 insertions(+), 0 deletions(-)


diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c446435..4ec1cf0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -183,6 +183,18 @@ struct kvm_vcpu {
 	} async_pf;
 #endif
 
+#ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
+	/*
+	 * Cpu relax intercept or pause loop exit optimization
+	 * cpu_relax_intercepted: set when a vcpu does a pause loop exit
+	 *  or cpu relax intercepted.
+	 * dy_eligible: indicates whether vcpu is eligible for directed yield.
+	 */
+	struct {
+		bool cpu_relax_intercepted;
+		bool dy_eligible;
+	} ple;
+#endif
 	struct kvm_vcpu_arch arch;
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7e14068..4ec0120 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -235,6 +235,8 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 		goto fail;
 	}
 	vcpu->run = page_address(page);
+	vcpu->ple.cpu_relax_intercepted = false;
+	vcpu->ple.dy_eligible = false;
 
 	r = kvm_arch_vcpu_init(vcpu);
 	if (r < 0)
@@ -1577,6 +1579,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	int pass;
 	int i;
 
+	me->ple.cpu_relax_intercepted = true;
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
 	 * currently running, because it got preempted by something
@@ -1602,6 +1605,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 			}
 		}
 	}
+	me->ple.cpu_relax_intercepted = false;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
 

