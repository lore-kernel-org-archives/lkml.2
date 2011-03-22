Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab1CVXUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:20:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59082 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1CVXUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:20:00 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=5AMJFd0FRxYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=6RyazhtGUUkll36psiwA:9 a=ipiY0Jp2-uue7Nct2K4A:7 a=E8J6MnUY4FxW5PZzOfjyHNvhd90A:4 a=PUjeQqilurYA:10 a=x8gzFH9gYPwA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Deadlock scenario in regulator core
From: Steven Rostedt <rostedt@goodmis.org>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4D892C0A.1090606@codeaurora.org>
References: <4D891C59.1030009@codeaurora.org>
	 <20110322223702.GO14675@home.goodmis.org> <4D892C0A.1090606@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Mar 2011 19:19:58 -0400
Message-ID: <1300835998.14261.13.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Peter and Ingo on Cc ]

On Tue, 2011-03-22 at 16:08 -0700, David Collins wrote:
> On 03/22/2011 03:37 PM, Steven Rostedt wrote:
> > On Tue, Mar 22, 2011 at 03:02:01PM -0700, David Collins wrote:
> >> Assume that A has already called regulator_enable for S1 some time in the
> >> past.
> >>
> >> Consumer A thread execution:
> >> 	regulator_disable(S1)
> >> 	mutex_lock(S1)
> >> 	_regulator_disable(S1)
> >> 	_notifier_call_chain(S1)
> >> 	mutex_lock(L2)
> >>
> >> Consumer B thread execution:
> >> 	regulator_enable(L2)
> >> 	mutex_lock(L2)
> >> 	_regulator_enable(L2)
> >> 	mutex_lock(S1)
> >>
> >> The locks for S1 and L2 are taken in opposite orders in the two threads;
> >> therefore, it is possible to achieve deadlock.  I am not sure about the
> >> best way to resolve this situation.  Is there a correctness requirement
> >> that regulator_enable holds the child regulator's lock when it attempts to
> >> enable the parent regulator?  Likewise, is the lock around
> >> _notifier_call_chain required?
> > 
> > I'm curious, if you had enabled lockdep, do you get a warning? If not,
> > why not?
> > 
> > Thanks,
> > 
> > -- Steve
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I have tried running with lockdep enabled.  It does not produce a warning
> about possible deadlock from locks being taken in opposite orders in two
> threads.  I assume that this is because it can only keep track of locks
> taken in the current stack backtrace.
> 
> It does produce a warning for regulator_disable by itself though on a
> regulator with a non-empty supply_list:
> 
>  =============================================
>  [ INFO: possible recursive locking detected ]
>  2.6.38-rc7+ #231
>  ---------------------------------------------
>  sh/25 is trying to acquire lock:
>   (&rdev->mutex){+.+...}, at: [<c0137ae4>] _notifier_call_chain+0x28/0x6c
> 
>  but task is already holding lock:
>   (&rdev->mutex){+.+...}, at: [<c0138410>] regulator_disable+0x24/0x74
> 
> The locks that it is noting are different; one is for the parent regulator
> and the other is for the child regulator. Any thoughts?

Looks to me that the mutex_lock() in _notifier_call_chain needs to be a
mutex_lock_nested().

The "_nested()" versions are when you have the same type of mutex taken
but belonging to two different instances. Like you have here:

	blocking_notifier_call_chain(&rdev->notifier, event, NULL);

	/* now notify regulator we supply */
	list_for_each_entry(_rdev, &rdev->supply_list, slist) {
		mutex_lock(&_rdev->mutex);
		_notifier_call_chain(_rdev, event, data);
		mutex_unlock(&_rdev->mutex);
	}

The rdev->mutex is already held, so we don't need to take it to call the
blocking_notifier_call_chain() with the rdev->notifier. But then the
list of rdev's in the rdev->supply_list are different instances but we
are still taking the same type of lock. lockdep treats all instances of
the same lock the same, so to lockdep this looks like a deadlock. To
teach lockdep that this is a different instance, simply use
mutex_lock_nested() instead.

-- Steve


