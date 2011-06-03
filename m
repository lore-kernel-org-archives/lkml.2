Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1FCMLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:11:38 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:60510 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1FCMLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:11:37 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCHSET ptrace] ptrace: implement PTRACE_SEIZE/INTERRUPT and group stop notification, take#4
Date: Fri, 3 Jun 2011 13:11:33 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <20110603012445.GA14872@mtj.dyndns.org> <201106031357.02859.vda.linux@googlemail.com>
In-Reply-To: <201106031357.02859.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106031311.33929.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011 12:57:02, Denys Vlasenko wrote:
> On Friday 03 June 2011 03:24, Tejun Heo wrote:
> > > > * Implicit signal on clone.
> > > 
> > > Best if it is converted to STOP trap (the same is one caused by INTERRUPT).
> > > 
> > > I guess this may be optionally changed
> > > (similar to how PTRACE_O_TRACEEXEC
> > > changes post-execve SIGTRAP into PTRACE_EVENT_EXEC).
> > > 
> > > Why not turn it on *unconditionally* on SEIZE?
> > > Because otherwise ptrace users will turn into
> > > 
> > > if (we_used_SEIZE)
> > >     do_something;
> > > else
> > >     do_something_else;
> > > 
> > > maze, which is maintenance nightmare.
> > > It's possible users will opt to not use new functionality at all
> > > instead of going that way.
> > 
> > Hmmm... I see.  The other side of the argument is that some level of
> > "if (SEIZEd)" is inevitable anyway and in the longer run we would be
> > better off defaulting to the better behavior than making things
> > optional.
> > 
> > > If everything is monolithically tied into SEIZE, users won't be able
> > > to opt to use only easy parts of new functionality (such as
> > > PTRACE_INTERRUPT and PTRACE_LISTEN) if this *forces* them
> > > to also use harder parts of new functionality, in this case
> > > forces them to double and obfuscate their existing code
> > > which handles SIGSTOP-on-child-auto-attach. They don't really
> > > want to, since this SIGSTOP *in practice* isn't that problematic.
> > 
> > Anyways, let's think about that, but SIGSTOP on clone is closely
> > linked to why SEIZE is used in the first place and I currently lean
> > toward tying it to SEIZE.
> 
> Ok.
> 
> SIGSTOP on clone is less problematic because in practice it's
> rather hard to send a real SIGSTOP to a thread which is _just_ created.
> So the race window is mostly theoretical - unlike the much more realistic
> race on initial attach to an already running process.
> 
> But if tracer already uses SEIZE on initial attach, it ought to be
> willing to handle the new way of post-clone stop too.
> Therefore I'm ok with this idea.
> 
> 
> > > > * What to do about events which are reported by genuine SIGTRAP
> > > >  generation?
> > > 
> > > I don't understand what you meant here. Example(s)?
> > 
> > The syscall, breakpoint, single step SIGTRAPs which can't be
> > distinguished from userland generated SIGTRAPs and may be mixed and/or
> > lost.  Maybe it's best to leave them alone or maybe we can add some
> > way to distinguish them which is mostly backward compatible (which is
> > enabled w/ SEIZE and hopefully doesn't require noticeable userland
> > changes).
> 
> Currently, all PTRACE_EVENTs are enabled with ptrace options.
> 
> I propose using the same way instead of using something different.
> It works. It's not problematic. Just add more PTRACE_O_foo bits.
> Then user who really want it will use it, and users which
> would rather use their existing code with less changes aren't
> forced to change.

I'm in principle against this.  What realistic good does it
bring over making exception/syscall SIGTRAPs distinguisheable
on the siginfo?  Userspace should see these SIGTRAPs if a tracer
isn't there anyway, and, even if a tracer _is_ there, you
may want to forward breakpoint/step SIGTRAPs to the
tracee, just as if a ptracer wasn't there --- I do that often to
debug an in-process self debugger.  Being able to distinguish the
cause of the SIGTRAP is useful for self debuggers as well,
which leads to putting the info in siginfo anyway.

> I am not insisting on a separate bit per event,
> single blanket PTRACE_O_FLAGTRAPS bit which converts all of these
> to PTRACE_EVENTs all once is ok with me.

-- 
Pedro Alves
