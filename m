Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab1KVU53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:57:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305Ab1KVU52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:57:28 -0500
Date: Tue, 22 Nov 2011 21:52:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] (Was: Q: tracing: can we change
	trace_signal_generate() signature?)
Message-ID: <20111122205239.GA20971@redhat.com>
References: <20111121191920.GA24883@redhat.com> <1321905799.20742.20.camel@frodo> <20111121202110.GA27966@redhat.com> <1321912356.20742.24.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321912356.20742.24.camel@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21, Steven Rostedt wrote:
>
> On Mon, 2011-11-21 at 21:21 +0100, Oleg Nesterov wrote:
>
> > Heh. How can I do this? The only thing I can do is: send the patch
> > to the maintainer - you ;)
> >
> > OK. I'll send the patch "officially" tomorrow, let's see who nacks it.
>
> I only maintain the tracing infrastructure. The tracepoint users are
> maintained by the subsystem they are used in. Who's the signal
> maintainer? ;)

You are trolling me ;)

> > > > @@ -1095,14 +1106,15 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
> > > >  			 * signal was rt and sent by user using something
> > > >  			 * other than kill().
> > > >  			 */
> > > > -			trace_signal_overflow_fail(sig, group, info);
> > > > -			return -EAGAIN;
> > > > +			result = TRACE_SIGNAL_OVERFLOW_FAIL;
> > > > +			ret = -EAGAIN;
> > > > +			goto ret;
> > > >  		} else {
> > > >  			/*
> > > >  			 * This is a silent loss of information.  We still
> > > >  			 * send the signal, but the *info bits are lost.
> > > >  			 */
> > > > -			trace_signal_lose_info(sig, group, info);
> > > > +			result = TRACE_SIGNAL_LOSE_INFO;
> > >
> > > Hmm, all this result manipulation added for tracing that doesn't occur
> > > in 99.99% of all machines?
> >
> > Not sure I understand...
>
> Is "result" used for anything but tracepoints? When tracing is disabled,
> the tracepoints should be just nops (when jump_label is enabled). Thus
> tracing is very light. But if we are constantly calculating "result",
> this is unused by those that don't use the tracing infrastructure, which
> is 99.99% of all users. This is what I meant.

Ah I see. I thought you dislike OVERFLOW_FAIL/LOSE_INFO namely.

Of course, you are right. OTOH, this patch shaves 1058 bytes from
.text. And without CONFIG_TRACE* gcc doesn't generate the extra code.



Oh. I simply do not know what can I do. Obviously, I'd like to avoid
the new tracepoints in __send_signal(), imho this would be ugly. But
the users want more info.

OK. let me send the patch at least for review. May be someone will
nack it authoritatively, in this case I can relax and forward the
nack back to bugzilla ;)

However, at least 2/2 looks very reasonable to me. In fact it looks
almost like the bug-fix.

Oleg.

