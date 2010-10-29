Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab0J2VLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 17:11:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37777 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab0J2VLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 17:11:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bn9kyKppy18XSzAwIiWKMlQADpZWdn4QbtFma/kjW7FQEEbWXlr5cwk8R7+uAeQutV
         DCdf0lypQP63dLNljXXRyQVQk7IcMZBPB/cZ/dmPdIJHOpib5BG0n25+Q8CBI+t+hMn9
         9XSbMdaExJLeJKNP22ljOoWM4lBlyKG/4zJbw=
Date: Fri, 29 Oct 2010 23:11:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Stefaniuc <mstefani@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Alexandre Julliard <julliard@winehq.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Prasad <prasad@linux.vnet.ibm.com>
Subject: Re: Regression in 2.6.36 in single stepping over hardware
	breakpoint (Wine)
Message-ID: <20101029211108.GA5356@nowhere>
References: <4CC8BFDD.8080600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC8BFDD.8080600@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 02:12:13AM +0200, Michael Stefaniuc wrote:
> Hello Frederic,
>
> there is a regression between 2.6.35 and 2.6.36 for 32bit Wine in the  
> Wine test checking the single stepping over hardware breakpoints:
> /home/michi/work/wine/tools/runtest -q -P wine -M ntdll.dll -T ../../..  
> -p ntdll_test.exe.so /home/michi/work/wine/dlls/ntdll/tests/exception.c  
> && touch exception.ok
> exception.c:585: Test failed: eip is wrong: 340002 instead of 340001
> exception.c:587: Test failed: B0 flag is not set in Dr6
> exception.c:588: Test failed: BS flag is set in Dr6
> exception.c:593: Test failed: eip is wrong: 7ed569d3 instead of 340002
> make: *** [exception.ok] Error 4
>
> All those tests are in bpx_handler()
> http://source.winehq.org/git/wine.git/?a=blob;f=dlls/ntdll/tests/exception.c;h=701b6bba091dddce724075dc41dd2ab407f28ac4;hb=HEAD#l559
>
> A regression test gives:
> 0c4519e825c9e2b6a8310deff8582f8c35bfbba9 is the first bad commit
> commit 0c4519e825c9e2b6a8310deff8582f8c35bfbba9
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date:   Thu Jun 24 21:21:27 2010 +0200
>
>     x86: Set resume bit before returning from breakpoint exception
>
>     Instruction breakpoints trigger before the instruction executes,
>     and returning back from the breakpoint handler brings us again
>     to the instruction that breakpointed. This naturally bring to
>     a breakpoint recursion.
>
>     To solve this, x86 has the Resume Bit trick. When the cpu flags
>     have the RF flag set, the next instruction won't trigger any
>     instruction breakpoint, and once this instruction is executed,
>     RF is cleared back.
>
>     This let's us jump back to the instruction that triggered the
>     breakpoint without recursion.
>
>     Use this when an instruction breakpoint triggers.
>
>     Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>     Cc: Will Deacon <will.deacon@arm.com>
>     Cc: Prasad <prasad@linux.vnet.ibm.com>
>     Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
>     Cc: Paul Mackerras <paulus@samba.org>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Cc: Jason Wessel <jason.wessel@windriver.com>
>
> :040000 040000 2eae1fa5f90b141d60fe28a971a618e9c0b1a232  
> e27fd94a1beb10e3688d555bd74c888b6a310293 M      arch
>
> Reverting this patch on top of 2.6.36 makes the problem go away.
>
> The problem is 100% reproducible and I see it in 32bit Wine on both
> 32bit and 64bit Linux. The regression might affect also 64bit Wine but
> those exception tests aren't compiled for 64bit Wine due to the lack of
> compiler support for win64 exceptions; so we cannot test it.
>
>
> Steps to reproduce:
> -------------------
> Any Wine version wine-1.2 or newer will do (either a tarball from
> http://sourceforge.net/projects/wine/files/Source/ or from git
>    git clone git://source.winehq.org/git/wine.git
> ./configure
> make
> cd dlls/ntdll/tests/
> make exception.ok
>
> Test results: The above errors on lines 585, 587, 588, 593 should not show
> up. Additionally there should be no error in line 665 as that means the  
> tests
> didn't run (there was a temporary regression in the 2.6.36-rc phase that
> produced the test failed on line 665; the patch from commit 89e45aac42d4
> was needed at each bisection point).
>
>
> For 32bit Wine builds on a x86_64 machine a pretty complete 32bit setup
> is needed too, but configure will let one know. If configure doesn't
> errors out but produces warnings, those can be safely ignored. It means
> the dependencies are optional and those aren't needed to reproduce this
> bug.  http://wiki.winehq.org/WineOn64bit has a lot more info on setting
> this up.
>
> bye
>         michael



Michael, thanks a lot for this report and for all these details. Thanks
to them it was so easy to reproduce that I had the impression I was playing
a video game with all the cheat codes possible: I even felt guilty.

There are several issues here.

In this wine test, the code sets up a breakpoint on ip + 1...:


func:
	ip    >:	nop
	ip + 1>:	nop
	ip + 2>:	ret


...and also sets up the single stepping. And then it starts from ip.
So one would expect two exceptions in chronological order: a first one for
the single step when ip finishes and a second one for the breakpoint in ip + 1
before ip + 1 is executed.

=> Single step exception are traps: they happen after instruction execution.
and instruction breakpoint are faults: they happen before instruction
execution. Both exceptions are then happening in the same place: before ip + 1
gets executed. But single step traps have a higher priority over other debug
exceptions like breakpoints, so they happen before. Both are not merged though,
the breakpoint exception will still happen after the single step one.

So, single steps and breakpoints exceptions are serialized. But our
kernel code doesn't care and pretend to be able to handle both at once:
during single step exceptions, the breakpoint handler still checks that the
origin of the exception is not a breakpoint. But this is bad because the
breakpoint status bits are in a random state during single step exceptions
(as said in the intel manual). This is the theory. In practice, at least
with my atom testbox, the breakpoint status bit is set already because the
hardware detected the breakpoint, it's just that the exception for this one
will come after.

So what happens is that we handle this spurious breakpoint status during
the single step exception, and then we set up the resume flag so that
we can forward progress (it's initially a convenience for perf event
but it has a side effect in this ptrace scenario), so the real instruction
breakpoint exception that was supposed to follow is finally ignored because
of the resume flag.

Wine expected two exceptions and eventually got only one (actually the
real scenario was more complicated, I extracted only the interesting
part).

So there are 2 problems here:

1) Breakpoint status bits must be ignored when we handle single step
exception.

2) I thought that setting the Resume Flag on instruction breakpoint would
have no side effects because nobody wants a breakpoint to loop on
the same instruction for ever. But this scenario shows there are other
side effects. Of course this would be fixed after we fix 1), but there
might be other ABI breakages due to other side effects of this. I should
perhaps fix that too, like not setting RF for ptrace breakpoints.


I'll fix that.

Thanks again for the report, plus I'm going to add this wine
testcase to my breakpoint regression tests.

