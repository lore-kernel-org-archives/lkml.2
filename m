Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab3AHRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:09:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab3AHRJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:09:27 -0500
Message-ID: <50EC527C.5030800@redhat.com>
Date: Tue, 08 Jan 2013 17:08:12 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: u3557@miso.sublimeip.com, Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: PTRACE_SYSCALL && vsyscall (Was: arch_check_bp_in_kernelspace:
 fix the range check)
References: <20121125225533.GA24905@redhat.com> <20121125234834.DAC34592076@miso.sublimeip.com> <20121202193058.GA4264@redhat.com> <841b7a319f9d22402d269eed23d03835.squirrel@mail.sublimeip.com> <20121204175933.GA11537@redhat.com>
In-Reply-To: <20121204175933.GA11537@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 05:59 PM, Oleg Nesterov wrote:

> But If we want to allow to trace vsyscall's, hw bp doesn't look very
> nice imo. HBP_NUM = 4 and you need to setup 3 bp's to trace them all.

Irrespective of the whole syscall tracing issue, allowing HW bkpts in
the vsyscall just seems like a bug fix to me.

> That is why I think PTRACE_SYSCALL should "simply work" somehow. And
> so far I think that "just report syscall_exit with orig_ax = -1" is
> the best (and simple) solution.

If you report exit alone, you'll confuse current GDB into mistaking
it for an enter, and all following enter/exits end up swapped/confused.
GDB assumes trap/sysgood alternates between enter/exit, and always
starts with enter.

(Mildly related, GDB has an old comment in the code (linux-nat.c)
that says:

 "However, most architectures can't handle a syscall
 being traced on the way out if it wasn't traced on
 the way in."

I've no clue if that's still true nowadays.)

> OK. We can do more. We can report both syscall_enter/exit and we can
> change orig_ax/ax temporary to "fool" the tracer, so that everything
> will look as a "normal" syscall. Like vsyscall_seccomp() does.
> 
> But this needs much more changes.

I'd just like to add, that if any new syscall related option is
to be added, can we please just go all the way and add
PTRACE_EVENT_SYSCALL_ENTER|PTRACE_EVENT_SYSCALL_EXIT instead?

http://sourceware.org/gdb/wiki/LinuxKernelWishList

-- 
Pedro Alves

