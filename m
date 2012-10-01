Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab2JAXTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:19:31 -0400
Received: from 1wt.eu ([62.212.114.60]:35416 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983Ab2JAXBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:43 -0400
Message-Id: <20121001225159.352867398@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 041/180] KVM: x86: fix missing checks in syscall emulation
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: =?latin1?q?Stephan=20B=E4rwolf?= <stephan.baerwolf@tu-ilmenau.de>

commit bdb42f5afebe208eae90406959383856ae2caf2b upstream

On hosts without this patch, 32bit guests will crash (and 64bit guests
may behave in a wrong way) for example by simply executing following
nasm-demo-application:

[bits 32]
global _start
SECTION .text
_start: syscall

(I tested it with winxp and linux - both always crashed)

Disassembly of section .text:

00000000 <_start>:
   0:   0f 05                   syscall

The reason seems a missing "invalid opcode"-trap (int6) for the
syscall opcode "0f05", which is not available on Intel CPUs
within non-longmodes, as also on some AMD CPUs within legacy-mode.
(depending on CPU vendor, MSR_EFER and cpuid)

Because previous mentioned OSs may not engage corresponding
syscall target-registers (STAR, LSTAR, CSTAR), they remain
NULL and (non trapping) syscalls are leading to multiple
faults and finally crashs.

Depending on the architecture (AMD or Intel) pretended by
guests, various checks according to vendor's documentation
are implemented to overcome the current issue and behave
like the CPUs physical counterparts.

[mtosatti: cleanup/beautify code]

[bwh: Backport to 2.6.32:
 - Add the prerequisite read of EFER
 - Return -1 in the error cases rather than invoking emulate_ud()
   directly
 - Adjust context]
[dannf: fix build by passing x86_emulate_ops through each call]

Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/kvm_emulate.h |   13 ++++++++
 arch/x86/kvm/emulate.c             |   57 ++++++++++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 61bf2eb..cc44e3d 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -192,6 +192,19 @@ struct x86_emulate_ctxt {
 #define X86EMUL_MODE_HOST X86EMUL_MODE_PROT64
 #endif
 
+/* CPUID vendors */
+#define X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx 0x68747541
+#define X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx 0x444d4163
+#define X86EMUL_CPUID_VENDOR_AuthenticAMD_edx 0x69746e65
+
+#define X86EMUL_CPUID_VENDOR_AMDisbetterI_ebx 0x69444d41
+#define X86EMUL_CPUID_VENDOR_AMDisbetterI_ecx 0x21726574
+#define X86EMUL_CPUID_VENDOR_AMDisbetterI_edx 0x74656273
+
+#define X86EMUL_CPUID_VENDOR_GenuineIntel_ebx 0x756e6547
+#define X86EMUL_CPUID_VENDOR_GenuineIntel_ecx 0x6c65746e
+#define X86EMUL_CPUID_VENDOR_GenuineIntel_edx 0x49656e69
+
 int x86_decode_insn(struct x86_emulate_ctxt *ctxt,
 		    struct x86_emulate_ops *ops);
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt,
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1350e43..aa2d905 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1495,20 +1495,73 @@ setup_syscalls_segments(struct x86_emulate_ctxt *ctxt,
 	ss->present = 1;
 }
 
+static bool em_syscall_is_enabled(struct x86_emulate_ctxt *ctxt,
+				  struct x86_emulate_ops *ops)
+{
+	u32 eax, ebx, ecx, edx;
+
+	/*
+	 * syscall should always be enabled in longmode - so only become
+	 * vendor specific (cpuid) if other modes are active...
+	 */
+	if (ctxt->mode == X86EMUL_MODE_PROT64)
+		return true;
+
+	eax = 0x00000000;
+	ecx = 0x00000000;
+	if (ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx)) {
+		/*
+		 * Intel ("GenuineIntel")
+		 * remark: Intel CPUs only support "syscall" in 64bit
+		 * longmode. Also an 64bit guest with a
+		 * 32bit compat-app running will #UD !! While this
+		 * behaviour can be fixed (by emulating) into AMD
+		 * response - CPUs of AMD can't behave like Intel.
+		 */
+		if (ebx == X86EMUL_CPUID_VENDOR_GenuineIntel_ebx &&
+		    ecx == X86EMUL_CPUID_VENDOR_GenuineIntel_ecx &&
+		    edx == X86EMUL_CPUID_VENDOR_GenuineIntel_edx)
+			return false;
+
+		/* AMD ("AuthenticAMD") */
+		if (ebx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx &&
+		    ecx == X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx &&
+		    edx == X86EMUL_CPUID_VENDOR_AuthenticAMD_edx)
+			return true;
+
+		/* AMD ("AMDisbetter!") */
+		if (ebx == X86EMUL_CPUID_VENDOR_AMDisbetterI_ebx &&
+		    ecx == X86EMUL_CPUID_VENDOR_AMDisbetterI_ecx &&
+		    edx == X86EMUL_CPUID_VENDOR_AMDisbetterI_edx)
+			return true;
+	}
+
+	/* default: (not Intel, not AMD), apply Intel's stricter rules... */
+	return false;
+}
+
 static int
-emulate_syscall(struct x86_emulate_ctxt *ctxt)
+emulate_syscall(struct x86_emulate_ctxt *ctxt, struct x86_emulate_ops *ops)
 {
 	struct decode_cache *c = &ctxt->decode;
 	struct kvm_segment cs, ss;
 	u64 msr_data;
+	u64 efer = 0;
 
 	/* syscall is not available in real mode */
 	if (c->lock_prefix || ctxt->mode == X86EMUL_MODE_REAL
 	    || ctxt->mode == X86EMUL_MODE_VM86)
 		return -1;
 
+	if (!(em_syscall_is_enabled(ctxt, ops)))
+		return -1;
+
+	kvm_x86_ops->get_msr(ctxt->vcpu, MSR_EFER, &efer);
 	setup_syscalls_segments(ctxt, &cs, &ss);
 
+	if (!(efer & EFER_SCE))
+		return -1;
+
 	kvm_x86_ops->get_msr(ctxt->vcpu, MSR_STAR, &msr_data);
 	msr_data >>= 32;
 	cs.selector = (u16)(msr_data & 0xfffc);
@@ -2342,7 +2395,7 @@ twobyte_insn:
 		}
 		break;
 	case 0x05: 		/* syscall */
-		if (emulate_syscall(ctxt) == -1)
+		if (emulate_syscall(ctxt, ops) == -1)
 			goto cannot_emulate;
 		else
 			goto writeback;
-- 
1.7.2.1.45.g54fbc



