Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1LWCL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 21:11:56 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45119 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1LWCLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 21:11:52 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6568"; a="149427904"
Message-ID: <4EF3E35F.6090502@codeaurora.org>
Date: Thu, 22 Dec 2011 18:11:43 -0800
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, srostedt@redhat.com,
        khilman@ti.com, linux-arm-msm@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Very sparse and high interrupt map with SPARSE_IRQ
References: <4EEA6435.5040207@codeaurora.org> <4EEA8192.7050306@gmail.com>
In-Reply-To: <4EEA8192.7050306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 3:24 PM, Rob Herring wrote:
> Have you looked at irq_domain (kernel/irq/irqdomain.c). This is meant to
> support complex mappings like this. Although in its current form it
> needs some work to support this. Is there no sub-grouping of interrupts
> at all?
>
> The hwirq # is stored in irq_data, so converting from Linux irq to hwirq
> # is O(1). Going the other way is implemented per domain and would
> depend on the implementation of .to_irq.

Thanks for the advice. The chip driver houses a number of devices shared 
over a SPMI bus. The SPMI bus supports up to 16 slave IDs, and each 
slave can have 256 devices. Each device can have up to 8 interrupts.

So this is pretty easy to support with irq_domains if we treat all 32768 
interrupts as one domain and allow the chip driver to own the entire 
32768 block of interrupts. Each translation is merely a O(1) calculation 
as you mentioned. And with SPARSE_IRQ, we only allocate the interrupts 
we use on the bus, and so there's very little cost associated with the 
large number of interrupts.

Were you thinking of supporting these sub-groups (eg. group of devices) 
in separate irq_domains? I'm somewhat curious if there's future work 
planned around this area. As it currently stands, it seems like this 
would only complicate things.

There is one issue that needs to be resolved in order to support even 
one irq_domain with this configuration. The problem is that we allocate 
irq_descs dynamically based on Device Tree information, and so 
irq_domain_add() needs to be modified to support this. In fact, there's 
even a comment in the function regarding this limitation. There's two 
problems with the implementation of irq_domain_add() for my usage:

1. It assumes irq_descs are already allocated. In my case, I would like 
to add the irq_domain at init time through of_irq_init(). But the actual 
descriptors are not allocated until much later.

2. It assumes that every hw_irq is available within the range of 
interrupts the domain manages, which is not true in my case. In my case, 
they are truly sparse.

Thus I am proposing we have a more simple irq_domain_add() function that 
solely adds the irq_domain to the list. Then we can create registration 
interface that does the extra initialization for the irq_data of each 
specified hw_irq. What do you think about this? I can submit a patch if 
others think this is reasonable.

Thanks,
Mike

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
