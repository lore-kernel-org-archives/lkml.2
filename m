Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab1EFAOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:14:24 -0400
Received: from kroah.org ([198.145.64.141]:32988 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab1EFANn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:11 2011
Message-Id: <20110506001210.909213003@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:11:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Avi Kivity <avi@redhat.com>
Subject: [patch 37/38] KVM: SVM: check for progress after IRET interception
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit bd3d1ec3d26b61120bb4f60b18ee99aa81839e6b upstream.

When we enable an NMI window, we ask for an IRET intercept, since
the IRET re-enables NMIs.  However, the IRET intercept happens before
the instruction executes, while the NMI window architecturally opens
afterwards.

To compensate for this mismatch, we only open the NMI window in the
following exit, assuming that the IRET has by then executed; however,
this assumption is not always correct; we may exit due to a host interrupt
or page fault, without having executed the instruction.

Fix by checking for forward progress by recording and comparing the IRET's
rip.  This is somewhat of a hack, since an unchaging rip does not mean that
no forward progress has been made, but is the simplest fix for now.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -135,6 +135,8 @@ struct vcpu_svm {
 
 	u32 *msrpm;
 
+	ulong nmi_iret_rip;
+
 	struct nested_state nested;
 
 	bool nmi_singlestep;
@@ -2653,6 +2655,7 @@ static int iret_interception(struct vcpu
 	++svm->vcpu.stat.nmi_window_exits;
 	clr_intercept(svm, INTERCEPT_IRET);
 	svm->vcpu.arch.hflags |= HF_IRET_MASK;
+	svm->nmi_iret_rip = kvm_rip_read(&svm->vcpu);
 	return 1;
 }
 
@@ -3474,7 +3477,12 @@ static void svm_complete_interrupts(stru
 
 	svm->int3_injected = 0;
 
-	if (svm->vcpu.arch.hflags & HF_IRET_MASK) {
+	/*
+	 * If we've made progress since setting HF_IRET_MASK, we've
+	 * executed an IRET and can allow NMI injection.
+	 */
+	if ((svm->vcpu.arch.hflags & HF_IRET_MASK)
+	    && kvm_rip_read(&svm->vcpu) != svm->nmi_iret_rip) {
 		svm->vcpu.arch.hflags &= ~(HF_NMI_MASK | HF_IRET_MASK);
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	}


