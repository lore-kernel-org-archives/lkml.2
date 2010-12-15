Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0LOVx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:53:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab0LOVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:53:25 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=heD8I4ohhdAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=BjzRWlmGuKg7lRy-EUAA:9 a=mI6qW1v0b7LwcfN9cSkA:7 a=HKDoiJtHXNmYrel01ZrCSwTAOBcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D0877D2.10000@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>
	 <4D0877D2.10000@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Dec 2010 16:53:22 -0500
Message-ID: <1292450002.5015.1903.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 16:09 +0800, Lai Jiangshan wrote:


>  /*
> @@ -543,11 +491,13 @@ static void remove_waiter(struct rt_mutex *lock,
>  
>  	raw_spin_lock_irqsave(&current->pi_lock, flags);
>  	plist_del(&waiter->list_entry, &lock->wait_list);
> -	waiter->task = NULL;
>  	current->pi_blocked_on = NULL;
>  	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
>  
> -	if (first && owner != current) {
> +	if (!owner)
> +		return;
> +
> +	if (first) {

This is a bug. There's a small chance that the mutex timed out, and at
that same time, the owner gave up the lock and woke this task up. Which
means this task is the new owner of the lock iff it was the
rt_mutex_top_waiter().

The fix is to do this:


	if (!owner) {
		if (first) {
			ret = try_to_take_rt_mutex();
			BUG_ON(!ret);
		}
		return first;
	}

	if (first) {

We need to make remove_waiter return 1 if it took the lock and 0 if it
did not, so it can pass this information back to the caller.

	if (unlikely(ret)) {
		if (remove_waiter(...))
			ret = 0;
	}

-- Steve


