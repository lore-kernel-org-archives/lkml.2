Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2LEMkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:40:08 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:36526 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2LEMkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:40:02 -0500
Message-ID: <50BF4047.50108@linux.vnet.ibm.com>
Date: Wed, 05 Dec 2012 18:08:31 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, sbw@mit.edu, tj@kernel.org,
        amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/10] CPU hotplug: Introduce "stable" cpu online
 mask, for atomic hotplug readers
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com> <20121204085324.25919.53090.stgit@srivatsabhat.in.ibm.com> <20121204141017.94a559f1.akpm@linux-foundation.org>
In-Reply-To: <20121204141017.94a559f1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120512-1618-0000-0000-000002F95BA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 03:40 AM, Andrew Morton wrote:
> On Tue, 04 Dec 2012 14:23:41 +0530
> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> From: Michael Wang <wangyun@linux.vnet.ibm.com>
>>
>> There are places where preempt_disable() is used to prevent any CPU from
>> going offline during the critical section. Let us call them as "atomic
>> hotplug readers" (atomic because they run in atomic contexts).
>>
>> Often, these atomic hotplug readers have a simple need : they want the cpu
>> online mask that they work with (inside their critical section), to be
>> stable, i.e., it should be guaranteed that CPUs in that mask won't go
>> offline during the critical section. An important point here is that they
>> don't really care if such a "stable" mask is a subset of the actual
>> cpu_online_mask.
>>
>> The intent of this patch is to provide such a "stable" cpu online mask
>> for that class of atomic hotplug readers.
>>
[...]
>>
>> ...
>>
>> @@ -705,12 +707,15 @@ extern const DECLARE_BITMAP(cpu_all_bits, NR_CPUS);
>>  
>>  #define for_each_possible_cpu(cpu) for_each_cpu((cpu), cpu_possible_mask)
>>  #define for_each_online_cpu(cpu)   for_each_cpu((cpu), cpu_online_mask)
>> +#define for_each_online_cpu_stable(cpu)					  \
>> +				for_each_cpu((cpu), cpu_online_stable_mask)
>>  #define for_each_present_cpu(cpu)  for_each_cpu((cpu), cpu_present_mask)
>>  
>>  /* Wrappers for arch boot code to manipulate normally-constant masks */
>>  void set_cpu_possible(unsigned int cpu, bool possible);
>>  void set_cpu_present(unsigned int cpu, bool present);
>>  void set_cpu_online(unsigned int cpu, bool online);
>> +void set_cpu_online_stable(unsigned int cpu, bool online);
> 
> The naming is inconsistent.  This is "cpu_online_stable", but
> for_each_online_cpu_stable() is "online_cpu_stable".  Can we make
> everything the same?
> 

