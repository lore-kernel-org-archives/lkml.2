Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2FELrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:47:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:53545 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab2FELrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:47:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="153100744"
Message-ID: <4FCDF1C8.9020007@linux.intel.com>
Date: Tue, 05 Jun 2012 19:47:20 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com> <alpine.LFD.2.02.1206042158200.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206042158200.3086@ionos>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/5 4:01, Thomas Gleixner 写道:
> On Mon, 4 Jun 2012, Chen Gong wrote:
>>> +/*
>>> + * Ensure that the timer is firing in @interval from now.
>>> + */
>>> +void mce_timer_kick(unsigned long interval)
>>> +{
>>> +	struct timer_list *t = &__get_cpu_var(mce_timer);
>>> +	unsigned long when = jiffies + interval;
>>> +	unsigned long iv = __this_cpu_read(mce_next_interval);
>>> +
>>> +	if (time_before(when, t->expires) && timer_pending(t)) {
>>> +		mod_timer(t, when);
>>> +	} else if (!mce_next_interval) {
>>
>> Why using mce_next_interval, it is a per_cpu var, should be non-NULL
>> definitely, right? How about using *iv* here?
> 
> iv is the thing to use. No idea why I typoed mce_next_interval into
> that.
>  
>>> +		t->expires = round_jiffies(jiffies + iv);
>>> +		add_timer_on(t, smp_processor_id());
>>> +	}
>>> +	if (interval < iv)
>>> +		__this_cpu_write(mce_next_interval, iv);
>>>  }
>>
>> This code should be __this_cpu_write(mce_next_interval, interval);?
> 
> Duh, yes.
> 
> Thanks,
> 
> 	tglx
> 
Hi, Thomas

Besides above issues, I still have some other questions as below:

>  static void mce_timer_fn(unsigned long data)
>  {
> ...
> +	/* Might have become 0 after CMCI storm subsided */
> +	if (iv) {
> +		t->expires = jiffies + iv;
> +		add_timer_on(t, smp_processor_id());
> +	}
> +}

I've found under some conditions, *t* is pending on the timer tree, so
add_timer_on will crash the whole system. Furthermore, if this timer
function triggers "WARN_ON(smp_processor_id() != data);", this timer
will be added on the other CPU, which means it loses the chance to
decrement *cmci_storm_on_cpus* to zero to reenable the CMCI. Maybe
this situation happens seldomly, but once it happens, CMCI will never
be actived again after it is disabled.


> +void mce_timer_kick(unsigned long interval)
> +{
> +	struct timer_list *t = &__get_cpu_var(mce_timer);
> +	unsigned long when = jiffies + interval;
> +	unsigned long iv = __this_cpu_read(mce_next_interval);
> +
> +	if (time_before(when, t->expires) && timer_pending(t)) {
> +		mod_timer(t, when);
> +	} else if (!mce_next_interval) {
> +		t->expires = round_jiffies(jiffies + iv);
> +		add_timer_on(t, smp_processor_id());

I've changed "else if (!mce_next_interval)" to "else if (iv)", but
I still think it is not right. Imaging *when* is after t->expires and
this timer is pending on the timer tree, so it will hit *else if*
if iv is not zero(common situations), again, add_timer_on will trigger
BUG_ON because this timer is pending.


>  static void intel_threshold_interrupt(void)
>  {
> +	if (cmci_storm_detect())
> +		return;
>  	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
>  	mce_notify_irq();
>  }

I think cmci_storm_detect should be placed in the machine_check_poll,
not out of it. Because machine_check_poll it the core execution logic
for CMCI handling, in the meanwhile, poll timer and mce-inject module
call machine_check_poll at any time. If poll timer or mce-inject run
too quickly, the CMCI handler has trouble. Whereas, if
cmci_storm_detect is in the machine_check_poll, this kind of possibility
can be avoid.
