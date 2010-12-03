Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0LCUGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 15:06:55 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48497 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0LCUGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 15:06:54 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6186"; a="65182491"
Message-ID: <4CF94DDD.8000409@codeaurora.org>
Date: Fri, 03 Dec 2010 12:06:53 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwalker@codeaurora.org, Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@marvell.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to	early_initcall
References: <1291327879-28073-1-git-send-email-johlstei@codeaurora.org> <20101202221909.GK29347@n2100.arm.linux.org.uk>
In-Reply-To: <20101202221909.GK29347@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Thu, Dec 02, 2010 at 02:11:18PM -0800, Jeff Ohlstein wrote:
>> Some machines require the use of coherent memory to bring up auxillary
>> cpus, and thus want to use dma_alloc_coherent prior to smp_init
>> completing.
> 
> I'd like to see the rest of the code to indicate why you need DMA
> coherent memory for SMP boot.  It seems to me quite unnecessary.
> DMA coherent memory is meant for talking to devices, not to other
> CPUs which will be part of the symmetric part of the system.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The code that needs this change will be submitted soon (hopefully in a 
day or two).

The MSM8660 SoC uses the TrustZone technology and the Linux kernel 
executes in normal/non-secure domain. When the second core is brought 
out of reset, it starts executing a secure image which then jumps to 
"secondary_startup". So, before bringing the second core out of reset, 
we need to inform the secure domain code where secondary_startup is 
located in memory.

We do the communication with the secure code by using buffers in memory. 
  The cache treats the NS (non secure) bit as an additional address bit 
when tagging memory. Hence, cache accesses are not coherent between the 
secure and non-secure domains. So, the secure side flushes it's cache 
after writing to the buffer. To properly read the response from the 
secure side, the kernel has to pick a buffer that isn't cacheable in the 
first place. We have similar issues in the reverse direction.

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
