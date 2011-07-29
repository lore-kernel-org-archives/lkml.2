Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1G2DbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 23:31:14 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39384 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1G2DbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 23:31:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110729013830.GC5404@dastard>
References: <20110729013830.GC5404@dastard>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 28 Jul 2011 23:30:49 -0400
X-Google-Sender-Auth: S_Fgm4QdmPkgyCRMpagokbumsxU
Message-ID: <CAObL_7GdxD07-9_aYZBDqutQD6cVz2kYHXAcUwDWr6NkqRdByw@mail.gmail.com>
Subject: Re: [3.0-rc0 Regression]: legacy vsyscall emulation increases user
 CPU time by 20%
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 9:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> Hi folks,
>
> It-s merge window again, which means I'm doing my usual "where did
> the XFS performance go" bisects again. The usual workload:
>

[...]

>
> The completion time over multiple runs is ~8m10s +/-5s, and the user
> CPU time is roughly 245s +/-5s
>
> Enter 5cec93c2 ("x86-64: Emulate legacy vsyscalls") and the result
> ends up at:
>
>     0     48000000            0     108975.2          9507483
>     0     48800000            0     114676.5          8604471
>     0     49600000            0      98062.0          8921525
>     0     50400000            0     103864.7          8218302
> 287.35user 2933.90system 8:33.11elapsed 627%CPU (0avgtext+0avgdata 82560maxresident)k
> 0inputs+0outputs (1664major+2603457minor)pagefaults 0swaps
>
> Noticable slow wall time with more variance - it's at 8m30s +/-10s,
> and the user CPU time is at 290s +/-5s. So the benchmark is slower to
> complete and consumes 20% more CPU in userspace. The following commit
> c971294 x86-64: ("Improve vsyscall emulation CS and RIP handling")
> also contributes to the slowdown a bit.

I'm surprised that the second commit had any effect.

>
> FYI, fs_mark does a lot of gettimeofday() calls - one before and
> after every syscall that does filesystem work so it can calculate
> the syscall times and the amount of time spent not doing syscalls.
> I'm assuming this is the problem based on the commit message.
> Issuing hundreds of thousands of getimeofday calls per second spread
> across multiple CPUs is not uncommon, especially in benchmark or
> performance measuring software. If that is the cause, then these
> commits add -significant- overhead to that process.

I put some work into speeding up vdso timing in 3.0.  As of Linus' tree now:

# test_vsyscall bench
Benchmarking  syscall gettimeofday      ...   7068000 loops in
0.50004s =   70.75 nsec / loop
Benchmarking     vdso gettimeofday      ...  23868000 loops in
0.50002s =   20.95 nsec / loop
Benchmarking vsyscall gettimeofday      ...   2106000 loops in
0.50004s =  237.44 nsec / loop

Benchmarking  syscall CLOCK_MONOTONIC   ...   9018000 loops in
0.50002s =   55.45 nsec / loop
Benchmarking     vdso CLOCK_MONOTONIC   ...  30867000 loops in
0.50002s =   16.20 nsec / loop

Benchmarking  syscall time              ...  12962000 loops in
0.50001s =   38.58 nsec / loop
Benchmarking     vdso time              ... 286269000 loops in
0.50000s =    1.75 nsec / loop
Benchmarking vsyscall time              ...   2412000 loops in
0.50012s =  207.35 nsec / loop

Benchmarking     vdso getcpu            ...  40265000 loops in
0.50001s =   12.42 nsec / loop
Benchmarking vsyscall getcpu            ...   2334000 loops in
0.50012s =  214.27 nsec / loop

Benchmarking dummy syscall              ...  14927000 loops in
0.50000s =   33.50 nsec / loop

So clock_gettime(CLOCK_MONOTONIC) is faster, more correct, and more
precise than gettimeofday.  IMO you should fix your benchmark :)


More seriously, though, I think it's a decent tradeoff to slow down
some extremely vsyscall-heavy legacy workloads to remove the last bit
of nonrandomized executable code.  The only way this should show up to
any significant extent is on modern rdtsc-using systems that make a
huge number of vsyscalls.  On older machines, even the cost of the
trap should be smallish compared to the cost of HPET / acpi_pm access.

>
> Assuming this is the problem, can this be fixed without requiring
> the whole world having to wait for the current glibc dev tree to
> filter down into distro repositories?

How old is your glibc?  gettimeofday has used the vdso since:

commit 9c6f6953fda96b49c8510a879304ea4222ea1781
Author: Ulrich Drepper <drepper@redhat.com>
Date:   Mon Aug 13 18:47:42 2007 +0000

    * sysdeps/unix/sysv/linux/x86_64/libc-start.c

        (_libc_vdso_platform_setup): If vDSO is not available point
        __vdso_gettimeofday to the vsyscall.
        * sysdeps/unix/sysv/linux/x86_64/gettimeofday.S [SHARED]: Use
        __vdso_gettimeofday instead of vsyscall.


We could play really evil games to speed it up a bit.  For example, I
think it's OK for int 0xcc to clobber rcx and r11, enabling this
abomination:

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e13329d..6edbde0 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1111,8 +1111,25 @@ zeroentry spurious_interrupt_bug
do_spurious_interrupt_bug
 zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
-zeroentry emulate_vsyscall do_emulate_vsyscall

+ENTRY(emulate_vsyscall)
+       INTR_FRAME
+       PARAVIRT_ADJUST_EXCEPTION_FRAME
+       pushq_cfi $-1           /* ORIG_RAX: no syscall to restart */
+       subq $ORIG_RAX-R15, %rsp
+       CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
+       call error_entry
+       DEFAULT_FRAME 0
+       movq %rsp,%rdi          /* pt_regs pointer */
+       xorl %esi,%esi          /* no error code */
+       call do_emulate_vsyscall
+       movq %rax,RAX(%rsp)
+       movq RSP(%rsp),%rcx
+       movq %rcx,PER_CPU_VAR(old_rsp)
+       RESTORE_REST
+       jmp ret_from_sys_call   /* XXX: should check cs */
+       CFI_ENDPROC
+END(emulate_vsyscall)

        /* Reload gs selector with exception handling */
        /* edi:  new selector */

speeds up the gettimeofday emulated vsyscall from 237 ns to 157 ns.


This may be the most evil kernel patch I've ever written.  But I think
it's almost correct and could be made completely correct with only a
little bit of additional effort.  (I'm not really suggesting this, but
it's at least worth some entertainment.)

--Andy

P.S.  Holy cow, iret is slow.  Anyone want to ask their Intel / AMD
friends to add an instruction just like sysret that pops rcx and r11
from the stack or reads them from non-serialized MSRs?  That way we
could do this to all of the 64-bit fast path returns.

P.P.S.  It's kind of tempting to set up a little userspace trampoline that does:

popq %r11
popq %rcx
ret 128

Page faults could increment rsp by 128 (preserving the red zone), push
rip, rcx, and r11, and return via sysretq to the trampoline.  This
would presumably save 80ns on Sandy Bridge :)
