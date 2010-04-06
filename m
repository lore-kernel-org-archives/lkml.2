Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0DFR4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:56:00 -0400
Received: from fifo99.com ([67.223.236.141]:47247 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab0DFRzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:55:53 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2010 13:55:53 EDT
Subject: Re: [RFC][PATCH] sched: cpuacct: Track cpuusage per cpu frequency
From: Daniel Walker <dwalker@fifo99.com>
To: Mike Chan <mike@android.com>
Cc: menage@google.com, balbir@in.ibm.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1270496004-9715-1-git-send-email-mike@android.com>
References: <1270496004-9715-1-git-send-email-mike@android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 10:48:47 -0700
Message-ID: <1270576127.9066.8.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-05 at 12:33 -0700, Mike Chan wrote:
> New file: cpuacct.cpufreq when CONFIG_CPU_FREQ_STATS is enabled.
> 
> cpuacct.cpufreq accounts for cpu time per-cpu frequency, time is exported
> in nano-seconds
> 
> We do not know the cpufreq table size at compile time.
> So a new config option CONFIG_CPUACCT_CPUFREQ_TABLE_MAX is intruduced,
> to determine the cpufreq table per-cpu in the cpuacct struct.
> 
> Signed-off-by: Mike Chan <mike@android.com>
> ---
>  init/Kconfig   |    5 +++
>  kernel/sched.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 104 insertions(+), 0 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index eb77e8c..e1e86df 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -534,6 +534,11 @@ config CGROUP_CPUACCT
>  	  Provides a simple Resource Controller for monitoring the
>  	  total CPU consumed by the tasks in a cgroup.
>  
> +config CPUACCT_CPUFREQ_TABLE_MAX
> +	int "Max CPUFREQ table size"
> +	depends on CGROUP_CPUACCT && CPU_FREQ_TABLE
> +	default 32
> +

I'd say make it just a regular define unless you can think of a reason
why a non-developer would want to touch this value.

>  config RESOURCE_COUNTERS
>  	bool "Resource counters"
>  	help
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 528a105..a0b56b5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -71,6 +71,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/ctype.h>
>  #include <linux/ftrace.h>
> +#include <linux/cpufreq.h>
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -8817,6 +8818,11 @@ struct cgroup_subsys cpu_cgroup_subsys = {
>   * (balbir@in.ibm.com).
>   */
>  
> +#ifdef CONFIG_CPU_FREQ_STAT
> +/* The alloc_percpu macro uses typeof so we must define a type here. */
> +typedef struct { u64 usage[CONFIG_CPUACCT_CPUFREQ_TABLE_MAX]; } cpufreq_usage_t;
> +#endif

you should be able to send it a regular struct . I found this usage,

lport->dev_stats = alloc_percpu(struct fcoe_dev_stats);

as an example.

Daniel

