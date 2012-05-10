Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734Ab2EJRgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:36:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46175 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760701Ab2EJRgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:32 -0400
Message-Id: <20120510173136.547636536@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>
Subject: [ 42/52] KVM: VMX: vmx_set_cr0 expects kvm->srcu locked
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit 7a4f5ad051e02139a9f1c0f7f4b1acb88915852b)

vmx_set_cr0 is called from vcpu run context, therefore it expects
kvm->srcu to be held (for setting up the real-mode TSS).

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3918,7 +3918,9 @@ static int vmx_vcpu_reset(struct kvm_vcp
 		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
 
 	vmx->vcpu.arch.cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 	vmx_set_cr0(&vmx->vcpu, kvm_read_cr0(vcpu)); /* enter rmode */
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	vmx_set_cr4(&vmx->vcpu, 0);
 	vmx_set_efer(&vmx->vcpu, 0);
 	vmx_fpu_activate(&vmx->vcpu);


