Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1A1Tt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:49:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab1A1TtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:49:25 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: [PATCH] release kvmclock page on reset
Date: Fri, 28 Jan 2011 14:48:06 -0500
Message-Id: <1296244086-15081-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up to know, we were relying on guest cooperation to turn off kvmclock.
I just realized that even though this is fine and nice, a more robust
method is to (also) turn it off on vcpu_reset on the hypervisor side.
This will protect us against reboots, and we don't expect the guest
to reset its cpu during normal operation anyway.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 arch/x86/kvm/x86.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bcc0efc..38b55b3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5878,6 +5878,11 @@ int kvm_arch_vcpu_reset(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	vcpu->arch.apf.msr_val = 0;
 
+	if (vcpu->arch.time_page) {
+		kvm_release_page_dirty(vcpu->arch.time_page);
+		vcpu->arch.time_page = NULL;
+	}
+
 	kvm_clear_async_pf_completion_queue(vcpu);
 	kvm_async_pf_hash_reset(vcpu);
 	vcpu->arch.apf.halted = false;
-- 
1.7.2.3

