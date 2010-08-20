Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0HTIMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:12:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab0HTIJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:05 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 26/35] Catchup slower TSC to guest rate
Date: Thu, 19 Aug 2010 22:07:40 -1000
Message-Id: <1282291669-25709-27-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the catchup code to continue adjusting the TSC when
running at lower than the guest rate

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a4215d7..086d56a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1013,8 +1013,11 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 			kvm_x86_ops->adjust_tsc_offset(v, tsc-tsc_timestamp);
 	}
 	local_irq_restore(flags);
-	if (catchup)
+	if (catchup) {
+		if (this_tsc_khz < v->kvm->arch.virtual_tsc_khz)
+			vcpu->tsc_rebase = 1;
 		return 0;
+	}
 
 	/*
 	 * Time as measured by the TSC may go backwards when resetting the base
@@ -5022,6 +5025,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	kvm_guest_exit();
 
+	/* Running on slower TSC without kvmclock, we must bump TSC */
+	if (vcpu->arch.tsc_rebase)
+		kvm_request_clock_update(vcpu);
+
 	preempt_enable();
 
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-- 
1.7.1

