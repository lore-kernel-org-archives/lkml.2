Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2EWQpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:45:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54648 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451Ab2EWQp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:45:29 -0400
Date: Wed, 23 May 2012 17:45:03 +0100
From: Will Deacon <will.deacon@arm.com>
To: Will Drewry <wad@chromium.org>
Cc: "wade_farnsworth@mentor.com" <wade_farnsworth@mentor.com>,
        "stevenrwalter@gmail.com" <stevenrwalter@gmail.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: New ARM asm/syscall.h incompatible? (commit
 bf2c9f9866928df60157bc4f1ab39f93a32c754e)
Message-ID: <20120523164503.GG26693@mudshark.cambridge.arm.com>
References: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 05:01:50PM +0100, Will Drewry wrote:
> Hi Wade and Steven,

Hi Will,

> I don't believe the syscall_get_arguments/syscall_set_arguments
> implementation that landed in 3.4 is correct or safe.  I didn't see it
> get pulled in - sorry for not mailing sooner! :(

Well, thanks for shouting anyway. It only went in during this merge window,
so hopefully we can fix it before 3.5.

> The current implementation allows for _7_ arguments and allows the 0th
> index to be the ARM_ORIG_r0 instead of starting with ARM_r0 == 0.  In
> the global description of syscall_*_arguments it says:
> 
>  * It's only valid to call this when @task is stopped for tracing on
>  * entry to a system call, due to %TIF_SYSCALL_TRACE or %TIF_SYSCALL_AUDIT.
>  * It's invalid to call this with @i + @n > 6; we only support system calls
>  * taking up to 6 arguments.

Hmm, where does this `6' come from? I see it's an open-coded constant in
some of the trace code, but as Russell pointed out:

http://lists.infradead.org/pipermail/linux-arm-kernel/2012-February/085509.html

we have the unusual case of requiring 7 arguments for a particular syscall.
Perhaps we could let the arch configure this?

> This means that the current implementation is broken when matching
> system call arguments for ftrace (unless there is an arch specific
> hack in there) and it breaks internal kernel API for any other
> consumers without arch knowledge (like seccomp mode=2).  Is there a
> reason to expose ARM_ORIG_r0 this way?  Am I misreading?
> 
> My understanding of the arch register usage at syscall time is something like:
> - ORIG_r0 gets the syscall number
> - r0 becomes the first system call argument
> - system call proceeds
> - on return, r0 is the return value

Aha, you're slightly off here. For ARM, ORIG_r0 is the first argument to the
system call (we keep it here as part of the syscall restarting code, since
the result of the interrupted syscall will sit in r0). The system call
number is either in r7 or encoded as part of the instruction but when
tracing we save it into the thread_info so we don't need to worry about
where it came from.

> Even audit_syscall_entry() uses ARM_r0 for the first argument which
> means that any future consumers doing syscall_get_arguments(..., 0, 6)
> would get the wrong first argument.

Thinking about it, I can't think of a scenario where the tracing code should
see a different value for ARM_r0 and ARM_ORIG_r0 on the entry path. Maybe we
should use ARM_r0 consistently for clarity.

> I'm also curious why the system call argument getter/setters allow for
> invalid requests instead of BUG_ON()ing?  All code that exposes
> syscall arguments to userspace should be limiting the number to a
> maximum of 6, and any other badness is a definite kernel bug.  Am I
> just really confused?

See the post from Russell linked above.

So I think the conclusion is that the 7-argument syscall (sys_syscall with
OABI) will have a truncated argument list when tracing.

Hope that helps,

Will
