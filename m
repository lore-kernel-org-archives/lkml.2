Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab0GMCI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:08:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab0GMCIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:08:55 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 04/18] Robust TSC compensation
Date: Mon, 12 Jul 2010 16:07:58 -1000
Message-Id: <1278986892-11733-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278986892-11733-1-git-send-email-zamsden@redhat.com>
References: <1278986892-11733-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the match of TSC find TSC writes that are close to each other
instead of perfectly identical; this allows the compensator to also
work in migration / suspend scenarios.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bb7451b..1c737b2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -897,7 +897,11 @@ void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm *kvm = vcpu->kvm;
 	u64 offset, ns, elapsed;
+<<<<<<< HEAD
 	struct timespec ts;
+=======
+	s64 sdiff;
+>>>>>>> db4c819... oops
 
 	spin_lock(&kvm->arch.tsc_write_lock);
 	offset = data - native_read_tsc();
@@ -905,16 +909,21 @@ void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 	monotonic_to_bootbased(&ts);
 	ns = timespec_to_ns(&ts);
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

