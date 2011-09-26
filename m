Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1IZBbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 21:31:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26621 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab1IZBbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 21:31:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6480"; a="121455604"
Message-ID: <4E7FD5FD.5070103@codeaurora.org>
Date: Sun, 25 Sep 2011 18:31:41 -0700
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id interrupts
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com>	<1316105551-17505-2-git-send-email-marc.zyngier@arm.com>	<4E767CD6.6090208@codeaurora.org> <4E770B3E.9040401@arm.com>
In-Reply-To: <4E770B3E.9040401@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 02:28 AM, Marc Zyngier wrote:
> On 19/09/11 00:20, Abhijeet Dharmapurikar wrote:
>> On 09/15/2011 09:52 AM, Marc Zyngier wrote:
...
>>   >  + *  @devname: An ascii name for the claiming device
>>   >  + *  @dev_id: A percpu cookie passed back to the handler function
>>   >  + *
>>   >  + *  This call allocates interrupt resources, but doesn't
>>   >  + *  automatically enable the interrupt. It has to be done on each
>>   >  + *  CPU using enable_percpu_irq().
>>   >  + *
>>   >  + *  Dev_id must be globally unique. It is a per-cpu variable, and
>>   >  + *  the handler gets called with the interrupted CPU's instance of
>>   >  + *  that variable.
>>   >  + */
>>   >  +int request_percpu_irq(unsigned int irq, irq_handler_t handler,
>>   >  +                   const char *devname, void __percpu *dev_id)
>>
>> Can we add irqflags argument. I think it will be useful to pass flags,
>> at least the IRQF_TRIGGER_MASK since it ends up calling __setup_irq().
>> The chip could use a set_type callback for ppi's too.
>
> We're entering dangerous territory here. While this would work with the
> GIC (the interrupt type is at the distributor level), you could easily
> imagine an interrupt controller with the PPI configuration at the CPU
> interface level... In that case, calling set_type from __setup_irq()
> would end up doing the wrong thing, and I'd hate the API to give the
> idea it can do things it may not do in the end...
>
> Furthermore, do we actually have a GIC implementation where PPI
> configuration isn't read-only? I only know about the ARM implementation,
> and the Qualcomm may well be different (the spec says it's
> implementation defined).

Yes, you are exactly right, Qualcomm's GIC has configurable PPIs. The 
default configuration for PPI's is level triggered, but we change the 
timer PPI to edge trigger. Without this we wont even boot (no timer
interrupts). We do this trigger type setting in board specific code.

Although I agree with your concern, I would still request to provide a 
facility to set the trigger flags. All the PPI's request will have that 
argument set to zero, except for msm timer (and few other msm 
interrupts). Additionally we can add that concern as a comment in 
request_percpu_irq so the user of request_percpu_irq is aware of it.


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
