Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2ECC16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 22:27:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35763 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2ECC14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 22:27:56 -0400
Message-ID: <4FA1ED1E.9000109@gmail.com>
Date: Thu, 03 May 2012 10:27:42 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: use local var instead of local_paca->irq_happened
 directly in __check_irq_replay
References: <4FA1E527.1090807@gmail.com> <1336011306.2653.3.camel@pasglop>
In-Reply-To: <1336011306.2653.3.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012年05月03日 10:15, Benjamin Herrenschmidt wrote:
> On Thu, 2012-05-03 at 09:53 +0800, Wang Sheng-Hui wrote:
>> local_paca->irq_happened may be changed asychronously. 
>>
>> In my test env (IBM Power 9117-MMA), I installed the RHEL6.2 with the shipped
>> oprofile. Then I run into kernel v3.4-rc4, setup/start oprofile and start the
>> LTP test suite.
>>
>> In a short while, the system would crash. Seems that oprofile may change
>> the irq_happened.
> 
>  .../...
> 
>> Use local var instead of local_paca->irq_happened directly in this function here.
>>
>> Please check this patch. Any comments are welcome.
> 
> It should not as __check_irq_replay() should always be called
> with interrupts hard disabled... Do you see any code path
> where that is not the case ?

This is the only case.
I have run LTP test suite on my system without oprofile over 24 hours
with 3.4-rc4 kernel. 
Then I started oprofile, and the system crashed quickly.

I wonder if oprofile does some special changes with the running.
But I'm not familiar with the internal of oprofile.

I tried to change BUG_ON to WARN_ON, and got lots of warnning messages
in dmesg. So I changed it to local var here.


> 
> Cheers,
> Ben.
> 
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  arch/powerpc/kernel/irq.c |   46 +++++++++++++++++++++++++++++---------------
>>  1 files changed, 30 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
>> index 5ec1b23..3d48b23 100644
>> --- a/arch/powerpc/kernel/irq.c
>> +++ b/arch/powerpc/kernel/irq.c
>> @@ -137,15 +137,17 @@ static inline notrace int decrementer_check_overflow(void)
>>   */
>>  notrace unsigned int __check_irq_replay(void)
>>  {
>> +	unsigned int ret_val;
>>  	/*
>>  	 * We use local_paca rather than get_paca() to avoid all
>>  	 * the debug_smp_processor_id() business in this low level
>>  	 * function
>>  	 */
>> -	unsigned char happened = local_paca->irq_happened;
>> +	unsigned char happened, irq_happened;
>> +	happened = irq_happened = local_paca->irq_happened;
>>  
>>  	/* Clear bit 0 which we wouldn't clear otherwise */
>> -	local_paca->irq_happened &= ~PACA_IRQ_HARD_DIS;
>> +	irq_happened &= ~PACA_IRQ_HARD_DIS;
>>  
>>  	/*
>>  	 * Force the delivery of pending soft-disabled interrupts on PS3.
>> @@ -161,33 +163,45 @@ notrace unsigned int __check_irq_replay(void)
>>  	 * decrementer itself rather than the paca irq_happened field
>>  	 * in case we also had a rollover while hard disabled
>>  	 */
>> -	local_paca->irq_happened &= ~PACA_IRQ_DEC;
>> -	if (decrementer_check_overflow())
>> -		return 0x900;
>> +	irq_happened &= ~PACA_IRQ_DEC;
>> +	if (decrementer_check_overflow()) {
>> +		ret_val = 0x900;
>> +		goto replay;
>> +	}
>>  
>>  	/* Finally check if an external interrupt happened */
>> -	local_paca->irq_happened &= ~PACA_IRQ_EE;
>> -	if (happened & PACA_IRQ_EE)
>> -		return 0x500;
>> +	irq_happened &= ~PACA_IRQ_EE;
>> +	if (happened & PACA_IRQ_EE) {
>> +		ret_val = 0x500;
>> +		goto replay;
>> +	}
>>  
>>  #ifdef CONFIG_PPC_BOOK3E
>>  	/* Finally check if an EPR external interrupt happened
>>  	 * this bit is typically set if we need to handle another
>>  	 * "edge" interrupt from within the MPIC "EPR" handler
>>  	 */
>> -	local_paca->irq_happened &= ~PACA_IRQ_EE_EDGE;
>> -	if (happened & PACA_IRQ_EE_EDGE)
>> -		return 0x500;
>> +	irq_happened &= ~PACA_IRQ_EE_EDGE;
>> +	if (happened & PACA_IRQ_EE_EDGE) {
>> +		ret_val = 0x500;
>> +		goto replay;
>> +	}
>>  
>> -	local_paca->irq_happened &= ~PACA_IRQ_DBELL;
>> -	if (happened & PACA_IRQ_DBELL)
>> -		return 0x280;
>> +	irq_happened &= ~PACA_IRQ_DBELL;
>> +	if (happened & PACA_IRQ_DBELL) {
>> +		ret_val = 0x280;
>> +		goto replay;
>> +	}
>>  #endif /* CONFIG_PPC_BOOK3E */
>>  
>>  	/* There should be nothing left ! */
>> -	BUG_ON(local_paca->irq_happened != 0);
>> +	BUG_ON(irq_happened != 0);
>> +	ret_val = 0;
>>  
>> -	return 0;
>> +replay:
>> +	local_paca->irq_happened = irq_happened;
>> +
>> +	return ret_val;
>>  }
>>  
>>  notrace void arch_local_irq_restore(unsigned long en)
> 
> 

