Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab1LEOJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 09:09:30 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:51714 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab1LEOJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 09:09:29 -0500
X-Greylist: delayed 15612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Dec 2011 09:09:29 EST
Message-ID: <4EDC938D.6000304@numascale.com>
Date: Mon, 05 Dec 2011 10:49:01 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/3] v4: Add support for Numascale's NumaChip
References: <4ED9199A.3060108@numascale-asia.com> <1323073238-32686-1-git-send-email-daniel@numascale-asia.com> <1323073238-32686-3-git-send-email-daniel@numascale-asia.com> <20111205091022.GA29006@elte.hu>
In-Reply-To: <20111205091022.GA29006@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/2011 10:10, Ingo Molnar wrote:
[]
>
> The patches are now structured mostly right and look clean.

Thanks for the review!

>
> Other small details i noticed:
>
>> +static int numachip_system;
>> +
>> +static struct apic apic_numachip;
>
> Those want to be __read_mostly - this also makes them more NUMA
> friendly .

Ok, makes sense.

>
>> +static int __cpuinit numachip_wakeup_secondary(int phys_apicid, unsigned long start_rip)
>> +{
>> +#ifdef CONFIG_SMP
>> +	union numachip_csr_g3_ext_irq_gen int_gen;
>> +	unsigned long flags;
>> +
>> +	int_gen.s._destination_apic_id = phys_apicid;
>> +	int_gen.s._vector = 0;
>> +	int_gen.s._msgtype = APIC_DM_INIT>>  8;
>> +	int_gen.s._index = 0;
>> +
>> +	local_irq_save(flags);
>> +	write_lcsr(CSR_G3_EXT_IRQ_GEN, int_gen.v);
>> +	local_irq_restore(flags);
>> +
>> +	mdelay(10);
>
> Exactly why does it have to sleep 10 milliseconds here? Please
> document it.

It doesn't. I'm not quite sure why it was left in there.. We will remove 
it. Thanks for catching it.

>
>> +
>> +	int_gen.s._msgtype = APIC_DM_STARTUP>>  8;
>> +	int_gen.s._vector = start_rip>>  12;
>> +
>> +	local_irq_save(flags);
>> +	write_lcsr(CSR_G3_EXT_IRQ_GEN, int_gen.v);
>> +	local_irq_restore(flags);
>> +
>> +	atomic_set(&init_deasserted, 1);
>> +#endif
>> +	return 0;
>
> You could do a 'depends on SMP' and stop uglifying the code with
> !SMP considerations. Unless a single-core installation with a UP
> kernel is possible and desired.

Agreed.

>
>> +static void numachip_send_IPI_allbutself(int vector)
>> +{
>> +	unsigned int this_cpu = smp_processor_id();
>> +	unsigned int cpu;
>> +	unsigned long flags;
>> +
>> +	local_irq_save(flags);
>> +	for_each_online_cpu(cpu) {
>> +		if (cpu != this_cpu)
>> +			numachip_send_IPI_one(cpu, vector);
>> +	}
>> +	local_irq_restore(flags);
>> +}
>
> This seems preempt unsafe: you take smp_processor_id() before
> disabling hardirqs.

Hmm, yes. Again some debug stuff laying around, local_irq_save/restore 
isn't really needed there I think.

We will redo this last patch and re-send after testing. Thanks!

Kind regards,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
