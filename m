Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2AOOXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 09:23:23 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45237 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753197Ab2AOOXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 09:23:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/SZC9cFxvSdDu+OSAL0XAITUpHDrLI/LDEsOmx5P
	BxiVHlYdSSt4Zh
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
From: Mike Galbraith <efault@gmx.de>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1326635168.6352.88.camel@marge.simson.net>
References: <20111108191149.GA7236@sgi.com>
	 <1326635168.6352.88.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Jan 2012 15:23:18 +0100
Message-ID: <1326637398.6352.103.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 14:46 +0100, Mike Galbraith wrote:
> On Tue, 2011-11-08 at 13:11 -0600, Dimitri Sivanich wrote:
> > Resending this.
> > 
> > 
> > Allow manual override of the tick_do_timer_cpu.
> 
> Bigger button below.


> +/* Called with cgroup_mutex held */
> +void cpuset_flags_set(int cpu, unsigned bits)
> +{
> +	struct rq *rq = cpu_rq(cpu);
> +	unsigned long flags;
> +	int nr;
> +
> +	raw_spin_lock_irqsave(&rq->lock, flags);
> +	/* Set blocker flags before taking any action */
> +	rq->cpuset_flags |= bits;
> +	for (nr = 0; bits; nr++) {
> +		if (!(bits & (1 << nr)))
> +			continue;
> +		switch (nr) {
> +		case RQ_TICK:
> +			break;
> +		case RQ_HPC:
> +			/* Ensure that jiffies doesn't go stale */
> +			if (!nr_hpc_cpus++) {
> +				tick_do_timer_cpu = 0;
> +				/* safe, CPU0 is modifier excluded */
> +				cpuset_flags_set(0, 1 << RQ_TICK);
> +				wake_up_idle_cpu(0);

Just in case someone was going to mention it, I'd already moved that
wakeup_idle_cpu() to RQ_TICK case, but the darn thing crawled back.

	-Mike

