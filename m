Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab0D3SlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:41:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:16535 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089Ab0D3RVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,303,1270450800"; 
   d="scan'208";a="514015003"
Date: Fri, 30 Apr 2010 09:41:23 -0700 (Pacific Daylight Time)
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: "davem@davemloft.net" <davem@davemloft.net>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH linux-next v2 1/2] irq: Add CPU mask affinity hint
In-Reply-To: <alpine.LFD.2.00.1004301249540.2951@localhost.localdomain>
Message-ID: <Pine.WNT.4.64.1004300939510.1892@PPWASKIE-MOBL2.amr.corp.intel.com>
References: <20100430085150.4630.46790.stgit@ppwaskie-hc2.jf.intel.com>
 <alpine.LFD.2.00.1004301249540.2951@localhost.localdomain>
X-X-Sender: ppwaskie@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Apr 2010, Thomas Gleixner wrote:

> On Fri, 30 Apr 2010, Peter P Waskiewicz Jr wrote:
>
>> This patch adds a cpumask affinity hint to the irq_desc
>> structure, along with a registration function and a read-only
>> proc entry for each interrupt.
>>
>> This affinity_hint handle for each interrupt can be used by
>> underlying drivers that need a better mechanism to control
>> interrupt affinity.  The underlying driver can register a
>> cpumask for the interrupt, which will allow the driver to
>> provide the CPU mask for the interrupt to anything that
>> requests it.  The intent is to extend the userspace daemon,
>> irqbalance, to help hint to it a preferred CPU mask to balance
>> the interrupt into.
>>
>> Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
>> ---
>>
>>  include/linux/interrupt.h |   13 +++++++++++++
>>  include/linux/irq.h       |    1 +
>>  kernel/irq/manage.c       |   28 ++++++++++++++++++++++++++++
>>  kernel/irq/proc.c         |   33 +++++++++++++++++++++++++++++++++
>>  4 files changed, 75 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index 75f3f00..9c9ea2a 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -209,6 +209,9 @@ extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
>>  extern int irq_can_set_affinity(unsigned int irq);
>>  extern int irq_select_affinity(unsigned int irq);
>>
>> +extern int irq_register_affinity_hint(unsigned int irq,
>> +                                      const struct cpumask *m);
>
> I think we can do with a single funtion irq_set_affinity_hint() and
> let the caller set the pointer to NULL.

That works too.  I like it.  :-)

>
>>
>> +int irq_register_affinity_hint(unsigned int irq, const struct cpumask *m)
>> +{
>> +	struct irq_desc *desc = irq_to_desc(irq);
>> +	unsigned long flags;
>
>  desc needs to be checked. It might be NULL !

Doh, good point!

>
>> +
>> +	raw_spin_lock_irqsave(&desc->lock, flags);
>> +	desc->affinity_hint = m;
>> +	raw_spin_unlock_irqrestore(&desc->lock, flags);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(irq_register_affinity_hint);
>
>  EXPORT_SYMBOL_GPL please

Will do.

>
>> +static int irq_affinity_hint_proc_show(struct seq_file *m, void *v)
>> +{
>> +	struct irq_desc *desc = irq_to_desc((long)m->private);
>> +	unsigned long flags;
>> +	int ret = -EINVAL;
>> +
>> +	raw_spin_lock_irqsave(&desc->lock, flags);
>> +	if (desc->affinity_hint) {
>> +		seq_cpumask(m, desc->affinity_hint);
>
>  Please make a local copy under desc->mask and do the seq_cpumask()
>  stuff on the local copy outside of desc->lock

Will do.

Cheers,

-PJ
