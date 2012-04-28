Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab2D1VqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 17:46:17 -0400
Received: from [12.216.194.151] ([12.216.194.151]:17385 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab2D1VqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 17:46:16 -0400
Message-ID: <4F9C6525.3050405@tilera.com>
Date: Sat, 28 Apr 2012 17:46:13 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: avoid calling do_signal() after fork from
 a kernel thread
References: <20120426183742.GA324@redhat.com> <20120426231942.GJ6871@ZenIV.linux.org.uk> <20120427172444.GA30267@redhat.com> <20120427184528.GL6871@ZenIV.linux.org.uk> <20120427202002.8ED632C0BF@topped-with-meat.com> <20120427211244.GO6871@ZenIV.linux.org.uk> <20120427212729.652542C0AF@topped-with-meat.com> <20120427231526.GP6871@ZenIV.linux.org.uk> <20120427235023.GR6871@ZenIV.linux.org.uk> <201204281858.q3SIwC7H014319@farm-0027.internal.tilera.com> <20120428205517.GW6871@ZenIV.linux.org.uk>
In-Reply-To: <20120428205517.GW6871@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2012 4:55 PM, Al Viro wrote:
> On Sat, Apr 28, 2012 at 02:51:43PM -0400, Chris Metcalf wrote:
>> Calling interrupt_return will check the privilege of the context we're
>> returning to avoid the possibility of kernel threads doing any kind
>> of userspace actions (including signal handling) after a fork.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> ---
>> Al, thanks for noticing this.  I've queued it up for 3.4.
>>
>> Do you have a case that might provoke the signal behavior in the
>> unpatched code?  The patched code passes our internal regressions.
>>
>>  arch/tile/kernel/intvec_32.S |    2 +-
>>  arch/tile/kernel/intvec_64.S |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
>> index 5d56a1e..d0f48ca 100644
>> --- a/arch/tile/kernel/intvec_32.S
>> +++ b/arch/tile/kernel/intvec_32.S
>> @@ -1274,7 +1274,7 @@ STD_ENTRY(ret_from_fork)
>>  	FEEDBACK_REENTER(ret_from_fork)
>>  	{
>>  	 movei  r30, 0               /* not an NMI */
>> -	 j      .Lresume_userspace   /* jump into middle of interrupt_return */
>> +	 j      interrupt_return
>>  	}
>>  	STD_ENDPROC(ret_from_fork)
> Umm...  I'm not sure that it's correct.  For one thing, ret_from_fork is
> used both for kernel threads and for plain old fork(2).  In the latter
> case you want .Lresume_userspace, not interrupt_return.

It's OK, since we will jump to .Lresume_userspace from interrupt_return in
the latter case:

STD_ENTRY(interrupt_return)
        /* If we're resuming to kernel space, don't check thread flags. */
        {
         [...]
         PTREGS_PTR(r29, PTREGS_OFFSET_EX1)
        }
        ld      r29, r29
        andi    r29, r29, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
        {
         beqzt  r29, .Lresume_userspace
         [...]
        }

The struct ptregs "ex1" field will reliably tell us whether we came from
kernel or userspace context.  Certainly for fork() this will indicate
userspace, since it's the return register info for the syscall.   And for
kernel_thread() we explicitly set up ex1 to indicate kernel privilege as well.

> For another,
> there's kernel_execve() and if it fails (binary doesn't exist/has wrong
> format/etc.) you'll get to .Lresume_userspace with EX1_PL(regs->ex1)
> unchanged, i.e. the kernel one...

This is a good point.  The current syscall return path goes directly to
.Lresume_userspace, which will screw up kernel syscalls.  I think the right
answer is still to jump to interrupt_return from those cases, though.  In
particular, this gets rid of the existing cruftiness where we have to
document that a local label (.Lresume_userspace) can be the target of jumps
from outside the containing function.

> As for the reproducer, just
> guess the PID of modprobe when you are e.g. trying to mount a filesystem
> with fs driver modular and not loaded; fork(), have parent wait a bit
> and call mount(), while the child keeps sending something more or less
> innocent (SIGCHLD, for example) to the guessed PID.  And either have
> /sbin/modprobe chmod -x before doing that (you'll need to remember to
> chmod it back before reboot, of course) or just
> mount --bind /dev/null /sbin/modprobe.  Either way, kernel_execve() will
> fail.  And if you manage to hit the sucker just as it's being spawned,
> you'll get the kernel_thread() codepath as well.
>
> FWIW, I like what you've done with do_work_pending() - it's much cleaner
> than usual loops and tests in assembler.  The only question is, what's
> going on with
> 	push_extra_callee_saves r0
> you are doing there - seems possibly over the top for situations when
> SIGPENDING isn't set and, more seriously, what if you go through that
> loop many times?  You slap them again and again into pt_regs, overwriting
> anything ptrace() might've done to r34..r51, right?

Yes, that's a good observation.  I should hoist the push of callee-saves to
before the loop.  I'll put out a new patch that incorporates both of those
changes.

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

