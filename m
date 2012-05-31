Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab2EaCE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:04:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9704 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769Ab2EaCEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:04:45 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=Vl-kc5HlrXwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=Ds3GogaVUjTumUKFKR0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Tjavf4Jgv6dPpoJ1sD4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120531020441.919136910@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 30 May 2012 21:28:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/5] ftrace/x86: Do not change stacks in DEBUG when calling lockdep
References: <20120531012829.160060586@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-x86-Do-not-change-stacks-in-DEBUG-when-callin.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When both DYNAMIC_FTRACE and LOCKDEP are set, the TRACE_IRQS_ON/OFF
will call into the lockdep code. The lockdep code can call lots of
functions that may be traced by ftrace. When ftrace is updating its
code and hits a breakpoint, the breakpoint handler will call into
lockdep. If lockdep happens to call a function that also has a breakpoint
attached, it will jump back into the breakpoint handler resetting
the stack to the debug stack and corrupt the contents currently on
that stack.

The 'do_sym' call that calls do_int3() is protected by modifying the
IST table to point to a different location if another breakpoint is
hit. But the TRACE_IRQS_OFF/ON are outside that protection, and if
a breakpoint is hit from those, the stack will get corrupted, and
the kernel will crash:

[ 1013.243754] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000002
[ 1013.272665] IP: [<ffff880145cc0000>] 0xffff880145cbffff
[ 1013.285186] PGD 1401b2067 PUD 14324c067 PMD 0
[ 1013.298832] Oops: 0010 [#1] PREEMPT SMP
[ 1013.310600] CPU 2
[ 1013.317904] Modules linked in: ip6t_REJECT nf_conntrack_ipv6 nf_defrag_i=
pv6 xt_state nf_conntrack ip6table_filter ip6_tables crc32c_intel ghash_clm=
ulni_intel microcode usb_debug serio_raw pcspkr iTCO_wdt i2c_i801 iTCO_vend=
or_support e1000e nfsd nfs_acl auth_rpcgss lockd sunrpc i915 video i2c_algo=
_bit drm_kms_helper drm i2c_core [last unloaded: scsi_wait_scan]
[ 1013.401848]
[ 1013.407399] Pid: 112, comm: kworker/2:1 Not tainted 3.4.0+ #30
[ 1013.437943] RIP: 8eb8:[<ffff88014630a000>]  [<ffff88014630a000>] 0xffff8=
80146309fff
[ 1013.459871] RSP: ffffffff8165e919:ffff88014780f408  EFLAGS: 00010046
[ 1013.477909] RAX: 0000000000000001 RBX: ffffffff81104020 RCX: 00000000000=
00000
[ 1013.499458] RDX: ffff880148008ea8 RSI: ffffffff8131ef40 RDI: ffffffff822=
03b20
[ 1013.521612] RBP: ffffffff81005751 R08: 0000000000000000 R09: 00000000000=
00000
[ 1013.543121] R10: ffffffff82cdc318 R11: 0000000000000000 R12: ffff880145c=
c0000
[ 1013.564614] R13: ffff880148008eb8 R14: 0000000000000002 R15: ffff8801478=
0cb40
[ 1013.586108] FS:  0000000000000000(0000) GS:ffff880148000000(0000) knlGS:=
0000000000000000
[ 1013.609458] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1013.627420] CR2: 0000000000000002 CR3: 0000000141f10000 CR4: 00000000001=
407e0
[ 1013.649051] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 1013.670724] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 1013.692376] Process kworker/2:1 (pid: 112, threadinfo ffff88013fe0e000, =
task ffff88014020a6a0)
[ 1013.717028] Stack:
[ 1013.724131]  ffff88014780f570 ffff880145cc0000 0000400000004000 00000000=
00000000
[ 1013.745918]  cccccccccccccccc ffff88014780cca8 ffffffff811072bb ffffffff=
81651627
[ 1013.767870]  ffffffff8118f8a7 ffffffff811072bb ffffffff81f2b6c5 ffffffff=
81f11bdb
[ 1013.790021] Call Trace:
[ 1013.800701] Code: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a =
<e7> d7 64 81 ff ff ff ff 01 00 00 00 00 00 00 00 65 d9 64 81 ff
[ 1013.861443] RIP  [<ffff88014630a000>] 0xffff880146309fff
[ 1013.884466]  RSP <ffff88014780f408>
[ 1013.901507] CR2: 0000000000000002

The solution was to reuse the NMI functions that change the IDT table to ma=
ke the debug
stack keep its current stack (in kernel mode) when hitting a breakpoint:

  call debug_stack_set_zero
  TRACE_IRQS_ON
  call debug_stack_reset

