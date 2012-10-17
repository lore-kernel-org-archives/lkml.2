Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2JQGN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:13:26 -0400
Received: from dnvwsmailout1.mcafee.com ([161.69.31.173]:50393 "EHLO
	DNVWSMAILOUT1.mcafee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2JQGNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:13:22 -0400
Message-ID: <507E4D40.9050202@snapgear.com>
Date: Wed, 17 Oct 2012 16:16:32 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-arch@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][CFT][CFReview] execve and kernel_thread unification work
References: <20121001213809.GA31155@ZenIV.linux.org.uk> <20121015013009.GB2616@ZenIV.linux.org.uk>
In-Reply-To: <20121015013009.GB2616@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On 15/10/12 11:30, Al Viro wrote:
> On Mon, Oct 01, 2012 at 10:38:09PM +0100, Al Viro wrote:
>> [with apologies for folks Cc'd, resent due to mis-autoexpanded l-k address
>> on the original posting ;-/  Mea culpa...]
>>
>> 	There's an interesting ongoing project around kernel_thread() and
>> friends, including execve() variants.  I really need help from architecture
>> maintainers on that one; I'd been able to handle (and test) quite a few
>> architectures on my own [alpha, arm, m68k, powerpc, s390, sparc, x86, um]
>> plus two more untested [frv, mn10300].  c6x patches had been supplied by
>> Mark Salter; everything else remains to be done.  Right now it's at
>> minus 1.2KLoC, quite a bit of that removed from asm glue and other black magic.
>
> Update:
> 	* all infrastructure is in mainline now, along with conversion for
> kernel_thread() callbacks to the form that allows really simple model for
> kernel_execve() _without_ flagday changes.
> 	* #experimental-kernel_thread is gone; this stuff is in for-next
> now.
> 	* a lot of architecture conversions had been done and some are
> even tested.  Currently missing are only 7 - avr32, hexagon, m32r, openrisc,
> score, tile and xtensa.  OTOH, a lot are completely untested.  I've put
> per-architecture stuff into separate branches and I promise never rebase
> those once arch maintainers will be OK with the stuff in them.  IOW, they'll
> be safe to pull into respective architecture trees.
>
> Folks, *please* review the stuff in signal.git#arch-*.  All of them are
> completely independent.  I'll be glad to get ACKs/fixes/replacements/etc.

I have checked arch-m68k on ColdFire with and without MMU, and it
is all fine. So for those:

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg



