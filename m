Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab1GMPfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:35:09 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:35940 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab1GMPfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:35:07 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOA37A-01-0C1-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/7] KVM: SVM: Use host_vmcb_pa for vmload and vmsave
Date: Wed, 13 Jul 2011 17:32:20 +0200
Message-ID: <1310571145-28930-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This saves copying over the vmload/vmsave switched part from
the host to the guest vmcb later.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3d5990f..dc703ac 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3704,9 +3704,13 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 		/* Enter guest mode */
 		"push %%"R"ax \n\t"
-		"mov %c[vmcb](%[svm]), %%"R"ax \n\t"
+		"mov %c[host_vmcb](%[svm]), %%"R"ax \n\t"
 		__ex(SVM_VMLOAD) "\n\t"
+		"mov (%%"R"sp), %%"R"ax\n\t"
+		"mov %c[vmcb](%[svm]), %%"R"ax \n\t"
 		__ex(SVM_VMRUN) "\n\t"
+		"mov (%%"R"sp), %%"R"ax\n\t"
+		"mov %c[host_vmcb](%[svm]), %%"R"ax \n\t"
 		__ex(SVM_VMSAVE) "\n\t"
 		"pop %%"R"ax \n\t"
 
@@ -3731,6 +3735,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 		:
 		: [svm]"a"(svm),
 		  [vmcb]"i"(offsetof(struct vcpu_svm, vmcb_pa)),
+		  [host_vmcb]"i"(offsetof(struct vcpu_svm, host_vmcb_pa)),
 		  [rbx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RBX])),
 		  [rcx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RCX])),
 		  [rdx]"i"(offsetof(struct vcpu_svm, vcpu.arch.regs[VCPU_REGS_RDX])),
-- 
1.7.4.1


