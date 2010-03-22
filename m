Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0CVDeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 23:34:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:37401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0CVDeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 23:34:19 -0400
Message-ID: <4BA6E4D1.6080704@kernel.org>
Date: Sun, 21 Mar 2010 20:32:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, lguest@ozlabs.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Campbell <ian.campbell@citrix.com>,
       Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 01/10] irq: move some interrupt arch_* functions into
 struct irq_chip.
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>	 <1269221770-9667-2-git-send-email-yinghai@kernel.org> <1269222962.3534.12.camel@concordia>
In-Reply-To: <1269222962.3534.12.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2010 06:56 PM, Michael Ellerman wrote:
> On Sun, 2010-03-21 at 18:36 -0700, Yinghai Lu wrote:
>> From: Ian Campbell <ian.campbell@citrix.com>
> ...
>> To replace the x86 arch_init_chip_data functionality
>> irq_to_desc_alloc_node now takes a pointer to a function to allocate
>> the chip data. This is necessary to ensure the allocation happens
>> under the correct locking at the core level. On PowerPC and SH
>> architectures (the other users of irq_to_desc_alloc_node) pass in NULL
>> which retains existing chip_data behaviour.
> ...
>>
>> -v4: yinghai add irq_to_desc_alloc_node_x...
>>      so could leave default path not changed...
> 
> Apologies for not noticing this sooner, but ..
> 
>> --- a/arch/powerpc/kernel/irq.c
>> +++ b/arch/powerpc/kernel/irq.c
>> @@ -1088,7 +1088,7 @@ int arch_early_irq_init(void)
>>  	return 0;
>>  }
>>  
>> -int arch_init_chip_data(struct irq_desc *desc, int node)
>> +int arch_init_irq_desc(struct irq_desc *desc, int node, init_chip_data_fn fn)
>>  {
>>  	desc->status |= IRQ_NOREQUEST;
>>  	return 0;
> 
> This is a bit feral, that is the init_chip_data_fn.
> 
> It seems like it only exists to support the following on x86:
> 
>> +int arch_init_irq_desc(struct irq_desc *desc, int node,
>> +			 init_chip_data_fn init_chip_data)
>> +{
>> +	if (!init_chip_data)
>> +		return x86_init_chip_data(desc, node);
>> +
>> +	return init_chip_data(desc, node);
>> +}
> 
> Which is really just a hack to avoid an if (xen) check isn't it?

 arch/powerpc/kernel/irq.c      |    2 +-

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 64f6f20..cafd378 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -1088,7 +1088,7 @@ int arch_early_irq_init(void)
 	return 0;
 }
 
-int arch_init_chip_data(struct irq_desc *desc, int node)
+int arch_init_irq_desc(struct irq_desc *desc, int node, init_chip_data_fn fn)
 {
 	desc->status |= IRQ_NOREQUEST;
 	return 0;

so this patch only change one line with powerpc code. 
> 
> It looks to me like this should just be done via a current machine
> vector or platform routine, in the same way as powerpc and (I think)
> ia64, ie:
> 
>> +int arch_init_irq_desc(struct irq_desc *desc, int node)
>> +{
>> +	return current_machine->init_chip_data(desc, node);
>> +}
> 
looks like xen in same run time, some irqs need x86_init_chip_data,
and some may need xen_init_chip_data later.

Thanks

Yinghai
