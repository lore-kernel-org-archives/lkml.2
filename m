Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2FCH2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 03:28:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab2FCH2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 03:28:08 -0400
Date: Sun, 3 Jun 2012 10:27:59 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv6 2/8] kvm: optimize ISR lookups
Message-ID: <d054c34a0765aee4e4f751bde73615befa33cc87.1338474301.git.mst@redhat.com>
References: <cover.1338474301.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1338474301.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We perform ISR lookups twice: during interrupt
injection and on EOI. Typical workloads only have
a single bit set there. So we can avoid ISR scans by
1. counting bits as we set/clear them in ISR
2. on set, caching the injected vector number
3. on clear, invalidating the cache

The real purpose of this is enabling PV EOI
which needs to quickly validate the vector.
But non PV guests also benefit: with this patch,
and without interrupt nesting, apic_find_highest_isr
will always return immediately without scanning ISR.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This revision is slightly reworked from the last version
I sent: I don't invalidate the cache when there is more
than one bit set in ISR. This makes the code simpler,
makes cache valid in more cases and avoids a branch on data path.

Otherwise this is basically the same as v2: this revision does not
yet address Thomas's idea of reworking the APIC page handling.

 arch/x86/kvm/lapic.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.h |    4 ++++
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 93c1574..db54e63 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -107,6 +107,16 @@ static inline void apic_clear_vector(int vec, void *bitmap)
 	clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
+static inline int __apic_test_and_set_vector(int vec, void *bitmap)
+{
+	return __test_and_set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
+}
+
+static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
+{
+	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
+}
+
 static inline int apic_hw_enabled(struct kvm_lapic *apic)
 {
 	return (apic)->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
@@ -210,6 +220,16 @@ static int find_highest_vector(void *bitmap)
 		return fls(word[word_offset << 2]) - 1 + (word_offset << 5);
 }
 
+static u8 count_vectors(void *bitmap)
+{
+	u32 *word = bitmap;
+	int word_offset;
+	u8 count = 0;
+	for (word_offset = 0; word_offset < MAX_APIC_VECTOR >> 5; ++word_offset)
+		count += hweight32(word[word_offset << 2]);
+	return count;
+}
+
 static inline int apic_test_and_set_irr(int vec, struct kvm_lapic *apic)
 {
 	apic->irr_pending = true;
@@ -242,6 +262,22 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 		apic->irr_pending = true;
 }
 
+static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
+{
+	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
+		++apic->isr_count;
+	BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
+	apic->isr_cache = vec;
+}
+
+static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
+{
+	if (__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
+		--apic->isr_count;
+	BUG_ON(apic->isr_count < 0);
+	apic->isr_cache = -1;
+}
+
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
@@ -273,6 +309,10 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq)
 static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 {
 	int result;
+	if (!apic->isr_count)
+		return -1;
+	if (likely(apic->isr_cache != -1))
+		return apic->isr_cache;
 
 	result = find_highest_vector(apic->regs + APIC_ISR);
 	ASSERT(result == -1 || result >= 16);
@@ -492,7 +532,7 @@ static void apic_set_eoi(struct kvm_lapic *apic)
 	if (vector == -1)
 		return;
 
-	apic_clear_vector(vector, apic->regs + APIC_ISR);
+	apic_clear_isr(vector, apic);
 	apic_update_ppr(apic);
 
 	if (!(apic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
@@ -1081,6 +1121,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
 		apic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
 	}
 	apic->irr_pending = false;
+	apic->isr_count = 0;
+	apic->isr_cache = -1;
 	update_divide_count(apic);
 	atomic_set(&apic->lapic_timer.pending, 0);
 	if (kvm_vcpu_is_bsp(vcpu))
@@ -1248,7 +1290,7 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	if (vector == -1)
 		return -1;
 
-	apic_set_vector(vector, apic->regs + APIC_ISR);
+	apic_set_isr(vector, apic);
 	apic_update_ppr(apic);
 	apic_clear_irr(vector, apic);
 	return vector;
@@ -1267,6 +1309,8 @@ void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu)
 	update_divide_count(apic);
 	start_apic_timer(apic);
 	apic->irr_pending = true;
+	apic->isr_count = count_vectors(apic->regs + APIC_ISR);
+	apic->isr_cache = -1;
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d29da25..edc985e 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -13,6 +13,10 @@ struct kvm_lapic {
 	u32 divide_count;
 	struct kvm_vcpu *vcpu;
 	bool irr_pending;
+	/* Number of bits set in ISR. */
+	s16 isr_count;
+	/* The highest vector set in ISR; if -1 - invalid, must scan ISR. */
+	int isr_cache;
 	/**
 	 * APIC register page.  The layout matches the register layout seen by
 	 * the guest 1:1, because it is accessed by the vmx microcode.
-- 
MST

