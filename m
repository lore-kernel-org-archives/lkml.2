Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab1KUVwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:52:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60864 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab1KUVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:52:38 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=OQnieflinJEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=5ZK8A6k4RrYE1XhnOlUA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Q: tracing: can we change trace_signal_generate() signature?
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20111121202110.GA27966@redhat.com>
References: <20111121191920.GA24883@redhat.com>
	 <1321905799.20742.20.camel@frodo>  <20111121202110.GA27966@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 16:52:36 -0500
Message-ID: <1321912356.20742.24.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 21:21 +0100, Oleg Nesterov wrote:

> > > IOW. Ignoring the changes in include/trace/events/signal.h,
> > > can the patch below work or the changes like this are not
> > > allowed?
> >
> > I say change it and see who screams.
> 
> Heh. How can I do this? The only thing I can do is: send the patch
> to the maintainer - you ;)
> 
> OK. I'll send the patch "officially" tomorrow, let's see who nacks it.

I only maintain the tracing infrastructure. The tracepoint users are
maintained by the subsystem they are used in. Who's the signal
maintainer? ;)

> 
> > > +enum {
> > > +	TRACE_SIGNAL_DELIVERED,
> > > +	TRACE_SIGNAL_IGNORED_OR_BLOCKED,
> 
> (can't understand why I added _OR_BLOCKED, it should be
>  TRACE_SIGNAL_IGNORED)

quilt refresh?

> 
> > > @@ -1095,14 +1106,15 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
> > >  			 * signal was rt and sent by user using something
> > >  			 * other than kill().
> > >  			 */
> > > -			trace_signal_overflow_fail(sig, group, info);
> > > -			return -EAGAIN;
> > > +			result = TRACE_SIGNAL_OVERFLOW_FAIL;
> > > +			ret = -EAGAIN;
> > > +			goto ret;
> > >  		} else {
> > >  			/*
> > >  			 * This is a silent loss of information.  We still
> > >  			 * send the signal, but the *info bits are lost.
> > >  			 */
> > > -			trace_signal_lose_info(sig, group, info);
> > > +			result = TRACE_SIGNAL_LOSE_INFO;
> > 
> > Hmm, all this result manipulation added for tracing that doesn't occur
> > in 99.99% of all machines?
> 
> Not sure I understand...

Is "result" used for anything but tracepoints? When tracing is disabled,
the tracepoints should be just nops (when jump_label is enabled). Thus
tracing is very light. But if we are constantly calculating "result",
this is unused by those that don't use the tracing infrastructure, which
is 99.99% of all users. This is what I meant.

-- Steve

> 
> With this patch trace_signal_generate() also reports "result" which
> allows to know was the signal actually delivered or not. And, if not,
> why it wasn't delivered.
> 
> TRACE_SIGNAL_OVERFLOW_FAIL and TRACE_SIGNAL_LOSE_INFO are not really
> needed, but this way we can kill trace_signal_overflow_fail() and
> trace_signal_lose_info() and simplify the code.
> 
> Oleg.


