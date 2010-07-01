Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab0GAU5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:57:37 -0400
Received: from kroah.org ([198.145.64.141]:47999 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab0GAUvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:38 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:40 2010
Message-Id: <20100701173440.214873866@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 159/164] KVM: SVM: Dont allow nested guest to VMMCALL into host
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

This patch disables the possibility for a l2-guest to do a
VMMCALL directly into the host. This would happen if the
l1-hypervisor doesn't intercept VMMCALL and the l2-guest
executes this instruction.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit 0d945bd9351199744c1e89d57a70615b6ee9f394)
---
 arch/x86/kvm/svm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1829,8 +1829,13 @@ static bool nested_svm_vmrun(struct vcpu
 		svm->vmcb->control.intercept_cr_write &= ~INTERCEPT_CR8_MASK;
 	}
 
-	/* We don't want a nested guest to be more powerful than the guest,
-	   so all intercepts are ORed */
+	/* We don't want to see VMMCALLs from a nested guest */
+	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMMCALL);
+
+	/*
+	 * We don't want a nested guest to be more powerful than the guest, so
+	 * all intercepts are ORed
+	 */
 	svm->vmcb->control.intercept_cr_read |=
 		nested_vmcb->control.intercept_cr_read;
 	svm->vmcb->control.intercept_cr_write |=


