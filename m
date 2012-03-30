Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935868Ab2C3VNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:13:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935854Ab2C3VNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:13:19 -0400
Message-Id: <20120330194853.357139060@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: [ 087/149] KVM: x86: extend "struct x86_emulate_ops" with "get_cpuid"
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Stephan=20B=C3=A4rwolf?= <stephan.baerwolf@tu-ilmenau.de>

commit bdb42f5afebe208eae90406959383856ae2caf2b upstream.

In order to be able to proceed checks on CPU-specific properties
within the emulator, function "get_cpuid" is introduced.
With "get_cpuid" it is possible to virtually call the guests
"cpuid"-opcode without changing the VM's context.

[mtosatti: cleanup/beautify code]

Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_emulate.h |    3 +++
 arch/x86/kvm/x86.c                 |   23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+)

--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -189,6 +189,9 @@ struct x86_emulate_ops {
 	int (*intercept)(struct x86_emulate_ctxt *ctxt,
 			 struct x86_instruction_info *info,
 			 enum x86_intercept_stage stage);
+
+	bool (*get_cpuid)(struct x86_emulate_ctxt *ctxt,
+			 u32 *eax, u32 *ebx, u32 *ecx, u32 *edx);
 };
 
 typedef u32 __attribute__((vector_size(16))) sse128_t;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4655,6 +4655,28 @@ static int emulator_intercept(struct x86
 	return kvm_x86_ops->check_intercept(emul_to_vcpu(ctxt), info, stage);
 }
 
+static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
+			       u32 *eax, u32 *ebx, u32 *ecx, u32 *edx)
+{
+	struct kvm_cpuid_entry2 *cpuid = NULL;
+
+	if (eax && ecx)
+		cpuid = kvm_find_cpuid_entry(emul_to_vcpu(ctxt),
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
 	.write_std           = kvm_write_guest_virt_system,
@@ -4685,6 +4707,7 @@ static struct x86_emulate_ops emulate_op
 	.get_fpu             = emulator_get_fpu,
 	.put_fpu             = emulator_put_fpu,
 	.intercept           = emulator_intercept,
+	.get_cpuid           = emulator_get_cpuid,
 };
 
 static void cache_all_regs(struct kvm_vcpu *vcpu)


