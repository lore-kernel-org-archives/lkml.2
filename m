Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab1BPIyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:54:17 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60063 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1BPIyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:54:14 -0500
Date: Wed, 16 Feb 2011 14:23:03 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@gmail.com>,
        Tim Chen <tim.c.chen@intel.com>, Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH] sched: Wholesale removal of sd_idle logic
Message-ID: <20110216085303.GH11868@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
 <1297723130-693-1-git-send-email-venki@google.com>
 <20110215170127.GA28865@dirshya.in.ibm.com>
 <AANLkTi=ENtUtgHYaCJqvDGYVFKyXYFcVVOOFf8-dfW=+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=ENtUtgHYaCJqvDGYVFKyXYFcVVOOFf8-dfW=+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Venkatesh Pallipadi <venki@google.com> [2011-02-15 10:26:01]:

<snip>

> >> @@ -3386,10 +3363,6 @@ redo:
> >>                       sd->balance_interval *= 2;
> >>       }
> >>
> >> -     if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
> >> -         !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
> >> -             ld_moved = -1;
> >
> > I have not figured out where ld_moved is checked for -1 and why we
> > need to treat this as a special case.
> >
> 
> Return value of -1 was being consumed in rebalance domains() call
> to load_balance(). Returning -1 (instead of 0 in this case) makes
> rebalance_domains() to call higher domain load balancing
> with CPU_NOT_IDLE, when sibling is busy and even when there
> was no load pulled in.

Ok, so in rebalance_domain() we need not distinguish between 1 or -1
return code.  We can set idle = CPU_NOT_IDLE as long as we pull
a task.  With removal of sd_idle logic, the value of idle will remain
same for all domains.

Now in idle_balance() you have to check for return code > 0 in order
to reset this_rq->idle_stamp = 0.  But in the next check:

	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
		/*
		 * We are going idle. next_balance may be set based on
		 * a busy processor. So reset next_balance.
		 */
		this_rq->next_balance = next_balance;
	}

Earlier, we would push the next_balance interval for busy sibling case
since pulled_task will be set to -1.  But now, with the removal of
sd_idle logic, the this_rq->next_balance will not be touched leading
to sooner rebalance.

In summary, the load_balance() will return 0 or 1, and the special
case of -1 is completely removed in the new code.  Thanks for the
clarification.

--Vaidy

