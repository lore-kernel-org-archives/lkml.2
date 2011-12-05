Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1LEJM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:12:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab1LEJMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:12:24 -0500
Date: Mon, 5 Dec 2011 10:10:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Steffen Persvold <sp@numascale.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 3/3] v4: Add support for Numascale's NumaChip
Message-ID: <20111205091022.GA29006@elte.hu>
References: <4ED9199A.3060108@numascale-asia.com>
 <1323073238-32686-1-git-send-email-daniel@numascale-asia.com>
 <1323073238-32686-3-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323073238-32686-3-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel J Blueman <daniel@numascale-asia.com> wrote:

> From: Steffen Persvold <sp@numascale.com>
> 
> v2:
>  - [Steffen] enumerate only accessible northbridges
>  - [Daniel] rediffed and validated against 3.1-rc10
>  
> v3:
>  - [Daniel] use x86_init core numbering override
>  - [Daniel] cleanups as per feedback
> 
> v4:
>  - [Daniel] use updated x86_cpuinit override
>  
> Signed-off-by: Steffen Persvold <sp@numascale.com>
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  arch/x86/Kconfig                             |   12 +
>  arch/x86/include/asm/numachip/numachip_csr.h |  167 ++++++++++++++
>  arch/x86/kernel/apic/Makefile                |    1 +
>  arch/x86/kernel/apic/apic_numachip.c         |  312 ++++++++++++++++++++++++++
>  4 files changed, 492 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/include/asm/numachip/numachip_csr.h
>  create mode 100644 arch/x86/kernel/apic/apic_numachip.c

The patches are now structured mostly right and look clean.

Other small details i noticed:

> +static int numachip_system;
> +
> +static struct apic apic_numachip;

Those want to be __read_mostly - this also makes them more NUMA 
friendly .

> +static int __cpuinit numachip_wakeup_secondary(int phys_apicid, unsigned long start_rip)
> +{
> +#ifdef CONFIG_SMP
> +	union numachip_csr_g3_ext_irq_gen int_gen;
> +	unsigned long flags;
> +
> +	int_gen.s._destination_apic_id = phys_apicid;
> +	int_gen.s._vector = 0;
> +	int_gen.s._msgtype = APIC_DM_INIT >> 8;
> +	int_gen.s._index = 0;
> +
> +	local_irq_save(flags);
> +	write_lcsr(CSR_G3_EXT_IRQ_GEN, int_gen.v);
> +	local_irq_restore(flags);
> +
> +	mdelay(10);

Exactly why does it have to sleep 10 milliseconds here? Please 
document it.

> +
> +	int_gen.s._msgtype = APIC_DM_STARTUP >> 8;
> +	int_gen.s._vector = start_rip >> 12;
> +
> +	local_irq_save(flags);
> +	write_lcsr(CSR_G3_EXT_IRQ_GEN, int_gen.v);
> +	local_irq_restore(flags);
> +
> +	atomic_set(&init_deasserted, 1);
> +#endif
> +	return 0;

You could do a 'depends on SMP' and stop uglifying the code with 
!SMP considerations. Unless a single-core installation with a UP 
kernel is possible and desired.

> +static void numachip_send_IPI_allbutself(int vector)
> +{
> +	unsigned int this_cpu = smp_processor_id();
> +	unsigned int cpu;
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	for_each_online_cpu(cpu) {
> +		if (cpu != this_cpu)
> +			numachip_send_IPI_one(cpu, vector);
> +	}
> +	local_irq_restore(flags);
> +}

This seems preempt unsafe: you take smp_processor_id() before 
disabling hardirqs.

Thanks,

	Ingo
