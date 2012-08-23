Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab2HWSSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:18:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759177Ab2HWSRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:17:04 -0400
X-Authority-Analysis: v=2.0 cv=cpwZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Krgf46sFzE0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=Lc250oefTfEA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=WfulkdPnAAAA:8 a=GBehT7mxifjpgzMjUDMA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=EvKJbDF4Ut8A:10 a=l29vjEC0CZ8A:10 a=xBBInulKeHQwFRfo9uEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120823181659.800413190@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 23 Aug 2012 14:15:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 4/4] ftrace/x86: Add support for -mfentry to x86_64
References: <20120823181537.510961094@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-x86-Add-support-for-mfentry-to-x86_64.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If the kernel is compiled with gcc 4.6.0 which supports -mfentry,
then use that instead of mcount.

With mcount, frame pointers are forced with the -pg option and we
get something like:

<can_vma_merge_before>:
       55                      push   %rbp
       48 89 e5                mov    %rsp,%rbp
       53                      push   %rbx
       41 51                   push   %r9
       e8 fe 6a 39 00          callq  ffffffff81483d00 <mcount>
       31 c0                   xor    %eax,%eax
       48 89 fb                mov    %rdi,%rbx
       48 89 d7                mov    %rdx,%rdi
       48 33 73 30             xor    0x30(%rbx),%rsi
       48 f7 c6 ff ff ff f7    test   $0xfffffffff7ffffff,%rsi

With -mfentry, frame pointers are no longer forced and the call looks
like this:

<can_vma_merge_before>:
       e8 33 af 37 00          callq  ffffffff81461b40 <__fentry__>
       53                      push   %rbx
       48 89 fb                mov    %rdi,%rbx
       31 c0                   xor    %eax,%eax
       48 89 d7                mov    %rdx,%rdi
       41 51                   push   %r9
       48 33 73 30             xor    0x30(%rbx),%rsi
       48 f7 c6 ff ff ff f7    test   $0xfffffffff7ffffff,%rsi

This adds the ftrace hook at the beginning of the function before a
frame is set up, and allows the function callbacks to be able to access
parameters. As kprobes now can use function tracing (at least on x86)
this speeds up the kprobe hooks that are at the beginning of the
function.

Link: http://lkml.kernel.org/r/20120807194100.130477900@goodmis.org

Acked-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig                 |    1 +
 arch/x86/include/asm/ftrace.h    |    7 ++++++-
 arch/x86/kernel/entry_64.S       |   32 +++++++++++++++++++++++++++-----
 arch/x86/kernel/x8664_ksyms_64.c |    6 +++++-
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a2d19ee..28dd891 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -36,6 +36,7 @@ config X86
 	select HAVE_KRETPROBES
 	select HAVE_OPTPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_FENTRY if X86_64
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index a6cae0c..9a25b52 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -35,7 +35,11 @@
 #endif
=20
 #ifdef CONFIG_FUNCTION_TRACER
-#define MCOUNT_ADDR		((long)(mcount))
+#ifdef CC_USING_FENTRY
+# define MCOUNT_ADDR		((long)(__fentry__))
+#else
+# define MCOUNT_ADDR		((long)(mcount))
+#endif
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
=20
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -46,6 +50,7 @@
 #ifndef __ASSEMBLY__
 extern void mcount(void);
 extern atomic_t modifying_ftrace_code;
+extern void __fentry__(void);
=20
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b7a81dc..ed767b7 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -68,10 +68,18 @@
 	.section .entry.text, "ax"
=20
 #ifdef CONFIG_FUNCTION_TRACER
+
+#ifdef CC_USING_FENTRY
+# define function_hook	__fentry__
+#else
+# define function_hook	mcount
+#endif
+
 #ifdef CONFIG_DYNAMIC_FTRACE
-ENTRY(mcount)
+
+ENTRY(function_hook)
 	retq
-END(mcount)
+END(function_hook)
=20
 /* skip is set if stack has been adjusted */
 .macro ftrace_caller_setup skip=3D0
