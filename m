Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1HJIm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:42:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43366 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1HJImx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:42:53 -0400
Date: Wed, 10 Aug 2011 11:42:48 +0300
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 1/2] cpumask: introduce cpumask for hotpluggable CPUs
Message-ID: <20110810084248.GB7673@matterhorn1>
Mail-Followup-To: Mike Turquette <mturquette@ti.com>,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
	linaro-dev@lists.linaro.org, patches@linaro.org
References: <1312940007-26069-1-git-send-email-mturquette@ti.com>
 <1312940007-26069-2-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1312940007-26069-2-git-send-email-mturquette@ti.com>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Aug 09, Mike Turquette wrote:
> On some platforms it is possible to have some CPUs which support CPU
> hotplug and some which do not.  Currently the prescence of an 'online'
> sysfs entry in userspace is adequate for applications to know that a CPU
> supports hotplug, but there is no convenient way to make the same
> determination in the kernel.
> 
> To better model this relationship this patch introduces a new cpumask to
> track CPUs that support CPU hotplug operations.
> 
> This new cpumask is populated at boot-time and remains static for the
> life of the machine.  Bits set in the mask indicate a CPU which supports
> hotplug, but make no guarantees about whether that CPU is currently
> online or not.  Likewise a cleared bit in the mask indicates either a
> CPU which cannot hotplug or a lack of a populated CPU.
> 
> The purpose of this new cpumask is to aid kernel code which uses CPU to
> take CPUs online and offline.  Possible uses are as a thermal event
> mitigation technique or as a power capping mechanism.
> 
> Signed-off-by: Mike Turquette <mturquette@ti.com>
> ---
>  include/linux/cpumask.h |   27 ++++++++++++++++++++++-----
>  kernel/cpu.c            |   18 ++++++++++++++++++
>  2 files changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index b24ac56..9eed444 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -39,10 +39,11 @@ extern int nr_cpu_ids;
>   * The following particular system cpumasks and operations manage
>   * possible, present, active and online cpus.
>   *
> - *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
> - *     cpu_present_mask - has bit 'cpu' set iff cpu is populated
> - *     cpu_online_mask  - has bit 'cpu' set iff cpu available to scheduler
> - *     cpu_active_mask  - has bit 'cpu' set iff cpu available to migration
> + *     cpu_possible_mask     - has bit 'cpu' set iff cpu is populatable
> + *     cpu_hotpluggable_mask - has bit 'cpu' set iff cpu is hotpluggable
> + *     cpu_present_mask      - has bit 'cpu' set iff cpu is populated
> + *     cpu_online_mask       - has bit 'cpu' set iff cpu available to scheduler
> + *     cpu_active_mask       - has bit 'cpu' set iff cpu available to migration
>   *
>   *  If !CONFIG_HOTPLUG_CPU, present == possible, and active == online.
>   *
> @@ -51,7 +52,11 @@ extern int nr_cpu_ids;
>   *  life of that system boot.  The cpu_present_mask is dynamic(*),
>   *  representing which CPUs are currently plugged in.  And
>   *  cpu_online_mask is the dynamic subset of cpu_present_mask,
> - *  indicating those CPUs available for scheduling.
> + *  indicating those CPUs available for scheduling.  The
> + *  cpu_hotpluggable_mask is also fixed at boot time, as the set of CPU
> + *  id's which are possible AND can hotplug.  Cleared bits in this mask
> + *  mean that either the CPU is not possible, or it is possible but does
> + *  not support CPU hotplug operations.
>   *
>   *  If HOTPLUG is enabled, then cpu_possible_mask is forced to have
>   *  all NR_CPUS bits set, otherwise it is just the set of CPUs that
> @@ -61,6 +66,9 @@ extern int nr_cpu_ids;
>   *  depending on what ACPI reports as currently plugged in, otherwise
>   *  cpu_present_mask is just a copy of cpu_possible_mask.
>   *
> + *  If CONFIG_HOTPLUG_CPU is enabled, then cpu_hotpluggable_mask matches
> + *  the description above, otherwise it is the empty set.
> + *
>   *  (*) Well, cpu_present_mask is dynamic in the hotplug case.  If not
>   *      hotplug, it's a copy of cpu_possible_mask, hence fixed at boot.
>   *
> @@ -76,6 +84,7 @@ extern int nr_cpu_ids;
>   */
>  
>  extern const struct cpumask *const cpu_possible_mask;
> +extern const struct cpumask *const cpu_hotpluggable_mask;
>  extern const struct cpumask *const cpu_online_mask;
>  extern const struct cpumask *const cpu_present_mask;
>  extern const struct cpumask *const cpu_active_mask;
> @@ -85,19 +94,23 @@ extern const struct cpumask *const cpu_active_mask;
>  #define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
>  #define num_present_cpus()	cpumask_weight(cpu_present_mask)
>  #define num_active_cpus()	cpumask_weight(cpu_active_mask)
> +#define num_hotpluggable_cpus()	cpumask_weight(cpu_hotpluggable_mask)
>  #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
>  #define cpu_possible(cpu)	cpumask_test_cpu((cpu), cpu_possible_mask)
>  #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
>  #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
> +#define cpu_hotpluggable(cpu)	cpumask_test_cpu((cpu, cpu_hotpluggable_mask)

                                 missing closing bracket? ^^^^ 							   

