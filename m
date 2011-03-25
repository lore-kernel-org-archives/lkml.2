Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1CYSk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 14:40:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63704 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab1CYSk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 14:40:27 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=XYJHFtupD_QA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=GV20oUVrZpU2w0Wo5V4A:9 a=Sagl8g5tL_ghtmWeVZYA:7 a=vc2V3apSRw-t4bH2AszHR7kaF9IA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 25 Mar 2011 14:40:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>, torvalds@osdl.org,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: deadlock caused by printk
Message-ID: <20110325184026.GD9313@home.goodmis.org>
References: <AANLkTinCk35LSMLyO0nD+Z1ZmZskaCCN5c8kyxLcmXYx@mail.gmail.com>
 <1301055698.2250.198.camel@laptop>
 <1301055960.2250.202.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301055960.2250.202.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 01:26:00PM +0100, Peter Zijlstra wrote:
> On Fri, 2011-03-25 at 13:21 +0100, Peter Zijlstra wrote:
> > On Fri, 2011-03-25 at 20:15 +0800, Ming Lei wrote:
> > > Hi,
> > > 
> > > These days I was studying "perf code" and try to dump some debug
> > > info in event_sched_out(): kernel/perf_event.c by printk, but found
> > > system can hang easily.
> > > 
> > > After digging into related code for several days, I find the hang is
> > > caused by spinlock deadlock when acquiring rq->lock in task_rq_lock(),
> > > which is called in the path below:
> > > 
> > >           try_to_wake_up<-wake_up_process<-up<-console_unlock<-printk.

I've brought this up before, and basically was told "don't do that" ;)

> > > 
> > > I wonder if there are some usage conventions about printk, which says
> > > explicitly that printk can not by used in some places of kernel. Or does the
> > > above show that it is a bug of kernel?

Just don't use it when the rq lock his held. Which you probably don't
want to anyway since most paths that require rq lock can flood the
console with printk messages.

> 
> > One thing you could to is use trace_printk() and use ftrace to debug
> > perf.
> 
> That should still work.

Yep, trace_printk() is the perfect thing to use to debug anything. I
tried hard to make it work in all contexts.

You can also set ftrace_dump_on_opps on the command line, or echo 1 into
/proc/sys/kernel/ftrace_dump_on_oops at run time if you want the ftrace
buffer to write to the console if the box crashes.

And finally, early_printk() works in these contexts too, as it doesn't
grab any locks. But because it does not, it can easily get corrupted
buffers.

-- Steve

