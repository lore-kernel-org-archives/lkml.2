Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1JYP2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:28:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab1JYP2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:28:04 -0400
Date: Tue, 25 Oct 2011 17:28:02 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: linux-next: manual merge of the tip tree with the cputime tree
Message-ID: <20111025152802.GA2731@tiehlicka.suse.cz>
References: <20111025183518.6b9747b5d870b55129266785@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025183518.6b9747b5d870b55129266785@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 25-10-11 18:35:18, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in fs/proc/stat.c
> between commit f6116715d1ba ("[S390] cputime: add sparse checking and
> cleanup") from the cputime tree and commit a25cac5198d4 ("proc: Consider
> NO_HZ when printing idle and iowait times") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Looks good.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/proc/stat.c
> index 566cd04,42b274d..0000000
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@@ -21,6 -22,35 +22,34 @@@
>   #define arch_idle_time(cpu) 0
>   #endif
>   
> + static cputime64_t get_idle_time(int cpu)
> + {
> + 	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
> + 	cputime64_t idle;
> + 
> + 	if (idle_time == -1ULL) {
> + 		/* !NO_HZ so we can rely on cpustat.idle */
>  -		idle = kstat_cpu(cpu).cpustat.idle;
>  -		idle = cputime64_add(idle, arch_idle_time(cpu));
> ++		idle = kstat_cpu(cpu).cpustat.idle + arch_idle_time(cpu);
> + 	} else
> + 		idle = usecs_to_cputime(idle_time);
> + 
> + 	return idle;
> + }
> + 
> + static cputime64_t get_iowait_time(int cpu)
> + {
> + 	u64 iowait_time = get_cpu_iowait_time_us(cpu, NULL);
> + 	cputime64_t iowait;
> + 
> + 	if (iowait_time == -1ULL)
> + 		/* !NO_HZ so we can rely on cpustat.iowait */
> + 		iowait = kstat_cpu(cpu).cpustat.iowait;
> + 	else
> + 		iowait = usecs_to_cputime(iowait_time);
> + 
> + 	return iowait;
> + }
> + 
>   static int show_stat(struct seq_file *p, void *v)
>   {
>   	int i, j;
> @@@ -39,16 -69,17 +68,16 @@@
>   	jif = boottime.tv_sec;
>   
>   	for_each_possible_cpu(i) {
>  -		user = cputime64_add(user, kstat_cpu(i).cpustat.user);
>  -		nice = cputime64_add(nice, kstat_cpu(i).cpustat.nice);
>  -		system = cputime64_add(system, kstat_cpu(i).cpustat.system);
>  -		idle = cputime64_add(idle, get_idle_time(i));
>  -		iowait = cputime64_add(iowait, get_iowait_time(i));
>  -		irq = cputime64_add(irq, kstat_cpu(i).cpustat.irq);
>  -		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
>  -		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
>  -		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
>  -		guest_nice = cputime64_add(guest_nice,
>  -			kstat_cpu(i).cpustat.guest_nice);
>  +		user += kstat_cpu(i).cpustat.user;
>  +		nice += kstat_cpu(i).cpustat.nice;
>  +		system += kstat_cpu(i).cpustat.system;
> - 		idle += kstat_cpu(i).cpustat.idle + arch_idle_time(i);
> - 		iowait += kstat_cpu(i).cpustat.iowait;
> ++		idle += get_idle_time(i);
> ++		iowait +=  get_iowait_time(i);
>  +		irq += kstat_cpu(i).cpustat.irq;
>  +		softirq += kstat_cpu(i).cpustat.softirq;
>  +		steal += kstat_cpu(i).cpustat.steal;
>  +		guest += kstat_cpu(i).cpustat.guest;
>  +		guest_nice += kstat_cpu(i).cpustat.guest_nice;
>   		sum += kstat_cpu_irqs_sum(i);
>   		sum += arch_irq_stat_cpu(i);
>   



-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
