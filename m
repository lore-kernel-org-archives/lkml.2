Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2DWNTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:19:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2848 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab2DWNS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:18:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 23 Apr 2012 06:18:58 -0700
Message-ID: <4F95567E.3090605@nvidia.com>
Date: Mon, 23 Apr 2012 18:47:50 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Vinod Koul <vinod.koul@linux.intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] dmaengine: tegra: add dma driver
References: <1334912896-4614-1-git-send-email-ldewangan@nvidia.com> <1334920487.31825.98.camel@vkoul-udesk3> <4F9153AF.7020901@nvidia.com> <1335170491.31825.104.camel@vkoul-udesk3> <4F95483F.5020005@nvidia.com> <20120423130659.GA22186@n2100.arm.linux.org.uk>
In-Reply-To: <20120423130659.GA22186@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 April 2012 06:36 PM, Russell King - ARM Linux wrote:
> On Mon, Apr 23, 2012 at 05:47:03PM +0530, Laxman Dewangan wrote:
>> Hi Russell,
>> On Monday 23 April 2012 02:11 PM, Vinod Koul wrote:
>>> On Fri, 2012-04-20 at 17:46 +0530, Laxman Dewangan wrote:
>>>> Thanks Vinod for quick review.
>>> Since I was on vacation, I hadn't noticed Russell has already sent the
>>> patches for omap dma support.
>>> http://permalink.gmane.org/gmane.linux.ports.arm.omap/75034
>>>
>>> It would be nice if both the efforts are coordinated.
>>>
>>> Btw I like the virtual channel support introduced by Russell
>>>
>> Can you please point me the virtual channel related change? I am not
>> able to locate this like search for function vchan_* ().
>> My driver is also on same line but not used vchan_* and also having
>> support for cyclic transfer.
> It's only been posted in RFC form on linux-arm-kernel and linux-omap
> lists.  The specific patch is:
>
> http://lists.arm.linux.org.uk/lurker/message/20120418.101116.082b350f.en.html
>
> I wouldn't call it perfected yet, but usable.  It doesn't have any
> knowledge about cyclic transfers either.

For simple dma, it is straight to use the virt_chan and it reduce lots 
of code from tegra_dma as most of it moved to the virt_dma.

Some points which I am looking are:
1. Extending this for cyclic support:
In cyclic mode, we need to call callback after period_len but do not 
want to free descriptors. So either I need to add flag on the desctiptor 
to no delet and so when vc->desc_free(vd); is called from callback, it 
will not delete the descriptor.

2. With very prep call, we are allocating descriptor. Is it is possible 
to allocate some desc in advance and then keep using them. The 
complexity is that if we allocate the desc in advance, we need to 
allocate the desc and sq_req list and maintain the two different lists 
as we dont know the sg_len in advance.

3. vchan_cookie_complete()  is not possible in the cyclic mode as we 
dont want to call dma_cookie_complete() but just want to do following 
two thing:

list_add_tail(&vd->node, &vc->desc_completed);
tasklet_schedule(&vc->task);

if we extend this function to bypass dma_cookie_complete(&vd->tx); or 
rather than calling this api, directly call the above apis.