@@ -84,7 +92,11 @@ END(mcount)
 	movq RIP(%rsp), %rdi
 	subq $MCOUNT_INSN_SIZE, %rdi
 	/* Load the parent_ip into the second parameter */
+#ifdef CC_USING_FENTRY
+	movq SS+16(%rsp), %rsi
+#else
 	movq 8(%rbp), %rsi
+#endif
 .endm
=20
 ENTRY(ftrace_caller)
@@ -177,7 +189,8 @@ END(ftrace_regs_caller)
=20
=20
 #else /* ! CONFIG_DYNAMIC_FTRACE */
-ENTRY(mcount)
+
+ENTRY(function_hook)
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
=20
@@ -199,7 +212,11 @@ trace:
 	MCOUNT_SAVE_FRAME
=20
 	movq RIP(%rsp), %rdi
+#ifdef CC_USING_FENTRY
+	movq SS+16(%rsp), %rsi
+#else
 	movq 8(%rbp), %rsi
+#endif
 	subq $MCOUNT_INSN_SIZE, %rdi
=20
 	call   *ftrace_trace_function
@@ -207,7 +224,7 @@ trace:
 	MCOUNT_RESTORE_FRAME
=20
 	jmp ftrace_stub
-END(mcount)
+END(function_hook)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_TRACER */
=20
@@ -215,9 +232,14 @@ END(mcount)
 ENTRY(ftrace_graph_caller)
 	MCOUNT_SAVE_FRAME
=20
+#ifdef CC_USING_FENTRY
+	leaq SS+16(%rsp), %rdi
+	movq $0, %rdx	/* No framepointers needed */
+#else
 	leaq 8(%rbp), %rdi
-	movq RIP(%rsp), %rsi
 	movq (%rbp), %rdx
+#endif
+	movq RIP(%rsp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rsi
=20
 	call	prepare_ftrace_return
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms=
_64.c
index 6020f6f..1330dd1 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -13,9 +13,13 @@
 #include <asm/ftrace.h>
=20
 #ifdef CONFIG_FUNCTION_TRACER
-/* mcount is defined in assembly */
+/* mcount and __fentry__ are defined in assembly */
+#ifdef CC_USING_FENTRY
+EXPORT_SYMBOL(__fentry__);
+#else
 EXPORT_SYMBOL(mcount);
 #endif
+#endif
=20
 EXPORT_SYMBOL(__get_user_1);
 EXPORT_SYMBOL(__get_user_2);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQNnObAAoJEIy3vGnGbaoAI/sP/ijwrJ8bW95qCXQUX+eE0/lN
JYMKy7TjI3Stlz+EHC+JtJVz4hbuOeWToZssbllWl2a1LDuHK63J8yRk2P3gGzMm
1CuKTfcIaU/Rpr+mgCuwK2y8lnvzIeTL0JiaQtusM87pPGej9TtShKVZMIYcCA9D
QvHQXYCA6k/W9QI22HPeAAVxHRx9a/N0o+yPwUJMUApseztcPmORCY/g9zz4qdl4
2sdPpLEocwfGWbUw/ewP2XF0WM7BCtwlajZpQt2EOJI7e9ojgFEuLMYm5Lc1rQjU
T0Lul8ZClhC+RGM2ZkfzEL2WsoGfwyS69NkSCW05BpAOwgsakyPQtov5PBnQQwxP
O6D/L6kyhh6+/D1jWd0UT9VYYh7PxmgBnds2ReqPm1GdCiiMxZahM6SlNR4BLxv0
p64n1oNlXi2Cm6IYS8OiSFFVdp80VTNWOkH3AyVTgbiz34KC8kenm0LXnY2jVait
LTactmagpVVpQ7Jp0j9nBBie1GQW21/ARyU1bt+x1qeo0GNSDdnfUEtTUtF+xRv7
tmnf3NhyC5ANs3pVe1IP2OPcn4HJs7xrzGKEvuxJ7UbBc7RwusNaGXT2VxUqlzcd
SzlKW7pt91ER2tIxDxb25aLj7SRO1iC1qQXBJH50WVEW5Q2vYshY36fM/W8uCxup
jfF+JxBz0DG2rgR+8HJ9
=pDf5
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
