Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2BCAcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:32:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34196 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2BCAcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:32:39 -0500
Date: Fri, 3 Feb 2012 00:32:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Indan Zupancic <indan@nul.nu>
Cc: Takuo Koguchi <takuo.koguchi.sw@hitachi.com>, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        fweisbec@gmail.com, mingo@redhat.com, jbaron@redhat.com,
        yrl.pp-manager.tt@hitachi.com, mcgrathr@google.com
Subject: Re: [PATCH] ARM: Wire up HAVE_SYSCALL_TRACEPOINTS
Message-ID: <20120203003220.GC14129@n2100.arm.linux.org.uk>
References: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com> <3743fd16323370925cf37c279f85d94a.squirrel@webmail.greenhost.nl> <4F2A55B6.4030006@hitachi.com> <06cd49dcb5a124722e042c308144d5b7.squirrel@webmail.greenhost.nl> <20120202111007.GF889@n2100.arm.linux.org.uk> <5afe2282e055f172906087538bdb1f3d.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5afe2282e055f172906087538bdb1f3d.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 12:38:58AM +0100, Indan Zupancic wrote:
> On Thu, February 2, 2012 12:10, Russell King - ARM Linux wrote:
> > On Thu, Feb 02, 2012 at 12:00:30PM +0100, Indan Zupancic wrote:
> >> On Thu, February 2, 2012 10:21, Takuo Koguchi wrote:
> >> > Right.  As Russel King suggested, this patch depends on those configs
> >> > until very large NR_syscalls is properly handled by ftrace.
> >>
> >> It has nothing to do with large NR_syscalls. Supporting OABI is hard,
> >
> > That's rubbish if you're doing things correctly, where correctly is
> > defined as 'not assuming that the syscall number is in r7, but reading
> > it from the thread_info->syscall member.
> 
> It was my impression that thread_info->syscall is only set in the ptrace
> path.

Well, as ptrace is the only syscall tracing we have at the moment in
the kernel, then that's how its done.

What we don't have there for ptrace is a method to read that, so
tools such as strace have had to fiddle about to discover the syscall
number.  That's something I have had a patch for some time to 'fix'
(a PTRACE_GET_SYSCALL to complement PTRACE_SET_SYSCALL) but haven't
had the motivation to try to fix that.

> Of course this can be changed, but it's tricky to do without adding
> instructions to the syscall entry path. One way would be to have a
> flag somewhere saying whether r7 or thread_info->syscall should be
> used, and also set thread_info->syscall for OABI calls. That at least
> won't slow down the EABI path.

Why would you need to change the entry path?  We already have a hook
out of the syscall path for doing tracing (via syscall_trace()) but
the fact that it sits in ptrace.c isn't an argument to create something
new.

> > Notice how the EABI case is a lot more complicated by the alignment
> > rules than the OABI - not only do you need something like the above
> 
> Only when you go through the args sequentially like that.

If you don't go through the args sequentially, then your only way of
deciding EABI args is via a table which describes the location of each
argument in the register set.

> If only EABI is supported everything is simple, because everyone knows
> what to expect. If OABI is also supported then more changes are needed:
> The above, but also some way to tell ptrace and other users if it was
> an EABI or OABI system call. And currently with ptrace there is no race
> free way of figuring out the OABI system call number from user space.

Absolute tosh, that really is.  Of course there's a way of figuring it
out.  Tools such as strace have been doing it for _years_ and have been
doing it extremely well.

Sure, some other thread may stamp over the syscall after you've entered
the kernel, but that's a bug in any case - if programs are doing that
then they're racy, and can't predict what system call they're going to
invoke.  So really that kind of race is not one to be concerned about.

And, in any case, using what's already there in syscall_trace() already
gives you a way to store and manipulate the syscall number.  So really
there's no argument over obtaining the syscall number from OABI at all.
