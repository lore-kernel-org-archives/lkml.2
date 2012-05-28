Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab2E1D3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51798 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752763Ab2E1D2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:28:55 -0400
Message-Id: <20120528031203.583213241@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 005/117] KVM: VMX: vmx_set_cr0 expects kvm->srcu locked
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit 7a4f5ad051e02139a9f1c0f7f4b1acb88915852b)

vmx_set_cr0 is called from vcpu run context, therefore it expects
kvm->srcu to be held (for setting up the real-mode TSS).

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kvm/vmx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7ac5993..7315488 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3915,7 +3915,9 @@ static int vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 		vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
 
 	vmx->vcpu.arch.cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
+	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 	vmx_set_cr0(&vmx->vcpu, kvm_read_cr0(vcpu)); /* enter rmode */
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 	vmx_set_cr4(&vmx->vcpu, 0);
 	vmx_set_efer(&vmx->vcpu, 0);
 	vmx_fpu_activate(&vmx->vcpu);


