Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab1CBBXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 20:23:17 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49651 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592Ab1CBBXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 20:23:16 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6272"; a="77249486"
Message-ID: <4D6D9C03.2080906@codeaurora.org>
Date: Tue, 01 Mar 2011 17:23:15 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: linux-arm-msm@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: CONFIG_ARM_DMA_MEM_BUFFERABLE and readl/writel weirdness
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell, Catalin,

In arch/arm/include/asm/io.h, we have the following piece of code:

#ifdef CONFIG_ARM_DMA_MEM_BUFFERABLE
#define __iormb()               rmb()
#define __iowmb()               wmb()
#else
#define __iormb()               do { } while (0)
#define __iowmb()               do { } while (0)
#endif

#define readb(c)                ({ u8  __v = readb_relaxed(c); 
__iormb(); __v; })
#define readw(c)                ({ u16 __v = readw_relaxed(c); 
__iormb(); __v; })
#define readl(c)                ({ u32 __v = readl_relaxed(c); 
__iormb(); __v; })

#define writeb(v,c)             ({ __iowmb(); writeb_relaxed(v,c); })
#define writew(v,c)             ({ __iowmb(); writew_relaxed(v,c); })
#define writel(v,c)             ({ __iowmb(); writel_relaxed(v,c); })

If I'm not missing some magic, this would mean that 
"CONFIG_ARM_DMA_MEM_BUFFERABLE" determines if readl(s)/writel(s) get to 
have a built in mb() or not.

The rest of the emails is under the assumption that my statement above 
is true.

This seems like a real bad thing to do.

There are so many other drivers that don't use or care about DMA and 
might still want to ensure some ordering constraints between their 
readl(s)/writel(s). They can't depend on readl/writel taking care of it 
for them since their code could be used in a kernel configuration that 
doesn't enable this config.

Firstly, I don't know how many people noticed this and realize they 
can't depend on readl/writel to take care of the mb()s for them. Seems 
like an unnecessary encouragement to make mistakes when it didn't need 
to be so.

Secondly, even if they realize they have to take care of it, they will 
have to continue using mb()s in to force ordering between their 
reads/writes. So, are we depending on the compiler to optimize these 
extra mb() out in the case where the config is enabled? I'm not sure it 
will be able to optimize out the extra mb()s in all cases.

Please let me know if I'm missing something and there is a good reason 
for writing the code as it is today. If there is not much of a reason 
for this, do you have any objections if I send a patch to split out the 
"readl/writel with built in mb()" as a separate config and 'select'ing 
it in ARM_DMA_MEM_BUFFERABLE?

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
