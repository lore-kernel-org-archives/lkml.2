Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1IQMZr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 08:25:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56420 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1IQMZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 08:25:46 -0400
Message-ID: <4E749341.9040101@colorfullife.com>
Date: Sat, 17 Sep 2011 14:32:01 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Subject: Re: [RFC][PATCH 3/3] ipc/sem: Rework wakeup scheme
References: <20110914133034.687048806@chello.nl> <20110914133750.916911903@chello.nl> <4E7235F6.1030303@colorfullife.com> <1316175497.10174.16.camel@twins>
In-Reply-To: <1316175497.10174.16.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 02:18 PM, Peter Zijlstra wrote:
> On Thu, 2011-09-15 at 19:29 +0200, Manfred Spraul wrote:
>> What is broken?
> So basically sembench was broken and the futex patch is causing spurious
> wakeups.
>
> I've got the below patch to fix up the sem code.
>
> One more question, do the sem wakeups need to be issued in FIFO order?
> There's a comment in there:
>
>   * User space visible behavior:
>   * - FIFO ordering for semop() operations (just FIFO, not starvation
>   *   protection)
>
> that seems to suggest the sem ops processing is in FIFO order, but does
> the user visible effect propagate to the wakeup order?
I'd ask the question the other way arould:
Is the wakeup order user visible?
IMHO: No, the scheduler might reorder the tasks anyway.

>
>   	/*
>   	 * If an interrupt occurred we have to clean up the queue
>   	 */
>   	if (timeout&&  jiffies_left == 0)
>   		error = -EAGAIN;
> +
> +	if (error == -EINTR&&  !signal_pending(current))
> +		goto retry;
> +
>   	unlink_queue(sma,&queue);
>
>   out_unlock_free:
Good solution.
-ERESTARTNOHAND would be even better, but this is definitively better 
than the current code.

--
     Manfred