>  #else
>  #define num_online_cpus()	1U
>  #define num_possible_cpus()	1U
>  #define num_present_cpus()	1U
>  #define num_active_cpus()	1U
> +#define num_hotpluggable_cpus()	0
>  #define cpu_online(cpu)		((cpu) == 0)
>  #define cpu_possible(cpu)	((cpu) == 0)
>  #define cpu_present(cpu)	((cpu) == 0)
>  #define cpu_active(cpu)		((cpu) == 0)
> +#define cpu_hotpluggable(cpu)	0
>  #endif
>  
>  /* verify cpu argument to cpumask_* operators */
> @@ -678,16 +691,20 @@ extern const DECLARE_BITMAP(cpu_all_bits, NR_CPUS);
>  #define cpu_none_mask to_cpumask(cpu_bit_bitmap[0])
>  
>  #define for_each_possible_cpu(cpu) for_each_cpu((cpu), cpu_possible_mask)
> +#define for_each_hotpluggable_cpu(cpu) \
> +				   for_each_cpu((cpu), cpu_hotpluggable_mask)
>  #define for_each_online_cpu(cpu)   for_each_cpu((cpu), cpu_online_mask)
>  #define for_each_present_cpu(cpu)  for_each_cpu((cpu), cpu_present_mask)
>  
>  /* Wrappers for arch boot code to manipulate normally-constant masks */
>  void set_cpu_possible(unsigned int cpu, bool possible);
> +void set_cpu_hotpluggable(unsigned int cpu, bool hotpluggable);
>  void set_cpu_present(unsigned int cpu, bool present);
>  void set_cpu_online(unsigned int cpu, bool online);
>  void set_cpu_active(unsigned int cpu, bool active);
>  void init_cpu_present(const struct cpumask *src);
>  void init_cpu_possible(const struct cpumask *src);
> +void init_cpu_hotpluggable(const struct cpumask *src);
>  void init_cpu_online(const struct cpumask *src);
>  
>  /**
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 12b7458..8c397c9 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -536,6 +536,11 @@ static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
>  const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
>  EXPORT_SYMBOL(cpu_possible_mask);
>  
> +static DECLARE_BITMAP(cpu_hotpluggable_bits, CONFIG_NR_CPUS) __read_mostly;
> +const struct cpumask *const cpu_hotpluggable_mask =
> +					to_cpumask(cpu_hotpluggable_bits);
> +EXPORT_SYMBOL(cpu_hotpluggable_mask);
> +
>  static DECLARE_BITMAP(cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
>  const struct cpumask *const cpu_online_mask = to_cpumask(cpu_online_bits);
>  EXPORT_SYMBOL(cpu_online_mask);
> @@ -556,6 +561,14 @@ void set_cpu_possible(unsigned int cpu, bool possible)
>  		cpumask_clear_cpu(cpu, to_cpumask(cpu_possible_bits));
>  }
>  
> +void set_cpu_hotpluggable(unsigned int cpu, bool hotpluggable)
> +{
> +	if (hotpluggable)
> +		cpumask_set_cpu(cpu, to_cpumask(cpu_hotpluggable_bits));
> +	else
> +		cpumask_clear_cpu(cpu, to_cpumask(cpu_hotpluggable_bits));
> +}
> +
>  void set_cpu_present(unsigned int cpu, bool present)
>  {
>  	if (present)
> @@ -590,6 +603,11 @@ void init_cpu_possible(const struct cpumask *src)
>  	cpumask_copy(to_cpumask(cpu_possible_bits), src);
>  }
>  
> +void init_cpu_hotpluggable(const struct cpumask *src)
> +{
> +	cpumask_copy(to_cpumask(cpu_hotpluggable_bits), src);
> +}
> +
>  void init_cpu_online(const struct cpumask *src)
>  {
>  	cpumask_copy(to_cpumask(cpu_online_bits), src);
> -- 
> 1.7.4.1
> 
> 
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
