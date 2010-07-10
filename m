Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0GJAel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:34:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50214 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0GJAei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:34:38 -0400
X-Authority-Analysis: v=1.1 cv=o8sBXTxWt3Y8I13SYZ0pmcTcOViZ+nX/QX6HkgGmvUU= c=1 sm=0 a=Uax4mGMbvacA:10 a=hO-oPbc3tlwA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VnNF1IyMAAAA:8 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=CmFHVTcvQthM1hWEb_cA:9 a=RlOuMdZh2cAPjTSAFvIA:7 a=Nmc40N2ty3j7CZVu4OHvlocNdXgA:4 a=PUjeQqilurYA:10 a=Zh68SRI7RUMA:10 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=_RhRFcbxBZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 4/4 V2] futex: convert hash_bucket locks to
 raw_spinlock_t
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Mike Galbraith <efault@gmx.de>, linux-rt-users@vger.kernel.org
In-Reply-To: <4C37A945.2000606@us.ibm.com>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
	 <1278714780-788-5-git-send-email-dvhltc@us.ibm.com>
	 <4C37A945.2000606@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 09 Jul 2010 20:34:35 -0400
Message-ID: <1278722075.1537.174.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:57 -0700, Darren Hart wrote:
> This version pulls in the bits mistakenly left in 3/4.
> 
> 
> >From 9f8b4faac79518f98131464c2d21a1c64fb841d2 Mon Sep 17 00:00:00 2001
> From: Darren Hart <dvhltc@us.ibm.com>
> Date: Fri, 9 Jul 2010 16:44:47 -0400
> Subject: [PATCH 4/4 V2] futex: convert hash_bucket locks to raw_spinlock_t
> 
> The requeue_pi mechanism introduced proxy locking of the rtmutex.  This creates
> a scenario where a task can wake-up, not knowing it has been enqueued on an
> rtmutex. In order to detect this, the task would have to be able to take either
> task->pi_blocked_on->lock->wait_lock and/or the hb->lock.  Unfortunately,
> without already holding one of these, the pi_blocked_on variable can change
> from NULL to valid or from valid to NULL. Therefor, the task cannot be allowed
> to take a sleeping lock after wakeup or it could end up trying to block on two
> locks, the second overwriting a valid pi_blocked_on value. This obviously
> breaks the pi mechanism.
> 
> This patch increases latency, while running the ltp pthread_cond_many test
> which Michal reported the bug with, I see double digit hrtimer latencies
> (typically only on the first run after boo):
> 
> 	kernel: hrtimer: interrupt took 75911 ns
> 
> This might be addressed by changing the various loops in the futex code to be
> incremental, probably at an additional throughput hit. The private hash_bucket
> lists discussed in the past could reduce hb->lock contention in some scenarios.
> It should be noted that pthread_cond_many is a rather pathological case.
> 
> This also introduces problems for plists which want a spinlock_t rather
> than a raw_spinlock_t. Any thoughts on how to address this?
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: John Kacur <jkacur@redhat.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Mike Galbraith <efault@gmx.de>
> ---
>  kernel/futex.c |   73 ++++++++++++++++++++++++++++++--------------------------
>  1 files changed, 39 insertions(+), 34 deletions(-)


