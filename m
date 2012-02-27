Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab2B0WTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:19:48 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50054 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab2B0WTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:19:47 -0500
Message-ID: <4F4C017E.5040200@gmail.com>
Date: Mon, 27 Feb 2012 14:19:42 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>, Ralf Baechle <ralf@linux-mips.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Tony Luck <tony.luck@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org, linux-mips@linux-mips.org,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/3] mips: Avoid raw handling of cpu_possible_map/cpu_online_map
References: <87wr7pbwbz.fsf@rustcorp.com.au> <1329259784-20592-1-git-send-email-venki@google.com> <1329259784-20592-3-git-send-email-venki@google.com>
In-Reply-To: <1329259784-20592-3-git-send-email-venki@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 02:49 PM, Venkatesh Pallipadi wrote:
> Use set_cpu_* and init_cpu_* variants instead.
>
> Signed-off-by: Venkatesh Pallipadi<venki@google.com>

I came up with the same thing, so...

Acked-by: David Daney <david.daney@cavium.com>

Ralf:  If you too were to Acknowledge the patch, we might get it merged.

David Daney

> ---
>   arch/mips/cavium-octeon/smp.c       |    2 +-
>   arch/mips/kernel/smp.c              |    4 ++--
>   arch/mips/netlogic/xlr/smp.c        |    4 ++--
>   arch/mips/pmc-sierra/yosemite/smp.c |    4 ++--
>   arch/mips/sgi-ip27/ip27-smp.c       |    2 +-
>   arch/mips/sibyte/bcm1480/smp.c      |    5 ++---
>   arch/mips/sibyte/sb1250/smp.c       |    5 ++---
>   7 files changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
> index efcfff4..5cce09c 100644
> --- a/arch/mips/cavium-octeon/smp.c
> +++ b/arch/mips/cavium-octeon/smp.c
> @@ -268,7 +268,7 @@ static int octeon_cpu_disable(void)
>
>   	spin_lock(&smp_reserve_lock);
>
> -	cpu_clear(cpu, cpu_online_map);
> +	set_cpu_online(cpu, false);
>   	cpu_clear(cpu, cpu_callin_map);
>   	local_irq_disable();
>   	fixup_irqs();
> diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> index 32c1e95..28777ff 100644
> --- a/arch/mips/kernel/smp.c
> +++ b/arch/mips/kernel/smp.c
> @@ -148,7 +148,7 @@ static void stop_this_cpu(void *dummy)
>   	/*
>   	 * Remove this CPU:
>   	 */
> -	cpu_clear(smp_processor_id(), cpu_online_map);
> +	set_cpu_online(smp_processor_id(), false);
>   	for (;;) {
>   		if (cpu_wait)
>   			(*cpu_wait)();		/* Wait if available. */
> @@ -248,7 +248,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
>   	while (!cpu_isset(cpu, cpu_callin_map))
>   		udelay(100);
>
> -	cpu_set(cpu, cpu_online_map);
> +	set_cpu_online(cpu, true);
>
>   	return 0;
>   }
> diff --git a/arch/mips/netlogic/xlr/smp.c b/arch/mips/netlogic/xlr/smp.c
> index 080284d..8084221 100644
> --- a/arch/mips/netlogic/xlr/smp.c
> +++ b/arch/mips/netlogic/xlr/smp.c
> @@ -154,7 +154,7 @@ void __init nlm_smp_setup(void)
>   	cpu_set(boot_cpu, phys_cpu_present_map);
>   	__cpu_number_map[boot_cpu] = 0;
>   	__cpu_logical_map[0] = boot_cpu;
> -	cpu_set(0, cpu_possible_map);
> +	set_cpu_possible(0, true);
>
>   	num_cpus = 1;
>   	for (i = 0; i<  NR_CPUS; i++) {
> @@ -166,7 +166,7 @@ void __init nlm_smp_setup(void)
>   			cpu_set(i, phys_cpu_present_map);
>   			__cpu_number_map[i] = num_cpus;
>   			__cpu_logical_map[num_cpus] = i;
> -			cpu_set(num_cpus, cpu_possible_map);
> +			set_cpu_possible(num_cpus, true);
>   			++num_cpus;
>   		}
>   	}
> diff --git a/arch/mips/pmc-sierra/yosemite/smp.c b/arch/mips/pmc-sierra/yosemite/smp.c
> index 2608752..b2b23eb 100644
> --- a/arch/mips/pmc-sierra/yosemite/smp.c
> +++ b/arch/mips/pmc-sierra/yosemite/smp.c
> @@ -155,10 +155,10 @@ static void __init yos_smp_setup(void)
>   {
>   	int i;
>
> -	cpus_clear(cpu_possible_map);
> +	init_cpu_possible(cpumask_of(0));
>
>   	for (i = 0; i<  2; i++) {
> -		cpu_set(i, cpu_possible_map);
> +		set_cpu_possible(i, true);
>   		__cpu_number_map[i]	= i;
>   		__cpu_logical_map[i]	= i;
>   	}
> diff --git a/arch/mips/sgi-ip27/ip27-smp.c b/arch/mips/sgi-ip27/ip27-smp.c
> index c6851df..735b43b 100644
> --- a/arch/mips/sgi-ip27/ip27-smp.c
> +++ b/arch/mips/sgi-ip27/ip27-smp.c
> @@ -76,7 +76,7 @@ static int do_cpumask(cnodeid_t cnode, nasid_t nasid, int highest)
>   			/* Only let it join in if it's marked enabled */
>   			if ((acpu->cpu_info.flags&  KLINFO_ENABLE)&&
>   			(tot_cpus_found != NR_CPUS)) {
> -				cpu_set(cpuid, cpu_possible_map);
> +				set_cpu_possible(cpuid, true);
>   				alloc_cpupda(cpuid, tot_cpus_found);
>   				cpus_found++;
>   				tot_cpus_found++;
> diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
> index d667875..63d2211 100644
> --- a/arch/mips/sibyte/bcm1480/smp.c
> +++ b/arch/mips/sibyte/bcm1480/smp.c
> @@ -147,14 +147,13 @@ static void __init bcm1480_smp_setup(void)
>   {
>   	int i, num;
>
> -	cpus_clear(cpu_possible_map);
> -	cpu_set(0, cpu_possible_map);
> +	init_cpu_possible(cpumask_of(0));
>   	__cpu_number_map[0] = 0;
>   	__cpu_logical_map[0] = 0;
>
>   	for (i = 1, num = 0; i<  NR_CPUS; i++) {
>   		if (cfe_cpu_stop(i) == 0) {
> -			cpu_set(i, cpu_possible_map);
> +			set_cpu_possible(i, true);
>   			__cpu_number_map[i] = ++num;
>   			__cpu_logical_map[num] = i;
>   		}
> diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
> index 38e7f6b..77f0df5 100644
> --- a/arch/mips/sibyte/sb1250/smp.c
> +++ b/arch/mips/sibyte/sb1250/smp.c
> @@ -135,14 +135,13 @@ static void __init sb1250_smp_setup(void)
>   {
>   	int i, num;
>
> -	cpus_clear(cpu_possible_map);
> -	cpu_set(0, cpu_possible_map);
> +	init_cpu_possible(cpumask_of(0));
>   	__cpu_number_map[0] = 0;
>   	__cpu_logical_map[0] = 0;
>
>   	for (i = 1, num = 0; i<  NR_CPUS; i++) {
>   		if (cfe_cpu_stop(i) == 0) {
> -			cpu_set(i, cpu_possible_map);
> +			set_cpu_possible(i, true);
>   			__cpu_number_map[i] = ++num;
>   			__cpu_logical_map[num] = i;
>   		}