> I've merged some of those into for-next, but that can change at any time -
> it's not final; for-next will be rebased.  Obviously, I hope to get to
> the situation when all of those branches (plus currently missing ones)
> get into shape that satisfies architecture maintainers.  Once that happens,
> all those branches will be merged into for-next.
>
> I think the model is about final wrt kernel_thread()/kernel_execve()/
> sys_execve().  There's one possible change on top of it, but it's reasonably
> well-isolated from the rest.  As it is, the model to aim for is this:
> 	* select GENERIC_KERNEL_THREAD and GENERIC_KERNEL_EXECVE
> 	* kill local kernel_thread()/kernel_execve() implementations
> 	* generic kernel_thread() will call your copy_thread() with
> NULL regs and fn/arg passed in the pair of arguments that are blindly
> passed all the way through to copy_thread() - usp and stack_size resp.
> In such case copy_thread() should arrange for the newborn to be woken
> up in a function that is very similar to ret_from_fork().  The only
> difference is that between the call of schedule_tail() and jumping into
> the "return from syscall" code it should call fn(arg), using the data
> left for it by copy_thread().
> 	* unlike the previous variant, ret_from_kernel_execve() is not
> needed at all; no need to play longjmp()-like games when kernel_thread()
> callbacks had been taught to return normally all the way out when
> kernel_execve() returns 0; any updates of sp/manipulations of register
> windows/etc. will happen without any magic.
> 	* provide current_pt_regs() if needed.  Default is
> task_pt_regs(current), but you might want to optimize it and unlike
> task_pt_regs() it must work whenever we are in syscall or in a kernel thread.
> task_pt_regs(task), OTOH, is required to work only when task can be
> interrogated by tracer.
> 	* no more syscalls-from-kernel, which often allows for simplifications
> in the syscall entry/exit logics.  I haven't done any of those; up to the
> architecture maintainers.
>
> 	One thing to keep in mind is that right now on SMP architectures
> there's the third caller of copy_thread(), besides fork()/clone()/vfork()
> (all pass userland pt_regs, with the address being current_pt_regs()) and
> kernel_thread() (pass NULL pt_regs, kthread creation time).  It's fork_idle()
> and it passes zero-filled pt_regs.  Frankly, I'm not even sure we want to
> call copy_thread() in that case - the stuff set up by it goes nowhere.
> We do that for each possible secondary CPU on SMP and we do *not* expose
> those threads to scheduler.  When CPU gets initialized we have the
> secondary bootstrap take that task_struct as current.  Its kernel stack,
> thread_info, etc. are set up by said secondary bootstrap, overriding whatever
> copy_thread() has done.  Eventually the bootstrap reaches cpu_idle(),
> which is where we schedule away.  switch_to() done by schedule() is what
> completes setting the things up; at that point they are ready to be woken
> up - and not in ret_from_fork(), of course.
> 	For the majority of architectures nothing done by copy_thread() in
> that case is used afterwards, so we might as well stop calling it when
> copy_process() is called by fork_idle().  I know of only one dubious case -
> powerpc sets thread->ksp_limit on copy_thread() and I'm not sure if
> that's get overwritten in secondary bootstrap - the value would be still
> correct and I don't see any obvious places where it would be reassigned
> on that codepath.  There might be other cases like that, though.  I would
> argue that for this kind of stuff the right place is arch_dup_task_struct(),
> not copy_thread()...  Hell knows.  Note that we are pretty much hitting
> the random path in copy_thread() in that case - what zeroed pt_regs look
> like to user_regs() is arch-dependent.
>
> 	This is the possible change I've mentioned above.  Not sure; I'd
> really like comments on that one.
>
> 	Branches in there:
> arch-blackfin - conversion; completely untested
> arch-cris - conversion; completely untested
> arch-h8300 - conversion; completely untested
> arch-microblaze - conversion; completely untested
> arch-sh - conversion; completely untested
> arch-unicore32 - conversion; completely untested
> arch-ia64 - conversion; tested only on ski, which is worth very little
> arch-c6x - followup to mainline; while it's minor, it's pretty much done
> blindly and *really* needs review by maintainer.
> arch-arm - contains heroic fix by rmk and nothing else.  Seems to work fine.
> arch-m68k - minor followup to stuff already in mainline; works on aranym
> arch-parisc - mostly the stuff tested by parisc folks + minor followup
> similar to m68k one.
> arch-s390 - minor followup to mainline; works in hercules
> arch-arm64 - patches from maintainer with minor followup folded
> arch-frv - minor followup to mainline, needs testing
> arch-mn10300 - minor followup to mainline, needs testing
> arch-mips - patches from me and Ralf; works on qemu
> arch-sparc - conversions for sparc32 and sparc64, plus the syscall_noerror
> optimization
> arch-powerpc - minor followups to mainline, need review by maintainers
>
> "Completely untested" in the above reads "no promises it even compiles, let
> alone isn't horribly broken".  Please, treat that as a possible starting
> point for doing the conversion for arch in question.  I might have misread
> the CPU manuals, your switch_to() implementation, etc., or just have been
> temporary insane from digging through dozens of architectures.  Hopefully
> temporary, that is...
>
> And folks, for pity sake, do the remaining seven.  The merge window is
> over, so...
>
> 			Al, buggering off to get some VFS work done.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
