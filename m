Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab2IFVlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:41:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab2IFVlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:41:03 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=dv6za2K3W50A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=hUPM8fjf3YcA:10 a=-k0NmLKOURZGD7taWHwA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346967661.1680.52.camel@gandalf.local.home>
Subject: Re: [PATCH tip/core/rcu 11/15] rcu: Avoid spurious RCU CPU stall
 warnings
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Date: Thu, 06 Sep 2012 17:41:01 -0400
In-Reply-To: <20120906210354.GC2448@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
	 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346352988-32444-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346943414.18408.31.camel@twins>
	 <1346944049.1680.23.camel@gandalf.local.home>
	 <1346944758.18408.35.camel@twins>
	 <20120906210354.GC2448@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 14:03 -0700, Paul E. McKenney wrote:

> Here are a few other ways that stalls can happen:
> 
> o	A CPU looping in an RCU read-side critical section.

For a minute? That's a bug.

> 	
> o	A CPU looping with interrupts disabled.  This condition can
> 	result in RCU-sched and RCU-bh stalls.

Also a bug.

> 
> o	A CPU looping with preemption disabled.  This condition can
> 	result in RCU-sched stalls and, if ksoftirqd is in use, RCU-bh
> 	stalls.

Bug as well.

> 
> o	A CPU looping with bottom halves disabled.  This condition can
> 	result in RCU-sched and RCU-bh stalls.

Bug too.

> 
> o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the kernel
> 	without invoking schedule().

Another bug.

> 
> o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
> 	happen to preempt a low-priority task in the middle of an RCU
> 	read-side critical section.   This is especially damaging if
> 	that low-priority task is not permitted to run on any other CPU,
> 	in which case the next RCU grace period can never complete, which
> 	will eventually cause the system to run out of memory and hang.
> 	While the system is in the process of running itself out of
> 	memory, you might see stall-warning messages.

Buggy system.

> 
> o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
> 	is running at a higher priority than the RCU softirq threads.
> 	This will prevent RCU callbacks from ever being invoked,
> 	and in a CONFIG_TREE_PREEMPT_RCU kernel will further prevent
> 	RCU grace periods from ever completing.  Either way, the
> 	system will eventually run out of memory and hang.  In the
> 	CONFIG_TREE_PREEMPT_RCU case, you might see stall-warning
> 	messages.

Not really a bug, but the developers need a spanking.

> 
> o	A hardware or software issue shuts off the scheduler-clock
> 	interrupt on a CPU that is not in dyntick-idle mode.  This
> 	problem really has happened, and seems to be most likely to
> 	result in RCU CPU stall warnings for CONFIG_NO_HZ=n kernels.

Driving the bug.

> 
> o	A bug in the RCU implementation.

Bug in the name.

> 
> o	A hardware failure.  This is quite unlikely, but has occurred
> 	at least once in real life.  A CPU failed in a running system,
> 	becoming unresponsive, but not causing an immediate crash.
> 	This resulted in a series of RCU CPU stall warnings, eventually
> 	leading the realization that the CPU had failed.

Hardware bug.

So, where's the "spurious RCU CPU stall warnings"?

All these cases deserve a warning.

-- Steve


