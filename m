Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab0GMTAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 15:00:15 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:34624 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0GMTAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 15:00:13 -0400
Message-ID: <4C3CB7A5.7010406@us.ibm.com>
Date: Tue, 13 Jul 2010 11:59:49 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH][RT] futex: protect against pi_blocked_on corruption during
 requeue PI -V2
References: <1278478019.10245.77.camel@marge.simson.net> <alpine.LFD.2.00.1007071356480.2604@localhost.localdomain> <4C3C1DCF.9090509@us.ibm.com> <alpine.LFD.2.00.1007131041230.3321@localhost.localdomain> <alpine.LFD.2.00.1007131222430.3321@localhost.localdomain> <alpine.LFD.2.00.1007131348180.3321@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1007131348180.3321@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 04:52 AM, Thomas Gleixner wrote:
> On Tue, 13 Jul 2010, Thomas Gleixner wrote:
>>
>> This code causes braindamage. I really wonder whether we need to
>> remove it according to the "United Nations Convention against Torture
>> and Other Cruel, Inhuman or Degrading Treatment or Punishment".
>>
>
> Ok, finally managed to twist my brain around it. Mike, can you give it
> a test ride ?

Since Mike is out I built this version and ran it a few times. I saw a 
100% reproduction rate previously. I haven't seen any errors in a 
handful of runs (~10) with this patch.

I do still see the hrtimer latency message on the first run, so this is 
likely unrelated to the issue we're addressing:

Jul 13 14:47:59 elm9m94 kernel: hrtimer: interrupt took 123924 ns

As for Thomas's changes, only a couple nitpics below:


> @@ -2255,18 +2265,51 @@ static int futex_wait_requeue_pi(u32 __u
>   	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
>   	futex_wait_queue_me(hb,&q, to);
>
> -	spin_lock(&hb->lock);
> -	ret = handle_early_requeue_pi_wakeup(hb,&q,&key2, to);
> -	spin_unlock(&hb->lock);
> -	if (ret)
> -		goto out_put_keys;
> +	/*
> +	 * Avoid races with requeue and trying to block on two mutexes
> +	 * (hb->lock and uaddr2's rtmutex) by serializing access to
> +	 * pi_blocked_on with pi_lock.
> +	 */
> +	raw_spin_lock_irq(&current->pi_lock);
> +	if (current->pi_blocked_on) {
> +		/* Requeue happened already */

This comment isn't quite accurate. The requeue may be in progress, which 
means the q.lock_ptr is not trustworthy as noted below. Consider:

		/*
		 * We have been requeued, or are in the process
		 * of being requeued.
		 */

> +		raw_spin_unlock_irq(&current->pi_lock);
> +	} else {
> +		/*
> +		 * Setting pi_blocked_on to PI_WAKEUP_INPROGRESS
> +		 * prevents a concurrent requeue from enqueuein us on

s/enqueuein/enqueueing/  not that my dictionary thinks either one of 
them are words ;-)

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
