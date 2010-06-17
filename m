Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220Ab0FQO4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:56:20 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:19548 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756173Ab0FQO4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:56:19 -0400
Message-ID: <4C1A378F.7070604@athenacr.com>
Date: Thu, 17 Jun 2010 10:56:15 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, Jiri Kosina <jkosina@suse.cz>,
       Chris Wedgwood <cw@f00f.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>	 <20100610181042.GA19210@puku.stupidest.org> <4C116652.8010408@athenacr.com>	 <alpine.LRH.2.00.1006161702470.2497@twin.jikos.cz>	 <1276701411.30669.6.camel@marge.simson.net>	 <1276756770.8248.20.camel@marge.simson.net>	 <1276758038.9628.1.camel@marge.simson.net>	 <1276771844.8121.14.camel@marge.simson.net> <1276781044.27822.309.camel@twins>
In-Reply-To: <1276781044.27822.309.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 09:24 AM, Peter Zijlstra wrote:
> On Thu, 2010-06-17 at 12:50 +0200, Mike Galbraith wrote:
> 
>> sched: do not ratelimit NOHZ when the tick is stopped.
>>
>> Chris Wedgwood reports that 39c0cbe sched: Rate-limit nohz causes a serial
>> console regression, unresponsiveness, and indeed it does.  The below fixes
>> it by not skipping out when the tick has been stopped.
>>
>> Tested that the throughput benefit of ratelimiting is still intact.  It is.
>>
>> Signed-off-by: Mike Galbraith <efault@gmx.de>
>> Reported-by: Chris Wedgwood <cw@f00f.org>
> 
>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>> index 5f171f0..83c5129 100644
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -315,7 +315,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>>  		goto end;
>>  	}
>>  
>> -	if (nohz_ratelimit(cpu))
>> +	if (!ts->tick_stopped && nohz_ratelimit(cpu))
>>  		goto end;
>>  
>>  	ts->idle_calls++;
>>  
> 
> 
> Humm,. the code around there suggests something like the below, but I
> must admit its been a while since I really read all that nohz stuff,
> Thomas, any preferences?

I tested Peter's variant, it eliminates the kvm console echo latency
that I was seeing. (I haven't tried Mike's earlier variant).

Tested-by: Brian Bloniarz <bmb@athenacr.com>

> ---
>  kernel/time/tick-sched.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 5f171f0..e0707ea 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -315,9 +315,6 @@ void tick_nohz_stop_sched_tick(int inidle)
>  		goto end;
>  	}
>  
> -	if (nohz_ratelimit(cpu))
> -		goto end;
> -
>  	ts->idle_calls++;
>  	/* Read jiffies and the time when jiffies were updated last */
>  	do {
> @@ -328,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>  	} while (read_seqretry(&xtime_lock, seq));
>  
>  	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
> -	    arch_needs_cpu(cpu)) {
> +	    arch_needs_cpu(cpu) || nohz_ratelimit(cpu)) {
>  		next_jiffies = last_jiffies + 1;
>  		delta_jiffies = 1;
>  	} else {
> 

