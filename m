Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150Ab2CPAEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:04:36 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:40261 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762123Ab2CPAEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:04:31 -0400
From: Kevin Hilman <khilman@ti.com>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 3/5] cpuidle: add support for states that affect multiple cpus
Organization: Texas Instruments, Inc.
References: <1331749794-8056-1-git-send-email-ccross@android.com>
	<1331749794-8056-4-git-send-email-ccross@android.com>
Date: Thu, 15 Mar 2012 17:04:43 -0700
In-Reply-To: <1331749794-8056-4-git-send-email-ccross@android.com> (Colin
	Cross's message of "Wed, 14 Mar 2012 11:29:52 -0700")
Message-ID: <87lin18l7o.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Cross <ccross@android.com> writes:

> +/**
> + * cpuidle_coupled_cpu_set_alive - adjust alive_count during hotplug transitions
> + * @cpu: target cpu number
> + * @alive: whether the target cpu is going up or down
> + *
> + * Run on the cpu that is bringing up the target cpu, before the target cpu
> + * has been booted, or after the target cpu is completely dead.
> + */
> +static void cpuidle_coupled_cpu_set_alive(int cpu, bool alive)
> +{
> +	struct cpuidle_device *dev;
> +	struct cpuidle_coupled *coupled;
> +
> +	mutex_lock(&cpuidle_lock);
> +
> +	dev = per_cpu(cpuidle_devices, cpu);
> +	if (!dev->coupled)
> +		goto out;
> +
> +	coupled = dev->coupled;
> +
> +	/*
> +	 * waiting_count must be at least 1 less than alive_count, because
> +	 * this cpu is not waiting.  Spin until all cpus have noticed this cpu
> +	 * is not idle and exited the ready loop before changing alive_count.
> +	 */
> +	while (atomic_read(&coupled->ready_count))
> +		cpu_relax();
> +
> +	smp_mb__before_atomic_inc();
> +	atomic_inc(&coupled->alive_count);

This doesn't look quite right.  alive_count is incrmented whether the
CPU is going up or down?

Maybe I misunderstood something, but I don't see anywhere where
alive_count is decrmemented after a CPU is removed.

Kevin

> +	smp_mb__after_atomic_inc();
> +
> +	if (alive)
> +		coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_NOT_IDLE;
> +	else
> +		coupled->requested_state[dev->cpu] = CPUIDLE_COUPLED_DEAD;
> +
> +out:
> +	mutex_unlock(&cpuidle_lock);
> +}
> +
