Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab0IBPbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:31:20 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:44229
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755295Ab0IBPbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:31:17 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L84LPJ-02-7M2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] KVM: SVM: Clean up rip handling in vmrun emulation
Date: Thu, 2 Sep 2010 17:29:47 +0200
Message-ID: <1283441387-7378-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the rip handling in the vmrun emulation
path from using next_rip to the generic kvm register access
functions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ecd4e58..1643f30 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2069,7 +2069,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 		return false;
 	}
 
-	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, vmcb_gpa,
+	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
 			       nested_vmcb->save.rip,
 			       nested_vmcb->control.int_ctl,
 			       nested_vmcb->control.event_inj,
@@ -2270,8 +2270,8 @@ static int vmrun_interception(struct vcpu_svm *svm)
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
-	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
-	skip_emulated_instruction(&svm->vcpu);
+	/* Save rip after vmrun instruction */
+	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);
 
 	if (!nested_svm_vmrun(svm))
 		return 1;
-- 
1.7.0.4


