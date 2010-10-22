Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab0JVTEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:04:25 -0400
Received: from kroah.org ([198.145.64.141]:34358 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759474Ab0JVS44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:34 2010
Message-Id: <20101022185234.356148502@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Zachary Amsden <zamsden@redhat.com>, mtosatti@redhat.com,
        avi@redhat.com
Subject: [078/103] KVM: x86: Move TSC reset out of vmcb_init
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

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
@@ -766,7 +766,6 @@ static void init_vmcb(struct vcpu_svm *s
 
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __pa(svm->msrpm);
-	control->tsc_offset = 0-native_read_tsc();
 	control->int_ctl = V_INTR_MASKING_MASK;
 
 	init_seg(&save->es);
@@ -902,6 +901,7 @@ static struct kvm_vcpu *svm_create_vcpu(
 	svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
 	svm->asid_generation = 0;
 	init_vmcb(svm);
+	svm->vmcb->control.tsc_offset = 0-native_read_tsc();
 
 	fx_init(&svm->vcpu);
 	svm->vcpu.arch.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;


