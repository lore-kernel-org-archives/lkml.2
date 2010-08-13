Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0HMVXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:23:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:54370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0HMVX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:23:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,365,1278313200"; 
   d="scan'208";a="827888339"
Subject: Re: [PATCH/RFC 3/5] [PATCH] sched: add book scheduling domain
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20100812172623.140578409@de.ibm.com>
References: <20100812172544.655648128@de.ibm.com>
	 <20100812172623.140578409@de.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 13 Aug 2010 14:22:52 -0700
Message-Id: <1281734572.2704.39.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 10:25 -0700, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> On top of the SMT and MC scheduling domains this adds the BOOK scheduling
> domain. This is useful for machines that have a four level cache hierarchy
> and but do not fall into the NUMA category.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

PeterZ had some ideas in cleaning up the sched domain setup to avoid
this maze of #ifdef's. I will let him comment on this.

thanks,
suresh
> ---
> 
>  arch/s390/defconfig      |    1
>  include/linux/sched.h    |   19 +++++++
>  include/linux/topology.h |    6 ++
>  kernel/sched.c           |  112 ++++++++++++++++++++++++++++++++++++++++++++---
>  kernel/sched_fair.c      |   11 ++--
>  5 files changed, 137 insertions(+), 12 deletions(-)
> 
> diff -urpN linux-2.6/arch/s390/defconfig linux-2.6-patched/arch/s390/defconfig
> --- linux-2.6/arch/s390/defconfig       2010-08-02 00:11:14.000000000 +0200
> +++ linux-2.6-patched/arch/s390/defconfig       2010-08-11 13:47:23.000000000 +0200
> @@ -248,6 +248,7 @@ CONFIG_64BIT=y
>  CONFIG_SMP=y
>  CONFIG_NR_CPUS=32
>  CONFIG_HOTPLUG_CPU=y
> +# CONFIG_SCHED_BOOK is not set
>  CONFIG_COMPAT=y
>  CONFIG_SYSVIPC_COMPAT=y
>  CONFIG_AUDIT_ARCH=y
> diff -urpN linux-2.6/include/linux/sched.h linux-2.6-patched/include/linux/sched.h
> --- linux-2.6/include/linux/sched.h     2010-08-11 13:47:16.000000000 +0200
> +++ linux-2.6-patched/include/linux/sched.h     2010-08-11 13:47:23.000000000 +0200
> @@ -807,7 +807,9 @@ enum powersavings_balance_level {
>         MAX_POWERSAVINGS_BALANCE_LEVELS
>  };
> 
> -extern int sched_mc_power_savings, sched_smt_power_savings;
> +extern int sched_smt_power_savings;
> +extern int sched_mc_power_savings;
> +extern int sched_book_power_savings;
> 
>  static inline int sd_balance_for_mc_power(void)
>  {
> @@ -820,11 +822,23 @@ static inline int sd_balance_for_mc_powe
>         return 0;
>  }
> 
> -static inline int sd_balance_for_package_power(void)
> +static inline int sd_balance_for_book_power(void)
>  {
>         if (sched_mc_power_savings | sched_smt_power_savings)
>                 return SD_POWERSAVINGS_BALANCE;
> 
> +       if (!sched_book_power_savings)
> +               return SD_PREFER_SIBLING;
> +
> +       return 0;
> +}
> +
> +static inline int sd_balance_for_package_power(void)
> +{
> +       if (sched_book_power_savings | sched_mc_power_savings |
> +           sched_smt_power_savings)
> +               return SD_POWERSAVINGS_BALANCE;
> +
>         return SD_PREFER_SIBLING;
>  }
> 
> @@ -875,6 +889,7 @@ enum sched_domain_level {
>         SD_LV_NONE = 0,
>         SD_LV_SIBLING,
>         SD_LV_MC,
> +       SD_LV_BOOK,
>         SD_LV_CPU,
>         SD_LV_NODE,
>         SD_LV_ALLNODES,
> diff -urpN linux-2.6/include/linux/topology.h linux-2.6-patched/include/linux/topology.h
> --- linux-2.6/include/linux/topology.h  2010-08-11 13:47:16.000000000 +0200
> +++ linux-2.6-patched/include/linux/topology.h  2010-08-11 13:47:23.000000000 +0200
> @@ -201,6 +201,12 @@ int arch_update_cpu_topology(void);
>         .balance_interval       = 64,                                   \
>  }
> 
> +#ifdef CONFIG_SCHED_BOOK
> +#ifndef SD_BOOK_INIT
> +#error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
> +#endif
> +#endif /* CONFIG_SCHED_BOOK */
> +
>  #ifdef CONFIG_NUMA
>  #ifndef SD_NODE_INIT
>  #error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
> diff -urpN linux-2.6/kernel/sched.c linux-2.6-patched/kernel/sched.c
> --- linux-2.6/kernel/sched.c    2010-08-11 13:47:23.000000000 +0200
> +++ linux-2.6-patched/kernel/sched.c    2010-08-11 13:47:23.000000000 +0200
> @@ -6472,7 +6472,9 @@ static void sched_domain_node_span(int n
>  }
>  #endif /* CONFIG_NUMA */
> 
> -int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
> +int sched_smt_power_savings;
> +int sched_mc_power_savings;
> +int sched_book_power_savings;
> 
>  /*
>   * The cpus mask in sched_group and sched_domain hangs off the end.
> @@ -6500,6 +6502,7 @@ struct s_data {
>         cpumask_var_t           nodemask;
>         cpumask_var_t           this_sibling_map;
>         cpumask_var_t           this_core_map;
> +       cpumask_var_t           this_book_map;
>         cpumask_var_t           send_covered;
>         cpumask_var_t           tmpmask;
>         struct sched_group      **sched_group_nodes;
> @@ -6511,6 +6514,7 @@ enum s_alloc {
>         sa_rootdomain,
>         sa_tmpmask,
>         sa_send_covered,
> +       sa_this_book_map,
>         sa_this_core_map,
>         sa_this_sibling_map,
>         sa_nodemask,
> @@ -6564,6 +6568,31 @@ cpu_to_core_group(int cpu, const struct
>  }
>  #endif /* CONFIG_SCHED_MC */
> 
> +/*
> + * book sched-domains:
> + */
> +#ifdef CONFIG_SCHED_BOOK
> +static DEFINE_PER_CPU(struct static_sched_domain, book_domains);
> +static DEFINE_PER_CPU(struct static_sched_group, sched_group_book);
> +
> +static int
> +cpu_to_book_group(int cpu, const struct cpumask *cpu_map,
> +                 struct sched_group **sg, struct cpumask *mask)
> +{
> +       int group = cpu;
> +#ifdef CONFIG_SCHED_MC
> +       cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
> +       group = cpumask_first(mask);
> +#elif defined(CONFIG_SCHED_SMT)
> +       cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
> +       group = cpumask_first(mask);
> +#endif
> +       if (sg)
> +               *sg = &per_cpu(sched_group_book, group).sg;
> +       return group;
> +}
> +#endif /* CONFIG_SCHED_BOOK */
> +
>  static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
>  static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
> 
> @@ -6572,7 +6601,10 @@ cpu_to_phys_group(int cpu, const struct
>                   struct sched_group **sg, struct cpumask *mask)
>  {
>         int group;
> -#ifdef CONFIG_SCHED_MC
> +#ifdef CONFIG_SCHED_BOOK
> +       cpumask_and(mask, cpu_book_mask(cpu), cpu_map);
> +       group = cpumask_first(mask);
> +#elif defined(CONFIG_SCHED_MC)
>         cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
>         group = cpumask_first(mask);
>  #elif defined(CONFIG_SCHED_SMT)
> @@ -6833,6 +6865,9 @@ SD_INIT_FUNC(CPU)
>  #ifdef CONFIG_SCHED_MC
>   SD_INIT_FUNC(MC)
>  #endif
> +#ifdef CONFIG_SCHED_BOOK
> + SD_INIT_FUNC(BOOK)
> +#endif
> 
>  static int default_relax_domain_level = -1;
> 
> @@ -6882,6 +6917,8 @@ static void __free_domain_allocs(struct
>                 free_cpumask_var(d->tmpmask); /* fall through */
>         case sa_send_covered:
>                 free_cpumask_var(d->send_covered); /* fall through */
> +       case sa_this_book_map:
> +               free_cpumask_var(d->this_book_map); /* fall through */
>         case sa_this_core_map:
>                 free_cpumask_var(d->this_core_map); /* fall through */
>         case sa_this_sibling_map:
> @@ -6928,8 +6965,10 @@ static enum s_alloc __visit_domain_alloc
>                 return sa_nodemask;
>         if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
>                 return sa_this_sibling_map;
> -       if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
> +       if (!alloc_cpumask_var(&d->this_book_map, GFP_KERNEL))
>                 return sa_this_core_map;
> +       if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
> +               return sa_this_book_map;
>         if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
>                 return sa_send_covered;
>         d->rd = alloc_rootdomain();
> @@ -6987,6 +7026,23 @@ static struct sched_domain *__build_cpu_
>         return sd;
>  }
> 
> +static struct sched_domain *__build_book_sched_domain(struct s_data *d,
> +       const struct cpumask *cpu_map, struct sched_domain_attr *attr,
> +       struct sched_domain *parent, int i)
> +{
> +       struct sched_domain *sd = parent;
> +#ifdef CONFIG_SCHED_BOOK
> +       sd = &per_cpu(book_domains, i).sd;
> +       SD_INIT(sd, BOOK);
> +       set_domain_attribute(sd, attr);
> +       cpumask_and(sched_domain_span(sd), cpu_map, cpu_book_mask(i));
> +       sd->parent = parent;
> +       parent->child = sd;
> +       cpu_to_book_group(i, cpu_map, &sd->groups, d->tmpmask);
> +#endif
> +       return sd;
> +}
> +
>  static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
>         const struct cpumask *cpu_map, struct sched_domain_attr *attr,
>         struct sched_domain *parent, int i)
> @@ -7044,6 +7100,15 @@ static void build_sched_groups(struct s_
>                                                 d->send_covered, d->tmpmask);
>                 break;
>  #endif
> +#ifdef CONFIG_SCHED_BOOK
> +       case SD_LV_BOOK: /* set up book groups */
> +               cpumask_and(d->this_book_map, cpu_map, cpu_book_mask(cpu));
> +               if (cpu == cpumask_first(d->this_book_map))
> +                       init_sched_build_groups(d->this_book_map, cpu_map,
> +                                               &cpu_to_book_group,
> +                                               d->send_covered, d->tmpmask);
> +               break;
> +#endif
>         case SD_LV_CPU: /* set up physical groups */
>                 cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
>                 if (!cpumask_empty(d->nodemask))
> @@ -7091,12 +7156,14 @@ static int __build_sched_domains(const s
> 
>                 sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
>                 sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
> +               sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
>                 sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
>                 sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
>         }
> 
>         for_each_cpu(i, cpu_map) {
>                 build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
> +               build_sched_groups(&d, SD_LV_BOOK, cpu_map, i);
>                 build_sched_groups(&d, SD_LV_MC, cpu_map, i);
>         }
> 
> @@ -7127,6 +7194,12 @@ static int __build_sched_domains(const s
>                 init_sched_groups_power(i, sd);
>         }
>  #endif
> +#ifdef CONFIG_SCHED_BOOK
> +       for_each_cpu(i, cpu_map) {
> +               sd = &per_cpu(book_domains, i).sd;
> +               init_sched_groups_power(i, sd);
> +       }
> +#endif
> 
>         for_each_cpu(i, cpu_map) {
>                 sd = &per_cpu(phys_domains, i).sd;
> @@ -7152,6 +7225,8 @@ static int __build_sched_domains(const s
>                 sd = &per_cpu(cpu_domains, i).sd;
>  #elif defined(CONFIG_SCHED_MC)
>                 sd = &per_cpu(core_domains, i).sd;
> +#elif defined(CONFIG_SCHED_BOOK)
> +               sd = &per_cpu(book_domains, i).sd;
>  #else
>                 sd = &per_cpu(phys_domains, i).sd;
>  #endif
> @@ -7368,7 +7443,8 @@ match2:
>         mutex_unlock(&sched_domains_mutex);
>  }
> 
> -#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> +#if defined(CONFIG_SCHED_BOOK) || defined(CONFIG_SCHED_MC) || \
> +    defined(CONFIG_SCHED_SMT)
>  static void arch_reinit_sched_domains(void)
>  {
>         get_online_cpus();
> @@ -7405,6 +7481,9 @@ static ssize_t sched_power_savings_store
>         case SD_LV_MC:
>                 sched_mc_power_savings = level;
>                 break;
> +       case SD_LV_BOOK:
> +               sched_book_power_savings = level;
> +               break;
>         default:
>                 break;
>         }
> @@ -7414,6 +7493,24 @@ static ssize_t sched_power_savings_store
>         return count;
>  }
> 
> +#ifdef CONFIG_SCHED_BOOK
> +static ssize_t sched_book_power_savings_show(struct sysdev_class *class,
> +                                            struct sysdev_class_attribute *attr,
> +                                            char *page)
> +{
> +       return sprintf(page, "%u\n", sched_book_power_savings);
> +}
> +static ssize_t sched_book_power_savings_store(struct sysdev_class *class,
> +                                             struct sysdev_class_attribute *attr,
> +                                             const char *buf, size_t count)
> +{
> +       return sched_power_savings_store(buf, count, SD_LV_BOOK);
> +}
> +static SYSDEV_CLASS_ATTR(sched_book_power_savings, 0644,
> +                        sched_book_power_savings_show,
> +                        sched_book_power_savings_store);
> +#endif
> +
>  #ifdef CONFIG_SCHED_MC
>  static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
>                                            struct sysdev_class_attribute *attr,
> @@ -7464,9 +7561,14 @@ int __init sched_create_sysfs_power_savi
>                 err = sysfs_create_file(&cls->kset.kobj,
>                                         &attr_sched_mc_power_savings.attr);
>  #endif
> +#ifdef CONFIG_SCHED_BOOK
> +       if (!err && book_capable())
> +               err = sysfs_create_file(&cls->kset.kobj,
> +                                       &attr_sched_book_power_savings.attr);
> +#endif
>         return err;
>  }
> -#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
> +#endif /* CONFIG_SCHED_BOOK || CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
> 
>  /*
>   * Update cpusets according to cpu_active mask.  If cpusets are
> diff -urpN linux-2.6/kernel/sched_fair.c linux-2.6-patched/kernel/sched_fair.c
> --- linux-2.6/kernel/sched_fair.c       2010-08-11 13:47:16.000000000 +0200
> +++ linux-2.6-patched/kernel/sched_fair.c       2010-08-11 13:47:23.000000000 +0200
> @@ -2039,7 +2039,8 @@ struct sd_lb_stats {
>         unsigned long busiest_group_capacity;
> 
>         int group_imb; /* Is there imbalance in this sd */
> -#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> +#if defined(CONFIG_SCHED_BOOK) || defined(CONFIG_SCHED_MC) || \
> +    defined(CONFIG_SCHED_SMT)
>         int power_savings_balance; /* Is powersave balance needed for this sd */
>         struct sched_group *group_min; /* Least loaded group in sd */
>         struct sched_group *group_leader; /* Group which relieves group_min */
> @@ -2096,8 +2097,8 @@ static inline int get_sd_load_idx(struct
>         return load_idx;
>  }
> 
> -
> -#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
> +#if defined(CONFIG_SCHED_BOOK) || defined(CONFIG_SCHED_MC) || \
> +    defined(CONFIG_SCHED_SMT)
>  /**
>   * init_sd_power_savings_stats - Initialize power savings statistics for
>   * the given sched_domain, during load balancing.
> @@ -2217,7 +2218,7 @@ static inline int check_power_save_busie
>         return 1;
> 
>  }
> -#else /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
> +#else /* CONFIG_SCHED_BOOK || CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
>  static inline void init_sd_power_savings_stats(struct sched_domain *sd,
>         struct sd_lb_stats *sds, enum cpu_idle_type idle)
>  {
> @@ -2235,7 +2236,7 @@ static inline int check_power_save_busie
>  {
>         return 0;
>  }
> -#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
> +#endif /* CONFIG_SCHED_BOOK || CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
> 
> 
>  unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
> 

