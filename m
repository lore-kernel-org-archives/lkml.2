Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0LXEy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 23:54:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab0LXEy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 23:54:26 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=MsfxUTlnwtkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=9axoW3ER4pvMAXTiG0EA:9 a=oWPewdQ_YwrBvCLu4DoA:7 a=FgoK2G4NBdQn4QBwjtjLS0i_FP0A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock wakeup
From: Steven Rostedt <rostedt@goodmis.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Morreale <PMorreale@novell.com>
In-Reply-To: <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
References: <20101223224755.078983538@goodmis.org>
	 <20101223225116.729981172@goodmis.org>
	 <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 23 Dec 2010 23:54:24 -0500
Message-ID: <1293166464.22802.415.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 21:45 -0700, Gregory Haskins wrote:
> Hey Steve,
> 
> >>> On 12/23/2010 at 05:47 PM, in message <20101223225116.729981172@goodmis.org>,
> Steven Rostedt <rostedt@goodmis.org> wrote: 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The commit: rtmutex: Optimize rt lock wakeup
> > 
> > Does not do what it was suppose to do.
> > This is because the adaptive waiter sets its state to TASK_(UN)INTERRUPTIBLE
> > before going into the loop. Thus, the test in wakeup_next_waiter()
> > will always fail on an adaptive waiter, as it only tests to see if
> > the pending waiter never has its state set ot TASK_RUNNING unless
> > something else had woke it up.
> > 
> > The smp_mb() added to make this test work is just as expensive as
> > just calling wakeup. And since we we fail to wake up anyway, we are
> > doing both a smp_mb() and wakeup as well.
> > 
> > I tested this with dbench and we run faster without this patch.
> > I also tried a variant that instead fixed the loop, to change the state
> > only if the spinner was to go to sleep, and that still did not show
> > any improvement.
> 
> Just a quick note to say I am a bit skeptical of this patch.  I know you are offline next week, so lets plan on hashing it out after the new year before I ack it.

Sure, but as I said, it is mostly broken anyway. I could even insert
some tracepoints to show that this is always missed (heck I'll add an
unlikely and do the branch profiler ;-)

The reason is that adaptive spinners spin in some other state than
TASK_RUNNING, thus it does not help adaptive spinners at all. I first
tried to fix that, but it made dbench run even slower. But I only did a
few tests, and only on a 4 CPU box, so it was a rather small sample. The
removal of the code had to deal with more that it was already broken
than anything else.

But yeah, we can hash this out in the new year. This is one of the
reasons I only posted this patch set as an RFC.

> 
> Happy holidays!

You too!

-- Steve


