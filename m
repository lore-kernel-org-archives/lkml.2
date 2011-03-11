Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1CKEnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 23:43:24 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41072 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab1CKEnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 23:43:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6281"; a="79132101"
Message-ID: <4D79A85D.8000301@codeaurora.org>
Date: Thu, 10 Mar 2011 20:43:09 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD v2 2/6] mfd: pm8xxx: Add irq support
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-3-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1103081201520.2787@localhost6.localdomain6> <4D770E47.6050402@codeaurora.org> <alpine.LFD.2.00.1103101126100.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103101126100.2787@localhost6.localdomain6>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Tue, 8 Mar 2011, Abhijeet Dharmapurikar wrote:
>> Thomas Gleixner wrote:
>>> On Mon, 7 Mar 2011, adharmap@codeaurora.org wrote:
>>>> +	if (pdata->irq_pdata) {
>>> So if pdata->irq_pdata == NULL you return success. Is that correct ?
>> Yes. The board configuration may choose not to use pmic interrupts.
> 
> Ok.
>  
>>> Also please return early on (!pdata->irq_pdata) and avoid that extra
>>> indent level for the real code path.
>> I did not do that because there are other subdevices that I will be adding in
>> the later patches. I cannot return early. well I will change it for this
>> patch.
> 
> Maybe splitting out the various init subsections into different
> functions which are called from here might be a good thing.
>  
>>>> +static void pm8xxx_irq_ack(struct irq_data *d)
>>>> +{
>>>> +	const struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
>>>> +	unsigned int pmirq = d->irq - chip->irq_base;
>>>> +	u8	block, config;
>>>> +
>>>> +	block = pmirq / 8;
>>>> +
>>>> +	config = PM_IRQF_WRITE | chip->config[pmirq] | PM_IRQF_CLR;
>>>> +	/* Keep the mask */
>>>> +	if (!(chip->irqs_allowed[block] & (1 << (pmirq % 8))))
>>>> +		config |= PM_IRQF_MASK_FE | PM_IRQF_MASK_RE;
>>> What's the point of this exercise? ack is called before mask and it
>> The register design is such that we cannot only clear the interrupt. One has
>> to write to the trigger bits while clearing it. Now trigger bits define
>> whether the interrupt is masked or unmasked. If unmasked they define whether
>> the interrupt rising/falling/level high/level low triggered.
>> So the code remembers which interrupts are masked and for them it clears and
>> rewrite the masked status in trigger bits. For unmasked ones it clears and
>> writes to the trigger bits essentially configuring them same way as it was
>> before. That is why the if satement to check interrupt was masked earlier,
>> chip->irqs_allowed[] maintains which interrupt are unmasked.
>>
>>> ack is called before mask and it
>>> should never be called when the interrupt is masked.
>> I didnt quite understand this comment. handle_level_irq calls mask_ack which
>> masks the interrupt and then acks it. In this case the ack is called after the
> 
> Indeed, sorry. So the right way to deal with that is to provide a
> mask_ack() callback which does it in the correct order for your
> HW. That way you avoid all the local state storage.


Yes however while updating the code I noticed that I would need to keep 
account of all the interrupts enabled and all the interrupts marked 
wakeup. This aids in switching to the wakeup set in the suspend callback 
and the enabled set in the resume callback. I will update the resume 
callback to enable the interrupts in irqs_allowed(the local state 
storage) in the next patch (my current patch does not do that).

IOW I need to keep the local state storage.


> 
> Thanks,
> 
> 	tglx


-- 
--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
