Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab0J1AOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 20:14:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab0J1AOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 20:14:10 -0400
Message-ID: <4CC8C04C.1070903@redhat.com>
Date: Thu, 28 Oct 2010 02:14:04 +0200
From: Michael Stefaniuc <mstefani@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Alexandre Julliard <julliard@winehq.org>
Subject: Re: Regression in 2.6.36 in single stepping over hardware breakpoint
 (Wine)
References: <4CC8BFDD.8080600@redhat.com>
In-Reply-To: <4CC8BFDD.8080600@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, forgot to say that I have opened
https://bugzilla.kernel.org/show_bug.cgi?id=21332 for this regression.

On 10/28/2010 02:12 AM, Michael Stefaniuc wrote:
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
>
> A regression test gives:
> 0c4519e825c9e2b6a8310deff8582f8c35bfbba9 is the first bad commit
> commit 0c4519e825c9e2b6a8310deff8582f8c35bfbba9
> Author: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Thu Jun 24 21:21:27 2010 +0200
>
> x86: Set resume bit before returning from breakpoint exception
>
> Instruction breakpoints trigger before the instruction executes,
> and returning back from the breakpoint handler brings us again
> to the instruction that breakpointed. This naturally bring to
> a breakpoint recursion.
>
> To solve this, x86 has the Resume Bit trick. When the cpu flags
> have the RF flag set, the next instruction won't trigger any
> instruction breakpoint, and once this instruction is executed,
> RF is cleared back.
>
> This let's us jump back to the instruction that triggered the
> breakpoint without recursion.
>
> Use this when an instruction breakpoint triggers.
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Prasad <prasad@linux.vnet.ibm.com>
> Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jason Wessel <jason.wessel@windriver.com>
>
> :040000 040000 2eae1fa5f90b141d60fe28a971a618e9c0b1a232
> e27fd94a1beb10e3688d555bd74c888b6a310293 M arch
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
> git clone git://source.winehq.org/git/wine.git
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
> bug. http://wiki.winehq.org/WineOn64bit has a lot more info on setting
> this up.

bye
     michael
