Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1GJSnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:43:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454Ab1GJSnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:43:16 -0400
Date: Sun, 10 Jul 2011 20:40:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: kill handle_signal()->set_fs()
Message-ID: <20110710184032.GA28312@redhat.com>
References: <20110710164424.GA20261@redhat.com> <4E19EEC2.7060806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E19EEC2.7060806@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10, H. Peter Anvin wrote:
>
> On 07/10/2011 09:44 AM, Oleg Nesterov wrote:
> > handle_signal()->set_fs() has a nice comment which explains what
> > set_fs() is, but it doesn't explain why it is needed and why it
> > depends on CONFIG_X86_64.
> >
> > Afaics, the history of this confusion is:
> >
> > 	1. I guess today nobody can explain why it was needed
> > 	   in arch/i386/kernel/signal.c, perhaps it was always
> > 	   wrong. This predates 2.4.0 kernel.
> >
> > 	2. then it was copy-and-past'ed to the new x86_64 arch.
> >
> > 	3. then it was removed from i386 (but not from x86_64)
> > 	   by b93b6ca3 "i386: remove unnecessary code".
> >
> > 	4. then it was reintroduced under CONFIG_X86_64 when x86
> > 	   unified i386 and x86_64, because the patch above didn't
> > 	   touch x86_64.
> >
> > Remove it. ->addr_limit should be correct. Even if it was possible
> > that it is wrong, it is too late to fix it after setup_rt_frame().
> >
>
> The main reason I could think of why this would be necessary is if we
> take an event while we have fs == KERNEL_DS inside the kernel

this is possible if we are the kernel thread, or set_fs(KERNEL_DS) was
called.

> which is
> then promoted to a signal.

How? We are going to return to the user-space. Obviously this is not
possible with the kernel thread. So I think this can only happen if
we already have a bug with unbalanced set_fs().

Are you absolutely sure that can't happen?

> In particular, there should be a setting upstream of this, as you're
> correctly pointing out that it's too late.  If not, we might actually
> have a problem.

Hmm... Now I recall, this was already discussed 5 years ago. Thanks to
google, see http://lkml.org/lkml/2007/7/17/321

In particular, Linus sayd:

	Heh. I think it's entirely historical.

	Please realize that the whole reason that function is called "set_fs()" is
	that it literally used to set the %fs segment register, not
	"->addr_limit".

	So I think the "set_fs(USER_DS)" is there _only_ to match the other

		regs->xds = __USER_DS;
		regs->xes = __USER_DS;
		regs->xss = __USER_DS;
		regs->xcs = __USER_CS;

	things, and never mattered. And now it matters even less, and has been
	copied to all other architectures where it is just totally insane.

Oleg.

