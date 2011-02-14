Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1BNPKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:10:07 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63658 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1BNPKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:10:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jgmFx9QlY5qfOBlKIDSUO5cMy35oxLpXxtHygZB8lZtkx74ZPdUaU16jkm/ytABOC1
         Xj+WRDfPCc+zru7AKzxuSPmGzIy/Xe4NWtEqUIAUlDkwTAo4oudTQOQ75rwJoZDNP6hr
         t9CHjbjDTfzI1WdvUUnoslj4xwZya6HV2aJFo=
Message-ID: <4D5945C8.4080108@gmail.com>
Date: Mon, 14 Feb 2011 18:10:00 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/2 -tip/master] x86, x2apic: minimize IPI register writes
 using cluster groups
References: <4D4B1835.10606@gmail.com> <20110214114515.GA9867@elte.hu>
In-Reply-To: <20110214114515.GA9867@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2011 02:45 PM, Ingo Molnar wrote:
>
> * Cyrill Gorcunov<gorcunov@gmail.com>  wrote:
>
>> In the case of x2apic cluster mode we can group IPI register writes based on the
>> cluster group instead of individual per-cpu destiantion messages. This reduces the
>> apic register writes and reduces the amount of IPI messages (in the best case we
>> can reduce it by a factor of 16).
>>
>> With this change, microbenchmark measuring the cost of flush_tlb_others(), with
>> the flush tlb IPI being sent from a cpu in the socket-1 to all the logical cpus in
>> socket-2 (on a Westmere-EX system that has 20 logical cpus in a socket) is 3x
>> times better now (compared to the former 'send one-by-one' algorithm).
>
> Pretty nice!
>
> I have a few structural and nitpicking comments:

Thanks a lot for review, Ingo! I'll address all the nits during this week.

...
>
>> +void x2apic_init_cpu_notifier(void)
>> +{
>> +	int cpu = smp_processor_id();
>>
>> +	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
>> +	zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
>> +	BUG_ON(!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu));
>
> Such a BUG_ON() is not particularly user friendly - and this could trigger during
> CPU hotplug events, i.e. while the system is fully booted up, right?
>
> Thanks,
>
> 	Ingo

Yup is not that much friendly but it's called during system bootup,
hotplug events are handled by

+static int __cpuinit
+cluster_setup(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	int err = 0;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
+		if (!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu)) {
+			free_cpumask_var(per_cpu(cpus_in_cluster, cpu));
+			free_cpumask_var(per_cpu(ipi_mask, cpu));
+			err = -ENOMEM;
+		}
+		break;

so it returns -ENOMEM if failed. And btw just noted that we forgot to make
x2apic_init_cpu_notifier being in __init section.

Or I miss something?

-- 
     Cyrill
