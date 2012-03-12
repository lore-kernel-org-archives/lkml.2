Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2CLORu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:17:50 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:41005 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2CLORs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:17:48 -0400
Date: Mon, 12 Mar 2012 10:17:39 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix idle ticks in cpu summary line of /proc/stat
Message-ID: <20120312101739.26eb373e@de.ibm.com>
In-Reply-To: <20120312121726.GA23608@tiehlicka.suse.cz>
References: <20120311182621.41674b39@de.ibm.com>
	<20120312121726.GA23608@tiehlicka.suse.cz>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12031214-0342-0000-0000-00000123D7EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012 13:17:26 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> Goot catch. But I think that the following fix should be better because
> it doesn't change the semantic of the function. What do you think?
..
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 7656642..dec767f 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -221,7 +221,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
>  		update_ts_time_stats(cpu, ts, now, last_update_time);
>  		idle = ts->idle_sleeptime;
>  	} else {
> -		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
> +		if (cpu_online(cpu) && ts->idle_active && !nr_iowait_cpu(cpu)) {
>  			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> 
>  			idle = ktime_add(ts->idle_sleeptime, delta);
> @@ -262,7 +262,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
>  		update_ts_time_stats(cpu, ts, now, last_update_time);
>  		iowait = ts->iowait_sleeptime;
>  	} else {
> -		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
> +		if (cpu_online(cpu) && ts->idle_active && nr_iowait_cpu(cpu) > 0) {
>  			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> 
>  			iowait = ktime_add(ts->iowait_sleeptime, delta);

I would prefer an early exit from the functions. The target cpu is offline,
who guarantees that the "struct tick_sched" for the cpu contains anything
useful?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


