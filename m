Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab0EJPND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:13:03 -0400
Received: from www.tglx.de ([62.245.132.106]:54698 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0EJPNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:13:00 -0400
Date: Mon, 10 May 2010 17:12:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Iram Shahzad <iram.shahzad@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: hrtimer: about hres_active
In-Reply-To: <9D38EE7159934A5C85505E9517638040@rainbow>
Message-ID: <alpine.LFD.2.00.1005101707410.3401@localhost.localdomain>
References: <20090206060328.181057235@goodmis.org> <9D38EE7159934A5C85505E9517638040@rainbow>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iram,

On Mon, 10 May 2010, Iram Shahzad wrote:

> I am trying to understand the purpose of "hres_active" of hrtimer
> and have the following question in this regard.
> 
> It seems "hres_active" indicates whether high resolution mode is
> active or not. But I am not clear about the idea behind it.
> 
> I see that hres_active is initialized to 0 here:
>    hrtimer_init_hres
> 
> and set to 1 here:
>    hrtimer_run_pending
>       -> hrtimer_switch_to_hres
> 
> That means hrtimer becomes "active" at the 1st timer softirq
> and remains so forever. Is this understanding correct?

No. The system switches to high resolution mode late in the boot
process and it does so only when there is high res capable hardware
available.
 
> My original concern is as follows:
> 
> hrtimer_get_next_event returns KTIME_MAX when hrtimer is "active".
> So if the above understanding is correct, then after the 1st timer
> softirq it will always return KTIME_MAX. This means cpu_idle will never
> take the hrtimer event into account and will always base its decision
> on the next event of the timer wheel. Is this intended behaviour?

Yes it is. In the case of high res active the hrtimer which is the
next to expire is already armed on that CPU in the clock event
device. Therefor we know already when the next hrtimer will fire. No
need to lookup further. But we have to check the timer wheel as it
might have a timer which is due earlier than the first to expire
hrtimer.

Thanks,

	tglx
