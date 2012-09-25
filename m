Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab2IYSur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:50:47 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48156 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2IYSuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:50:46 -0400
Message-ID: <5061FCDD.6050406@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 00:20:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, mhocko@suse.cz, schwidefsky@de.ibm.com,
        deepthi@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RESEND PATCH v2] nohz: fix idle ticks in cpu summary line of
 /proc/stat
References: <20120910111157.3940.68948.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120910111157.3940.68948.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092518-5564-0000-0000-0000049D614B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 04:43 PM, Srivatsa S. Bhat wrote:
> From: Michal Hocko <mhocko@suse.cz>
> 
> Git commit 09a1d34f8535ecf9 "nohz: Make idle/iowait counter update
> conditional" introduced a bug in regard to cpu hotplug. The effect is
> that the number of idle ticks in the cpu summary line in /proc/stat is
> still counting ticks for offline cpus.
> 
> Reproduction is easy, just start a workload that keeps all cpus busy,
> switch off one or more cpus and then watch the idle field in top.
> On a dual-core with one cpu 100% busy and one offline cpu you will get
> something like this:
> 
> %Cpu(s): 48.7 us,  1.3 sy,  0.0 ni, 50.0 id,  0.0 wa,  0.0 hi,  0.0 si,
> %0.0 st
> 
> The problem is that an offline cpu still has ts->idle_active == 1.
> To fix this we should make sure that the cpu is online when calling
> get_cpu_idle_time_us and get_cpu_iowait_time_us.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> [srivatsa.bhat@linux.vnet.ibm.com: Rebased to current mainline]
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
> Hi Thomas,
> 
> This is a resend of the patch posted by Michal at [1]. Martin had explained
> the importance of this patch for fixing the bug for x86 case in [2]. (The s390
> fix is already upstream, commit id cb85a6ed67e9). Could you kindly consider
> taking this fix?
>

Hi Thomas,
Any thoughts on this?

Regards,
Srivatsa S. Bhat
 
> [1]. http://thread.gmane.org/gmane.linux.kernel/1265374/focus=1266457
> [2]. http://thread.gmane.org/gmane.linux.kernel/1265374/focus=1276336
> 
>  fs/proc/stat.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> index 64c3b31..e296572 100644
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -45,10 +45,13 @@ static cputime64_t get_iowait_time(int cpu)
> 
>  static u64 get_idle_time(int cpu)
>  {
> -	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
> +	u64 idle, idle_time = -1ULL;
> +
> +	if (cpu_online(cpu))
> +		idle_time = get_cpu_idle_time_us(cpu, NULL);
> 
>  	if (idle_time == -1ULL)
> -		/* !NO_HZ so we can rely on cpustat.idle */
> +		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
>  		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
>  	else
>  		idle = usecs_to_cputime64(idle_time);
> @@ -58,10 +61,13 @@ static u64 get_idle_time(int cpu)
> 
>  static u64 get_iowait_time(int cpu)
>  {
> -	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
> +	u64 iowait, iowait_time = -1ULL;
> +
> +	if (cpu_online(cpu))
> +		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
> 
>  	if (iowait_time == -1ULL)
> -		/* !NO_HZ so we can rely on cpustat.iowait */
> +		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
>  		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
>  	else
>  		iowait = usecs_to_cputime64(iowait_time);
> 

