Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab0LLJ2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 04:28:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab0LLJ2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 04:28:33 -0500
Message-ID: <4D0495AA.4050600@redhat.com>
Date: Sun, 12 Dec 2010 11:28:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: linux-kernel@vger.kernel.org, zamsden@redhat.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] Fix preempt imbalance in kvm_timer_init()
References: <1291920155.8141.4.camel@localhost.localdomain>
In-Reply-To: <1291920155.8141.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 08:42 PM, Thomas Meyer wrote:
> Signed-off-by: Thomas Meyer<thomas@m3y3r.de>
> ---
>   arch/x86/kvm/x86.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cdac9e5..2609c3d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4561,7 +4561,7 @@ static struct notifier_block kvmclock_cpu_notifier_block = {
>
>   static void kvm_timer_init(void)
>   {
> -	int cpu;
> +	int cpu = get_cpu();
>
>   	max_tsc_khz = tsc_khz;
>   	register_hotcpu_notifier(&kvmclock_cpu_notifier_block);

This eventually takes a mutex (in cpu_maps_update_begin()), so it can't 
be called with preemption disabled.

> @@ -4569,13 +4569,14 @@ static void kvm_timer_init(void)
>   #ifdef CONFIG_CPU_FREQ
>   		struct cpufreq_policy policy;
>   		memset(&policy, 0, sizeof(policy));
> -		cpufreq_get_policy(&policy, get_cpu());
> +		cpufreq_get_policy(&policy, cpu);
>   		if (policy.cpuinfo.max_freq)
>   			max_tsc_khz = policy.cpuinfo.max_freq;
>   #endif
>   		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
>   					  CPUFREQ_TRANSITION_NOTIFIER);
>   	}
> +	put_cpu();
>   	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
>   	for_each_online_cpu(cpu)
>   		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);


-- 
error compiling committee.c: too many arguments to function