If the TRACE_IRQS_ON happens to hit a breakpoint then it will keep the curr=
ent stack
and not crash the box.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |   44 ++++++++++++++++++++++++++++++++++++++++=
+---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 320852d..7d65133 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -191,6 +191,44 @@ ENDPROC(native_usergs_sysret64)
 .endm
=20
 /*
+ * When dynamic function tracer is enabled it will add a breakpoint
+ * to all locations that it is about to modify, sync CPUs, update
+ * all the code, sync CPUs, then remove the breakpoints. In this time
+ * if lockdep is enabled, it might jump back into the debug handler
+ * outside the updating of the IST protection. (TRACE_IRQS_ON/OFF).
+ *
+ * We need to change the IDT table before calling TRACE_IRQS_ON/OFF to
+ * make sure the stack pointer does not get reset back to the top
+ * of the debug stack, and instead just reuses the current stack.
+ */
+#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_TRACE_IRQFLAGS)
+
+.macro TRACE_IRQS_OFF_DEBUG
+	call debug_stack_set_zero
+	TRACE_IRQS_OFF
+	call debug_stack_reset
+.endm
+
+.macro TRACE_IRQS_ON_DEBUG
+	call debug_stack_set_zero
+	TRACE_IRQS_ON
+	call debug_stack_reset
+.endm
+
+.macro TRACE_IRQS_IRETQ_DEBUG offset=3DARGOFFSET
+	bt   $9,EFLAGS-\offset(%rsp)	/* interrupts off? */
+	jnc  1f
+	TRACE_IRQS_ON_DEBUG
+1:
+.endm
+
+#else
+# define TRACE_IRQS_OFF_DEBUG		TRACE_IRQS_OFF
+# define TRACE_IRQS_ON_DEBUG		TRACE_IRQS_ON
+# define TRACE_IRQS_IRETQ_DEBUG		TRACE_IRQS_IRETQ
+#endif
+
+/*
  * C code is not supposed to know about undefined top of stack. Every time
  * a C function with an pt_regs argument is called from the SYSCALL based
  * fast path FIXUP_TOP_OF_STACK is needed.
@@ -1098,7 +1136,7 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
-	TRACE_IRQS_OFF
+	TRACE_IRQS_OFF_DEBUG
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
 	subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
@@ -1393,7 +1431,7 @@ paranoidzeroentry machine_check *machine_check_vector=
(%rip)
 ENTRY(paranoid_exit)
 	DEFAULT_FRAME
 	DISABLE_INTERRUPTS(CLBR_NONE)
-	TRACE_IRQS_OFF
+	TRACE_IRQS_OFF_DEBUG
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz paranoid_restore
 	testl $3,CS(%rsp)
@@ -1404,7 +1442,7 @@ paranoid_swapgs:
 	RESTORE_ALL 8
 	jmp irq_return
 paranoid_restore:
-	TRACE_IRQS_IRETQ 0
+	TRACE_IRQS_IRETQ_DEBUG 0
 	RESTORE_ALL 8
 	jmp irq_return
 paranoid_userspace:
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPxtG6AAoJEIy3vGnGbaoApIIP+wdkARnQwBGkXlbUf4rGX3o8
SMu+i38ay738xfFdux+ZMQsk2LiqtzpDUFAyqe2s6V+Dmjn4rCAJRiwYidhzlSPy
LLvuMeGYo/c4uQUscYxFh4tWAKcR2pZbfWG3/b4qlkKQEsXp41LOrP2xj4cTXixX
nbtiXuS4owFOl2bGjcV0DQzk1j4mwDVEwJgnqbncaJf2ASmMCbsv70R6HurOTejF
vlW1/HPgAFFRwnhrSMHISDj1w4h1cMQ5/umPG7tk8X9uIvVAsDTM0h1ISO9M86ym
nUcNXrE7Qrivk6c6mDO0XzkYoLZM694PUqQqQIdEpjiMbVFzyVYSILDCnWnDuov6
rBFSa1kMQxb1y0y8X6wimBVIxkSkH8YjRyH6njBIxqLoK5uNX67E0E5pgH8FlaHT
2zH+CFWSiAndjjtIUAGzkeXIOF9q2pobVfLB09NIF4WhYzToub/hgnYKooJElXxh
nNv1UNJEDjabsOldyj9YZ5+CUTKEedo0MoOA4RasiYEeAQq5dAgGp3cnmKA0DPN8
HW7tOTGyyx/0nFleyKEYT8xhJDyUQfw/8Q1NDDhA7rTRX/G7VmSiBb52PEMnANfo
vSoFNG/z+Qd0ekBy20w3LRd4+AJSOZs0e1SVjachwh5SOiVdYw+TRZR2DWgemMhX
BKBpSMihby3O2/VfSzwx
=HsvZ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
