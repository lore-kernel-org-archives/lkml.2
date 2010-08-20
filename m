Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab0HTIIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab0HTII2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:28 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 12/35] Robust TSC compensation
Date: Thu, 19 Aug 2010 22:07:26 -1000
Message-Id: <1282291669-25709-13-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the match of TSC find TSC writes that are close to each other
instead of perfectly identical; this allows the compensator to also
work in migration / suspend scenarios.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 52680f6..0f3e5fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -928,21 +928,27 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
 	unsigned long flags;
+	s64 sdiff;
 
 	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
 	offset = data - native_read_tsc();
 	ns = get_kernel_ns();
 	elapsed = ns - kvm->arch.last_tsc_nsec;
+	sdiff = data - kvm->arch.last_tsc_write;
+	if (sdiff < 0)
+		sdiff = -sdiff;
 
 	/*
-	 * Special case: identical write to TSC within 5 seconds of
+	 * Special case: close write to TSC within 5 seconds of
 	 * another CPU is interpreted as an attempt to synchronize
-	 * (the 5 seconds is to accomodate host load / swapping).
+	 * The 5 seconds is to accomodate host load / swapping as
+	 * well as any reset of TSC during the boot process.
 	 *
 	 * In that case, for a reliable TSC, we can match TSC offsets,
-	 * or make a best guest using kernel_ns value.
+	 * or make a best guest using elapsed value.
 	 */
-	if (data == kvm->arch.last_tsc_write && elapsed < 5ULL * NSEC_PER_SEC) {
+	if (sdiff < nsec_to_cycles(5ULL * NSEC_PER_SEC) &&
+	    elapsed < 5ULL * NSEC_PER_SEC) {
 		if (!check_tsc_unstable()) {
 			offset = kvm->arch.last_tsc_offset;
 			pr_debug("kvm: matched tsc offset for %llu\n", data);
-- 
1.7.1

