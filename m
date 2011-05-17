Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab1EQFyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 01:54:39 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:58904 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab1EQFyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 01:54:36 -0400
Message-ID: <4DD20D89.9020402@st.com>
Date: Tue, 17 May 2011 11:24:17 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dw_dmac: Replace subsys_init() with arch_initcall()
References: <f06f05e982c6182565a7fee1f7d6396cae895133.1305521318.git.viresh.kumar@st.com>	 <1305561993.28926.73.camel@vkoul-udesk3>  <4DD1F443.1040205@st.com> <1305603818.28926.82.camel@vkoul-udesk3>
In-Reply-To: <1305603818.28926.82.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 09:13 AM, Koul, Vinod wrote:
> On Tue, 2011-05-17 at 09:36 +0530, viresh kumar wrote:
>> On 05/16/2011 09:36 PM, Koul, Vinod wrote:
>>> On Mon, 2011-05-16 at 10:20 +0530, Viresh Kumar wrote:
>>>> In some cases users of dw_dmac, amba-pl022, are initialized before dw_dmac, and
>>>> if they try to use dw_dmac, they simply fail. So its better we register init()
>>>> routine of driver using arch_initcall() instead of subsys_init(), so that dma
>>>> driver is available at the earliest possible.
>>>>
>>>> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>>>> ---
>>>>  drivers/dma/dw_dmac.c |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
>>>> index 54d72a8..4b580e7 100644
>>>> --- a/drivers/dma/dw_dmac.c
>>>> +++ b/drivers/dma/dw_dmac.c
>>>> @@ -1566,7 +1566,7 @@ static int __init dw_init(void)
>>>>  {
>>>>  	return platform_driver_probe(&dw_driver, dw_probe);
>>>>  }
>>>> -subsys_initcall(dw_init);
>>>> +arch_initcall(dw_init);
>>> arch_init is usually kept for subystem initialization.
>>> Why cant you move the amba-pl022 init to module_init, that should take
>>> care of this.
>>>
>>
>> Actually, amba-pl022 init was moved to subsys_initcall earlier with
>> following patch:
>>
>> And so i moved dma's init to arch_initcall. Also the similar approach is
>> taken by drivers/dma/ste_dma40.c
>>
>> Also, maybe it makes more sense for dma to be up at the earliest.
>> Isn't it?
> 
> As I said before arch init is supposed to used for initialization of the
> subsystems not for a driver init.
> You need to ensure that with given init levels and makefile order your
> dependencies are properly resolved, rather than this approach.
> 
> Like move whatever dependent on amba to late_init and amba to module
> init, that would be advisable approach rather than above.
> 

As i said earlier, with following patch from Linus:

commit 25c8e03bdb769dfe2381f8b7942f05b0eb4bdf31
Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Mon Sep 6 11:02:12 2010 +0200

    spi/pl022: move probe call to subsys_initcall()
    
    The PL022 SPI bus is sometimes used for early stuff like
    regulators that need to be present at module_init() time, so
    we move this to a subsys_initcall().
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/spi/amba-pl022.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

SPI bus is required for regulators and so probably he can't have
module_init() for amba-pl022. And so, DMA has nothing more than
arch_initcall().

@Linus: What do you say? Can we get back to module_init() for amba-pl022?
And subsys_initcall() for DMA.

-- 
viresh
