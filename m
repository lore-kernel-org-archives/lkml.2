Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0KSVwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:52:51 -0500
Received: from kroah.org ([198.145.64.141]:51759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757243Ab0KSVp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:27 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:10 2010
Message-Id: <20101119214410.660351843@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:42:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Gleb Natapov <gleb@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [15/45] KVM: SVM: Fix wrong intercept masks on 32 bit
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 061e2fd16863009c8005b4b5fdfb75c7215c0b99 upstream.

This patch makes KVM on 32 bit SVM working again by
correcting the masks used for iret interception. With the
wrong masks the upper 32 bits of the intercepts are masked
out which leaves vmrun unintercepted. This is not legal on
svm and the vmrun fails.
Bug was introduced by commits 95ba827313 and 3cfc3092.

Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2111,7 +2111,7 @@ static int cpuid_interception(struct vcp
 static int iret_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	++svm->vcpu.stat.nmi_window_exits;
-	svm->vmcb->control.intercept &= ~(1UL << INTERCEPT_IRET);
+	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_IRET);
 	svm->vcpu.arch.hflags |= HF_IRET_MASK;
 	return 1;
 }
@@ -2506,7 +2506,7 @@ static void svm_inject_nmi(struct kvm_vc
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
-	svm->vmcb->control.intercept |= (1UL << INTERCEPT_IRET);
+	svm->vmcb->control.intercept |= (1ULL << INTERCEPT_IRET);
 	++vcpu->stat.nmi_injections;
 }
 


