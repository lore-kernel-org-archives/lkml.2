Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab0FOOW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:22:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:53633 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812Ab0FOOWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:22:25 -0400
Date: Tue, 15 Jun 2010 07:24:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avoid using smp_processor_id() in preemptible code
 (nr_iowait_cpu)
Message-ID: <20100615072435.5a47d850@infradead.org>
In-Reply-To: <20100615061927.GA3312@swordfish>
References: <20100613203352.GA3577@swordfish>
	<1276461183.2659.4.camel@maxim-laptop>
	<201006140136.18652.rjw@sisk.pl>
	<20100614140941.GA3581@swordfish.minsk.epam.com>
	<20100614073853.6fa2f91f@infradead.org>
	<20100614145439.GA3448@swordfish.minsk.epam.com>
	<20100614080154.7d6a71fc@infradead.org>
	<20100614151735.GB3448@swordfish.minsk.epam.com>
	<20100614204021.52c50cdc@infradead.org>
	<20100615061927.GA3312@swordfish>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010 09:19:27 +0300
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 1d7b9bc..101e8aa 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -159,10 +159,12 @@ update_ts_time_stats(struct tick_sched *ts,
> ktime_t now, u64 *last_update_time) ktime_t delta;
>  
>  	if (ts->idle_active) {
> +		int cpu = get_cpu();
>  		delta = ktime_sub(now, ts->idle_entrytime);
>  		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime,
> delta);
> -		if (nr_iowait_cpu() > 0)
> +		if (nr_iowait_cpu(cpu) > 0)
>  			ts->iowait_sleeptime =
> ktime_add(ts->iowait_sleeptime, delta);
> +		put_cpu();
>  		ts->idle_entrytime = now;
>  	}


hmm this part is wrong
you pick the current cpu, rather than the one denoted by ts.....

they will normally be the same, except for the case where you get your
warning...
(and this is also why you can't move the get_cpu() inside
nr_iowait_cpu() ... )

>  


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
