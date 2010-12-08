Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab0LHBcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:32:33 -0500
Received: from kroah.org ([198.145.64.141]:49078 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab0LHBBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:47 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:36 2010
Message-Id: <20101208005736.402742096@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [150/289] KVM: Correct ordering of ldt reload wrt fs/gs reload
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit 0a77fe4c188e25917799f2356d4aa5e6d80c39a2 upstream.

If fs or gs refer to the ldt, they must be reloaded after the ldt.  Reorder
the code to that effect.

Userspace code that uses the ldt with kvm is nonexistent, so this doesn't fix
a user-visible bug.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |    2 +-
 arch/x86/kvm/vmx.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3281,6 +3281,7 @@ static void svm_vcpu_run(struct kvm_vcpu
 	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 
 	load_host_msrs(vcpu);
+	kvm_load_ldt(ldt_selector);
 	loadsegment(fs, fs_selector);
 #ifdef CONFIG_X86_64
 	load_gs_index(gs_selector);
@@ -3288,7 +3289,6 @@ static void svm_vcpu_run(struct kvm_vcpu
 #else
 	loadsegment(gs, gs_selector);
 #endif
-	kvm_load_ldt(ldt_selector);
 
 	reload_tss(vcpu);
 
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -846,8 +846,6 @@ static void __vmx_load_host_state(struct
 
 	++vmx->vcpu.stat.host_state_reload;
 	vmx->host_state.loaded = 0;
-	if (vmx->host_state.fs_reload_needed)
-		loadsegment(fs, vmx->host_state.fs_sel);
 	if (vmx->host_state.gs_ldt_reload_needed) {
 		kvm_load_ldt(vmx->host_state.ldt_sel);
 #ifdef CONFIG_X86_64
@@ -857,6 +855,8 @@ static void __vmx_load_host_state(struct
 		loadsegment(gs, vmx->host_state.gs_sel);
 #endif
 	}
+	if (vmx->host_state.fs_reload_needed)
+		loadsegment(fs, vmx->host_state.fs_sel);
 	reload_tss();
 #ifdef CONFIG_X86_64
 	if (is_long_mode(&vmx->vcpu)) {


