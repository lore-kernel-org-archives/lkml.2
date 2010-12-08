Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0LHBBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:50 -0500
Received: from kroah.org ([198.145.64.141]:49071 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280Ab0LHBBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:46 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:36 2010
Message-Id: <20101208005736.297567693@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segooon@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [149/289] KVM: x86: fix information leak to userland
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 arch/x86/kvm/x86.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2305,6 +2305,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_
 		!kvm_exception_is_soft(vcpu->arch.exception.nr);
 	events->exception.nr = vcpu->arch.exception.nr;
 	events->exception.has_error_code = vcpu->arch.exception.has_error_code;
+	events->exception.pad = 0;
 	events->exception.error_code = vcpu->arch.exception.error_code;
 
 	events->interrupt.injected =
@@ -2318,12 +2319,14 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_
 	events->nmi.injected = vcpu->arch.nmi_injected;
 	events->nmi.pending = vcpu->arch.nmi_pending;
 	events->nmi.masked = kvm_x86_ops->get_nmi_mask(vcpu);
+	events->nmi.pad = 0;
 
 	events->sipi_vector = vcpu->arch.sipi_vector;
 
 	events->flags = (KVM_VCPUEVENT_VALID_NMI_PENDING
 			 | KVM_VCPUEVENT_VALID_SIPI_VECTOR
 			 | KVM_VCPUEVENT_VALID_SHADOW);
+	memset(&events->reserved, 0, sizeof(events->reserved));
 }
 
 static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
@@ -2366,6 +2369,7 @@ static void kvm_vcpu_ioctl_x86_get_debug
 	dbgregs->dr6 = vcpu->arch.dr6;
 	dbgregs->dr7 = vcpu->arch.dr7;
 	dbgregs->flags = 0;
+	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
@@ -2849,6 +2853,7 @@ static int kvm_vm_ioctl_get_pit2(struct
 		sizeof(ps->channels));
 	ps->flags = kvm->arch.vpit->pit_state.flags;
 	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
+	memset(&ps->reserved, 0, sizeof(ps->reserved));
 	return r;
 }
 
@@ -3229,6 +3234,7 @@ long kvm_arch_vm_ioctl(struct file *filp
 		now_ns = timespec_to_ns(&now);
 		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
 		user_ns.flags = 0;
+		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))


