Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2JAXLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:11:44 -0400
Received: from 1wt.eu ([62.212.114.60]:35563 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab2JAXCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:41 -0400
Message-Id: <20121001225159.310279850@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 040/180] KVM: x86: extend "struct x86_emulate_ops" with "get_cpuid"
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: =?latin1?q?Stephan=20B=E4rwolf?= <stephan.baerwolf@tu-ilmenau.de>

commit 0769c5de24621141c953fbe1f943582d37cb4244 upstream

In order to be able to proceed checks on CPU-specific properties
within the emulator, function "get_cpuid" is introduced.
With "get_cpuid" it is possible to virtually call the guests
"cpuid"-opcode without changing the VM's context.

[mtosatti: cleanup/beautify code]

[bwh: Backport to 2.6.32:
 - Don't use emul_to_vcpu
 - Adjust context]

Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/kvm_emulate.h |    2 ++
 arch/x86/kvm/x86.c                 |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 5ed59ec..61bf2eb 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -109,6 +109,8 @@ struct x86_emulate_ops {
 				unsigned int bytes,
 				struct kvm_vcpu *vcpu);
 
+	bool (*get_cpuid)(struct x86_emulate_ctxt *ctxt,
+			 u32 *eax, u32 *ebx, u32 *ecx, u32 *edx);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df1cefb..23b5a71 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2871,12 +2871,35 @@ void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 }
 EXPORT_SYMBOL_GPL(kvm_report_emulation_failure);
 
+static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
+			       u32 *eax, u32 *ebx, u32 *ecx, u32 *edx)
+{
+	struct kvm_cpuid_entry2 *cpuid = NULL;
+
+	if (eax && ecx)
+		cpuid = kvm_find_cpuid_entry(ctxt->vcpu,
+					    *eax, *ecx);
+
+	if (cpuid) {
+		*eax = cpuid->eax;
+		*ecx = cpuid->ecx;
+		if (ebx)
+			*ebx = cpuid->ebx;
+		if (edx)
+			*edx = cpuid->edx;
+		return true;
+	}
+
+	return false;
+}
+
 static struct x86_emulate_ops emulate_ops = {
 	.read_std            = kvm_read_guest_virt_system,
 	.fetch               = kvm_fetch_guest_virt,
 	.read_emulated       = emulator_read_emulated,
 	.write_emulated      = emulator_write_emulated,
 	.cmpxchg_emulated    = emulator_cmpxchg_emulated,
+	.get_cpuid           = emulator_get_cpuid,
 };
 
 static void cache_all_regs(struct kvm_vcpu *vcpu)
-- 
1.7.2.1.45.g54fbc



