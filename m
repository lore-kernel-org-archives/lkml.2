Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1BDJt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 04:49:26 -0500
Received: from david.siemens.de ([192.35.17.14]:28768 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab1BDJtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:49:24 -0500
Message-ID: <4D4BCB97.6000900@siemens.com>
Date: Fri, 04 Feb 2011 10:49:11 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH] KVM: x86: Convert tsc_write_lock to raw_spinlock
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code under this lock requires non-preemptibility. Ensure this also over
-rt by converting it to raw spinlock.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/x86.c              |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ffd7f8d..25e7734 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -448,7 +448,7 @@ struct kvm_arch {
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
-	spinlock_t tsc_write_lock;
+	raw_spinlock_t tsc_write_lock;
 	u64 last_tsc_nsec;
 	u64 last_tsc_offset;
 	u64 last_tsc_write;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a7f65aa..d813919 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1017,7 +1017,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	unsigned long flags;
 	s64 sdiff;
 
-	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = data - native_read_tsc();
 	ns = get_kernel_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
@@ -1050,7 +1050,7 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	kvm->arch.last_tsc_write = data;
 	kvm->arch.last_tsc_offset = offset;
 	kvm_x86_ops->write_tsc_offset(vcpu, offset);
-	spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 	/* Reset of TSC must disable overshoot protection below */
 	vcpu->arch.hv_clock.tsc_timestamp = 0;
@@ -6009,7 +6009,7 @@ int kvm_arch_init_vm(struct kvm *kvm)
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 
-	spin_lock_init(&kvm->arch.tsc_write_lock);
+	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
 
 	return 0;
 }
-- 
1.7.1
