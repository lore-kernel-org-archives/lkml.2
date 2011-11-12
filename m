Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1KLBfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 20:35:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45365 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab1KLBfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 20:35:19 -0500
Message-ID: <4EBDCD4E.1060801@google.com>
Date: Fri, 11 Nov 2011 17:35:10 -0800
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, fweisbec@gmail.com
Subject: Re: [PATCH v2 03/14] Move /proc/stat logic inside sched.c
References: <1320182360-20043-1-git-send-email-glommer@parallels.com> <1320182360-20043-4-git-send-email-glommer@parallels.com>
In-Reply-To: <1320182360-20043-4-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 02:19 PM, Glauber Costa wrote:
> This patch moves all of the /proc/stat display code inside
> sched.c. The goal is to later on, have a different version
> of it per-cgroup. In containers environment, this is useful
> to give each container a different and independent view of
> the statistics displayed in this file.
>
> Signed-off-by: Glauber Costa<glommer@parallels.com>
> ---
>   fs/proc/stat.c        |  139 +-----------------------------------------------
>   include/linux/sched.h |    1 +
>   kernel/sched.c        |  142 +++++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 144 insertions(+), 138 deletions(-)
>

This feels a little contrived.  sched.c isn't the right place for much of this 
code.  Why do you want to move it all instead of exporting the functionality 
(e.g. remove static?).

