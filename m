Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab0LOMHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 07:07:54 -0500
Received: from www.tglx.de ([62.245.132.106]:48902 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab0LOMHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 07:07:53 -0500
Date: Wed, 15 Dec 2010 13:07:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
In-Reply-To: <4D0877D2.10000@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1012151029090.12146@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com>  <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>  <4D083900.1050801@cn.fujitsu.com> <1292386606.5015.1862.camel@gandalf.stny.rr.com> <4D0877D2.10000@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Lai Jiangshan wrote:
> +	if (waiter || rt_mutex_has_waiters(lock)) {
> +		unsigned long flags;
> +		struct rt_mutex_waiter *top;
> +
> +		raw_spin_lock_irqsave(&task->pi_lock, flags);
> +
> +		/* remove the queued waiter. */
> +		if (waiter) {
> +			plist_del(&waiter->list_entry, &lock->wait_list);
> +			task->pi_blocked_on = NULL;
> +		}
> +
> +		/*
> +		 * We have to enqueue the top waiter(if have) into
> +		 * task->pi_waiters list and would get boost from it.

No, we don't get boosted from it. We just have to enqueue it into
pi_waiters list. There is no boosting happening at this point. Please
be very careful with the comments in this code.

Otherwise this looks really interesting. Still this wants to be ported
to -rt and stress tested there.

Thanks,

	tglx
