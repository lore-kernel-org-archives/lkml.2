Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2LLJoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:44:16 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52734 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab2LLJoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:44:12 -0500
Message-ID: <50C851E7.8090401@imgtec.com>
Date: Wed, 12 Dec 2012 09:44:07 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [braindump][RFC] signals and syscall restarts (Re: [PATCH v2
 19/44] metag: Signal handling)
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-20-git-send-email-james.hogan@imgtec.com> <20121205171609.GW4939@ZenIV.linux.org.uk> <50C07ECE.9070602@imgtec.com> <20121206220955.GZ4939@ZenIV.linux.org.uk> <20121208181458.GD4939@ZenIV.linux.org.uk>
In-Reply-To: <20121208181458.GD4939@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_12_09_44_09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/12 18:14, Al Viro wrote:
> On Thu, Dec 06, 2012 at 10:09:55PM +0000, Al Viro wrote:
> 
>> 	What we need to guarantee is
>> * restarts do not happen on signals caught in interrupts or exceptions
>> * restarts do not happen on signals caught in sigreturn()

Since we don't currently have an orig syscall in our pt_regs that
we can make invalid, is it acceptable to just explicitly exclude
rt_sigreturn? e.g. using something like this around the switch
statements that check for -ERESTART*:

/*
 * Decide whether a syscall restart should be checked for.
 * This needs to exclude non-syscalls (syscall == -1), and sys_rt_sigreturn.
 */
static int restartable_syscall(int syscall)
{
	return syscall >= 0 && syscall != __NR_rt_sigreturn;
}

>> * restart should happen only once, even if we get through do_signal() many
>> times.
> 
> BTW, signal caught in sigreturn is *not* something requiring a narrow
> race.  It's perfectly normal to have some signals blocked for the
> duration of signal handler - the signal itself is blocked by default
> unless you have set SA_NODEFER in sa_flags and there's sa_mask allowing
> to block an arbitrary set of signals.  Upon return from signal handler
> we undo that and if any of the temporary blocked signals has arrived
> while we'd been in the handler (e.g. had been raised by the handler itself),
> it will be caught as soon as we unblock it, i.e. in sigreturn.
> 
> Unfortunately, the testcases are somewhat architecture-dependent.  See, for
> example, arm one in commit 653d48b22166db2d8b1515ebe6f9f0f7c95dfc86; there
> might be a way to arrange for asm-free equivalent if one played with -O0,
> but it's probably not worth the trouble.  That one deals with sigreturn
> from signal caught in interrupt; sigreturn from signal caught in syscall
> is a bit trickier.  TBH, I don't understand your syscall calling conventions
> well enough to cook one up; your restart logics looks really strange.
> You leave ->DX[0].U0 modified - fair enough, it doesn't seem to be used
> by syscall entry path - *and* you revert ->DX[0].U1 to the state you
> used to have on entry.  The thing is, I don't see any place that would
> have changed it in between; why do you need that
> 	regs->REG_SYSCALL = orig_syscall;
> in there at all?

Yes, this doesn't seem to be necessary. The only other place
REG_SYSCALL is changed is when it's set to __NR_restart_syscall, in
which case I presume it never needs to be reset i.e. if a syscall
returns -ERESTART_RESTARTBLOCK, it either doesn't return a different
-ERESTART* from the restart block callback, or it's acceptable in
that case to restart sys_restart_syscall rather than the original
syscall that returned -ERESTART_RESTARTBLOCK. Is that right?

> 
> BTW, could you (and other folks submitting ports) document the ABI?
> See e.g. Documentation/frv/kernel-ABI.txt for fairly decent example...
> 

Good idea, something like below?

Thanks
James

Date: Tue, 11 Dec 2012 10:08:26 +0000
Subject: [PATCH 1/1] metag: add kernel-ABI document

Add a document in Documentation/metag/ describing the Linux ABI for
metag. It includes an outline of the registers, which ones are special
in userland and the kernel, the system call ABI, and an overview of the
calling conventions.

It was suggested that new architecture ports should have some ABI
documentation available, with Documentation/frv/kernel-ABI.txt
referenced as a decent example, from which some inspiration was drawn
for this patch.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
---
 Documentation/metag/00-INDEX       |    2 +
 Documentation/metag/kernel-ABI.txt |  256 ++++++++++++++++++++++++++++++++++++
 2 files changed, 258 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/metag/kernel-ABI.txt

