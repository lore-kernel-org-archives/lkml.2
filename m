Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970Ab1LPXGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:06:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760963Ab1LPXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:06:16 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=7Z0CbYhRvaEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8 a=meVymXHHAAAA:8 a=a8jRQv5W5aWhhUlY0_oA:9 a=HPBRQbDe49wkOcnyWS8A:7 a=QEXdDO2ut3YA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=A_fhFIFpcfzHbkubRbcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111216230613.808006660@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 16 Dec 2011 17:59:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Turner <pjt@google.com>
Subject: [PATCH 1/6] x86: Do not schedule while still in NMI context
References: <20111216225906.481643317@goodmis.org>
Content-Disposition: inline; filename=0001-x86-Do-not-schedule-while-still-in-NMI-context.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Linus Torvalds <torvalds@linux-foundation.org>

The NMI handler uses the paranoid_exit routine that checks the
NEED_RESCHED flag, and if it is set and the return is for userspace,
then interrupts are enabled, the stack is swapped to the thread's stack,
and schedule is called. The problem with this is that we are still in an
NMI context until an iret is executed. This means that any new NMIs are
now starved until an interrupt or exception occurs and does the iret.

As NMIs can not be masked and can interrupt any location, they are
treated as a special case. NEED_RESCHED should not be set in an NMI
handler. The interruption by the NMI should not disturb the work flow
for scheduling. Any IPI sent to a processor after sending the
NEED_RESCHED would have to wait for the NMI anyway, and after the IPI
finishes the schedule would be called as required.

There is no reason to do anything special leaving an NMI. Remove the
call to paranoid_exit and do a simple return. This not only fixes the
bug of starved NMIs, but it also cleans up the code.

Link: http://lkml.kernel.org/r/CA+55aFzgM55hXTs4griX5e9=3Dv_O+=3Due+7Rj0PTD=
=3DM7hFYpyULQ@mail.gmail.com

Acked-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Turner <pjt@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index faf8d5e..3819ea9 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1489,46 +1489,14 @@ ENTRY(nmi)
 	movq %rsp,%rdi
 	movq $-1,%rsi
 	call do_nmi
-#ifdef CONFIG_TRACE_IRQFLAGS
-	/* paranoidexit; without TRACE_IRQS_OFF */
-	/* ebx:	no swapgs flag */
-	DISABLE_INTERRUPTS(CLBR_NONE)
 	testl %ebx,%ebx				/* swapgs needed? */
 	jnz nmi_restore
-	testl $3,CS(%rsp)
-	jnz nmi_userspace
 nmi_swapgs:
 	SWAPGS_UNSAFE_STACK
 nmi_restore:
 	RESTORE_ALL 8
 	jmp irq_return
-nmi_userspace:
-	GET_THREAD_INFO(%rcx)
-	movl TI_flags(%rcx),%ebx
-	andl $_TIF_WORK_MASK,%ebx
-	jz nmi_swapgs
-	movq %rsp,%rdi			/* &pt_regs */
-	call sync_regs
-	movq %rax,%rsp			/* switch stack for scheduling */
-	testl $_TIF_NEED_RESCHED,%ebx
-	jnz nmi_schedule
-	movl %ebx,%edx			/* arg3: thread flags */
-	ENABLE_INTERRUPTS(CLBR_NONE)
-	xorl %esi,%esi 			/* arg2: oldset */
-	movq %rsp,%rdi 			/* arg1: &pt_regs */
-	call do_notify_resume
-	DISABLE_INTERRUPTS(CLBR_NONE)
-	jmp nmi_userspace
-nmi_schedule:
-	ENABLE_INTERRUPTS(CLBR_ANY)
-	call schedule
-	DISABLE_INTERRUPTS(CLBR_ANY)
-	jmp nmi_userspace
 	CFI_ENDPROC
-#else
-	jmp paranoid_exit
-	CFI_ENDPROC
-#endif
 END(nmi)
=20
 ENTRY(ignore_sysret)
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO687mAAoJEIy3vGnGbaoAD/cP/0SkuZT57+vheDWnDliqHQQh
71T8dnpsHzIdGuu0Ikon+66iIgN9UdAMi6S6nMsRMgoGn1/3FhazKdaB84xIXWpj
FXG2xyyVuIFXG+T7vk69tpISkPJDIKbQWg5ohiAwLdADmhFlwP0ZCoSNNyqWcaE3
CPAKcEIHhpGKnDkzudSFKm4fzXKIJAAArUcKNdJ36ECm7ygLv/ypHoOrUFEk8E7/
VpcqwyPohiDY42+CwDNQl32lhC0owE23XCKTVBCpJUb0ydKrChZHtGpy+GPLJMwU
k0xyKE1OVWnAJK8mhgKD2tpxVwLdF3t77lymDT3AJnZ3gKihBOtxvdYVpWD9DJ+7
PWZ4JTe6joL1Nsy7i5JHOgcDlWIBqDS6LG9xtFK+GbuT38NOAJI8/wDmupy3eNEM
fewYwbdBTgUJ4519tQFNjy7MVndrNOSWfTKZ1LOuAcJ2O4QHx7LTVtdR3upaKtSU
i/6TudjWyyvNCj+5KD69Oh7n8/RXkw1InEI/CsbGFrDTLLjZ2heIL+weWy8sFsmK
phEGjkSfHSYnpfusjsugmxmyKGYdDgUmD1cRtCc0QWy+4S05wX2G/JTqaj2qRgBS
ARn4L/Qbc91IUCPLtk7gPaCwQUtuTVpqfxRpCQp3PvRP2WmXFgplCQx0nB448YjP
erihxTh3+5Lq3q7KAuny
=ua23
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
