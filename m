Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0HBPBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:01:00 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:24256
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750959Ab0HBPA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:00:58 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzzz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6J4WX-02-4IV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] KVM: SVM: Check for nested vmrun intercept before emulating vmrun
Date: Mon, 2 Aug 2010 16:46:44 +0200
Message-ID: <1280760405-22591-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280760405-22591-1-git-send-email-joerg.roedel@amd.com>
References: <1280760405-22591-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch lets the nested vmrun fail if the L1 hypervisor
has not intercepted vmrun. This fixes the "vmrun intercept
check" unit test.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b44c9cc..083fa88 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2015,6 +2015,14 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 	return true;
 }
 
+static bool nested_vmcb_checks(struct vmcb *vmcb)
+{
+	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
+		return false;
+
+	return true;
+}
+
 static bool nested_svm_vmrun(struct vcpu_svm *svm)
 {
 	struct vmcb *nested_vmcb;
@@ -2029,6 +2037,17 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	if (!nested_vmcb)
 		return false;
 
+	if (!nested_vmcb_checks(nested_vmcb)) {
+		nested_vmcb->control.exit_code    = SVM_EXIT_ERR;
+		nested_vmcb->control.exit_code_hi = 0;
+		nested_vmcb->control.exit_info_1  = 0;
+		nested_vmcb->control.exit_info_2  = 0;
+
+		nested_svm_unmap(page);
+
+		return false;
+	}
+
 	trace_kvm_nested_vmrun(svm->vmcb->save.rip - 3, vmcb_gpa,
 			       nested_vmcb->save.rip,
 			       nested_vmcb->control.int_ctl,
-- 
1.7.0.4


