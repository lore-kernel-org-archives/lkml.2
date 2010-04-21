Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab0DUR1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 13:27:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51204 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0DUR13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 13:27:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Om03UXn+IlicHuvc4s6oLpnWRplKHH63ModOC73mEeREPavJGS96rtRlE+S9wpn1mg
         ciyvyNBVDwAl0fb2Le0/3sXXqnF+2nY+lFryo7AZLt29CaGh7l+rqCH3UHPZ7i0UF6q9
         7acRDttgCSsqIKF7APDeIXYsB9RUlUWc5u7IM=
Date: Wed, 21 Apr 2010 19:27:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/6] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100421172730.GD5650@nowhere>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com> <1271777043-3807-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271777043-3807-2-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor things:


On Tue, Apr 20, 2010 at 11:23:58AM -0400, Don Zickus wrote:
> +#ifdef CONFIG_PERF_EVENTS_NMI
> +struct perf_event_attr wd_hw_attr = {
> +	.type		= PERF_TYPE_HARDWARE,
> +	.config		= PERF_COUNT_HW_CPU_CYCLES,
> +	.size		= sizeof(struct perf_event_attr),
> +	.pinned		= 1,
> +	.disabled	= 1,
> +};



Shouldn't it be static?


> +
> +/* Callback function for perf event subsystem */
> +void watchdog_overflow_callback(struct perf_event *event, int nmi,
> +		 struct perf_sample_data *data,
> +		 struct pt_regs *regs)
> +{
> +	int this_cpu = smp_processor_id();
> +	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
> +	char warn = per_cpu(watchdog_warn, this_cpu);



You can use __get_cpu_var() here



> +
> +	if (touch_ts == 0) {
> +		__touch_watchdog();
> +		return;
> +	}
> +
> +	/* check for a hardlockup
> +	 * This is done by making sure our timer interrupt
> +	 * is incrementing.  The timer interrupt should have
> +	 * fired multiple times before we overflow'd.  If it hasn't
> +	 * then this is a good indication the cpu is stuck
> +	 */
> +	if (is_hardlockup(this_cpu)) {
> +		/* only print hardlockups once */
> +		if (warn & HARDLOCKUP)
> +			return;
> +
> +		if (hardlockup_panic)
> +			panic("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> +		else
> +			WARN(1, "Watchdog detected hard LOCKUP on cpu %d", this_cpu);
> +
> +		per_cpu(watchdog_warn, this_cpu) = warn | HARDLOCKUP;



and here.



> +		return;
> +	}
> +
> +	per_cpu(watchdog_warn, this_cpu) = warn & ~HARDLOCKUP;
> +	return;
> +}
> +static void watchdog_interrupt_count(void)
> +{
> +	__get_cpu_var(hrtimer_interrupts)++;
> +}
> +#else
> +static void watchdog_interrupt_count(void) { return; }



Off case should be inline (although gcc will probably inline it by itself)



> +#endif /* CONFIG_PERF_EVENTS_NMI */
> +
> +/* watchdog kicker functions */
> +static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
> +{
> +	int this_cpu = smp_processor_id();
> +	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);



__get_cpu_var