I've actually gotten rid of the cpu_online_stable_mask in my new version
(which I'll post shortly), based on Tejun's suggestion.

>>  void set_cpu_active(unsigned int cpu, bool active);
>>  void init_cpu_present(const struct cpumask *src);
>>  void init_cpu_possible(const struct cpumask *src);
>>
>> ...
>>
>> +void get_online_cpus_stable_atomic(void)
>> +{
>> +	preempt_disable();
>> +	this_cpu_inc(hotplug_reader_refcount);
>> +
>> +	/*
>> +	 * Prevent reordering of writes to hotplug_reader_refcount and
>> +	 * reads from cpu_online_stable_mask.
>> +	 */
>> +	smp_mb();
>> +}
>> +EXPORT_SYMBOL_GPL(get_online_cpus_stable_atomic);
>> +
>> +void put_online_cpus_stable_atomic(void)
>> +{
>> +	/*
>> +	 * Prevent reordering of reads from cpu_online_stable_mask and
>> +	 * writes to hotplug_reader_refcount.
>> +	 */
>> +	smp_mb();
>> +	this_cpu_dec(hotplug_reader_refcount);
>> +	preempt_enable();
>> +}
>> +EXPORT_SYMBOL_GPL(put_online_cpus_stable_atomic);
>> +
>>  static struct {
>>  	struct task_struct *active_writer;
>>  	struct mutex lock; /* Synchronizes accesses to refcount, */
>> @@ -237,6 +304,44 @@ static inline void check_for_tasks(int cpu)
>>  	write_unlock_irq(&tasklist_lock);
>>  }
>>  
>> +/*
>> + * We want all atomic hotplug readers to refer to the new value of
>> + * cpu_online_stable_mask. So wait for the existing atomic hotplug readers
>> + * to complete. Any new atomic hotplug readers will see the updated mask
>> + * and hence pose no problems.
>> + */
>> +static void sync_hotplug_readers(void)
>> +{
>> +	unsigned int cpu;
>> +
>> +	for_each_online_cpu(cpu) {
>> +		while (per_cpu(hotplug_reader_refcount, cpu))
>> +			cpu_relax();
>> +	}
>> +}
> 
> That all looks solid to me.

Actually it isn't fully correct. For example, consider a reader such as this:

get_online_cpus_atomic_stable();

for_each_online_cpu_stable(cpu)
	do_operation_X();

for_each_online_cpu_stable(cpu)
	undo_operation_X();

put_online_cpus_atomic_stable();

Here, the stable mask is supposed to remain *unchanged* throughout the
entire duration of get/put_online_cpus_stable_atomic(). However, since the
hotplug writer updates the stable online mask without waiting for anything,
the reader can see updates to the stable mask *in-between* his critical section!
So he can end up doing operation_X() on CPUs 1, 2 and 3 and undoing the operation
on only CPUs 1 and 2, for example, because CPU 3 was removed from the stable
mask in the meantime, by the hotplug writer!

IOW, it actually breaks the fundamental guarantee that we set out to provide
in the first place! Of course, the usecase I gave above is hypothetical, but
it _is_ valid and important nevertheless, IMHO.

Anyway, the new version (which gets rid of the extra cpumask) won't get
into such issues. I actually have a version of the "extra cpumask" patchset
that fixes this particular issue using rwlocks (like Michael mentioned), but
I won't post it because IMHO it is much superior to provide the necessary
synchronization without using such extra cpumasks at all.

> 
>> +/*
>> + * We are serious about taking this CPU down. So clear the CPU from the
>> + * stable online mask.
>> + */
>> +static void prepare_cpu_take_down(unsigned int cpu)
>> +{
>> +	set_cpu_online_stable(cpu, false);
>> +
>> +	/*
>> +	 * Prevent reordering of writes to cpu_online_stable_mask and reads
>> +	 * from hotplug_reader_refcount.
>> +	 */
>> +	smp_mb();
>> +
>> +	/*
>> +	 * Wait for all active hotplug readers to complete, to ensure that
>> +	 * there are no critical sections still referring to the old stable
>> +	 * online mask.
>> +	 */
>> +	sync_hotplug_readers();
>> +}
> 
> I wonder about the cpu-online case.  A typical caller might want to do:
> 
> 
> /*
>  * Set each online CPU's "foo" to "bar"
>  */
> 
> int global_bar;
> 
> void set_cpu_foo(int bar)
> {
> 	get_online_cpus_stable_atomic();
> 	global_bar = bar;
> 	for_each_online_cpu_stable()
> 		cpu->foo = bar;
> 	put_online_cpus_stable_atomic()
> }
> 
> void_cpu_online_notifier_handler(void)
> {
> 	cpu->foo = global_bar;
> }
> 
> And I think that set_cpu_foo() would be buggy, because a CPU could come
> online before global_bar was altered, and that newly-online CPU would
> pick up the old value of `bar'.
> 
> So what's the rule here?  global_bar must be written before we run
> get_online_cpus_stable_atomic()?
> 
> Anyway, please have a think and spell all this out?
> 

Can I please skip this issue of CPUs coming online for now?

preempt_disable() along with stop_machine() never prevented CPUs from coming
online. It only prevented CPUs from going offline. The drop-in replacement
to stop_machine() should also provide that guarantee, at minimum. Later we
can either improvise it to also prevent CPU online, or probably come up with
suitable rules/conventions to deal with it.

In summary, I would like to have a solid replacement for stop_machine() as
the first goal. I hope that sounds reasonable...?

Regards,
Srivatsa S. Bhat

