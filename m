Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab0GAVTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:19:31 -0400
Received: from kroah.org ([198.145.64.141]:33217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759111Ab0GAVPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:18 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:01 2010
Message-Id: <20100701174301.730443769@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [180/200] KVM: SVM: Sync all control registers on nested vmexit
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

Currently the vmexit emulation does not sync control
registers were the access is typically intercepted by the
nested hypervisor. But we can not count on that intercepts
to sync these registers too and make the code
architecturally more correct.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit cdbbdc1210223879450555fee04c29ebf116576b)
---
 arch/x86/kvm/svm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1647,9 +1647,13 @@ static int nested_svm_vmexit(struct vcpu
 	nested_vmcb->save.ds     = vmcb->save.ds;
 	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
 	nested_vmcb->save.idtr   = vmcb->save.idtr;
+	nested_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
 	if (npt_enabled)
 		nested_vmcb->save.cr3    = vmcb->save.cr3;
+	else
+		nested_vmcb->save.cr3    = svm->vcpu.arch.cr3;
 	nested_vmcb->save.cr2    = vmcb->save.cr2;
+	nested_vmcb->save.cr4    = svm->vcpu.arch.cr4;
 	nested_vmcb->save.rflags = vmcb->save.rflags;
 	nested_vmcb->save.rip    = vmcb->save.rip;
 	nested_vmcb->save.rsp    = vmcb->save.rsp;