> diff --git a/kernel/sched.c b/kernel/sched.c
> index e78e1aa..3f42916 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -71,6 +71,7 @@
>   #include<linux/ctype.h>
>   #include<linux/ftrace.h>
>   #include<linux/slab.h>
> +#include<linux/tick.h>
>
>   #include<asm/tlb.h>
>   #include<asm/irq_regs.h>
> @@ -9494,6 +9495,147 @@ struct cgroup_subsys cpu_cgroup_subsys = {
>
>   #endif	/* CONFIG_CGROUP_SCHED */
>
> +#ifndef fi
> +#define arch_irq_stat_cpu(cpu) 0
> +#endif
> +#ifndef arch_irq_stat
> +#define arch_irq_stat() 0
> +#endif
> +#ifndef arch_idle_time
> +#define arch_idle_time(cpu) 0
> +#endif
> +
> +static u64 get_idle_time(int cpu)
> +{
> +	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
> +
> +	if (idle_time == -1ULL) {
> +		/* !NO_HZ so we can rely on cpustat.idle */
> +		idle = kstat_cpu(cpu).cpustat[IDLE];
> +		idle += arch_idle_time(cpu);
> +	} else
> +		idle = usecs_to_cputime(idle_time);
> +
> +	return idle;
> +}
> +
> +static u64 get_iowait_time(int cpu)
> +{
> +	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
> +
> +	if (iowait_time == -1ULL)
> +		/* !NO_HZ so we can rely on cpustat.iowait */
> +		iowait = kstat_cpu(cpu).cpustat[IOWAIT];
> +	else
> +		iowait = usecs_to_cputime(iowait_time);
> +
> +	return iowait;
> +}
> +
> +int cpu_cgroup_proc_stat(struct seq_file *p)
> +{
> +	int i, j;
> +	unsigned long jif;
> +	u64 user, nice, system, idle, iowait, irq, softirq, steal;
> +	u64 guest, guest_nice;
> +	u64 sum = 0;
> +	u64 sum_softirq = 0;
> +	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
> +	struct timespec boottime;
> +
> +	user = nice = system = idle = iowait =
> +		irq = softirq = steal = 0;
> +	guest = guest_nice = 0;
> +	getboottime(&boottime);
> +	jif = boottime.tv_sec;
> +
> +	for_each_possible_cpu(i) {
> +		user += kstat_cpu(i).cpustat[USER];
> +		nice += kstat_cpu(i).cpustat[NICE];
> +		system += kstat_cpu(i).cpustat[SYSTEM];
> +		idle += get_idle_time(i);
> +		iowait += get_iowait_time(i);
> +		irq += kstat_cpu(i).cpustat[IRQ];
> +		softirq += kstat_cpu(i).cpustat[SOFTIRQ];
> +		steal += kstat_cpu(i).cpustat[STEAL];
> +		guest += kstat_cpu(i).cpustat[GUEST];
> +		guest_nice += kstat_cpu(i).cpustat[GUEST_NICE];
> +
> +		for (j = 0; j<  NR_SOFTIRQS; j++) {
> +			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
> +
> +			per_softirq_sums[j] += softirq_stat;
> +			sum_softirq += softirq_stat;
> +		}
> +	}
> +	sum += arch_irq_stat();
> +
> +	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
> +		"%llu\n",
> +		(unsigned long long)cputime64_to_clock_t(user),
> +		(unsigned long long)cputime64_to_clock_t(nice),
> +		(unsigned long long)cputime64_to_clock_t(system),
> +		(unsigned long long)cputime64_to_clock_t(idle),
> +		(unsigned long long)cputime64_to_clock_t(iowait),
> +		(unsigned long long)cputime64_to_clock_t(irq),
> +		(unsigned long long)cputime64_to_clock_t(softirq),
> +		(unsigned long long)cputime64_to_clock_t(steal),
> +		(unsigned long long)cputime64_to_clock_t(guest),
> +		(unsigned long long)cputime64_to_clock_t(guest_nice));
> +	for_each_online_cpu(i) {
> +		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */

GCC 3.2 is the listed current minimum requirement.  If this code is being 
revisited this could be cleaned up.

> +		user = kstat_cpu(i).cpustat[USER];
> +		nice = kstat_cpu(i).cpustat[NICE];
> +		system = kstat_cpu(i).cpustat[SYSTEM];
> +		idle = get_idle_time(i);
> +		iowait = get_iowait_time(i);
> +		irq = kstat_cpu(i).cpustat[IRQ];
> +		softirq = kstat_cpu(i).cpustat[SOFTIRQ];
> +		steal = kstat_cpu(i).cpustat[STEAL];
> +		guest = kstat_cpu(i).cpustat[GUEST];
> +		guest_nice = kstat_cpu(i).cpustat[GUEST_NICE];
> +		seq_printf(p,
> +			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
> +			"%llu\n",
> +			i,
> +			(unsigned long long)cputime64_to_clock_t(user),
> +			(unsigned long long)cputime64_to_clock_t(nice),
> +			(unsigned long long)cputime64_to_clock_t(system),
> +			(unsigned long long)cputime64_to_clock_t(idle),
> +			(unsigned long long)cputime64_to_clock_t(iowait),
> +			(unsigned long long)cputime64_to_clock_t(irq),
> +			(unsigned long long)cputime64_to_clock_t(softirq),
> +			(unsigned long long)cputime64_to_clock_t(steal),
> +			(unsigned long long)cputime64_to_clock_t(guest),
> +			(unsigned long long)cputime64_to_clock_t(guest_nice));
> +	}
> +	seq_printf(p, "intr %llu", (unsigned long long)sum);
> +
> +	/* sum again ? it could be updated? */
> +	for_each_irq_nr(j)
> +		seq_printf(p, " %u", kstat_irqs(j));
> +
> +	seq_printf(p,
> +		"\nctxt %llu\n"
> +		"btime %lu\n"
> +		"processes %lu\n"
> +		"procs_running %lu\n"
> +		"procs_blocked %lu\n",
> +		nr_context_switches(),
> +		(unsigned long)jif,
> +		total_forks,
> +		nr_running(),
> +		nr_iowait());
> +
> +	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
> +
> +	for (i = 0; i<  NR_SOFTIRQS; i++)
> +		seq_printf(p, " %u", per_softirq_sums[i]);
> +	seq_putc(p, '\n');
> +
> +	return 0;
> +}
> +
>   #ifdef CONFIG_CGROUP_CPUACCT
>
>   /*

