Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2GBJL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:11:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42088 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2GBJL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:11:57 -0400
Message-ID: <1341220283.28750.138.camel@twins>
Subject: Re: [PATCH v3 3/5] ARM: topology: Update cpu_power according to DT
 information
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yong.zhang0@gmail.com, namhyung@kernel.org,
        jean.pihet@newoldbits.com
Date: Mon, 02 Jul 2012 11:11:23 +0200
In-Reply-To: <1340205562-7653-4-git-send-email-vincent.guittot@linaro.org>
References: <1340205562-7653-1-git-send-email-vincent.guittot@linaro.org>
	 <1340205562-7653-4-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 17:19 +0200, Vincent Guittot wrote:
> +#ifdef CONFIG_OF
> +struct cpu_efficiency {
> +       const char *compatible;
> +       unsigned long efficiency;
> +};
> +
> +/*
> + * Table of relative efficiency of each processors
> + * The efficiency value must fit in 20bit. The final
> + * cpu_scale value must be in the range
> + * 0 < cpu_scale < 2*SCHED_POWER_SCALE.

This wants a why.. I suspects its to do with keeping capacity on 1.

> + * Processors that are not defined in the table,
> + * use the default SCHED_POWER_SCALE value for cpu_scale.
> + */
> +struct cpu_efficiency table_efficiency[] = {
> +       {"arm,cortex-a15", 3891},
> +       {"arm,cortex-a7",  2048},
> +       {NULL, },
> +};
> +
> +struct cpu_capacity {
> +       unsigned long hwid;
> +       unsigned long capacity;
> +};
> +
> +struct cpu_capacity *cpu_capacity;
> +
> +unsigned long middle_capacity = 1;

It would be very nice to not have to learn to read device-tree nonsense
to work on the scheduler, how about something like this:?

/*
 * Iterate all cpus and set the efficiency (as per table_efficiency)
 * also calculate the middle efficiency:
 *   (max{eff_i} - min{eff_i}) / 2
 * This is later used to scale the cpu_power field such that an
 * 'average' cpu is of middle power. Also see the comments near
 * table_efficiency[] and update_cpu_power().
 */

> +static void __init parse_dt_topology(void)
> +{
> +       struct cpu_efficiency *cpu_eff;
> +       struct device_node *cn = NULL;
> +       unsigned long min_capacity = (unsigned long)(-1);
> +       unsigned long max_capacity = 0;
> +       unsigned long capacity = 0;
> +       int alloc_size, cpu = 0;
> +
> +       alloc_size = nr_cpu_ids * sizeof(struct cpu_capacity);
> +       cpu_capacity = (struct cpu_capacity *)kzalloc(alloc_size, GFP_NOWAIT);
> +
> +       while ((cn = of_find_node_by_type(cn, "cpu"))) {
> +               const u32 *rate, *reg;
> +               int len;
> +
> +               if (cpu >= num_possible_cpus())
> +                       break;
> +
> +               for (cpu_eff = table_efficiency; cpu_eff->compatible; cpu_eff++)
> +                       if (of_device_is_compatible(cn, cpu_eff->compatible))
> +                               break;
> +
> +               if (cpu_eff->compatible == NULL)
> +                       continue;
> +
> +               rate = of_get_property(cn, "clock-frequency", &len);
> +               if (!rate || len != 4) {
> +                       pr_err("%s missing clock-frequency property\n",
> +                               cn->full_name);
> +                       continue;
> +               }
> +
> +               reg = of_get_property(cn, "reg", &len);
> +               if (!reg || len != 4) {
> +                       pr_err("%s missing reg property\n", cn->full_name);
> +                       continue;
> +               }
> +
> +               capacity = ((be32_to_cpup(rate)) >> 20) * cpu_eff->efficiency;
> +
> +               /* Save min capacity of the system */
> +               if (capacity < min_capacity)
> +                       min_capacity = capacity;
> +
> +               /* Save max capacity of the system */
> +               if (capacity > max_capacity)
> +                       max_capacity = capacity;
> +
> +               cpu_capacity[cpu].capacity = capacity;
> +               cpu_capacity[cpu++].hwid = be32_to_cpup(reg);
> +       }
> +
> +       if (cpu < num_possible_cpus())
> +               cpu_capacity[cpu].hwid = (unsigned long)(-1);
> +
> +       middle_capacity = (min_capacity + max_capacity) >> 11;
> +}
> +
> +void update_cpu_power(unsigned int cpu, unsigned long hwid)
> +{
> +       unsigned int idx = 0;
> +
> +       /* look for the cpu's hwid in the cpu capacity table */

This smells like an O(n^2) loop.. ARM has only small cpu counts so this
isn't an immediate issue, would still be nice to make a note of it
though.

> +       for (idx = 0; idx < num_possible_cpus(); idx++) {
> +               if (cpu_capacity[idx].hwid == hwid)
> +                       break;
> +
> +               if (cpu_capacity[idx].hwid == -1)
> +                       return;
> +       }
> +
> +       if (idx == num_possible_cpus())
> +               return;
> +
> +       set_power_scale(cpu, cpu_capacity[idx].capacity / middle_capacity);

OK, but there's no guarantee here you'll stay within that
[1,2*SCHED_POWER_SCALE-1] range. This might want a comment and or
runtime verification so that when people extend the table_efficiency[]
wrongly we'll get notice, humm?

> +       printk(KERN_INFO "CPU%u: update cpu_power %lu\n",
> +               cpu, arch_scale_freq_power(NULL, cpu));
> +} 
