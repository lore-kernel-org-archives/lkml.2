Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2APHqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:46:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38051 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab2APHqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:46:00 -0500
Date: Mon, 16 Jan 2012 08:45:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120116074540.GE15641@elte.hu>
References: <20120110174509.GA30802@redhat.com>
 <20120113182015.GA3902@redhat.com>
 <20120115182441.GA24694@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120115182441.GA24694@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 01/13, Oleg Nesterov wrote:
> >
> > Hello,
> 
> ping ;)
> 
> > Please pull from
> >
> > 	git://github.com/utrace/linux sigtrace
> >
> >
> > Another (4th) attempt to push these simple changes, now in the form
> > of a pull request (yes, github, I still can't restore my korg account).
> >
> > 2/2 looks like a bugfix to me, but 1/2 changes the output from
> > trace_signal_generate() and removes trace_signal_overflow_fail.
> > In essence the change is:
> >
> > 	-       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
> > 	+       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d grp=%d res=%d",
> >
> > where
> > 	- grp=0/1 means private or shared
> >
> > 	- res is enum {
> > 			TRACE_SIGNAL_DELIVERED,
> > 			TRACE_SIGNAL_IGNORED,
> > 			TRACE_SIGNAL_ALREADY_PENDING,
> > 			TRACE_SIGNAL_OVERFLOW_FAIL,
> > 			TRACE_SIGNAL_LOSE_INFO,
> > 		};
> >
> > Obviously this is the user visible change. But personally I do
> > agree with Seiji who requested this feature. Currently
> > trace_signal_generate() just records the fact that __send_signal()
> > was called, you can't know whether the signal was actually sent
> > or not.
> >
> > Steven Rostedt says:
> >
> > 	Adding more to a tracepoint is never an issue, even without a library to
> > 	parse the data correctly (which we still need in the distros). Thus this
> > 	change should have no issues.
> >
> >
> >
> > Oleg Nesterov (2):
> >       tracing: let trace_signal_generate() report more info, kill overflow_fail/lose_info
> >       tracing: send_sigqueue() needs trace_signal_generate() too
> >
> >  include/trace/events/signal.h |   85 +++++++++++------------------------------
> >  kernel/signal.c               |   28 +++++++++----
> >  2 files changed, 41 insertions(+), 72 deletions(-)

I've also Cc:-ed Masami-san who appears to have introduced most 
of this trace information.

Looks good to me at a first (quick) sight, except this bit 
which changes the ABI:

> > 	-       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d",
> > 	+       TP_printk("sig=%d errno=%d code=%d comm=%s pid=%d grp=%d res=%d",

That's not how we change tracepoints generally - we add a new 
one and eventually phase out the old one. Which apps/tools rely 
on the old tracepoint? If it's exactly zero apps then we might 
be able to change it, but this needs to be investigated.

Note, it might make sense to send these as two patches to lkml 
with me Cc:-ed to avoid any github trust issues, i can apply 
them and push them to Linus.

Thanks,

	Ingo
