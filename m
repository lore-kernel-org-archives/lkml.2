Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2BAWB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:01:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2BAWB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:01:26 -0500
Date: Wed, 1 Feb 2012 14:01:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
 -v5
Message-Id: <20120201140125.c656df41.akpm@linux-foundation.org>
In-Reply-To: <1328055439-9441-1-git-send-email-venki@google.com>
References: <CABeCy1aPp4=v90v_wAsw-KWDwNs59CwwYSJ-36+4t8kMuCaK0w@mail.gmail.com>
	<1328055439-9441-1-git-send-email-venki@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 16:17:19 -0800
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

Looks good to me.

> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -604,9 +604,13 @@ EXPORT_SYMBOL(cpu_all_bits);
>  #ifdef CONFIG_INIT_ALL_POSSIBLE
>  static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
>  	= CPU_BITS_ALL;
> +unsigned int nr_possible_cpus __read_mostly = CONFIG_NR_CPUS;
>  #else
>  static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
> +unsigned int nr_possible_cpus __read_mostly;
>  #endif
> +EXPORT_SYMBOL(nr_possible_cpus);

What the heck is CONFIG_INIT_ALL_POSSIBLE?

<blames Rusty>

:    1) Some archs (m32, parisc, s390) set possible_map to all 1, so we add a
:       CONFIG_INIT_ALL_POSSIBLE for this rather than break them.

Seems strange.  Do these architectures really need to initialise
cpu_possible_map at compile-time, when all the other architectures
manage to do it at runtime?

