Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab0DACZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:25:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935Ab0DACZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:25:57 -0400
X-Authority-Analysis: v=1.1 cv=pKw63bS+wPQ6BxbjPFuXko/1Hb8f7lpGL8zfzHecwYY= c=1 sm=0 a=5_LdwiuLWHQA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=63SHTuVW8WvA3R2mAQsA:9 a=NdVsBFc6du9G6Am1Q1cA:7 a=k9FVD6jhqoN3OoOvAIu4d-0Omg4A:4 a=PUjeQqilurYA:10 a=IePpGRbsbpkco2dL:21 a=8XrVUr-FaGlq3Xsk:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <4BB40140.20109@us.ibm.com>
References: <4BB3D90C.3030108@us.ibm.com>
	 <1270078689.19685.8040.camel@gandalf.stny.rr.com>
	 <4BB40140.20109@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 31 Mar 2010 22:25:53 -0400
Message-ID: <1270088753.19685.8218.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 19:13 -0700, Darren Hart wrote:
> Steven Rostedt wrote:
> > On Wed, 2010-03-31 at 16:21 -0700, Darren Hart wrote:
> > 
> >> o What type of lock hold times do we expect to benefit?
> > 
> > 0 (that's a zero) :-p
> > 
> > I haven't seen your patches but you are not doing a heuristic approach,
> > are you? That is, do not "spin" hoping the lock will suddenly become
> > free. I was against that for -rt and I would be against that for futex
> > too.
> 
> I'm not sure what you're getting at here. Adaptive spinning is indeed 
> hoping the lock will become free while you are spinning and checking 
> it's owner...

I'm talking about the original idea people had of "lets spin for 50us
and hope it is unlocked before then", which I thought was not a good
idea.


> 
> > 
> >> o How much contention is a good match for adaptive spinning?
> >>    - this is related to the number of threads to run in the test
> >> o How many spinners should be allowed?
> >>
> >> I can share the kernel patches if people are interested, but they are 
> >> really early, and I'm not sure they are of much value until I better 
> >> understand the conditions where this is expected to be useful.
> > 
> > Again, I don't know how you implemented your adaptive spinners, but the
> > trick to it in -rt was that it would only spin while the owner of the
> > lock was actually running. If it was not running, it would sleep. No
> > point waiting for a sleeping task to release its lock.
> 
> It does exactly this.

OK, that's good.

> 
> > Is this what you did? Because, IIRC, this only benefited spinlocks
> > converted to mutexes. It did not help with semaphores, because
> > semaphores could be held for a long time. Thus, it was good for short
> > held locks, but hurt performance on long held locks.
> 
> Trouble is, I'm still seeing performance penalties even on the shortest 
> critical section possible (lock();unlock();)

performance penalties compared to what? not having adaptive at all?

> 
> > If userspace is going to do this, I guess the blocked task would need to
> > go into kernel, and spin there (with preempt enabled) if the task is
> > still active and holding the lock.
> 
> It is currently under preempt_disable() just like mutexes. I asked Peter 
> why it was done that way for mutexes, but didn't really get an answer. 
> He did point out that since we check need_resched() at every iteration 
> that we won't run longer than our timeslice anyway, so it shouldn't be a 
>   problem.

Sure it's not a problem ;-)

-- Steve


