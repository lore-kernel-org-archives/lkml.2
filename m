Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1ADPsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:48:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53248 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1ADPsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:48:02 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=MsfxUTlnwtkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=BbT4ttFzhC7kX151OrUA:9 a=lJTZpJiFikjU_6BK7bXwwAVuh4EA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock wakeup
From: Steven Rostedt <rostedt@goodmis.org>
To: pmorreale@novell.com
Cc: Gregory Haskins <ghaskins@novell.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        ThomasGleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1294154349.3371.24.camel@hermosa.morreale.net>
References: <20101223224755.078983538@goodmis.org>
	 <20101223225116.729981172@goodmis.org>
	 <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
	 <1293166464.22802.415.camel@gandalf.stny.rr.com>
	 <4D19A8B20200005A00079658@novprvoes0310.provo.novell.com>
	 <1294081596.3948.192.camel@gandalf.stny.rr.com>
	 <1294086147.3948.194.camel@gandalf.stny.rr.com>
	 <1294154349.3371.24.camel@hermosa.morreale.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 04 Jan 2011 10:47:59 -0500
Message-ID: <1294156079.3948.209.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 08:19 -0700, Peter W. Morreale wrote:
> On Mon, 2011-01-03 at 15:22 -0500, Steven Rostedt wrote:
> > On Mon, 2011-01-03 at 14:06 -0500, Steven Rostedt wrote:
> > 
> > > 
> > > 	if (adaptive_wait(&waiter, orig_owner))
> > > 		sleep = 1;
> > > 	else
> > > 		sleep = 0;
> > > 
> > > 	if (sleep)
> > 
> > 
> > > 		raw_spin_lock(&lock->wait_lock);
> > > 		saved_state = rt_set_current_block_state(saved_state);
> > > 		if (!lock->owner && &waiter == rt_mutex_top_waiter(lock))
> > > 			sleep = 0;
> > > 		raw_spin_unlock(&lock->wait_lock);
> > 
> > I may be able to remove the above locks and replace it with:
> > 
> > 	saved_state = rt_set_current_blocked_state(saved_state);
> > 	if (orig_owner == rt_mutex_owner(lock))
> > 		schedule_rt_mutex(lock);
> > 
> > -- Steve
> 
> Isn't it possible to miss a wakeup here if the waiter becomes preempted?

Why? Preemption doesn't change the task state.

> 
> Recall that adaptive wait is a preemptive wait.  Hence the (I believe)
> original reason we did the adaptive spin in a (transitioning)  sleep
> state.

Yes it is a preemptive wait, I would not have accepted the patches if it
was anything else. But preemption is not affected by the state of the
task. A task could be TASK_RUNNING or TASK_INTERRUPTIBLE or
TASK_UNINTERRUPTIBLE, and that would not affect how it acts when it is
preempted.

-- Steve


