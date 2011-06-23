Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab1FWJ0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:26:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:53311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759153Ab1FWJ0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:26:13 -0400
Subject: Re: [patch 3/4] stop_machine: implement
 stop_machine_from_offline_cpu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, tj@kernel.org, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, youquan.song@intel.com
In-Reply-To: <20110622222044.038298780@sbsiddha-MOBL3.sc.intel.com>
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
	 <20110622222044.038298780@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 11:25:19 +0200
Message-ID: <1308821119.1022.84.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-22 at 15:20 -0700, Suresh Siddha wrote:
> +int stop_machine_from_offline_cpu(int (*fn)(void *), void *data,
> +                                 const struct cpumask *cpus)
> +{
> +       struct stop_machine_data smdata = { .fn = fn, .data = data,
> +                                           .active_cpus = cpus };
> +       struct cpu_stop_done done;
> +       int ret;
> +
> +       /* Local CPU must be offline and CPU hotplug in progress. */
> +       BUG_ON(cpu_online(raw_smp_processor_id()));
> +       smdata.num_threads = num_online_cpus() + 1;     /* +1 for local */
> +
> +       /* No proper task established and can't sleep - busy wait for lock. */
> +       while (!mutex_trylock(&stop_cpus_mutex))
> +               cpu_relax();
> +
> +       /* Schedule work on other CPUs and execute directly for local CPU */
> +       set_state(&smdata, STOPMACHINE_PREPARE);
> +       cpu_stop_init_done(&done, num_online_cpus());
> +       queue_stop_cpus_work(cpu_online_mask, stop_machine_cpu_stop, &smdata,
> +                            &done);
> +       ret = stop_machine_cpu_stop(&smdata);
> +
> +       /* Busy wait for completion. */
> +       while (!completion_done(&done.completion))
> +               cpu_relax();
> +
> +       mutex_unlock(&stop_cpus_mutex);
> +       return ret ?: done.ret;
> +} 

Damn thats ugly, I sure hope you're going to make those hardware folks
pay for this :-)

In commit d0af9eed5aa91b6b7b5049cae69e5ea956fd85c3 you mention that its
specific to HT, wouldn't it make sense to limit the stop-machine use in
the next patch to the sibling mask instead of the whole machine?
