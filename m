Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab0IHNV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:21:58 -0400
Received: from www.tglx.de ([62.245.132.106]:43589 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab0IHNVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:21:55 -0400
Date: Wed, 8 Sep 2010 15:21:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Jan Blunck <jblunck@suse.de>,
        Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Sven-Thorsten Dietrich <sdietrich@novell.com>,
        Michael Galbraith <MGalbraith@novell.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC 3/4] Disable scheduler tick when we are running SCHED_FIFO
 tasks
In-Reply-To: <1283949943.23762.16.camel@laptop>
Message-ID: <alpine.LFD.2.00.1009081515350.2477@localhost6.localdomain6>
References: <1283948964-6418-1-git-send-email-jblunck@suse.de>  <1283948964-6418-4-git-send-email-jblunck@suse.de> <1283949943.23762.16.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010, Peter Zijlstra wrote:

> On Wed, 2010-09-08 at 14:29 +0200, Jan Blunck wrote:
> > This patch is disabling the scheduler tick to go off when there is a task
> > with SCHED_FIFO policy running. Since these tasks are not timesliced anyway
> > we only care about timers, softirqs and such stuff just like when we disable
> > the tick during idle periods.
> > 
> 
> Also, doesn't this break any and all jiffies users?

Only on UP. On SMP we hand off the do_timer duty to some other core.
 
> And you need to restart the tick on call_rcu() and everything else that
> requires the tick for processing.

Not only this. If the task enqueues a timer_list timer via a syscall
or an interrupt/softirq enqueues a timer_list timer while the tick is
off then this timer will not fire until the task goes back into
schedule.

That approach is way too naive. There is a boatload of subtle wreckage
waiting and it needs careful analysis of this to work. Frederic is
looking into this already.

Thanks,

	tglx
