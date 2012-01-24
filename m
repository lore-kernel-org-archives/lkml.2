Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2AXVBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:01:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43540 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab2AXVBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:01:44 -0500
MIME-Version: 1.0
In-Reply-To: <4F1F04E8.6000603@linux.vnet.ibm.com>
References: <CABeCy1bgRe8=KKimBtB39F9KaJko=aD7xqYfAT0t6YcS6CMLZA@mail.gmail.com>
	<1327372455-1383-1-git-send-email-venki@google.com>
	<4F1F04E8.6000603@linux.vnet.ibm.com>
Date: Tue, 24 Jan 2012 13:01:44 -0800
Message-ID: <CABeCy1ZA1nkWSmbN2LE+V1SxKEHX4XrpN5xfdzY=NSsS8=L0DA@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus -v3
From: Venki Pallipadi <venki@google.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:22 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 01/24/2012 08:04 AM, Venkatesh Pallipadi wrote:
>
>> Kernel's notion of possible cpus (from include/linux/cpumask.h)
>>  *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
>>
>>  *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
>>  *  that it is possible might ever be plugged in at anytime during the
>>  *  life of that system boot.
>>
>>  #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)
>>
>> and on x86 cpumask_weight() calls hweight64 and hweight64 (on older kernels
>> and systems with !X86_FEATURE_POPCNT) or a popcnt based alternative.
>>
>> i.e, We needlessly go through this mask based calculation everytime
>> num_possible_cpus() is called.
>>
>> The problem is there with cpu_online_mask() as well, which is fixed value at
>> boot time in !CONFIG_HOTPLUG_CPU case and should not change that often even
>> in HOTPLUG case.
>>
>> Though most of the callers of these two routines are init time (with few
>> exceptions of runtime calls), it is cleaner to use variables
>> and not go through this repeated mask based calculation.
>>
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>> ---
>>  arch/x86/kernel/smpboot.c |    2 +-
>>  include/linux/cpumask.h   |   10 ++++++++--
>>  kernel/cpu.c              |    5 +++++
>>  kernel/smp.c              |    4 ++++
>>  4 files changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index 66d250c..f87fcde 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -947,7 +947,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
>>                       nr++;
>>               }
>>
>> -             nr_cpu_ids = 8;
>> +             setup_nr_cpu_ids();
>>       }
>>  #endif
>>
>> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
>> index 4f7a632..ac3113b 100644
>> --- a/include/linux/cpumask.h
>> +++ b/include/linux/cpumask.h
>> @@ -23,10 +23,14 @@ typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
>>
>>  #if NR_CPUS == 1
>>  #define nr_cpu_ids           1
>> +#define nr_possible_cpus     1
>>  #else
>>  extern int nr_cpu_ids;
>> +extern int nr_possible_cpus;
>>  #endif
>>
>> +extern int nr_online_cpus;
>> +
>>  #ifdef CONFIG_CPUMASK_OFFSTACK
>>  /* Assuming NR_CPUS is huge, a runtime limit is more efficient.  Also,
>>   * not all bits may be allocated. */
>> @@ -81,8 +85,10 @@ extern const struct cpumask *const cpu_present_mask;
>>  extern const struct cpumask *const cpu_active_mask;
>>
>>  #if NR_CPUS > 1
>> -#define num_online_cpus()    cpumask_weight(cpu_online_mask)
>> -#define num_possible_cpus()  cpumask_weight(cpu_possible_mask)
>> +
>> +#define num_online_cpus()    (nr_online_cpus)
>> +#define num_possible_cpus()  (nr_possible_cpus)
>> +
>>  #define num_present_cpus()   cpumask_weight(cpu_present_mask)
>>  #define num_active_cpus()    cpumask_weight(cpu_active_mask)
>>  #define cpu_online(cpu)              cpumask_test_cpu((cpu), cpu_online_mask)
>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>> index 2060c6e..f179baa 100644
>> --- a/kernel/cpu.c
>> +++ b/kernel/cpu.c
>> @@ -622,6 +622,9 @@ static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
>>  const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
>>  EXPORT_SYMBOL(cpu_active_mask);
>>
>> +int nr_online_cpus __read_mostly;
>> +EXPORT_SYMBOL(nr_online_cpus);
>> +
>>  void set_cpu_possible(unsigned int cpu, bool possible)
>>  {
>>       if (possible)
>> @@ -644,6 +647,8 @@ void set_cpu_online(unsigned int cpu, bool online)
>>               cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
>>       else
>>               cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
>> +
>> +     nr_online_cpus = cpumask_weight(cpu_online_mask);
>>  }
>>
>>  void set_cpu_active(unsigned int cpu, bool active)
>> diff --git a/kernel/smp.c b/kernel/smp.c
>> index db197d6..106e519 100644
>> --- a/kernel/smp.c
>> +++ b/kernel/smp.c
>> @@ -658,10 +658,14 @@ early_param("maxcpus", maxcpus);
>>  int nr_cpu_ids __read_mostly = NR_CPUS;
>>  EXPORT_SYMBOL(nr_cpu_ids);
>>
>> +int nr_possible_cpus __read_mostly = NR_CPUS;
>> +EXPORT_SYMBOL(nr_possible_cpus);
>> +
>>  /* An arch may set nr_cpu_ids earlier if needed, so this would be redundant */
>>  void __init setup_nr_cpu_ids(void)
>>  {
>>       nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
>> +     nr_possible_cpus = cpumask_weight(cpu_possible_mask);
>>  }
>>
>>  /* Called by boot processor to activate the rest. */
>
>
>
> This patch still has problems, IMHO.
>
> A quick grep on the source for set_cpu_possible() revealed the following
> problematic areas:
> 1. arch/alpha/kernel/process.c: common_shutdown_1()
>   set_cpu_possible() with second parameter as 'false' is used here.
>   Though this is the shutdown code, a disparity between what
>   num_possible_cpus() reports and what is actually there in
>   cpu_possible_mask is not such a good idea, at any point in time.
>
> 2. arch/cris/arch-v32/kernel/smp.c: smp_prepare_boot_cpu()
>   smp_prepare_boot_cpu() is called after setup_nr_cpu_ids().
>
>   (Btw, I think things are really messed up in cris as it is, if I am not
>   totally mistaken).
>
> 3. arch/mn10300/kernel/smp.c: smp_prepare_cpus()
>   This function calls set_cpu_possible(). smp_prepare_cpus() is called in
>   kernel_init(), which is much later than setup_nr_cpu_ids().
>
> 4. arch/um/kernel/smp.c: smp_prepare_cpus()
>   Same as in 3.
>
> 5. As far as arch/x86/xen is concerned, I can see code such as the following,
>   among other things:
>
>    xen_smp_prepare_cpus():
>
>    /* Restrict the possible_map according to max_cpus. */
>    while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
>            for (cpu = nr_cpu_ids - 1; !cpu_possible(cpu); cpu--)
>                    continue;
>            set_cpu_possible(cpu, false);
>    }
>
> If I am not missing anything obvious, applying this patch can effectively
> convert the above code into an infinite loop, among other damages!
>
> I still feel it would be safer to edit set_cpu_possible() such that
> nr_possible_cpus is updated whenever cpu_possible_mask is altered.
>

With the xen example above you have easily convinced me to not mess
with this code too much.
Will go back to the drawing board looking for simplest possible change.
Thanks again for being vigilant about this.

-Venki

> Regards,
> Srivatsa S. Bhat
> IBM Linux Technology Center
>
