Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab2FPGNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:13:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52881 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab2FPGNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:13:06 -0400
MIME-Version: 1.0
In-Reply-To: <1339826183.9220.218.camel@pasglop>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
 <1339822897-15840-5-git-send-email-grant.likely@secretlab.ca> <1339826183.9220.218.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 16 Jun 2012 00:12:45 -0600
X-Google-Sender-Auth: 5LbY2jznthIUZd0LXh4S7iXLlK0
Message-ID: <CACxGe6vv5v6oDrJp6u9kJ0TrBUU0ZKNQ-88E_+Cp1k7ifMACsQ@mail.gmail.com>
Subject: Re: [PATCH 04/12] irqdomain: Eliminate dedicated radix lookup functions
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:56 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2012-06-15 at 23:01 -0600, Grant Likely wrote:
>> In preparation to remove the slow revmap path, eliminate the public
>> radix revmap lookup functions.  This simplifies the code and makes the
>> slowpath removal patch a lot simpler.
>
> The idea here was to avoid a test (performance in the fast path) since
> the controller knows the type of revmap it uses. You could just remove
> the fallback to the slow path if there's a mismatch and keep the WARN_ON
> no ? No biggie, it's just a switch/case with fairly predictable outcome
> I suppose ...

With some of the further refactoring, I'm hoping to reduce the number
of tests to even less than the original 'optimized' path did.  For
instance the linear lookup function still checked the domain type for
safety (although I think I probably added that test).  If there aren't
a whole bunch of different domain types, then the only test becomes
whether or not the hwirq is greater than the linear map size.  NOMAP
is still a wrench in the works though.

>
> A few other nits:
>
>>       return irq;
>> diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
>> index cd1d18d..9049d9f 100644
>> --- a/arch/powerpc/sysdev/xics/xics-common.c
>> +++ b/arch/powerpc/sysdev/xics/xics-common.c
>> @@ -329,9 +329,6 @@ static int xics_host_map(struct irq_domain *h, unsigned int virq,
>>
>>       pr_devel("xics: map virq %d, hwirq 0x%lx\n", virq, hw);
>>
>> -     /* Insert the interrupt mapping into the radix tree for fast lookup */
>> -     irq_radix_revmap_insert(xics_host, virq, hw);
>> -
>>       /* They aren't all level sensitive but we just don't really know */
>>       irq_set_status_flags(virq, IRQ_LEVEL);
>
> This looks like it belongs in a different patch, possibly "[02/12]
> irqdomain: Always update revmap when setting up a virq" no ?
>
>> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
>> index 3425631..d8b88c5 100644
>> --- a/include/linux/irqdomain.h
>> +++ b/include/linux/irqdomain.h
>> @@ -169,10 +169,6 @@ static inline int irq_create_identity_mapping(struct irq_domain *host,
>>       return irq_create_strict_mappings(host, hwirq, hwirq, 1);
>>  }
>>
>> -extern void irq_radix_revmap_insert(struct irq_domain *host, unsigned int virq,
>> -                                 irq_hw_number_t hwirq);
>> -extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
>> -                                         irq_hw_number_t hwirq);
>>  extern unsigned int irq_linear_revmap(struct irq_domain *host,
>>                                     irq_hw_number_t hwirq);
>>
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>> index 1a8f3d2..79a7711 100644
>> --- a/kernel/irq/irqdomain.c
>> +++ b/kernel/irq/irqdomain.c
>> @@ -415,7 +415,9 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
>>                               domain->revmap_data.linear.revmap[hwirq] = virq;
>>                       break;
>>               case IRQ_DOMAIN_MAP_TREE:
>> -                     irq_radix_revmap_insert(domain, virq, hwirq);
>> +                     mutex_lock(&revmap_trees_mutex);
>> +                     radix_tree_insert(&domain->revmap_data.tree, hwirq, irq_data);
>> +                     mutex_unlock(&revmap_trees_mutex);
>>                       break;
>>               }
>
> That too looks like it belongs in another patch.

Okay, I'll take a look at those.

g.
