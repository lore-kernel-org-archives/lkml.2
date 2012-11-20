Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2KTATU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:19:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab2KTATT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:19:19 -0500
Date: Mon, 19 Nov 2012 16:19:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: Inject NMI when locked up and going to panic
Message-Id: <20121119161917.229c6d6f.akpm@linux-foundation.org>
In-Reply-To: <1353198533-24473-1-git-send-email-sasha.levin@oracle.com>
References: <1353198533-24473-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2012 19:28:53 -0500
Sasha Levin <sasha.levin@oracle.com> wrote:

> Send an NMI to all CPUs when a lockup is detected and the lockup
> watchdog code is configured to panic. This gives us a fairly uptodate
> snapshot of all CPUs in the system.
> 
> This lets us get stack trace of all CPUs which makes life easier
> trying to debug a deadlock, and the NMI doesn't change anything
> since the next step is a kernel panic.
> 

nit: I'll rename this to "watchdog: trigger all-cpu backtrace when
locked up and going to panic".  We don't know how the arch implements
trigger_all_cpu_backtrace() at this level!


> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -239,10 +239,12 @@ static void watchdog_overflow_callback(struct perf_event *event,
>  		if (__this_cpu_read(hard_watchdog_warn) == true)
>  			return;
>  
> -		if (hardlockup_panic)
> +		if (hardlockup_panic) {
> +			trigger_all_cpu_backtrace();
>  			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> -		else
> +		} else {
>  			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> +		}
>  
>  		__this_cpu_write(hard_watchdog_warn, true);
>  		return;
> @@ -323,8 +325,10 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  		else
>  			dump_stack();
>  
> -		if (softlockup_panic)
> +		if (softlockup_panic) {
> +			trigger_all_cpu_backtrace();
>  			panic("softlockup: hung tasks");
> +		}
>  		__this_cpu_write(soft_watchdog_warn, true);
>  	} else
>  		__this_cpu_write(soft_watchdog_warn, false);

The change seems sensible, but I wonder about CONFIG_SMP=n machines. 
Will they end up getting the same backtrace displayed twice?

(I don't remember whether trigger_all_cpu_backtrace() is really
trigger_all_other_cpu_backtrace() and we didn't document it).

