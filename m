Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab2BBXjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:39:08 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:42463 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2BBXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:39:06 -0500
Message-ID: <5afe2282e055f172906087538bdb1f3d.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120202111007.GF889@n2100.arm.linux.org.uk>
References: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com>
    <3743fd16323370925cf37c279f85d94a.squirrel@webmail.greenhost.nl>
    <4F2A55B6.4030006@hitachi.com>
    <06cd49dcb5a124722e042c308144d5b7.squirrel@webmail.greenhost.nl>
    <20120202111007.GF889@n2100.arm.linux.org.uk>
Date: Fri, 3 Feb 2012 00:38:58 +0100
Subject: Re: [PATCH] ARM: Wire up HAVE_SYSCALL_TRACEPOINTS
From: "Indan Zupancic" <indan@nul.nu>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Takuo Koguchi" <takuo.koguchi.sw@hitachi.com>,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        jbaron@redhat.com, yrl.pp-manager.tt@hitachi.com, mcgrathr@google.com
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 02b201d9c048bcde4aa7ed91fc024d05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, February 2, 2012 12:10, Russell King - ARM Linux wrote:
> On Thu, Feb 02, 2012 at 12:00:30PM +0100, Indan Zupancic wrote:
>> On Thu, February 2, 2012 10:21, Takuo Koguchi wrote:
>> > Right.  As Russel King suggested, this patch depends on those configs
>> > until very large NR_syscalls is properly handled by ftrace.
>>
>> It has nothing to do with large NR_syscalls. Supporting OABI is hard,
>
> That's rubbish if you're doing things correctly, where correctly is
> defined as 'not assuming that the syscall number is in r7, but reading
> it from the thread_info->syscall member.

It was my impression that thread_info->syscall is only set in the ptrace path.

Of course this can be changed, but it's tricky to do without adding
instructions to the syscall entry path. One way would be to have a
flag somewhere saying whether r7 or thread_info->syscall should be
used, and also set thread_info->syscall for OABI calls. That at least
won't slow down the EABI path.

>> e.g. it doesn't put the syscall nr in r7, it's encoded as part of the
>> syscall instruction. Also the ABI for some system calls is different,
>> with different arg layouts (alignment of 64 bit args is different).
>
> OABI is a lot more simple because you know how the args are layed out
> without needing a table to work out where the padding is.  You know
> if you have a 64-bit argument that it follows immediately after a
> 32-bit argument without needing any alignment.
>
> So:
>
> next_arg_reg(current_arg_reg, next_size, oabi)
> {
> 	if (oabi) {
> 		/* OABI case */
> 		next_arg_reg = current_arg_reg + 1;
> 	} else {
> 		/* EABI case */
> 		next_arg_reg = current_arg_reg + 1;
> 		if (next_size == 64 && next_arg_reg & 1)
> 			next_arg_reg++;
> 	}
> 	return next_arg_reg;
> }
>
> Notice how the EABI case is a lot more complicated by the alignment
> rules than the OABI - not only do you need something like the above

Only when you go through the args sequentially like that.

> but also you need a table to describe the size of the arguments for
> every syscall in the system.

You need that anyway if you want to handle 64-bit data as one arg
instead of two 32-bit args, no matter if it is OABI or EABI.

Like Roland said in his reply to this issue, just return the registers
and let the caller interpret the data. So ignore 64 bit arguments,
just pretend they are two 32 bit values, which they actually are anyway.
And yes you have unused padding args then, but so what? The argument
layout and meaning is syscall specific anyway, so the caller needs
specific knowledge already.

You can't return whole 64-bit args anyway except if you pretend all
arguments are 64-bit, which seems like a bad idea.

So if you have something like:

int sys_foo(int x, uint64 y);

x is arg 1, and y is arg 3 + 4 in EABI. But pretending that y is just
arg 2 makes no sense in generic syscall handling. And as you need some
syscall specific table anyway, it doesn't matter much if you need to
account for alignment or not.

If only EABI is supported everything is simple, because everyone knows
what to expect. If OABI is also supported then more changes are needed:
The above, but also some way to tell ptrace and other users if it was
an EABI or OABI system call. And currently with ptrace there is no race
free way of figuring out the OABI system call number from user space.
All in all starting with just EABI support and avoiding all the OABI
problems seems the best option.

Greetings,

Indan


