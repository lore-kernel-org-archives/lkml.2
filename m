Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3AAKqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 05:46:24 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:40851 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3AAKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 05:46:22 -0500
Message-ID: <50E2BE71.6010100@synopsys.com>
Date: Tue, 1 Jan 2013 16:16:09 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v1 12/31] ARC: Interrupt Handling
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <1352281674-2186-13-git-send-email-vgupta@synopsys.com> <alpine.LFD.2.02.1211122059101.10000@ionos>
In-Reply-To: <alpine.LFD.2.02.1211122059101.10000@ionos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2012 01:38 AM, Thomas Gleixner wrote:
> On Wed, 7 Nov 2012, Vineet Gupta wrote:
>> +void __init init_IRQ(void)
>> +{
>> +	const int irq = TIMER0_IRQ;
>> +
>> +	/*
>> +	 * Each CPU needs to register irq of it's private TIMER0.
>> +	 * The APIs request_percpu_irq()/enable_percpu_irq() will not be
>> +	 * functional, if we don't "prep" the generic IRQ sub-system with
>> +	 * the following:
>> +	 * -Ensure that devid passed to request_percpu_irq() is indeed per cpu
>> +	 * -disable NOAUTOEN, w/o which the device handler never gets called
> 
> What sets NOAUTOEN in the first place? The core code definitely does
> not.

So this is based off of my orig 3.2 port and I can see similar flow even in 3.7

(1) start_kernel
     early_irq_initd
       desc_set_defaults
         irqd_set(IRQD_IRQ_DISAB)

(2) For setting up IRQ dev to be per-cpu
     irq_set_percpu_devid
         irq_set_percpu_devid_flags
                irq_set_status_flags(IRQ_NOAUTOEN | ....)  <----

Am I missing/overlooking something ?


> 
>> +	 */
>> +	irq_set_percpu_devid(irq);
>> +	irq_modify_status(irq, IRQ_NOAUTOEN, 0);
> 
> Aside of that we have irq_clear_status_flags() for this.

OK ! I can use that.


> 
>> +	plat_init_IRQ();
>> +}
> 
>> +int __init get_hw_config_num_irq(void)
> 
> How is that function used ?


This is used in the SMP port patch to verify that number of IRQs have been
configured properly in hardware. This is again in mini-series #2 of v1 patchset
https://lkml.org/lkml/2012/11/12/160

Thx,
-Vineet
