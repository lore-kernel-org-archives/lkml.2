Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab1AHTJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 14:09:45 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50241 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab1AHTJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 14:09:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6220"; a="69762905"
Message-ID: <4D28B671.9050704@codeaurora.org>
Date: Sat, 08 Jan 2011 11:09:37 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: tglx@linutronix.de, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: interrupt latency while resuming.
References: <4D2897D1.3040609@codeaurora.org> <20110108171332.GB31708@n2100.arm.linux.org.uk>
In-Reply-To: <20110108171332.GB31708@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2011 09:13 AM, Russell King - ARM Linux wrote:
> On Sat, Jan 08, 2011 at 08:58:57AM -0800, Abhijeet Dharmapurikar wrote:
>>
>> I am trying to address an issue of not handling a wakeup interrupt quick
>> enough while resuming. It is an edge triggered interrupt with the
>> IRQ_WAKEUP flag set. The interrupt controller implements lazy disabling
>> of interrupts, IOW does not have a disable callback in the irq_chip.
>>
>> So while going in to supend that interrupt is marked  IRQ_DISABLED in
>> dpm_suspend_noirq().
>>
>> On resume handle_edge_trigger is run right after
>> arch_suspend_enable_irqs(). It finds the interrupt marked  IRQ_DISABLED
>> and it sets the IRQ_PENDING flag and does not call the handler.
>>
>> As the resume path unrolls, non boot cpus  are enabled,
>> dpm_resume_noirq() is run. At that time it finds the IRQ_PENDING flag is
>> set on this interrupt and the interrupt handler is run.

> Another solution is to check whether we can run the handler before other
> CPUs are online - it may mean we're breaking IRQ affinity, but any
> non-boot affinity has already been broken by taking the other CPUs
> offline.

Agree. I think we are breaking affinity anyways by not setting the 
interrupt targets to pre disable_nonboot_cpus().

We can say that for interrupts marked IRQF_LOW_SUSPEND_LATENCY we may 
not be  honoring the affinity. They *will* run on the boot cpu, even if 
their affinity is set to others upon resume. Driver authors should 
excercise caution wrt to affinity for such interrupts.
For all the other interrupts we can restore the targets to pre 
disable_nonboot_cpu state. But this is a different problem.

Do you agree?

I will test the proposal of IRQF_LOW_SUSPEND_LATENCY and push out a 
patch soon.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
