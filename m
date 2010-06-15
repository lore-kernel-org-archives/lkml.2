Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0FOICy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:02:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab0FOICu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:02:50 -0400
Message-ID: <4C1733A8.8080005@redhat.com>
Date: Tue, 15 Jun 2010 11:02:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: mtosatti@redhat.com, glommer@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] Make cpu_tsc_khz updates use local CPU.
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-3-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:34 AM, Zachary Amsden wrote:
> This simplifies much of the init code; we can now simply always
> call tsc_khz_changed, optionally passing it a new value, or letting
> it figure out the existing value (while interrupts are disabled, and
> thus, by inference from the rule, not raceful against CPU hotplug or
> frequency updates, which will issue IPIs to the local CPU to perform
> this very same task).
>
>
> -static void bounce_off(void *info)
> +static void tsc_bad(void *info)
>   {
> -	/* nothing */
> +	per_cpu(cpu_tsc_khz, raw_smp_processor_id()) = 0;
>    

Can use __get_cpu_var(cpu_tsc_khz) = 0;

> +}
> +
> +static void tsc_khz_changed(void *data)
> +{
> +	struct cpufreq_freqs *freq = data;
> +
> +	if (data) {
> +		per_cpu(cpu_tsc_khz, freq->cpu) = freq->new;
> +	} else if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
> +		__get_cpu_var(cpu_tsc_khz) =
> +			cpufreq_quick_get(raw_smp_processor_id());
> +	}
>    

Excessive bracketing.

> +	if (!per_cpu(cpu_tsc_khz, raw_smp_processor_id()))
> +		per_cpu(cpu_tsc_khz, raw_smp_processor_id()) = tsc_khz;
>   }
>
>
> +static int kvmclock_cpu_notifier(struct notifier_block *nfb,
> +					unsigned long action, void *hcpu)
> +{
> +	unsigned int cpu = (unsigned long)hcpu;
> +
> +	switch (action) {
> +		case CPU_ONLINE:
> +		case CPU_DOWN_FAILED:
> +			smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
> +			break;
> +		case CPU_DOWN_PREPARE:
> +			smp_call_function_single(cpu, tsc_bad, NULL, 1);
> +			break;
>    

A little frightening in the chance for livelock, but I think you got it 
right.  vcpus on the doomed cpu will have need_resched() set and will 
not be trapped in a loop trying to write the clock and failing.


-- 
error compiling committee.c: too many arguments to function

