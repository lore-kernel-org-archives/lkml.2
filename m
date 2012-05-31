Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab2EaCEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 22:04:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9704 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab2EaCEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 22:04:42 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=17vVJ0OR0l4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=h2xc5Y505kivUmRXO0EA:9 a=QEXdDO2ut3YA:10 a=X6fUgycoKihUSBfr_X0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120531012829.160060586@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 30 May 2012 21:28:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 0/5] [GIT PULL] ftrace: Fix bug with function tracing and lockdep
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Dave Jones reported a bug from ftrace. I saw the same bug but
thought it was a compile problem because it would trigger everytime
I booted, but after rebuilding the kernel, it stopped triggering.
I mistook this as a build bug (something not cleaned properly).

What also confused me was that Dave also experienced the bug going
away after doing a make clean.

Seems that was just shear luck!

After rebuilding and booting I was able to get it to trigger again.
I found that it was something going wrong with the updating=20
of the functions via the breakpoints (the removal of stop machine for
function tracing). I added a mdelay(1) where I usually sync the
updates (add breakpoint, wait 1ms, modify code, wait 1ms, remove breakpoint)
and this happened to trigger the bug 90% of the time.

Finally figured it out. It was a combination of lockdep and the int3
handler:

.macro paranoidzeroentry_ist sym do_sym ist
ENTRY(\sym)
	INTR_FRAME
	PARAVIRT_ADJUST_EXCEPTION_FRAME
	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
	subq $ORIG_RAX-R15, %rsp
	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
	call save_paranoid
	TRACE_IRQS_OFF
	movq %rsp,%rdi		/* pt_regs pointer */
	xorl %esi,%esi		/* no error code */
	subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
	call \do_sym
	addq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
	jmp paranoid_exit	/* %ebx: no swapgs flag */
	CFI_ENDPROC
END(\sym)
.endm

The above macro is called by the do_int3 code. When a int3 is hit, the
stack jumps to the debug stack (like what happens on NMI). The
 subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
is a little trick incase the \do_sym happens to hit a breakpoint too.
And for the most part, that works.

But that TRACE_IRQS_OFF up there (and several more called by the
paranoid_exit), is not protected by that trick. Thus, if the tracing
code hits a breakpoint we reset the debug stack and start clobbering all
over the previous code's stack.

Usually this is not an issue, unless lockdep sees the TRACE_IRQS_OFF
or TRACE_IRQS_ON while holding locks that have been taken for the first
time (with interrupts disabled). This explains why if the bug did not
trigger on the first try of starting the function tracer, it usually
would not trigger. It requires a new lock to be taken. The longer you
keep the box running, the less likely it will acquire a lock for the first
time.

Once lockdep sees a new lock changing its interrupts status, it starts
recording it (and calling lots of code). Unfortunately, some of this
code is traced by the function tracer.

I first started making a lot of this code 'notrace' but found that
it just wasn't reliable enough. The list of functions to mark just
kept growing, and I would only know if I got them all if I happen
to run all the paths.

Then I tried to play tricks by doing a switch of the stack. I tried
to modify sync_regs() but it would partially work, and it seemed
that NMIs would cause it to crash as well. I spent too much time on
it and finally figured to go with the easiest approach.

As this is only needed when LOCKDEP (and just in case, I did it when
TRACE_IRQFLAGS was enabled), I figured breakpoint performance wasn't
an issue (LOCKDEP and TRACE_IRQSFLAGS has a much bigger overhead).

I decided to reuse the code from the NMI to switch the IDT before calling
the TRACE_IRQS_ON/OFF and switch it back afterward. It would be nice
to do it just once on entering do_int3, and once leaving, but because
the TRACE_IRQS_ON/OFF and TRACE_IRQS_IRETQ are called in several branches
of the paranoid_exit, I decided to keep it simple and modify it every
time.

In the future, we can work to make this rely on modifying_ftrace_code,
but there's races to deal with, and this bug needs to be fixed now.

Also, while debugging this, I found a few more little bugs.

The first patch fixes a race with setting the modifying_ftrace_code
and the executing of the int3 handlers.

The second fixes a bug where we don't do the breakpoint update of
the function trace callback (the one called in the mcount trampoline).
This could cause a GPF when tracing is running and the function
tracer changes.

The third patch is a minor bug fix in the NMI handling of the idt switch.
If a NMI preempts a int3 handler, it switches the idt, properly, and
sets a variable to tell the handler to put it back when it exits. The
problem is that the variable never got reset, and it constantly loaded
the old IDT back on every NMI from then on. This is more of a performance
and correctness fix.

The last two patches fix the lockdep and breakpoint issue.

Comments are welcomed, but if there's no problem then ...

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 1f9f5e93a9ab9cdf2504a25c24f3f8715c4ba785


Steven Rostedt (5):
      ftrace: Synchronize variable setting with breakpoints
      ftrace: Use breakpoint method to update ftrace caller
      x86: Reset the debug_stack update counter
      x86: Allow nesting of the debug stack IDT setting
      ftrace/x86: Do not change stacks in DEBUG when calling lockdep

----
 arch/x86/include/asm/ftrace.h |    2 +-
 arch/x86/kernel/cpu/common.c  |    8 ++++-
 arch/x86/kernel/entry_64.S    |   44 ++++++++++++++++++++++++--
 arch/x86/kernel/ftrace.c      |   69 ++++++++++++++++++++++++++++++++++++-=
----
 arch/x86/kernel/nmi.c         |    4 ++-
 arch/x86/kernel/traps.c       |    3 +-
 6 files changed, 116 insertions(+), 14 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPxtG0AAoJEIy3vGnGbaoAUu8P/0/Yb9R+KksvNWPmwJu/CEIH
PJaaaVFtgStl9WbMR4nx61NO+Ew9tMcSOWg71zmDoftceJH7ZmUL7cfXBE2xW215
vkyGEsODEfQCcaYXrApYPH7ouMIBAUm9yMOxKChiEmgtMKoowLeTFcp5xx7Jud8f
nKySYH3BXbn3N14Xpvn3bK5izIamh4MAKpAHLMUNew6b/4fAiLzL0YHEfpILoaVf
5wcw8xbFtNMPxBCW37/xg5H0ZWPVM3od747Iw8BhkGYtDKWf9w/I5PYdxZuqwQQP
56PN6f5eujEzJVxrN0pNaI8bSfCRfsFy+ijMKCjUJfdNjLYBtN8hsBxRZ4CuJJ3m
6SyDslHfo+iS0bygEISGg2LMREGWMw/vaaDktk5HWJnGXDTYA+pu4/8Q1+x26Ruc
RrW85a5oY+W6ml3JHB7w99qiNqyrEFrZooGn9uAIzLLGM7uBhYNWjqwzNp5J1RE0
TNeYxWOrjvKTy8gvbI+1VK2jMK+1RcdcDEqc15JRGp+Mhp4lDTwbpn3SIRYUTCbh
ckfnw0vmyOiqKExl+IiWnlp+BRwLFM9YfhD/b7ba6tXKW20GStZygorhGz6qlb7I
n/qPO2z3u3mcYpgGuXCw0tahblXehtkTm9qssjOPSt7k4VijSSQuzKnuFmbVNrF9
yo0H/WKTZtxK4qNcitlt
=57vN
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
