Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0J3Sy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 14:54:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64729 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab0J3Syy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 14:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VaxgW74JoryjhSO9ncKzLn5Rj8v8DPvX8dB1XxIvBe2uH6aE+h3C+UzpEfStouUlZk
         EnzTDA9ordibN3DOFozCKwE8aOh1MnFdDRN+JrwCH9SD8WraDiJdI8uqZ8s1cLxJRpMs
         K58C1uykFCjhBNzVRxt996gUAsnfriERANAsE=
Date: Sat, 30 Oct 2010 22:54:47 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: kernel-janitors@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch v2] x86: kvm: x86: fix information leak to userland
Message-ID: <20101030185447.GA7629@albatros>
References: <1288447871-7715-1-git-send-email-segooon@gmail.com>
 <4CCC2D11.7090109@web.de>
 <20101030153147.GA14169@albatros>
 <4CCC3DC2.6090505@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCC3DC2.6090505@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structures kvm_vcpu_events, kvm_debugregs, kvm_pit_state2 and
kvm_clock_data are copied to userland with some padding and reserved
fields unitialized.  It leads to leaking of contents of kernel stack
memory.  We have to initialize them to zero.

In patch v1 Jan Kiszka suggested to fill reserved fields with zeros
instead of memset'ting the whole struct.  It makes sense as these
fields are explicitly marked as padding.  No more fields need zeroing.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tesed only.

 arch/x86/kvm/x86.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0818f6..463c65b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2560,6 +2560,7 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 		!kvm_exception_is_soft(vcpu->arch.exception.nr);
 	events->exception.nr = vcpu->arch.exception.nr;
 	events->exception.has_error_code = vcpu->arch.exception.has_error_code;
+	events->exception.pad = 0;
 	events->exception.error_code = vcpu->arch.exception.error_code;
 
 	events->interrupt.injected =
@@ -2573,12 +2574,14 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
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
@@ -2623,6 +2626,7 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 	dbgregs->dr6 = vcpu->arch.dr6;
 	dbgregs->dr7 = vcpu->arch.dr7;
 	dbgregs->flags = 0;
+	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
@@ -3106,6 +3110,7 @@ static int kvm_vm_ioctl_get_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
 		sizeof(ps->channels));
 	ps->flags = kvm->arch.vpit->pit_state.flags;
 	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
+	memset(&ps->reserved, 0, sizeof(ps->reserved));
 	return r;
 }
 
@@ -3486,6 +3491,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
 		local_irq_enable();
 		user_ns.flags = 0;
+		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
-- 
Vasiliy
