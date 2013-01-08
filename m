Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3AHJAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:00:15 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:42884 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab3AHJAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:00:13 -0500
Message-ID: <50EBE01B.80704@free-electrons.com>
Date: Tue, 08 Jan 2013 10:00:11 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/3] gpio: pca953x: make the register access by GPIO
 bank
References: <1357599097-19053-1-git-send-email-gregory.clement@free-electrons.com> <1357599097-19053-2-git-send-email-gregory.clement@free-electrons.com> <50EBD9B6.3090601@free-electrons.com> <50EBDFAD.2090903@free-electrons.com>
In-Reply-To: <50EBDFAD.2090903@free-electrons.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

On 08/01/2013 09:58, Gregory CLEMENT wrote:
> On 01/08/2013 09:32 AM, Maxime Ripard wrote:
>> On 07/01/2013 23:51, Gregory CLEMENT wrote:
>>>  static irqreturn_t pca953x_irq_handler(int irq, void *devid)
>>>  {
>>>  	struct pca953x_chip *chip = devid;
>>> -	u32 pending;
>>> -	u32 level;
>>> +	u8 pending[MAX_BANK];
>>> +	u8 level;
>>> +	int i;
>>>  
>>> -	pending = pca953x_irq_pending(chip);
>>> -
>>> -	if (!pending)
>>> +	if (!pca953x_irq_pending(chip, pending))
>>>  		return IRQ_HANDLED;
>>>  
>>> -	do {
>>> -		level = __ffs(pending);
>>> -		handle_nested_irq(irq_find_mapping(chip->domain, level));
>>> -
>>> -		pending &= ~(1 << level);
>>> -	} while (pending);
>>> +	for (i = 0; i < NBANK(chip); i++) {
>>> +		do {
>>> +			level = __ffs(pending[i]);
>>> +			handle_nested_irq(irq_find_mapping(chip->domain,
>>> +							level + (BANK_SZ * i)));
>>> +			pending[i] &= ~(1 << level);
>>> +		} while (pending[i]);
>>> +	}
>>>  
>>>  	return IRQ_HANDLED;
>>>  }
>>
>> This triggers the following warning when an interrupt is raised:
>>
>> [   30.773500] ------------[ cut here ]------------
>> [   30.778843] WARNING: at /home/tmp/linux/kernel/irq/irqdomain.c:137 irq_domain_legacy_revmap+0x2c/0x48()
>> [   30.788375] Modules linked in:
>> [   30.791531] [<c0014100>] (unwind_backtrace+0x0/0xf0) from [<c001c878>] (warn_slowpath_common+0x4c/0x64)
>> [   30.801125] [<c001c878>] (warn_slowpath_common+0x4c/0x64) from [<c001c8ac>] (warn_slowpath_null+0x1c/0x24)
>> [   30.810968] [<c001c8ac>] (warn_slowpath_null+0x1c/0x24) from [<c006b5e0>] (irq_domain_legacy_revmap+0x2c/0x48)
>> [   30.821187] [<c006b5e0>] (irq_domain_legacy_revmap+0x2c/0x48) from [<c01c3734>] (pca953x_irq_handler+0x16c/0x1ac)
>> [   30.831656] [<c01c3734>] (pca953x_irq_handler+0x16c/0x1ac) from [<c0068688>] (irq_thread+0xd0/0x124)
>> [   30.841000] [<c0068688>] (irq_thread+0xd0/0x124) from [<c003c238>] (kthread+0xa4/0xb0)
>> [   30.849125] [<c003c238>] (kthread+0xa4/0xb0) from [<c000ed48>] (ret_from_fork+0x14/0x2c)
>> [   30.857375] ---[ end trace 09584b7a73100a49 ]---
>>
> 
> Humm it seems that this warning is caused by attempting to use an out of range hwirq.
> I need to investigate it more in details.
> 
> Expect the IRQ part, is this version is working for your gpio expander?

Yes, it works fine if you leave the interruptions aside.

Maxime

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
