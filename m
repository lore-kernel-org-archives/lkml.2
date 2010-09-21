Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0IUXOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:14:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18942 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0IUXOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:14:05 -0400
Message-ID: <4C993BE1.1020506@kernel.org>
Date: Tue, 21 Sep 2010 16:12:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jack Steiner <steiner@sgi.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 - irq vector assignment
References: <20100921200502.GA26587@sgi.com> <AANLkTinkiZC6bvRJ10EsG-CZSjdJtqW4N7pfq7vnvz3i@mail.gmail.com> <alpine.LFD.2.00.1009212310410.2416@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1009212310410.2416@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 02:34 PM, Thomas Gleixner wrote:
> On Tue, 21 Sep 2010, Yinghai Lu wrote:
>>>  arch/x86/kernel/apic/io_apic.c |    5 +++++
>>>  1 file changed, 5 insertions(+)
>>>
>>> Index: linux/arch/x86/kernel/apic/io_apic.c
>>> ===================================================================
>>> --- linux.orig/arch/x86/kernel/apic/io_apic.c   2010-09-17 13:00:19.164638447 -0500
>>> +++ linux/arch/x86/kernel/apic/io_apic.c        2010-09-17 13:00:23.448595373 -0500
>>> @@ -3253,6 +3253,11 @@ unsigned int create_irq_nr(unsigned int
>>>                desc_new = move_irq_desc(desc_new, node);
>>>                cfg_new = desc_new->chip_data;
>>>
>>> +#ifdef CONFIG_NUMA
>>> +               if (node >= 0 && __assign_irq_vector(new, cfg_new, node_to_cpumask_map[node]) == 0)
>>> +                       irq = new;
>>> +               else
>>> +#endif
>>>                if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
>>>                        irq = new;
>>>                break;
>>
>> target_cpus() for uv_x and x2apic phys mode all have cpu_online_mask()
>>
>> so we should get the vector for other cpus. aka __assign_irq_vector()
>> should not fail. unless you have so many irq > nr_irqs.
> 
> Did you even read the changelog ? It's not about "should".
> 
> All CPU0 vectors are assigned already just because the current code
> takes the first cpu in the target_cpus mask regardless of the node on
> which the irq_desc is allocated. That's crap. Why do we allocate
> irq_desc on node and leave the vector assigned to node(cpu0) ?

 ok, i got it. vectors from cpus on node0 are used by devices from others nodes.
later devices from node0 can not get vector from node0.

Yinghai
