Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1ACUWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:22:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1ACUWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:22:30 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=MsfxUTlnwtkA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=d_wQqMYOy-r8hfbEupwA:9 a=oZLbcS_mN6WfjUvw3aMA:7 a=uQjyJmpdxBbSgAatITwsyC4rmKMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][RT][PATCH 3/4] rtmutex: Revert Optimize rt lock wakeup
From: Steven Rostedt <rostedt@goodmis.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        ThomasGleixner <tglx@linutronix.de>,
        Peter Morreale <PMorreale@novell.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1294081596.3948.192.camel@gandalf.stny.rr.com>
References: <20101223224755.078983538@goodmis.org>
	 <20101223225116.729981172@goodmis.org>
	 <4D13DF250200005A000793E1@novprvoes0310.provo.novell.com>
	 <1293166464.22802.415.camel@gandalf.stny.rr.com>
	 <4D19A8B20200005A00079658@novprvoes0310.provo.novell.com>
	 <1294081596.3948.192.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 03 Jan 2011 15:22:27 -0500
Message-ID: <1294086147.3948.194.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 14:06 -0500, Steven Rostedt wrote:

> 
> 	if (adaptive_wait(&waiter, orig_owner))
> 		sleep = 1;
> 	else
> 		sleep = 0;
> 
> 	if (sleep)


> 		raw_spin_lock(&lock->wait_lock);
> 		saved_state = rt_set_current_block_state(saved_state);
> 		if (!lock->owner && &waiter == rt_mutex_top_waiter(lock))
> 			sleep = 0;
> 		raw_spin_unlock(&lock->wait_lock);

I may be able to remove the above locks and replace it with:

	saved_state = rt_set_current_blocked_state(saved_state);
	if (orig_owner == rt_mutex_owner(lock))
		schedule_rt_mutex(lock);

-- Steve


> 		if (sleep)
> 			schedule_rt_mutex(lock);
> 		saved_state = rt_restore_current_blocked_state(saved_state);
> 	}
> 
> Otherwise we can risk the wakeup_next_waiter() missing the wakeup.
> 
> To clarify, we want the adaptive_wait() to run as TASK_RUNNING. Then if
> we must sleep, then we must set the state to TASK_UNINTERRUPTIBLE, test
> again if we can still the lock, and if not then sleep. Otherwise, if a
> wakeup happens just before we set the state to TASK_UNINTERRUPTIBLE,
> then we miss the wake up all together.
> 
> I can do this change, and see what impact it makes.
> 
> I'm also curious if this ever worked? If it did not, then are you sure
> your tests that show the benefit of it was true. I don't have a large
> scale box at my disposal ATM, so I can only see what this does on 4way
> machines.
> 
> -- Steve
> 


