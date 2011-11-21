Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1KUUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:25:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab1KUUZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:25:57 -0500
Date: Mon, 21 Nov 2011 21:21:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: tracing: can we change trace_signal_generate() signature?
Message-ID: <20111121202110.GA27966@redhat.com>
References: <20111121191920.GA24883@redhat.com> <1321905799.20742.20.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321905799.20742.20.camel@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21, Steven Rostedt wrote:
>
> On Mon, 2011-11-21 at 20:19 +0100, Oleg Nesterov wrote:
> > Hello,
> >
> > Is it possible to change trace_signal_generate()'s args or this
> > is the part of the kernel ABI?
>
> As Linus said. It's only part of the ABI if a tool is using it. If you
> change it and no one complains, then it should be good to go.

I only I knew if it is used (and how) or not...

> > IOW. Ignoring the changes in include/trace/events/signal.h,
> > can the patch below work or the changes like this are not
> > allowed?
>
> I say change it and see who screams.

Heh. How can I do this? The only thing I can do is: send the patch
to the maintainer - you ;)

OK. I'll send the patch "officially" tomorrow, let's see who nacks it.

> > +enum {
> > +	TRACE_SIGNAL_DELIVERED,
> > +	TRACE_SIGNAL_IGNORED_OR_BLOCKED,

(can't understand why I added _OR_BLOCKED, it should be
 TRACE_SIGNAL_IGNORED)

> > @@ -1095,14 +1106,15 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
> >  			 * signal was rt and sent by user using something
> >  			 * other than kill().
> >  			 */
> > -			trace_signal_overflow_fail(sig, group, info);
> > -			return -EAGAIN;
> > +			result = TRACE_SIGNAL_OVERFLOW_FAIL;
> > +			ret = -EAGAIN;
> > +			goto ret;
> >  		} else {
> >  			/*
> >  			 * This is a silent loss of information.  We still
> >  			 * send the signal, but the *info bits are lost.
> >  			 */
> > -			trace_signal_lose_info(sig, group, info);
> > +			result = TRACE_SIGNAL_LOSE_INFO;
> 
> Hmm, all this result manipulation added for tracing that doesn't occur
> in 99.99% of all machines?

Not sure I understand...

With this patch trace_signal_generate() also reports "result" which
allows to know was the signal actually delivered or not. And, if not,
why it wasn't delivered.

TRACE_SIGNAL_OVERFLOW_FAIL and TRACE_SIGNAL_LOSE_INFO are not really
needed, but this way we can kill trace_signal_overflow_fail() and
trace_signal_lose_info() and simplify the code.

Oleg.

