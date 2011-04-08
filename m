Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391Ab1DHO6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 10:58:21 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:53273 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757204Ab1DHO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 10:58:20 -0400
Message-ID: <4D9F224A.60902@shipmail.org>
Date: Fri, 08 Apr 2011 16:57:14 +0200
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexdeucher@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be passed
 in for DMA API calls.
References: <20110322143137.GA25113@dumpdata.com> <4D89AB8F.6020500@shipmail.org> <20110323125105.GA6599@dumpdata.com> <4D89F2DE.7020209@shipmail.org> <20110323145246.GA7546@dumpdata.com> <4D8AF834.8040700@shipmail.org> <20110324142509.GA32416@dumpdata.com> <AANLkTinUGjwTzMFbHHckkiuCQ8sF+i5iMQsXesG34f6U@mail.gmail.com> <20110324162135.GA835@dumpdata.com> <4D8CF46F.2070206@shipmail.org> <20110331154954.GA7695@dumpdata.com>
In-Reply-To: <20110331154954.GA7695@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

Sorry for waiting so long to answer. Workload is quite heavy ATM.
Please see inline.


On 03/31/2011 05:49 PM, Konrad Rzeszutek Wilk wrote:
>>> I can start this next week if you guys are comfortable with this idea.
>>>
>>>
>>>        
>> Konrad,
>>
>> 1) A couple of questions first. Where are the memory pools going to
>> end up in this design. Could you draft an API? How is page
>> accounting going to be taken care of? How do we differentiate
>> between running on bare metal and running on a hypervisor?
>>      
> My thought was that the memory pool's wouldn't be affected. Instead
> of all of the calls to alloc_page/__free_page (and dma_alloc_coherent/
> dma_free_coherent) would go through this API calls.
>
> What I thought off are three phases:
>
>   1). Get in the patch that passed in 'struct dev' to the dma_alloc_coherent
>    for 2.6.39 so that PowerPC folks can use the it with radeon cards. My
>    understanding is that the work you plan on to isn't going in 2.6.39
>    but rather in 2.6.40 - and if get my stuff ready (the other phases)
>    we can work out the kinks together. This way also the 'struct dev'
>    is passed in the TTM layer.
>    

I'm not happy with this solution. If something goes in, it should be 
complete, otherwise future work need to worry about not breaking 
something that's already broken. Also it adds things to TTM api's that 
are not really necessary.


I'd like to see a solution that  encapsulates all device-dependent stuff 
(including the dma adresses) in the ttm backend, so the TTM backend code 
is the only code that needs to worry about device dependent stuff. Core 
ttm should only need to worry about whether pages can be transferrable 
to other devices, and whether pages can be inserted into the page cache.

This change should be pretty straightforward. We move the ttm::pages 
array into the backend, and add ttm backend functions to allocate pages 
and to free pages. The backend is then completely free to keep track of 
page types and dma addresses completely hidden from core ttm, and we 
don't need to shuffle those around. This opens up both for completely 
device-private coherent memory and for "dummy device" coherent memory.

In the future, when TTM needs to move a ttm to another device, or when 
it needs to insert pages into the page cache, pages that are device 
specific will be copied and then freed. "Dummy device" pages can be 
transferred to other devices, but not inserted into the page cache.

/Thomas







