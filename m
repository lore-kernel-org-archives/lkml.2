Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2LETH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 14:07:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab2LETHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 14:07:25 -0500
Date: Wed, 5 Dec 2012 20:07:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, tj@kernel.org,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"
	atomic readers to prevent CPU offline
Message-ID: <20121205190703.GA13795@redhat.com>
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com> <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try to read this series later,

one minor and almost offtopic nit.

On 12/06, Srivatsa S. Bhat wrote:
>
>  static int __ref take_cpu_down(void *_param)
>  {
>  	struct take_cpu_down_param *param = _param;
> +	unsigned long flags;
>  	int err;
>
> +	/*
> +	 *  __cpu_disable() is the step where the CPU is removed from the
> +	 *  cpu_online_mask. Protect it with the light-lock held for write.
> +	 */
> +	write_lock_irqsave(&light_hotplug_rwlock, flags);
> +
>  	/* Ensure this CPU doesn't handle any more interrupts. */
>  	err = __cpu_disable();
> -	if (err < 0)
> +	if (err < 0) {
> +		write_unlock_irqrestore(&light_hotplug_rwlock, flags);
>  		return err;
> +	}
> +
> +	/*
> +	 * We have successfully removed the CPU from the cpu_online_mask.
> +	 * So release the light-lock, so that the light-weight atomic readers
> +	 * (who care only about the cpu_online_mask updates, and not really
> +	 * about the actual cpu-take-down operation) can continue.
> +	 *
> +	 * But don't enable interrupts yet, because we still have work left to
> +	 * do, to actually bring the CPU down.
> +	 */
> +	write_unlock(&light_hotplug_rwlock);
>
>  	cpu_notify(CPU_DYING | param->mod, param->hcpu);
> +
> +	local_irq_restore(flags);
>  	return 0;

This is subjective, but imho _irqsave and the fat comment look confusing.

Currently take_cpu_down() is always called with irqs disabled, so you
do not need to play with interrupts.

10/10 does s/__stop_machine/stop_cpus/ and that patch could simply add
local_irq_disable/enable into take_cpu_down().

But again this is minor and subjective, I won't insist.

Oleg.

