Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1BOIjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 03:39:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56733 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1BOIjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 03:39:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eWZ4QSprzn6bWZsJuS36llncoq4/vxhITGL/dA5saiUTH9820iGjJCmRktI5kR2u9H
         nKAU1AMxmjD76+oiWrq3eecoFzxbUf5rAb1jEWtuLzuGiVGvUxvtnS6dPvWABa6o90Jj
         GgSE+ZR+hjjepy7yOhx8I6h6INkiYHnFHKbs4=
MIME-Version: 1.0
In-Reply-To: <20110215032259.GA8489@elte.hu>
References: <4D4B1835.10606@gmail.com>
	<20110214114515.GA9867@elte.hu>
	<4D5945C8.4080108@gmail.com>
	<20110215032259.GA8489@elte.hu>
Date: Tue, 15 Feb 2011 11:39:10 +0300
Message-ID: <AANLkTiknLx8-SisY6it_1YitKp-HOPAt7ch5BG4=xbv-@mail.gmail.com>
Subject: Re: [RFC 1/2 -tip/master] x86, x2apic: minimize IPI register writes
 using cluster groups
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/11, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> On 02/14/2011 02:45 PM, Ingo Molnar wrote:
>> >
>> >* Cyrill Gorcunov<gorcunov@gmail.com>  wrote:
>> >
>> >>In the case of x2apic cluster mode we can group IPI register writes
>> >> based on the
>> >>cluster group instead of individual per-cpu destiantion messages. This
>> >> reduces the
>> >>apic register writes and reduces the amount of IPI messages (in the best
>> >> case we
>> >>can reduce it by a factor of 16).
>> >>
>> >>With this change, microbenchmark measuring the cost of
>> >> flush_tlb_others(), with
>> >>the flush tlb IPI being sent from a cpu in the socket-1 to all the
>> >> logical cpus in
>> >>socket-2 (on a Westmere-EX system that has 20 logical cpus in a socket)
>> >> is 3x
>> >>times better now (compared to the former 'send one-by-one' algorithm).
>> >
>> >Pretty nice!
>> >
>> >I have a few structural and nitpicking comments:
>>
>> Thanks a lot for review, Ingo! I'll address all the nits during this week.
>>
>> ...
>> >
>> >>+void x2apic_init_cpu_notifier(void)
>> >>+{
>> >>+	int cpu = smp_processor_id();
>> >>
>> >>+	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
>> >>+	zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
>> >>+	BUG_ON(!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu));
>> >
>> >Such a BUG_ON() is not particularly user friendly - and this could
>> > trigger during
>> >CPU hotplug events, i.e. while the system is fully booted up, right?
>> >
>> >Thanks,
>> >
>> >	Ingo
>>
>> Yup is not that much friendly but it's called during system bootup,
>> hotplug events are handled by
>>
>> +static int __cpuinit
>> +cluster_setup(struct notifier_block *nfb, unsigned long action, void
>> *hcpu)
>> +{
>> +	unsigned int cpu = (unsigned long)hcpu;
>> +	int err = 0;
>> +
>> +	switch (action) {
>> +	case CPU_UP_PREPARE:
>> +		zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
>> +		zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
>> +		if (!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu)) {
>> +			free_cpumask_var(per_cpu(cpus_in_cluster, cpu));
>> +			free_cpumask_var(per_cpu(ipi_mask, cpu));
>> +			err = -ENOMEM;
>> +		}
>> +		break;
>>
>> so it returns -ENOMEM if failed. And btw just noted that we forgot to make
>> x2apic_init_cpu_notifier being in __init section.
>>
>> Or I miss something?
>
> Is there no GFP_NOFAIL or GFP_FAIL_ON_PANIC variant that could be used the
> 'must not
> fail' property of the boot-time allocation?
>
> Thanks,
>
> 	Ingo
>

If only i'm not missing something obvious we can set GFP_NOFAIL ending
in endless loop if allocation failed (slab should be already running
at this point of boot). Probably another option might be to switch to
no-apic mode if there is no enough memory to allocate this masks
(though i guess if allocation failed at this point we likely to fail
in further allocations in kernel anyway)
