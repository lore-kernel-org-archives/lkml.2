Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab0J1RXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:23:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40320 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999Ab0J1RXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:23:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6150"; a="59682008"
Message-ID: <4CC9B167.8010401@codeaurora.org>
Date: Thu, 28 Oct 2010 10:22:47 -0700
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm-owner@vger.kernel.org
Subject: Re: [RFC IRQ] genirq: fix handle_nested_irq for lazy disable
References: <1288144209-28086-1-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1010270909590.3100@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010270909590.3100@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
>> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
>> index baa5c4a..35ccc41 100644
>> --- a/kernel/irq/chip.c
>> +++ b/kernel/irq/chip.c
>> @@ -419,6 +419,7 @@ void handle_nested_irq(unsigned int irq)
>>  {
>>  	struct irq_desc *desc = irq_to_desc(irq);
>>  	struct irqaction *action;
>> +	int mask_this_irq = 0;
>>  	irqreturn_t action_ret;
>>  
>>  	might_sleep();
>> @@ -428,8 +429,10 @@ void handle_nested_irq(unsigned int irq)
>>  	kstat_incr_irqs_this_cpu(irq, desc);
>>  
>>  	action = desc->action;
>> -	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
>> +	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
>> +		mask_this_irq = 1;
>>  		goto out_unlock;
>> +	}
>>  
>>  	desc->status |= IRQ_INPROGRESS;
>>  	raw_spin_unlock_irq(&desc->lock);e
>> @@ -443,6 +446,11 @@ void handle_nested_irq(unsigned int irq)
>>  
>>  out_unlock:
>>  	raw_spin_unlock_irq(&desc->lock);
>> +	if (unlikely(mask_this_irq)) {
>> +		chip_bus_lock(irq, desc);
>> +		desc->chip->mask(irq);
> 
> That does not work with current mainline due to the irq_chip changes,
> can you please respin against linus latest?
Sure will address this in the next patch.
> 
> Also there is no requirement for irq_chip instances to implement the
> mask function, so this might crash the kernel for innocent users of
> that infrastructure. mask_irq() is your friend.
Thanks, this one too.
> 
> Aside of that this wont work for edge triggered interrupts, as you'd
> loose the edge, so this needs more thought and a thorough look at the
> users of handle_nested_irq().

I didn't understand this though. This patch will mask the interrupt in 
the controller even if it were edge. My interrupt controller latches
edges and wants a mask (or an ack) to be executed to deactivate the line 
summary line. Do you mean that I should mark the interrupt IRQ_PENDING 
if it were an edge before masking it? If not, can you please explain.

Thanks,
Abhijeet
