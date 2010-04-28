Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0D1Mg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 08:36:58 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34961 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0D1Mg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 08:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ORkG/+HfYw+vafRkpG5YKl5hj4Bb57ydoH8RmPaCQDW+MA+A4ZTMoVwFX8WaGdUXWx
         unkmWOzZpbruDZsjnIrPLiREtIoULaqM9LQ+7YF5dKukvZqc0WPPc1UkAXT2AUPMyCCM
         acxyP2X440t2HMfVlLiunBP+8YZ8A27ObHQxQ=
Date: Wed, 28 Apr 2010 14:36:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/8] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100428123645.GA12017@nowhere>
References: <1272039216-8890-1-git-send-email-dzickus@redhat.com> <1272039216-8890-2-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272039216-8890-2-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 12:13:29PM -0400, Don Zickus wrote:
> +void watchdog_overflow_callback(struct perf_event *event, int nmi,
> +		 struct perf_sample_data *data,
> +		 struct pt_regs *regs)
> +{
> +	int this_cpu = smp_processor_id();
> +	unsigned long touch_ts = per_cpu(watchdog_touch_ts, this_cpu);
> +	char warn = __get_cpu_var(watchdog_warn);
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
> +		__get_cpu_var(watchdog_warn) = warn | HARDLOCKUP;
> +		return;
> +	}
> +
> +	__get_cpu_var(watchdog_warn) = warn & ~HARDLOCKUP;
> +	return;
> +}
[...]
> +static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
> +{
> +	int this_cpu = smp_processor_id();
> +	unsigned long touch_ts = __get_cpu_var(watchdog_touch_ts);
> +	char warn = __get_cpu_var(watchdog_warn);
> +	struct pt_regs *regs = get_irq_regs();
> +	int duration;
> +
> +	/* kick the hardlockup detector */
> +	watchdog_interrupt_count();
> +
> +	/* kick the softlockup detector */
> +	wake_up_process(__get_cpu_var(softlockup_watchdog));
> +
> +	/* .. and repeat */
> +	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
> +
> +	if (touch_ts == 0) {
> +		__touch_watchdog();
> +		return HRTIMER_RESTART;
> +	}
> +
> +	/* check for a softlockup
> +	 * This is done by making sure a high priority task is
> +	 * being scheduled.  The task touches the watchdog to
> +	 * indicate it is getting cpu time.  If it hasn't then
> +	 * this is a good indication some task is hogging the cpu
> +	 */
> +	duration = is_softlockup(touch_ts, this_cpu);
> +	if (unlikely(duration)) {
> +		/* only warn once */
> +		if (warn & SOFTLOCKUP)
> +			return HRTIMER_RESTART;
> +
> +		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
> +			this_cpu, duration,
> +			current->comm, task_pid_nr(current));
> +		print_modules();
> +		print_irqtrace_events(current);
> +		if (regs)
> +			show_regs(regs);
> +		else
> +			dump_stack();
> +
> +		if (softlockup_panic)
> +			panic("softlockup: hung tasks");
> +		__get_cpu_var(watchdog_warn) = warn | SOFTLOCKUP;
> +	} else
> +		__get_cpu_var(watchdog_warn) = warn & ~SOFTLOCKUP;


Note these watchdog_warn modifications are racy against the same that
happens with HARDLOCKUP. You might clear what did the nmi.

The race is harmless enough that we don't care much I think, but that's
why it would have make sense to separate watchdog_warn tracking space
between both.


