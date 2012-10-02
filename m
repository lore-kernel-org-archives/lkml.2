Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2JBKD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 06:03:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50442 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2JBKD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 06:03:27 -0400
Message-ID: <506ABBCF.8010009@ti.com>
Date: Tue, 2 Oct 2012 15:32:55 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/7] ARM: davinci: Add support for an L3RAM gen_pool
References: <1348861072-14507-1-git-send-email-mporter@ti.com> <1348861072-14507-5-git-send-email-mporter@ti.com> <506986B2.1030000@ti.com> <20121001123242.GJ5641@beef>
In-Reply-To: <20121001123242.GJ5641@beef>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/2012 6:02 PM, Matt Porter wrote:
> On Mon, Oct 01, 2012 at 05:34:02PM +0530, Sekhar Nori wrote:
>> Hi Matt,
>>
>> On 9/29/2012 1:07 AM, Matt Porter wrote:
>>> L3RAM (shared SRAM) is needed for use by several drivers.
>>> This creates a genalloc pool and a hook for the platform code
>>> to provide the struct gen_pool * in platform data.
>>>
>>> Signed-off-by: Matt Porter <mporter@ti.com>
>>
>> I am not sure if any of the DaVinci devices have a need to allocate from
>> *both* ARM RAM and shared RAM. Shared RAM is not present on all DaVinci
>> devices AFAIR, and on DA850, there is just 8KB ARM RAM so I am not sure
>> if there is much point in trying to allocate from there.
>>
>> Can you instead see if Ben's earlier patch[1] to use shared RAM for SRAM
>> allocation on DA850 makes sense for your case? If yes, can you repost
>> with Ben's patch included in your series instead of this patch? I would
>> prefer that over creating a new pool for shared RAM.
> 
> Hrm, I did look at Ben's earlier patch. The reason I added a separate
> pool mostly was so I didn't have to touch the PM code at all. That can
> continue using the private SRAM API with the ARM RAM as it is now. The

But you dont have to touch the PM code. PM code can continue using SRAM
API. I have verified in the past that PM can work using shared RAM.

> idea here was to allow that to be separate since no other bus masters
> can access the ARM RAM anyway and do something that didn't require
> regression testing PM. Also, I figured there's really no reason to use
> even a tiny bit of the shared SRAM on PM if we have that ARM RAM there
> and working fine for that use case.

I see no reason why PM would break with shared RAM. I have not even seen
reports of shared RAM being short of size so we need to save space by
having PM code in ARM RAM. I can test the changes before the code is
committed and it will get tested in linux-next as well.

> The other thing is that Ben's patch needs to be rewritten to at least
> have the hook I added so we can provide the gen_pool in platform data.
> If you prefer this path still, I can add the needed hook on top of his
> original patch. Ultimately, I only *need* genalloc support for the
> shared sram so I can remove the private SRAM API from uio_pruss...so I'm
> happy with any way to get at it.

Right, I prefer just adding the hook so that genalloc can be used along
with SRAM API.

> Oh, and to be honest...it's not just for uio_pruss, but also to cleanly
> remove the private SRAM API usage from the davinci ASoC driver too.

Audio can use the shared RAM too. And once all users of the SRAM API are
gone, only the hook to help pass the gen_pool as platform data needs to
remain.

Thanks,
Sekhar
