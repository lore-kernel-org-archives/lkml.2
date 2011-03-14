Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab1CNO2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 10:28:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52490 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab1CNO2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 10:28:48 -0400
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=u2_5ZAQ68KIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=sDaV93BWH5J0pGpM6yEA:9 a=47MVeimRYMbGOykSPmMA:7 a=8QbceKd8ZcN5YPDYZIhby-GrZywA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/2] tracing - putting cond_resched into tace_pipe loop
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110314141853.GB1936@jolsa.brq.redhat.com>
References: <1299970786-8075-1-git-send-email-jolsa@redhat.com>
	 <1299970786-8075-3-git-send-email-jolsa@redhat.com>
	 <20110313145811.GA30558@redhat.com>
	 <1300111651.9910.87.camel@gandalf.stny.rr.com>
	 <20110314141853.GB1936@jolsa.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Mar 2011 10:28:46 -0400
Message-ID: <1300112926.9910.100.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 15:18 +0100, Jiri Olsa wrote:


> > I'm not sure that this needs the signal_pending() or the break, or even
> > the cond_resched(). Perhaps the first patch fixes the bug. But that
> > while loop does not block, and it should just spin enough to fill a
> > page. If it is not filling the page then that's a bug.
> 
> well, if there are no "event lost" messages and the flags are set
> to the "bin or raw" and you trace events only, then the page
> is not be filled.
> 
> But as there'll be allways lost events, the page will be populated
> and it will get out of the loop.

There's two loops, I'm talking about the inner one, which will break out
when there are no events left to process.

The "waitagain" calls into tracing_wait_pipe which has the
signal_pending() attribute. It should also block, or return -EAGAIN if
the caller is not blocking.

> 
> > 
> > Jiri,
> > 
> > Can you reproduce the bug with just he first patch? Actually, I can
> > reproduce it on vanilla, I'll apply your first patch and see if that
> > fixes things. If not, then we need to find out why and fix those.
> 
> The first patch fixies the 'lost evets' trace, so the loop is escaped
> when the page is full.
> (I was going to send some change for first patch WARN_ON -> WARN_ONCE)

Yes, I was going to recommend doing that too.

> 
> I think in case there are no 'lost events' and we have the conditions
> I describe, we need the cond_resched call.

No we don't.

As for non preempt kernels, honestly, I don't care about latencies. If
you are worried about latencies, don't run a non preempt kernel. I do
care if it goes into an infinite loop, or never processes signals, which
would be a bug. But long running times in the kernel on a non preempt
kernel. Well, that's just part of the game.

-- Steve

> 
> I'll send new patch version shortly.
> 
> thanks,
> jirka
> > 
> > -- Steve
> > 
> > 


