Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab2CYWFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 18:05:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab2CYWFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 18:05:17 -0400
Date: Mon, 26 Mar 2012 00:05:20 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC dontapply] kvm_para: add mmio word store hypercall
Message-ID: <20120325220518.GA27879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We face a dilemma: IO mapped addresses are legacy,
so, for example, PCI express bridges waste 4K
of this space for each link, in effect limiting us
to 16 devices using this space.

Memory is supposed to replace them, but memory
exits are much slower than PIO because of the need for
emulation and page walks.

As a solution, this patch adds an MMIO hypercall with
the guest physical address + data.

I did test that this works but didn't benchmark yet.

TODOs:
This only implements a 2 bytes write since this is
the minimum required for virtio, but we'll probably need
at least 1 byte reads (for ISR read).
We can support up to 8 byte reads/writes for 64 bit
guests and up to 4 bytes for 32 ones - better limit
to 4 bytes for everyone for consistency, or support
the maximum that we can?

Further, a feature bit will need to be exposed to
guests so they know they can use the feature.

Need to test performance impact.

Finally the patch was on an ancient kvm version
and will need to be rebased.
Posting here for early flames/feedback.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/svm.c       |    3 +--
 arch/x86/kvm/vmx.c       |    3 +--
 arch/x86/kvm/x86.c       |   14 ++++++++++++++
 include/linux/kvm_para.h |    1 +
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5fa553b..00460e1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1833,8 +1833,7 @@ static int vmmcall_interception(struct vcpu_svm *svm)
 {
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
-	kvm_emulate_hypercall(&svm->vcpu);
-	return 1;
+	return kvm_emulate_hypercall(&svm->vcpu);
 }
 
 static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3b4c8d8..0fff33e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4597,8 +4597,7 @@ static int handle_halt(struct kvm_vcpu *vcpu)
 static int handle_vmcall(struct kvm_vcpu *vcpu)
 {
 	skip_emulated_instruction(vcpu);
-	kvm_emulate_hypercall(vcpu);
-	return 1;
+	return kvm_emulate_hypercall(vcpu);
 }
 
 static int handle_invd(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9cbfc06..7bc00ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4915,7 +4915,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
+	struct kvm_run *run = vcpu->run;
 	unsigned long nr, a0, a1, a2, a3, ret;
+	gpa_t gpa;
 	int r = 1;
 
 	if (kvm_hv_hypercall_enabled(vcpu->kvm))
@@ -4946,12 +4948,24 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	case KVM_HC_VAPIC_POLL_IRQ:
 		ret = 0;
 		break;
+	case KVM_HC_MMIO_STORE_WORD:
+		gpa = hc_gpa(vcpu, a1, a2);
+		if (!write_mmio(vcpu, gpa, 2, &a0) && run) {
+			run->exit_reason = KVM_EXIT_MMIO;
+			run->mmio.phys_addr = gpa;
+			memcpy(run->mmio.data, &a0, 2);
+			run->mmio.len = 2;
+			run->mmio.is_write = 1;
+                        r = 0;
+		}
+		goto noret;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
 	}
 out:
 	kvm_register_write(vcpu, VCPU_REGS_RAX, ret);
+noret:
 	++vcpu->stat.hypercalls;
 	return r;
 }
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index ff476dd..fa74700 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -19,6 +19,7 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_MMIO_STORE_WORD		5
 
 /*
  * hypercalls use architecture specific
-- 
1.7.9.111.gf3fb0
