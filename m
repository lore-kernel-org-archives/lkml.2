Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2BBLKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 06:10:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47569 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab2BBLK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 06:10:29 -0500
Date: Thu, 2 Feb 2012 11:10:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Indan Zupancic <indan@nul.nu>
Cc: Takuo Koguchi <takuo.koguchi.sw@hitachi.com>, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, jbaron@redhat.com,
        yrl.pp-manager.tt@hitachi.com, mcgrathr@google.com
Subject: Re: [PATCH] ARM: Wire up HAVE_SYSCALL_TRACEPOINTS
Message-ID: <20120202111007.GF889@n2100.arm.linux.org.uk>
References: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com> <3743fd16323370925cf37c279f85d94a.squirrel@webmail.greenhost.nl> <4F2A55B6.4030006@hitachi.com> <06cd49dcb5a124722e042c308144d5b7.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06cd49dcb5a124722e042c308144d5b7.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 12:00:30PM +0100, Indan Zupancic wrote:
> On Thu, February 2, 2012 10:21, Takuo Koguchi wrote:
> > Right.  As Russel King suggested, this patch depends on those configs
> > until very large NR_syscalls is properly handled by ftrace.
> 
> It has nothing to do with large NR_syscalls. Supporting OABI is hard,

That's rubbish if you're doing things correctly, where correctly is
defined as 'not assuming that the syscall number is in r7, but reading
it from the thread_info->syscall member.

> e.g. it doesn't put the syscall nr in r7, it's encoded as part of the
> syscall instruction. Also the ABI for some system calls is different,
> with different arg layouts (alignment of 64 bit args is different).

OABI is a lot more simple because you know how the args are layed out
without needing a table to work out where the padding is.  You know
if you have a 64-bit argument that it follows immediately after a
32-bit argument without needing any alignment.

So:

next_arg_reg(current_arg_reg, next_size, oabi)
{
	if (oabi) {
		/* OABI case */
		next_arg_reg = current_arg_reg + 1;
	} else {
		/* EABI case */
		next_arg_reg = current_arg_reg + 1;
		if (next_size == 64 && next_arg_reg & 1)
			next_arg_reg++;
	}
	return next_arg_reg;
}

Notice how the EABI case is a lot more complicated by the alignment
rules than the OABI - not only do you need something like the above
but also you need a table to describe the size of the arguments for
every syscall in the system.
