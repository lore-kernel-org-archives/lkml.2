Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0DVT2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:28:17 -0400
Received: from kroah.org ([198.145.64.141]:37496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab0DVT2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:12 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:12 2010
Message-Id: <20100422190912.479270783@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [057/197] KVM: VMX: Update instruction length on intercepted BP
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jan Kiszka <jan.kiszka@siemens.com>

commit c573cd22939e54fc1b8e672054a505048987a7cb upstream

We intercept #BP while in guest debugging mode. As VM exits due to
intercepted exceptions do not necessarily come with valid
idt_vectoring, we have to update event_exit_inst_len explicitly in such
cases. At least in the absence of migration, this ensures that
re-injections of #BP will find and use the correct instruction length.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2674,6 +2674,12 @@ static int handle_rmode_exception(struct
 		kvm_queue_exception(vcpu, vec);
 		return 1;
 	case BP_VECTOR:
+		/*
+		 * Update instruction length as we may reinject the exception
+		 * from user space while in guest debugging mode.
+		 */
+		to_vmx(vcpu)->vcpu.arch.event_exit_inst_len =
+			vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
 			return 0;
 		/* fall through */
@@ -2790,6 +2796,13 @@ static int handle_exception(struct kvm_v
 		kvm_run->debug.arch.dr7 = vmcs_readl(GUEST_DR7);
 		/* fall through */
 	case BP_VECTOR:
+		/*
+		 * Update instruction length as we may reinject #BP from
+		 * user space while in guest debugging mode. Reading it for
+		 * #DB as well causes no harm, it is not used in that case.
+		 */
+		vmx->vcpu.arch.event_exit_inst_len =
+			vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
 		kvm_run->debug.arch.exception = ex_no;


