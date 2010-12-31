Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0LaKj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 05:39:27 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19022 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab0LaKj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 05:39:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6212"; a="68826241"
Message-ID: <4D1DB2DD.3020701@codeaurora.org>
Date: Fri, 31 Dec 2010 02:39:25 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
CC: Russell King <linux@arm.linux.org.uk>, Chao Xie <chao.xie@marvell.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] GIC: Assign correct flow handler type in set_type callback
References: <1293686960-12581-1-git-send-email-adharmap@codeaurora.org> <AANLkTimA8ZP4WL8u0Uvtt-0MWXPkGfjwQ7437pL-h0D-@mail.gmail.com>
In-Reply-To: <AANLkTimA8ZP4WL8u0Uvtt-0MWXPkGfjwQ7437pL-h0D-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2010 10:27 PM, Rabin Vincent wrote:
> On Thu, Dec 30, 2010 at 10:59 AM, Abhijeet Dharmapurikar
> <adharmap@codeaurora.org>  wrote:
>> There are some interrupts that are true edge triggered in nature. If not
>> marked IRQ_PENDING, when disabled, they will be lost.
>>
>> Use the set_type callback to assign the correct flow type handler for
>> shared peripheral interrupts.
>>
>> Signed-off-by: Abhijeet Dharmapurikar<adharmap@codeaurora.org>
>> ---
>> This came to light when a edge triggered interrupt was supposed to wakeup the
>> sytem. The flow handler was set to the default handle_level_irq. On the resume
>> path the flow handler was invoked right after the I bit was cleared but before
>> each individual interrupts were enabled. This made the handle_level_irq ignore
>
> Why does the flow handler hit when the interrupt is disabled?  Have you set
> IRQF_NOSUSPEND on this interrupt?
>
Since GIC doesnt have disable callback it implements lazy disabling. The 
interrupt is only marked IRQ_DISABLED in the descriptor but is not 
masked in the GIC. Hence the interrupt flow handler is hit.

Now that I re-read the code setting IRQF_NO_SUSPEND would fix the issue. 
But shouldnt set_irq_wake() do something similar?

Do I need to request IRQF_NO_SUSPEND for all the interrupts that could 
possibly wakeup the system - seems a bit unnecessary. IMO the interrupt 
should not be disabled if it is marked IRQF_NO_SUPEND || IRQ_WAKEUP is set.

Abhijeet


