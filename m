Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1HDTFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 15:05:20 -0400
Received: from smtp4.Stanford.EDU ([171.67.219.84]:58054 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754540Ab1HDTFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 15:05:15 -0400
Message-ID: <4E3AED68.5060506@ccrma.stanford.edu>
Date: Thu, 04 Aug 2011 12:05:12 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Subject: Re: [ANNOUNCE] 3.0-rt6
References: <alpine.LFD.2.02.1107282213000.31246@ionos>	 <4E3A3D7C.6050403@localhost> <1312450965.16729.7.camel@twins>
In-Reply-To: <1312450965.16729.7.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was going to try this but it appears it is in rt7, trying to build rt7 
fails with:

ERROR: "of_find_property" [drivers/tty/serial/of_serial.ko] undefined!
ERROR: "of_find_property" [drivers/hwmon/ltc4245.ko] undefined!

-- Fernando

On 08/04/2011 02:42 AM, Peter Zijlstra wrote:
> On Wed, 2011-08-03 at 23:34 -0700, Fernando Lopez-Lezcano wrote:
>> [  117.026009]  [<ffffffff814ef322>] _raw_spin_lock+0x45/0x79
>> [  117.026009]  [<ffffffff8107b6f1>] ? __run_posix_cpu_timers+0x8f/0x353
>> [  117.026009]  [<ffffffff8107b6f1>] __run_posix_cpu_timers+0x8f/0x353
>
> I think its this one, could you confirm?
>
> ---
> Index: linux-2.6/kernel/posix-cpu-timers.c
> ===================================================================
> --- linux-2.6.orig/kernel/posix-cpu-timers.c
> +++ linux-2.6/kernel/posix-cpu-timers.c
> @@ -1288,10 +1288,11 @@ static inline int fastpath_timer_check(s
>   	sig = tsk->signal;
>   	if (sig->cputimer.running) {
>   		struct task_cputime group_sample;
> +		unsigned long flags;
>
> -		raw_spin_lock(&sig->cputimer.lock);
> +		raw_spin_lock_irqsave(&sig->cputimer.lock, flags);
>   		group_sample = sig->cputimer.cputime;
> -		raw_spin_unlock(&sig->cputimer.lock);
> +		raw_spin_unlock_irqrestore(&sig->cputimer.lock, flags);
>
>   		if (task_cputime_expired(&group_sample,&sig->cputime_expires))
>   			return 1;
>
