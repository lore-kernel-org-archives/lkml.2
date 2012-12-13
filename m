Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab2LMIx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:53:28 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:51521 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2LMIx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:53:27 -0500
MIME-Version: 1.0
In-Reply-To: <50C93C40.8020101@intel.com>
References: <1355319092-30980-1-git-send-email-vincent.guittot@linaro.org>
	<1355319092-30980-3-git-send-email-vincent.guittot@linaro.org>
	<50C93C40.8020101@intel.com>
Date: Thu, 13 Dec 2012 09:53:23 +0100
Message-ID: <CAKfTPtD2EG1iUo0J_bF9SmMqMdiXw08zJdT=UKcRATdUV+nEWQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] sched: add a new SD SHARE_POWERLINE flag for sched_domain
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, peterz@infradead.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, preeti@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, len.brown@intel.com,
        arjan@linux.intel.com, amit.kucheria@linaro.org,
        viresh.kumar@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 December 2012 03:24, Alex Shi <alex.shi@intel.com> wrote:
> On 12/12/2012 09:31 PM, Vincent Guittot wrote:
>> This new flag SD_SHARE_POWERDOMAIN is used to reflect whether groups of CPU in
>> a sched_domain level can or not reach a different power state. If clusters can
>> be power gated independently, as an example, the flag should be cleared at CPU
>> level. This information is used to decide if it's worth packing some tasks in
>> a group of CPUs in order to power gated the other groups instead of spreading
>> the tasks. The default behavior of the scheduler is to spread tasks so the
>> flag is set into all sched_domains
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  arch/ia64/include/asm/topology.h |    1 +
>>  arch/tile/include/asm/topology.h |    1 +
>>  include/linux/sched.h            |    1 +
>>  include/linux/topology.h         |    4 ++++
>>  kernel/sched/core.c              |    6 ++++++
>>  5 files changed, 13 insertions(+)
>>
>> diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
>> index a2496e4..6d0b617 100644
>> --- a/arch/ia64/include/asm/topology.h
>> +++ b/arch/ia64/include/asm/topology.h
>> @@ -65,6 +65,7 @@ void build_cpu_to_node_map(void);
>>                               | SD_BALANCE_EXEC       \
>>                               | SD_BALANCE_FORK       \
>>                               | SD_WAKE_AFFINE,       \
>> +                             | arch_sd_local_flags(0)\
>>       .last_balance           = jiffies,              \
>>       .balance_interval       = 1,                    \
>>       .nr_balance_failed      = 0,                    \
>> diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
>> index d5e86c9..adc8710 100644
>> --- a/arch/tile/include/asm/topology.h
>> +++ b/arch/tile/include/asm/topology.h
>> @@ -71,6 +71,7 @@ static inline const struct cpumask *cpumask_of_node(int node)
>>                               | 0*SD_WAKE_AFFINE                      \
>>                               | 0*SD_SHARE_CPUPOWER                   \
>>                               | 0*SD_SHARE_PKG_RESOURCES              \
>> +                             | arch_sd_local_flags(0)                \
>>                               | 0*SD_SERIALIZE                        \
>>                               ,                                       \
>>       .last_balance           = jiffies,                              \
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 046e39a..3287be1 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -844,6 +844,7 @@ enum cpu_idle_type {
>>  #define SD_BALANCE_WAKE              0x0010  /* Balance on wakeup */
>>  #define SD_WAKE_AFFINE               0x0020  /* Wake task to waking CPU */
>>  #define SD_SHARE_CPUPOWER    0x0080  /* Domain members share cpu power */
>> +#define SD_SHARE_POWERDOMAIN 0x0100  /* Domain members share power domain */
>>  #define SD_SHARE_PKG_RESOURCES       0x0200  /* Domain members share cpu pkg resources */
>>  #define SD_SERIALIZE         0x0400  /* Only a single load balancing instance */
>>  #define SD_ASYM_PACKING              0x0800  /* Place busy groups earlier in the domain */
>> diff --git a/include/linux/topology.h b/include/linux/topology.h
>> index d3cf0d6..3eab293 100644
>> --- a/include/linux/topology.h
>> +++ b/include/linux/topology.h
>> @@ -99,6 +99,8 @@ int arch_update_cpu_topology(void);
>>                               | 1*SD_WAKE_AFFINE                      \
>>                               | 1*SD_SHARE_CPUPOWER                   \
>>                               | 1*SD_SHARE_PKG_RESOURCES              \
>> +                             | arch_sd_local_flags(SD_SHARE_CPUPOWER|\
>> +                                             SD_SHARE_PKG_RESOURCES) \
>>                               | 0*SD_SERIALIZE                        \
>>                               | 0*SD_PREFER_SIBLING                   \
>>                               | arch_sd_sibling_asym_packing()        \
>> @@ -131,6 +133,7 @@ int arch_update_cpu_topology(void);
>>                               | 1*SD_WAKE_AFFINE                      \
>>                               | 0*SD_SHARE_CPUPOWER                   \
>>                               | 1*SD_SHARE_PKG_RESOURCES              \
>> +                             | arch_sd_local_flags(SD_SHARE_PKG_RESOURCES)\
>>                               | 0*SD_SERIALIZE                        \
>>                               ,                                       \
>>       .last_balance           = jiffies,                              \
>> @@ -161,6 +164,7 @@ int arch_update_cpu_topology(void);
>>                               | 1*SD_WAKE_AFFINE                      \
>>                               | 0*SD_SHARE_CPUPOWER                   \
>>                               | 0*SD_SHARE_PKG_RESOURCES              \
>> +                             | arch_sd_local_flags(0)                \
>
> The general style looks like prefering SD_XXX flag directly.

In fact, I have followed the same style as
arch_sd_sibling_asym_packing or sd_local_flags which conditionally set
flags for sched_domain


>
