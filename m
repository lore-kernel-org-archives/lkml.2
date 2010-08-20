Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab0HTIJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:09:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab0HTII5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:57 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 23/35] Set initial TSC rate conversion factors
Date: Thu, 19 Aug 2010 22:07:37 -1000
Message-Id: <1282291669-25709-24-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/x86.c              |   12 ++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 638cae5..3a54cc1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -403,6 +403,9 @@ struct kvm_arch {
 	u64 last_tsc_nsec;
 	u64 last_tsc_offset;
 	u64 last_tsc_write;
+	u32 virtual_tsc_khz;
+	u32 virtual_tsc_mult;
+	s8 virtual_tsc_shift;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3691e70..d715ec0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -918,6 +918,15 @@ static inline u64 nsec_to_cycles(u64 nsec)
 	return (nsec * __get_cpu_var(cpu_tsc_khz)) / USEC_PER_SEC;
 }
 
+static void kvm_arch_set_tsc_khz(struct kvm *kvm, u32 this_tsc_khz)
+{
+	/* Compute a scale to convert nanoseconds in TSC cycles */
+	kvm_get_time_scale(this_tsc_khz, NSEC_PER_SEC / 1000,
+			   &kvm->arch.virtual_tsc_shift,
+			   &kvm->arch.virtual_tsc_mult);
+	kvm->arch.virtual_tsc_khz = this_tsc_khz;
+}
+
 void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -5636,6 +5645,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	}
 	vcpu->arch.pio_data = page_address(page);
 
+	if (!kvm->arch.virtual_tsc_khz)
+		kvm_arch_set_tsc_khz(kvm, max_tsc_khz);
+
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
 		goto fail_free_pio_data;
-- 
1.7.1

