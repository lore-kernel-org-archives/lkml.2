Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab0DVUgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:36:47 -0400
Received: from kroah.org ([198.145.64.141]:37514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253Ab0DVT2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:13 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:12 2010
Message-Id: <20100422190912.660513915@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [059/197] KVM: SVM: Reset cr0 properly on vcpu reset
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eduardo Habkost <ehabkost@redhat.com>

commit 18fa000ae453767b59ab97477925895a3f0c46ea upstream

svm_vcpu_reset() was not properly resetting the contents of the guest-visible
cr0 register, causing the following issue:
https://bugzilla.redhat.com/show_bug.cgi?id=525699

Without resetting cr0 properly, the vcpu was running the SIPI bootstrap routine
with paging enabled, making the vcpu get a pagefault exception while trying to
run it.

Instead of setting vmcb->save.cr0 directly, the new code just resets
kvm->arch.cr0 and calls kvm_set_cr0(). The bits that were set/cleared on
vmcb->save.cr0 (PG, WP, !CD, !NW) will be set properly by svm_set_cr0().

kvm_set_cr0() is used instead of calling svm_set_cr0() directly to make sure
kvm_mmu_reset_context() is called to reset the mmu to nonpaging mode.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/svm.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -625,11 +625,12 @@ static void init_vmcb(struct vcpu_svm *s
 	save->rip = 0x0000fff0;
 	svm->vcpu.arch.regs[VCPU_REGS_RIP] = save->rip;
 
-	/*
-	 * cr0 val on cpu init should be 0x60000010, we enable cpu
-	 * cache by default. the orderly way is to enable cache in bios.
+	/* This is the guest-visible cr0 value.
+	 * svm_set_cr0() sets PG and WP and clears NW and CD on save->cr0.
 	 */
-	save->cr0 = 0x00000010 | X86_CR0_PG | X86_CR0_WP;
+	svm->vcpu.arch.cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
+	kvm_set_cr0(&svm->vcpu, svm->vcpu.arch.cr0);
+
 	save->cr4 = X86_CR4_PAE;
 	/* rdx = ?? */
 


