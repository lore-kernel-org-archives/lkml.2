Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1AXSIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:08:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab1AXSIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:08:16 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 04/16] KVM-HV: KVM Userspace registering ioctl
Date: Mon, 24 Jan 2011 13:06:25 -0500
Message-Id: <1295892397-11354-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1295892397-11354-1-git-send-email-glommer@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM, which stands for KVM Virtual Memory (I wanted to call it KVM Virtual Mojito),
is a piece of shared memory that is visible to both the hypervisor and the guest
kernel - but not the guest userspace.

The basic idea is that the guest can tell the hypervisor about a specific
piece of memory, and what it expects to find in there. This is a generic
abstraction, that goes to userspace (qemu) if KVM (the hypervisor) can't
handle a specific request, thus giving us flexibility in some features
in the future.

KVM (The hypervisor) can change the contents of this piece of memory at
will. This works well with paravirtual information, and hopefully
normal guest memory - like last update time for the watchdog, for
instance.

This patch contains the basic implementation of the userspace communication.
Userspace can query the presence/absence of this feature in the normal way.
It also tells the hypervisor that it is capable of handling - in whatever
way it chooses, registrations that the hypervisor does not know how to.
In x86, only user so far, this mechanism is implemented as generic userspace
msr exit, that could theorectically be used to implement msr-handling in
userspace.

I am keeping it separate from the headers to facilitate backports to people
who wants to backport the kernel part but not the hypervisor, or the other way around.

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Rik van Riel <riel@redhat.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    4 ++++
 arch/x86/kvm/vmx.c |    4 ++++
 arch/x86/kvm/x86.c |   11 +++++++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 73a8f1d..214e740 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2990,6 +2990,10 @@ static int wrmsr_interception(struct vcpu_svm *svm)
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
 	if (svm_set_msr(&svm->vcpu, ecx, data)) {
 		trace_kvm_msr_write_ex(ecx, data);
+		if (svm->vcpu.run->exit_reason == KVM_EXIT_X86_MSR_OP) {
+			skip_emulated_instruction(&svm->vcpu);
+			return 0;
+		}
 		kvm_inject_gp(&svm->vcpu, 0);
 	} else {
 		trace_kvm_msr_write(ecx, data);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e2c4e32..f5c585f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3385,6 +3385,10 @@ static int handle_wrmsr(struct kvm_vcpu *vcpu)
 
 	if (vmx_set_msr(vcpu, ecx, data) != 0) {
 		trace_kvm_msr_write_ex(ecx, data);
+		if (vcpu->run->exit_reason == KVM_EXIT_X86_MSR_OP) {
+			skip_emulated_instruction(vcpu);
+			return 0;
+		}
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6206fd3..4ee9c87 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1543,6 +1543,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 
 		kvm_read_guest(vcpu->kvm, data, &area_desc, sizeof(area_desc));
 		area_desc.result = 0xF;
+
+		if (vcpu->kvm->register_mem_area_uspace) {
+			vcpu->run->exit_reason = KVM_EXIT_X86_MSR_OP;
+			vcpu->run->msr.msr_data = data;
+			return 1;
+		}
+rma_out:
 		kvm_write_guest(vcpu->kvm, data, &area_desc, sizeof(area_desc));
 		break;
 	}
@@ -1974,6 +1981,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
+	case KVM_CAP_REGISTER_MEM_AREA:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -3555,6 +3563,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_USERSPACE_REGISTER_MEM_AREA:
+		kvm->register_mem_area_uspace = 1;
+		break;
 
 	default:
 		;
-- 
1.7.2.3

