Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab0LLXqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36170 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0LLXqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:50 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: segooon@gmail.com, mtosatti@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [105/223] KVM: x86: fix information leak to userland
Message-Id: <20101212234645.C0955B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segooon@gmail.com>

commit 97e69aa62f8b5d338d6cff49be09e37cc1262838 upstream.

Structures kvm_vcpu_events, kvm_debugregs, kvm_pit_state2 and
kvm_clock_data are copied to userland with some padding and reserved
fields unitialized.  It leads to leaking of contents of kernel stack
memory.  We have to initialize them to zero.

In patch v1 Jan Kiszka suggested to fill reserved fields with zeros
instead of memset'ting the whole struct.  It makes sense as these
fields are explicitly marked as padding.  No more fields need zeroing.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kvm/x86.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kvm/x86.c
===================================================================
--- linux.orig/arch/x86/kvm/x86.c
+++ linux/arch/x86/kvm/x86.c
@@ -2220,6 +2220,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_
 		!kvm_exception_is_soft(vcpu->arch.exception.nr);
 	events->exception.nr = vcpu->arch.exception.nr;
 	events->exception.has_error_code = vcpu->arch.exception.has_error_code;
+	events->exception.pad = 0;
 	events->exception.error_code = vcpu->arch.exception.error_code;
 
 	events->interrupt.injected =
@@ -2233,13 +2234,14 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_
 	events->nmi.injected = vcpu->arch.nmi_injected;
 	events->nmi.pending = vcpu->arch.nmi_pending;
 	events->nmi.masked = kvm_x86_ops->get_nmi_mask(vcpu);
+	events->nmi.pad = 0;
 
 	events->sipi_vector = vcpu->arch.sipi_vector;
 
 	events->flags = (KVM_VCPUEVENT_VALID_NMI_PENDING
 			 | KVM_VCPUEVENT_VALID_SIPI_VECTOR
 			 | KVM_VCPUEVENT_VALID_SHADOW);
-
+	memset(&events->reserved, 0, sizeof(events->reserved));
 	vcpu_put(vcpu);
 }
 
@@ -2289,6 +2291,7 @@ static void kvm_vcpu_ioctl_x86_get_debug
 	dbgregs->dr6 = vcpu->arch.dr6;
 	dbgregs->dr7 = vcpu->arch.dr7;
 	dbgregs->flags = 0;
+	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
 
 	vcpu_put(vcpu);
 }
@@ -2756,6 +2759,7 @@ static int kvm_vm_ioctl_get_pit2(struct
 		sizeof(ps->channels));
 	ps->flags = kvm->arch.vpit->pit_state.flags;
 	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
+	memset(&ps->reserved, 0, sizeof(ps->reserved));
 	return r;
 }
 
@@ -3153,6 +3157,7 @@ long kvm_arch_vm_ioctl(struct file *filp
 		now_ns = timespec_to_ns(&now);
 		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
 		user_ns.flags = 0;
+		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
