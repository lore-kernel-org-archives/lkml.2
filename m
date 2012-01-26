Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab2AZXW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 18:22:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab2AZXW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 18:22:58 -0500
Date: Thu, 26 Jan 2012 15:22:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
 -v4
Message-Id: <20120126152257.bfba0c25.akpm@linux-foundation.org>
In-Reply-To: <1327447541-3040-1-git-send-email-venki@google.com>
References: <CABeCy1ZA1nkWSmbN2LE+V1SxKEHX4XrpN5xfdzY=NSsS8=L0DA@mail.gmail.com>
	<1327447541-3040-1-git-send-email-venki@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 15:25:41 -0800
Venkatesh Pallipadi <venki@google.com> wrote:

> Kernel's notion of possible cpus (from include/linux/cpumask.h)
>  *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
> 
>  *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
>  *  that it is possible might ever be plugged in at anytime during the
>  *  life of that system boot.
> 
>  #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)
> 
> and on x86 cpumask_weight() calls hweight64 and hweight64 (on older kernels
> and systems with !X86_FEATURE_POPCNT) or a popcnt based alternative.
> 
> i.e, We needlessly go through this mask based calculation everytime
> num_possible_cpus() is called.
> 
> The problem is there with cpu_online_mask() as well, which is fixed value at
> boot time in !CONFIG_HOTPLUG_CPU case and should not change that often even
> in HOTPLUG case.
> 
> Though most of the callers of these two routines are init time (with few
> exceptions of runtime calls), it is cleaner to use variables
> and not go through this repeated mask based calculation.
>
> ...
>
> +extern int nr_online_cpus;
> +extern int nr_possible_cpus;
> +
>  #ifdef CONFIG_CPUMASK_OFFSTACK
>  /* Assuming NR_CPUS is huge, a runtime limit is more efficient.  Also,
>   * not all bits may be allocated. */
> @@ -81,8 +84,10 @@ extern const struct cpumask *const cpu_present_mask;
>  extern const struct cpumask *const cpu_active_mask;
>  
>  #if NR_CPUS > 1
> -#define num_online_cpus()	cpumask_weight(cpu_online_mask)
> -#define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
> +
> +#define num_online_cpus()	(nr_online_cpus)
> +#define num_possible_cpus()	(nr_possible_cpus)

This changes the return types from "unsigned int" to int.  Worse, the
return types become dependent upon CONFIG_SMP.

s/int/unsigned int/g, methinks.

>
> ...
>
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -604,16 +604,23 @@ EXPORT_SYMBOL(cpu_all_bits);
>  #ifdef CONFIG_INIT_ALL_POSSIBLE
>  static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
>  	= CPU_BITS_ALL;
> +int nr_possible_cpus __read_mostly = NR_CPUS;

It looks strange to see cpu_possible_bits using CONFIG_NR_CPUS whereas
nr_possible_cpus uses NR_CPUS.  I suggest using CONFIG_NR_CPUS for
both.

Aside: that FIXME in include/linux/threads.h should get fixed - it's
stupid.  We should fix the Kconfigs.

And the legacy NR_CPUS should be banished from the kernel altogether.

>  #else
>  static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
> +int nr_possible_cpus __read_mostly;
>  #endif
>  const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
>  EXPORT_SYMBOL(cpu_possible_mask);
>  
> +EXPORT_SYMBOL(nr_possible_cpus);

It's better to place the export immediately following the nr_possible_cpus
definition(s).
