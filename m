Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab0GAVTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:19:34 -0400
Received: from kroah.org ([198.145.64.141]:33220 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137Ab0GAVPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:19 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:01 2010
Message-Id: <20100701174301.814600411@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [181/200] KVM: SVM: Fix nested msr intercept handling
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

The nested_svm_exit_handled_msr() function maps only one
page of the guests msr permission bitmap. This patch changes
the code to use kvm_read_guest to fix the bug.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit 4c7da8cb43c09e71a405b5aeaa58a1dbac3c39e9)
---
 arch/x86/kvm/svm.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1459,19 +1459,13 @@ static bool nested_svm_exit_handled_msr(
 {
 	u32 param = svm->vmcb->control.exit_info_1 & 1;
 	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
-	struct page *page;
 	bool ret = false;
 	u32 t0, t1;
-	u8 *msrpm;
+	u8 val;
 
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return false;
 
-	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, &page);
-
-	if (!msrpm)
-		goto out;
-
 	switch (msr) {
 	case 0 ... 0x1fff:
 		t0 = (msr * 2) % 8;
@@ -1492,11 +1486,10 @@ static bool nested_svm_exit_handled_msr(
 		goto out;
 	}
 
-	ret = msrpm[t1] & ((1 << param) << t0);
+	if (!kvm_read_guest(svm->vcpu.kvm, svm->nested.vmcb_msrpm + t1, &val, 1))
+		ret = val & ((1 << param) << t0);
 
 out:
-	nested_svm_unmap(page);
-
 	return ret;
 }
 


