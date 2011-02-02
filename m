Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1BBN32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 08:29:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab1BBN31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 08:29:27 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: [PATCH v2] use guest value of version field in kvmclock
Date: Wed,  2 Feb 2011 08:27:56 -0500
Message-Id: <1296653276-31931-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi noticed that we have to use guest's value for the version field,
instead of keeping track of it ourselves. If we don't do that,
the following situation can arise:

 vcpu->arch.hv_clock.version is initialized to zero.
 Guest reads version (result: 2)
 Guest starts reading data
 Live migration; vcpu->arch.hv_clock.version is zeroed
 Steal time update; vcpu->arch.hv_clock.version += 2; write to guest
 Guest continues reading data
 Guest reads version (result: 2)

Signed-off-by: Glauber Costa <glommer@redhat.com>
CC: Avi Kivity <avi@redhat.com>

---
v2: don't get rid of the actual values =)
---
 arch/x86/kvm/x86.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c39ab4a..5707405 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1151,15 +1151,18 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->last_guest_tsc = tsc_timestamp;
 	vcpu->hv_clock.flags = 0;
 
+	shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
+
 	/*
 	 * The interface expects us to write an even number signaling that the
 	 * update is finished. Since the guest won't see the intermediate
-	 * state, we just increase by 2 at the end.
+	 * state, we just increase by 2 at the end. We use the guest's value as
+	 * a basis to make it migration-safe.
 	 */
+	memcpy(&vcpu->hv_clock.version, shared_kaddr + vcpu->time_offset,
+	       sizeof(vcpu->hv_clock.version));
 	vcpu->hv_clock.version += 2;
 
-	shared_kaddr = kmap_atomic(vcpu->time_page, KM_USER0);
-
 	memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
 	       sizeof(vcpu->hv_clock));
 
-- 
1.7.2.3

