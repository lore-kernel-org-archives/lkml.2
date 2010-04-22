Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0DVKfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:35:41 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:25223 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab0DVKdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:33:31 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L19XBL-01-034-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/8] KVM: SVM: Make sure rip is synced to vmcb before nested vmexit
Date: Thu, 22 Apr 2010 12:33:08 +0200
Message-ID: <1271932394-13968-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Apr 2010 10:33:18.0981 (UTC) FILETIME=[39709B50:01CAE207]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug where a nested guest always went over
the same instruction because the rip was not advanced on a
nested vmexit.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ec20584..c480d7f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2960,6 +2960,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	u16 gs_selector;
 	u16 ldt_selector;
 
+	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
+	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
+	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
+
 	/*
 	 * A vmexit emulation is required before the vcpu can be executed
 	 * again.
@@ -2967,10 +2971,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->nested.exit_required))
 		return;
 
-	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
-	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
-	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
-
 	pre_svm_run(svm);
 
 	sync_lapic_to_cr8(vcpu);
-- 
1.7.0.4


