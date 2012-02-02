Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab2BBLN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 06:13:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38118 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab2BBLN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 06:13:56 -0500
Message-ID: <4F2A6FAC.8010906@mvista.com>
Date: Thu, 02 Feb 2012 15:12:44 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pasupathy, Visuvanadan" <vichu@ti.com>
Subject: Re: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
References: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com> <4F22CC37.8010307@mvista.com> <47CEF8C4B26E8C44B22B028A650E0EA9317D2B9D@DBDE01.ent.ti.com> <4F27D011.8060203@mvista.com> <47CEF8C4B26E8C44B22B028A650E0EA9317D9346@DBDE01.ent.ti.com> <20120202090923.GC9948@legolas.emea.dhcp.ti.com>
In-Reply-To: <20120202090923.GC9948@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-02-2012 13:09, Felipe Balbi wrote:

>>>>>> As a next step to dma-engine based cppi4.1 driver implementation
>>>>>> this RFC has the overview of changes in the musb driver.
>>>>>> RFC on CPPI slave driver changes will follow next.
>>>
>>>>>> Overview of changes in the musb driver
>>>>>> ======================================

>>>>>> 1)Add a dma-engine.c file in the drivers/usb/musb folder
>>>>>> 2)This file will host the current musb dma APIs and translates them to
>>>>>>      dmaengine APIs.
>>>>>> 3)This will help to keep the changes in drivers/usb/musb/musb* files
>>>>>>      minimal and also to retain compatibility other DMA (Mentor etc.)
>>>>>>      drivers which are yet to be moved to drivers/dma
>>>>>> 4)drivers/usb/musb/dma-engine.c, will wrap the dmaengine APIs to
>>>>>>      make existing musb APIs compatible.
>>>>>> 5)drivers/usb/musb/dma-engine.c file will implement the filter
>>>>>>      functions and also implement .dma_controller_create (allocates
>>>>>>      &    provides "dma_controller" object) and .dma_controller_delete
>>>>>> 6)CPPI4.1 DMA specific queue and buffer management will be internal
>>>>>>      to slave CPPI DMA driver implementation.

>>>>>       You mean drivers/dma/ driver?

>>>> yes.

>>>>> I think you are forgotting that CPPI 4.1 MUSB
>>>>> has some registers controlling DMA/interrupts beside those of CPPI 4.1
>>>>> controller and MUSB core itself. How do they fit in your scheme?

>>>> We have been discussing on how to handle these in slave driver and

>>>      These certainly cannot be handled in the slave driver because the
>>> registers are different for every controller implementation and, the
>>> main thing, they don't belong to CPPI 4.1 as such.

>> Felipe suggested to use device tree for differences in register maps
>> among different platforms.

>> I do see issues in reading wrapper interrupt status register and then
>> calling musb_interrupt() [defined inside musb_core.c] from slave driver.

> I have been thinking about that lately. In the end of the day, I want to
> remove direct dependencies between musb_core and glue. So what I was
> thinking about goes like so:

> Glue layer basically has to prepare musb->int_usb, musb->int_tx and
> musb->int_rx for musb. Maybe handle some glue specific stuff and so on,
> but the IRQ line still belongs to MUSB.

> So the idea would be to add something like:

> musb_platform_read_intrusb()
> musb_platform_read_intrtx()
> musb_platform_read_intrrx()

> those would default to basic:

> musb_readb(musb->mregs, MUSB_INTRUSB);
> musb_readw(musb->mregs, MUSB_INTRTX);
> musb_readw(musb->mregs, MUSB_INTRRX);

> if platform ops aren't passed. So, it would look something like:

> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index 72a424d..ba0bcc2 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -1488,9 +1488,9 @@ static irqreturn_t generic_interrupt(int irq, void *__hci)
>
>   	spin_lock_irqsave(&musb->lock, flags);
>
> -	musb->int_usb = musb_readb(musb->mregs, MUSB_INTRUSB);
> -	musb->int_tx = musb_readw(musb->mregs, MUSB_INTRTX);
> -	musb->int_rx = musb_readw(musb->mregs, MUSB_INTRRX);
> +	musb->int_usb = musb_platform_read_intusb(musb->controller);
> +	musb->int_tx = musb_platform_read_inttx(musb->controller);
> +	musb->int_rx = musb_platform_read_intrx(musb->controller);
>
>   	if (musb->int_usb || musb->int_tx || musb->int_rx)
>   		retval = musb_interrupt(musb);
>
> those would make sure to prepare the cached IRQ status registers for
> MUSB core.
>
> Keep in mind that this is only necessary because on
> DaVinci/OMAP-L13x/AM35x devices you guys have decided to make the
> wrapper read the IRQ status register from MUSB address space. And
> because those are clear-on-read, we're screwed.

> Oh well, this is the best I could come up with. Any problems you guys
> see ?

    On DaVinci/OMAP-L1x these 3 calls need to extract data from a single 
32-bit register, so that doesn't seem a good idea to me. The current scheme 
seems OK to me. Or either implement a signle function to read all 3 interrupt 
masks...

musb_platform_read_ints()

WBR, Sergei
