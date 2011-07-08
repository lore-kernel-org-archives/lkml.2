Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1GHUNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 16:13:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:43932 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab1GHUN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 16:13:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,500,1304319600"; 
   d="scan'208";a="24606174"
Message-ID: <4E1764E7.7090804@intel.com>
Date: Fri, 08 Jul 2011 13:13:27 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: Qin Dehua <qindehua@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "neilb@suse.de" <neilb@suse.de>, "Jiang, Dave" <dave.jiang@intel.com>
Subject: Re: PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause
 OOPS
References: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com> <20110630074301.GC27959@flint.arm.linux.org.uk> <BANLkTimBTayh_mjOLMZbz3D+wqdtZ10=wA@mail.gmail.com> <20110630112804.GA21481@flint.arm.linux.org.uk> <BANLkTimo18w5yuE4jtATPvbgENCL04LMpA@mail.gmail.com> <BANLkTimupUqpLDdDvMRjB+Js0xW59MTOQA@mail.gmail.com> <20110707093928.GA15325@flint.arm.linux.org.uk> <CA+gQ4tczHA2NGyLaVFjDs6CQjeQZbzNCCBU0zX4HVgaF4VFEFQ@mail.gmail.com> <20110708080751.GA14947@flint.arm.linux.org.uk> <20110708173251.GA9561@flint.arm.linux.org.uk>
In-Reply-To: <20110708173251.GA9561@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/8/2011 10:32 AM, Russell King wrote:
> On Fri, Jul 08, 2011 at 09:07:51AM +0100, Russell King wrote:
>> On Fri, Jul 08, 2011 at 12:38:38PM +0800, Qin Dehua wrote:
>>> After doing the above changes, the kernel just report  BUG_ON(dir ==
>>> DMA_BIDIRECTIONAL):
>>
>> That's really unfortunate.
>>
>> The only other thing I can think which may help is to enable all the
>> raid5, async_tx and dmaengine debug code.  And I hope you have
>> DMA_API_DEBUG enabled in your .config ?
>
> I'm really grasping at straws here...
>
> I'll add to this that I'm out of ideas at the moment (I don't know the
> RAID5 nor the async offload code), and the only way I can think of
> resolving this is to revert the commit.
>
> While that sounds like a good thing to do, it means people using ARMv6
> and later CPUs will be risking data corruption, which I don't think is
> that desirable either - and will in itself cause a regression there.

Not much of a choice but crashing is better than data corruption. 
Disabling CONFIG_ASYNC_TX_DMA until the mapping violations can be 
resolved is probably the better course of action.  Something like.

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 1c28816..cb254a1 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -247,6 +247,7 @@ config NET_DMA
  config ASYNC_TX_DMA
         bool "Async_tx: Offload support for the async_tx api"
         depends on DMA_ENGINE
+       depends on !ARM
         help
           This allows the async_tx api to take advantage of offload 
engines for
           memcpy, memset, xor, and raid6 p+q operations.  If your 
platform has


>
> So we really need to the bottom of what's going on (which I suspect
> may be due to DMA API abuse by the async offload stuff - mapping the
> same buffer multiple times with differing attributes.)  Why that would
> impact sh->count I've no idea.
>

This is concerning, I'll see about dusting off my iop34x and 
reproducing.  Might not be for a week or so...

--
Dan
