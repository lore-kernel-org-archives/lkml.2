Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0CaXiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:38:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62166 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab0CaXiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:38:13 -0400
X-Authority-Analysis: v=1.1 cv=8Rq9yliVGc3GxcN10kx+g7e/eWPAtZnInWtRlahw0rA= c=1 sm=0 a=5_LdwiuLWHQA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=uzfE4TgbX_JZYTqcWMAA:9 a=Ckipl1BaRA7J8VVww2cA:7 a=dtAGMromqxJSHl5MiZHS1SKb1lgA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
       Chris Wright <chrisw@sous-sol.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <4BB3D90C.3030108@us.ibm.com>
References: <4BB3D90C.3030108@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 31 Mar 2010 19:38:09 -0400
Message-ID: <1270078689.19685.8040.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 16:21 -0700, Darren Hart wrote:

> o What type of lock hold times do we expect to benefit?

0 (that's a zero) :-p

I haven't seen your patches but you are not doing a heuristic approach,
are you? That is, do not "spin" hoping the lock will suddenly become
free. I was against that for -rt and I would be against that for futex
too.

> o How much contention is a good match for adaptive spinning?
>    - this is related to the number of threads to run in the test
> o How many spinners should be allowed?
> 
> I can share the kernel patches if people are interested, but they are 
> really early, and I'm not sure they are of much value until I better 
> understand the conditions where this is expected to be useful.

Again, I don't know how you implemented your adaptive spinners, but the
trick to it in -rt was that it would only spin while the owner of the
lock was actually running. If it was not running, it would sleep. No
point waiting for a sleeping task to release its lock.

Is this what you did? Because, IIRC, this only benefited spinlocks
converted to mutexes. It did not help with semaphores, because
semaphores could be held for a long time. Thus, it was good for short
held locks, but hurt performance on long held locks.

If userspace is going to do this, I guess the blocked task would need to
go into kernel, and spin there (with preempt enabled) if the task is
still active and holding the lock.

Then the application would need to determine which to use. An adaptive
spinner for short held locks, and a normal futex for long held locks.

-- Steve


