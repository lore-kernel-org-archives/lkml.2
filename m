Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2ARTUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:20:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54028 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2ARTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:20:16 -0500
Message-ID: <4F171B6B.2040303@gmail.com>
Date: Wed, 18 Jan 2012 14:20:11 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Venki Pallipadi <venki@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
References: <1326852454-26117-1-git-send-email-venki@google.com> <4F165EB4.9090309@gmail.com> <CABeCy1Y+02K3wiKra+w6UWy9ZVJh3-EajsFB6BwKgZwW3ma9BQ@mail.gmail.com>
In-Reply-To: <CABeCy1Y+02K3wiKra+w6UWy9ZVJh3-EajsFB6BwKgZwW3ma9BQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1/18/12 1:52 PM), Venki Pallipadi wrote:
> On Tue, Jan 17, 2012 at 9:55 PM, KOSAKI Motohiro
> <kosaki.motohiro@gmail.com>  wrote:
>> (1/17/12 9:07 PM), Venkatesh Pallipadi wrote:
>>> Kernel's notion of possible cpus (from include/linux/cpumask.h)
>>>    *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
>>>
>>>    *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
>>>    *  that it is possible might ever be plugged in at anytime during the
>>>    *  life of that system boot.
>>>
>>>    #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)
>>>
>>> and on x86 cpumask_weight() calls hweight64 and hweight64 (on older kernels
>>> and systems with !X86_FEATURE_POPCNT) or a popcnt based alternative.
>>>
>>> i.e, We needlessly go through this mask based calculation everytime
>>> num_possible_cpus() is called.
>>>
>>> The problem is there with cpu_online_mask() as well, which is fixed value at
>>> boot time in !CONFIG_HOTPLUG_CPU case and should not change that often even
>>> in HOTPLUG case.
>>>
>>> Though most of the callers of these two routines are init time (with few
>>> exceptions of runtime calls), it is cleaner to use variables
>>> and not go through this repeated mask based calculation.
>>>
>>> Signed-off-by: Venkatesh Pallipadi<venki@google.com>
>>> ---
>>>    include/linux/cpumask.h |    8 ++++++--
>>>    kernel/cpu.c            |    9 +++++++++
>>>    2 files changed, 15 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
>>> index 4f7a632..2eb04dd 100644
>>> --- a/include/linux/cpumask.h
>>> +++ b/include/linux/cpumask.h
>>> @@ -80,9 +80,13 @@ extern const struct cpumask *const cpu_online_mask;
>>>    extern const struct cpumask *const cpu_present_mask;
>>>    extern const struct cpumask *const cpu_active_mask;
>>>
>>> +extern int nr_online_cpus;
>>> +
>>>    #if NR_CPUS>    1
>>> -#define num_online_cpus()    cpumask_weight(cpu_online_mask)
>>> -#define num_possible_cpus()  cpumask_weight(cpu_possible_mask)
>>> +
>>> +#define num_online_cpus()    (nr_online_cpus)
>>> +#define num_possible_cpus()  (nr_cpu_ids)
>>
>> nr_cpu_ids mean maximum cpu id of cpus. if cpu id are sparse, maximum id
>> doesn't match number of cpus.
>>
>
> Yes. But will it be sparse in any arch? I saw some of the users of
> num_possible_cpus() doing things like allocating a buffer for that
> size and then indexing it using get_cpu(). So, I thought it would be
> better to use the existing nr_cpu_ids instead of inventing another
> variable. If indeed any arch is depending on this being sparse, we can
> have a new variable similar to num_possible_cpus and also audit all
> users of num_possible_cpus to see whether they should be using
> nr_cpu_ids instead.

If my remember is correct, sparc does.


