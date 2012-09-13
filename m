Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab2IMP4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:56:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51848 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467Ab2IMP4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:56:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6833"; a="233974029"
Message-ID: <5052021B.4050808@codeaurora.org>
Date: Thu, 13 Sep 2012 11:56:11 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 02/31] arm64: Kernel booting and initialisation
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com> <1347035226-18649-3-git-send-email-catalin.marinas@arm.com> <20120909172046.GB31430@game.jcrosoft.org> <20120910161159.GH27042@arm.com> <20120912120858.GI31430@game.jcrosoft.org> <20120912134916.GF21823@arm.com>
In-Reply-To: <20120912134916.GF21823@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin and Will,

On 09/12/2012 09:49 AM, Catalin Marinas wrote:
> On Wed, Sep 12, 2012 at 01:08:58PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> On 17:11 Mon 10 Sep     , Catalin Marinas wrote:
>>> On Sun, Sep 09, 2012 at 06:20:46PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>> On 17:26 Fri 07 Sep     , Catalin Marinas wrote:
>>>>> +Before jumping into the kernel, the following conditions must be met:
>>>>> +
>>>>> +- Quiesce all DMA capable devices so that memory does not get
>>>>> +  corrupted by bogus network packets or disk data.  This will save
>>>>> +  you many hours of debug.
>>>>> +
>>>>> +- Primary CPU general-purpose register settings
>>>>> +  x0 = physical address of device tree blob (dtb) in system RAM.
>>>>> +  x1 = 0 (reserved for future use)
>>>>> +  x2 = 0 (reserved for future use)
>>>>> +  x3 = 0 (reserved for future use)
>>>>> +
>>>>> +- CPU mode
>>>>> +  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
>>>>> +  IRQ and FIQ).
>>>>> +  The CPU must be in either EL2 (RECOMMENDED in order to have access to
>>>>> +  the virtualisation extensions) or non-secure EL1.
>>>>> +
>>>>> +- Caches, MMUs
>>>>> +  The MMU must be off.
>>>>> +  Instruction cache may be on or off.
>>>>> +  Data cache must be off and invalidated.
>>>>> +  External caches (if present) must be configured and disabled.
>>>>> +
>>>>> +- Architected timers
>>>>> +  CNTFRQ must be programmed with the timer frequency.
>>>>> +  If entering the kernel at EL1, CNTHCTL_EL2 must have EL1PCTEN (bit 0)
>>>>> +  set where available.
>>>> can you explain why?
>>>
>>> Otherwise the kernel cannot access the generic timer registers (it is
>>> described in the AArch64 exception model which isn't public yet).
>> I do not like the idea to do too much in the boot loader

I agree that where possible we should minimize the amount of work required of
bootloaders. I'm not sure that the percentage of work we might be able to trim
away on hardware would be significant, but on simulators I think we might be
able to get to the point where, if you can specify the r0 reset value to be
the dtb pointer, you can just load a devicetree blob and kernel image into
memory and start executing the kernel, no boot wrapper required.

I don't know if Jean-Christophe was commenting on just the EL1PCTEN bit or
also the CNTFRQ register, but with regard to the latter, it appears to me that
the timer code actually reads the frequency primarily from the devicetree and
only reads CNTFRQ if the "clock-frequency" property is unspecified or
specified as zero.

I suggest that the kernel calling requirements be modified to communicate this
fallback, rather than mandatory, status, unless some not-yet-released part of
the arm64 kernel needs it. If userspace code will need to use CNTFRQ at some
point then perhaps that should be mentioned in an informational note rather
than being presented as a kernel booting requirement.

> git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/boot-wrapper-aarch64.git

The UART and GIC stuff is board-specific, and I don't currently have any
suggestions about the multicore initialization, but would you object to the
kernel eventually being equipped to make the descent from EL3 itself?

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by
the Linux Foundation