diff --git a/Documentation/metag/00-INDEX b/Documentation/metag/00-INDEX
index 4fe2e16..4a93a27 100644
--- a/Documentation/metag/00-INDEX
+++ b/Documentation/metag/00-INDEX
@@ -6,3 +6,5 @@ coremem.txt
 	- Documents the core memory interface used by suspend code
 comet/
 	- Documentation specific to the Comet SoC
+kernel-ABI.txt
+	- Documents metag ABI details
diff --git a/Documentation/metag/kernel-ABI.txt b/Documentation/metag/kernel-ABI.txt
new file mode 100644
index 0000000..7b8dee8
--- /dev/null
+++ b/Documentation/metag/kernel-ABI.txt
@@ -0,0 +1,256 @@
+			==========================
+			KERNEL ABIS FOR METAG ARCH
+			==========================
+
+This document describes the Linux ABIs for the metag architecture, and has the
+following sections:
+
+ (*) Outline of registers
+ (*) Userland registers
+ (*) Kernel registers
+ (*) System call ABI
+ (*) Calling conventions
+
+
+====================
+OUTLINE OF REGISTERS
+====================
+
+The main Meta core registers are arranged in units:
+
+	UNIT	Type	DESCRIPTION	GP	EXT	PRIV	GLOBAL
+	=======	=======	===============	=======	=======	=======	=======
+	CT	Special	Control unit
+	D0	General	Data unit 0	0-7	8-15	16-31	16-31
+	D1	General	Data unit 1	0-7	8-15	16-31	16-31
+	A0	General	Address unit 0	0-3	4-7	 8-15	 8-15
+	A1	General	Address unit 1	0-3	4-7	 8-15	 8-15
+	PC	Special	PC unit		0		 1
+	PORT	Special	Ports
+	TR	Special	Trigger unit			 0-7
+	TT	Special	Trace unit			 0-5
+	FX	General	FP unit			0-15
+
+GP registers form part of the main context.
+
+Extended context registers (EXT) may not be present on all hardware threads and
+can be context switched if support is enabled and the appropriate bits are set
+in e.g. the D0.8 register to indicate what extended state to preserve.
+
+Global registers are shared between threads and are privilege protected.
+
+See arch/metag/include/asm/metag_regs.h for definitions relating to core
+registers and the fields and bits they contain. See the TRMs for further details
+about special registers.
+
+Several special registers are preserved in the main context, these are the
+interesting ones:
+
+	REG	(ALIAS)		PURPOSE
+	=======================	===============================================
+	CT.1	(TXMODE)	Processor mode bits (particularly for DSP)
+	CT.2	(TXSTATUS)	Condition flags and LSM_STEP (MGET/MSET step)
+	CT.3	(TXRPT)		Branch repeat counter
+	PC.0	(PC)		Program counter
+
+Some of the general registers have special purposes in the ABI and therefore
+have aliases:
+
+	D0 REG	(ALIAS)	PURPOSE		D1 REG	(ALIAS)	PURPOSE
+	===============	===============	===============	=======================
+	D0.0	(D0Re0)	32bit result	D1.0	(D1Re0)	Top half of 64bit result
+	D0.1	(D0Ar6)	Argument 6	D1.1	(D1Ar5)	Argument 5
+	D0.2	(D0Ar4)	Argument 4	D1.2	(D1Ar3)	Argument 3
+	D0.3	(D0Ar2)	Argument 2	D1.3	(D1Ar1)	Argument 1
+	D0.4	(D0FrT)	Frame temp	D1.4	(D1RtP)	Return pointer
+	D0.5		Call preserved	D1.5		Call preserved
+	D0.6		Call preserved	D1.6		Call preserved
+	D0.7		Call preserved	D1.7		Call preserved
+
+	A0 REG	(ALIAS)	PURPOSE		A1 REG	(ALIAS)	PURPOSE
+	===============	===============	===============	=======================
+	A0.0	(A0StP)	Stack pointer	A1.0	(A1GbP)	Global base pointer
+	A0.1	(A0FrP)	Frame pointer	A1.1	(A1LbP)	Local base pointer
+	A0.2				A1.2
+	A0.3				A1.3
+
+
+==================
+USERLAND REGISTERS
+==================
+
+All the general purpose D0, D1, A0, A1 registers are preserved when entering the
+kernel (including asynchronous events such as interrupts and timer ticks) except
+the following which have special purposes in the ABI:
+
+	REGISTERS	WHEN	STATUS		PURPOSE
+	===============	=======	===============	===============================
+	D0.8		DSP	Preserved	ECH, determines what extended
+						DSP state to preserve.
+	A0.0	(A0StP)	ALWAYS	Preserved	Stack >= A0StP may be clobbered
+						at any time by the creation of a
+						signal frame.
+	A1.0	(A1GbP)	SMP	Clobbered	Used as temporary for loading
+						kernel stack pointer and saving
+						core context.
+	A0.15		!SMP	Protected	Stores kernel stack pointer.
+	A1.15		ALWAYS	Protected	Stores kernel base pointer.
+
+On UP A0.15 is used to store the kernel stack pointer for storing the userland
+context. A0.15 is global between hardware threads though which means it cannot
+be used on SMP for this purpose. Since no protected local registers are
+available A1GbP is reserved for use as a temporary to allow a percpu stack
+pointer to be loaded for storing the rest of the context.
+
+
+================
+KERNEL REGISTERS
+================
+
+When in the kernel the following registers have special purposes in the ABI:
+
+	REGISTERS	WHEN	STATUS		PURPOSE
+	===============	=======	===============	===============================
+	A0.0	(A0StP)	ALWAYS	Preserved	Stack >= A0StP may be clobbered
+						at any time by the creation of
+						an irq signal frame.
+	A1.0	(A1GbP)	ALWAYS	Preserved	Reserved (kernel base pointer).
+
+
+===============
+SYSTEM CALL ABI
+===============
+
+When a system call is made, the following registers are effective:
+
+	REGISTERS	CALL			RETURN
+	===============	=======================	===============================
+	D0.0	(D0Re0)				Return value (or -errno)
+	D1.0	(D1Re0)	System call number	Clobbered
+	D0.1	(D0Ar6)	Syscall arg #6		Preserved
+	D1.1	(D1Ar5)	Syscall arg #5		Preserved
+	D0.2	(D0Ar4)	Syscall arg #4		Preserved
+	D1.2	(D1Ar3)	Syscall arg #3		Preserved
+	D0.3	(D0Ar2)	Syscall arg #2		Preserved
+	D1.3	(D1Ar1)	Syscall arg #1		Preserved
+
+Due to the limited number of argument registers and some system calls with badly
+aligned 64-bit arguments, 64-bit values are always packed in consecutive
+arguments, even if this is contrary to the normal calling conventions (where the
+two halves would go in a matching pair of data registers).
+
+For example fadvise64_64 usually has the signature:
+
+	long sys_fadvise64_64(i32 fd, i64 offs, i64 len, i32 advice);
+
+But for metag fadvise64_64 is wrapped so that the 64-bit arguments are packed:
+
+	long sys_fadvise64_64_metag(i32 fd,      i32 offs_lo,
+				    i32 offs_hi, i32 len_lo,
+				    i32 len_hi,  i32 advice)
+
+So the arguments are packed in the registers like this:
+
+	D0 REG	(ALIAS)	VALUE		D1 REG	(ALIAS)	VALUE
+	===============	===============	===============	=======================
+	D0.1	(D0Ar6)	advice		D1.1	(D1Ar5)	hi(len)
+	D0.2	(D0Ar4)	lo(len)		D1.2	(D1Ar3)	hi(offs)
+	D0.3	(D0Ar2)	lo(offs)	D1.3	(D1Ar1)	fd
+
+
+===================
+CALLING CONVENTIONS
+===================
+
+These calling conventions apply to both user and kernel code. The stack grows
+from low addresses to high addresses in the metag ABI. The stack pointer (A0StP)
+should always point to the next free address on the stack and should at all
+times be 64-bit aligned. The following registers are effective at the point of a
+call:
+
+	REGISTERS	CALL			RETURN
+	===============	=======================	===============================
+	D0.0	(D0Re0)				32bit return value
+	D1.0	(D1Re0)				Upper half of 64bit return value
+	D0.1	(D0Ar6)	32bit argument #6	Clobbered
+	D1.1	(D1Ar5)	32bit argument #5	Clobbered
+	D0.2	(D0Ar4)	32bit argument #4	Clobbered
+	D1.2	(D1Ar3)	32bit argument #3	Clobbered
+	D0.3	(D0Ar2)	32bit argument #2	Clobbered
+	D1.3	(D1Ar1)	32bit argument #1	Clobbered
+	D0.4	(D0FrT)				Clobbered
+	D1.4	(D1RtP)	Return pointer		Clobbered
+	D{0-1}.{5-7}				Preserved
+	A0.0	(A0StP)	Stack pointer		Preserved
+	A1.0	(A0GbP)				Preserved
+	A0.1	(A0FrP)	Frame pointer		Preserved
+	A1.1	(A0LbP)				Preserved
+	A{0-1},{2-3}				Clobbered
+
+64-bit arguments are placed in matching pairs of registers (i.e. the same
+register number in both D0 and D1 units), with the least significant half in D0
+and the most significant half in D1, leaving a gap where necessary. Futher
+arguments are stored on the stack in reverse order (earlier arguments at higher
+addresses):
+
+	ADDRESS		0     1     2     3	4     5     6     7
+	===============	===== ===== ===== =====	===== ===== ===== =====
+	A0StP       -->
+	A0StP-0x08	32bit argument #8	32bit argument #7
+	A0StP-0x10	32bit argument #10	32bit argument #9
+
+Function prologues tend to look a bit like this:
+
+	/* If frame pointer in use, move it to frame temp register so it can be
+	   easily pushed onto stack */
+	MOV	D0FrT,A0FrP
+
+	/* If frame pointer in use, set it to stack pointer */
+	ADD	A0FrP,A0StP,#0
+
+	/* Preserve D0FrT, D1RtP, D{0-1}.{5-7} on stack, incrementing A0StP */
+	MSETL	[A0StP++],D0FrT,D0.5,D0.6,D0.7
+
+	/* Allocate some stack space for local variables */
+	ADD	A0StP,A0StP,#0x10
+
+At this point the stack would look like this:
+
+	ADDRESS		0     1     2     3	4     5     6     7
+	===============	===== ===== ===== =====	===== ===== ===== =====
+	A0StP       -->
+	A0StP-0x08
+	A0StP-0x10
+	A0StP-0x18	Old D0.7		Old D1.7
+	A0StP-0x20	Old D0.6		Old D1.6
+	A0StP-0x28	Old D0.5		Old D1.5
+	A0FrP       -->	Old A0FrP (frame ptr)	Old D1RtP (return ptr)
+	A0FrP-0x08	32bit argument #8	32bit argument #7
+	A0FrP-0x10	32bit argument #10	32bit argument #9
+
+Function epilogues tend to differ depending on the use of a frame pointer. An
+example of a frame pointer epilogue:
+
+	/* Restore D0FrT, D1RtP, D{0-1}.{5-7} from stack, incrementing A0FrP */
+	MGETL	D0FrT,D0.5,D0.6,D0.7,[A0FrP++]
+	/* Restore stack pointer to where frame pointer was before increment */
+	SUB	A0StP,A0FrP,#0x20
+	/* Restore frame pointer from frame temp */
+	MOV	A0FrP,D0FrT
+	/* Return to caller via restored return pointer */
+	MOV	PC,D1RtP
+
+If the function hasn't touched the frame pointer, MGETL cannot be safely used
+with A0StP as it always increments and that would expose the stack to clobbering
+by interrupts (kernel) or signals (user). Therefore it's common to see the MGETL
+split into separate GETL instructions:
+
+	/* Restore D0FrT, D1RtP, D{0-1}.{5-7} from stack */
+	GETL	D0FrT,D1RtP,[A0StP+#-0x30]
+	GETL	D0.5,D1.5,[A0StP+#-0x28]
+	GETL	D0.6,D1.6,[A0StP+#-0x20]
+	GETL	D0.7,D1.7,[A0StP+#-0x18]
+	/* Restore stack pointer */
+	SUB	A0StP,A0StP,#0x30
+	/* Return to caller via restored return pointer */
+	MOV	PC,D1RtP
-- 
1.7.7.6

