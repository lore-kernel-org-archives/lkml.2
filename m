Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1IMBRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 21:17:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37166 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1IMBRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 21:17:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6467"; a="118025833"
Message-ID: <4E6EAF1E.6060608@codeaurora.org>
Date: Mon, 12 Sep 2011 18:17:18 -0700
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: davidb@codeaurora.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, dwalker@fifo99.com,
        linux-arm-msm-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC PATCH] genirq: set pending flag for disabled level interrupt
References: <1312820566-5842-1-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.02.1109021046240.2723@ionos>
In-Reply-To: <alpine.LFD.2.02.1109021046240.2723@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 01:47 AM, Thomas Gleixner wrote:
>
> On Mon, 8 Aug 2011, Abhijeet Dharmapurikar wrote:
>
>> For hardware which has no wakeup source configuration facility, it needs
>> its wakeup interrupts unmasked.
>> If a wakeup edge interrupt triggered while the system was suspending the
>> edge flow handler marks it pending and masks the interrupt. The kernel
>> checks pending flag on wakeup interrupts and aborts suspend if one is set.
>>
>> If a wakeup level interrupt triggered while the system was suspending the
>> level flow handler masks the interrupt without setting the pending flag.
>> Suspend won't be aborted. This is fine as it is expected that a level
>> triggered interrupt will stay triggered and cause the system to resume.
>> This however doesn't work on chips that don't have wakeup configuration
>> in hardware because such chips need that interrupt unmasked for causing
>> a resume.
>>
>> Address that shortcoming by making the level flow handler set the pending
>> flag if a wakeup interrupt controlled by such a chip is triggered while
>> it is suspended.
>
> And how is that supposed to work ?
>
> check_irq_resend()
> {
>          if (irq_settings_is_level(desc))
>                  return;
> ...
>

Hmm, I missed this check. Sorry.

I will send another patch that extends check_wakeup_irqs().

>> Signed-off-by: Abhijeet Dharmapurikar<adharmap@codeaurora.org>
>> ---
>> If a level interrupt irq triggered right while the system was doing
>> suspend_noirqs, the level flow handler will mask that interrupt and when the
>> system went in to power collapse the interrupt controller did not wakeup the
>> phone. The interrupt controller needs an interrupt triggered and masked to
>> wakeup the phone - it does not have any wakeup interrupt configuration.
>> The solution presented here is to mark that level triggered
>> wakeup interrupt pending for chips with IRQCHIP_MASK_ON_SUSPEND. This will cause
>> check_wakeup_irqs to abort suspend.
>> Other solution would be to unmask such level interrupt in check_wakeup_irqs()
>> but that seemed like I was expanding and complicating check_wakeup_irqs()
>> duties - let me know if you think otherwise.
>> Note that we cannot unmask the interrupt in the level flow handler, that will
>> cause an interrupt storm.
>>
>>   include/linux/irq.h |    4 +++-
>>   kernel/irq/chip.c   |   16 +++++++++++++++-
>>   2 files changed, 18 insertions(+), 2 deletions(-)


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
