Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab0KSVvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:51:06 -0500
Received: from kroah.org ([198.145.64.141]:51794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335Ab0KSVpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:31 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:11 2010
Message-Id: <20101119214411.151411755@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:43:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com, Zachary Amsden <zamsden@redhat.com>
Subject: [21/45] [PATCH 7/8] KVM: x86: Move TSC reset out of vmcb_init
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zachary Amsden <zamsden@redhat.com>

commit 47008cd887c1836bcadda123ba73e1863de7a6c4 upstream.

The VMCB is reset whenever we receive a startup IPI, so Linux is setting
TSC back to zero happens very late in the boot process and destabilizing
the TSC.  Instead, just set TSC to zero once at VCPU creation time.

Why the separate patch?  So git-bisect is your friend.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -621,7 +621,6 @@ static void init_vmcb(struct vcpu_svm *s
 
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __pa(svm->msrpm);
-	control->tsc_offset = 0-native_read_tsc();
 	control->int_ctl = V_INTR_MASKING_MASK;
 
 	init_seg(&save->es);
@@ -754,6 +753,7 @@ static struct kvm_vcpu *svm_create_vcpu(
 	svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
 	svm->asid_generation = 0;
 	init_vmcb(svm);
+	svm->vmcb->control.tsc_offset = 0-native_read_tsc();
 
 	fx_init(&svm->vcpu);
 	svm->vcpu.fpu_active = 1;


