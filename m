Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab0D0Q0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:26:14 -0400
Received: from cifronik.21th.com ([62.16.86.116]:40046 "EHLO cifronik.21th.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab0D0Q0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:26:12 -0400
X-Greylist: delayed 955 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2010 12:26:12 EDT
From: Sergey Temerkhanov <temerkhanov@cifronik.ru>
To: steve@digidescorp.com
Subject: Re: [PATCH] [RFC] Xilinx MPMC SDMA subsystem
Date: Tue, 27 Apr 2010 20:09:50 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
Cc: Sergey Temerkhanov <temerkhanov@yandex.ru>, linuxppc-dev@lists.ozlabs.org,
       Grant Likely <grant.likely@secretlab.ca>,
       microblaze-uclinux@itee.uq.edu.au,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201003172118.41559.temerkhanov@cifronik.ru> <201003292304.39657.temerkhanov@yandex.ru> <1271780995.3067.79.camel@iscandar.digidescorp.com>
In-Reply-To: <1271780995.3067.79.camel@iscandar.digidescorp.com>
MIME-Version: 1.0
Message-Id: <201004272009.50693.temerkhanov@cifronik.ru>
Organization: Cifronic ZAO
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 April 2010 20:29:55 Steven J. Magnani wrote:
> Hi Sergey,
> 
> I've only just started using this in earnest, sorry for not getting back
> to you sooner. It's a nice encapsulation of the MPMC/SDMA functionality,
> thanks for posting it.
> 
> In order to integrate this into my system, I refactored the bus
> attachment code and added hooks for platform bus. I also removed some
> dead code, reformatted some things to satisfy checkpatch, tweaked
> #includes to fix Microblaze compilation, and fixed a potential bug where
> sdma_set_coalesce() could return without releasing a spinlock. I also
> optimized the sdma_desc_* functions by moving any byte swapping from
> runtime to compile-time.

Well, it looks good.
> 
> Some more controversial changes / items for discussion:
> 
> 1. I dropped setting the tail descriptor in the sdma_[rt]x_init()
> functions since that would start DMA, which is not what I think we want.
> 

Needs some testing, I think. Back in 2008, AFAIR, I've had some problems with 
this approach, but I don't remember exactly if it was the cause.

> 2. I made RX and TX interrupts optional. There are use cases (DMAing
> while atomic) in which interrupts are not necessary. The DMA engine only
> needs RX interrupts. There is an (obscure) mode in which it might also
> want TX interrupts, and in that case it's only interested in error
> interrupts - normal "done" interrupts are of no interest whatsoever.
> Rather than try to adapt the sdma driver to fit that case, I think I
> will drop that mode from the DMA engine driver.

Looks good too.

> 
> 2A. I will need, but haven't added yet, methods to know if a SDMA
> channel has RX and TX IRQ resources. I'm assuming that a simple inline
> accessor is preferred over snooping struct sdma directly.

I would suggest sdma_has_[r|t]x().

> 
> 3. I changed the user[4] field of struct sdma_desc to individually-named
> fields app1 - app4, to match the MPMC datasheet. I found user[0]
> confusing and already had to fix a bug where I had coded user[0]
> thinking it was app0, when I really should have specified stat_ctl.

It doesn't really matter as these fields have different meaning in different 
applications and one has to decode it appropriately. If it helps to write more 
understandable code, so be it.

> 
> 4. Why have sdma_[rt]x_submit() return a value if it is always zero?

I don't remember exactly why I've coded this, but now I think that return 
value isn't needed for these functions too.

> 
> 5. I would like to see the 'virt' and 'flags' fields removed from struct
> sdma_desc and SDMA_ALIGNMENT reduced from 0x40 to 0x20. Neither field is
> used in the sdma driver itself. I understand why 'virt' is there, but
> having it in the struct will make the DMA engine driver less efficient.
> Because the DMA engine operates on 'loopback' SDMA channels it always
> allocates descriptors in pairs. Also the DMA engine framework already
> provides storage for the 'virt' pointer. Having a larger-than-necessary
> structure would force the DMA engine to do larger allocations from its
> DMA pool - instead of 64 bytes per dual descriptor, it would have to
> allocate 128.

The 'virt' and 'flags' fields are there specially for users. The 'virt' is 
intended for the pointer to the structure associated with the buffer (maybe, 
'virt' should be called 'priv' instead), and 'flags' is there to determine 
which data type 'virt' is pointing to.

> 
> 6. I'm concerned that there is no concept of "allocating" a channel,
> something like a sdma_device_get() / sdma_device_put() pair that would
> prevent concurrent access to a SDMA device by removing the device from
> consideration by sdma_find_device().
> 
> 7. In that same vein, I'm curious about the need for a list of
> sdma_clients. Is there a use case for this in your systems?
> 

I've added the list of clients rather recently to support several of my 
drivers which implement the separate descriptor rings and char devices for RX 
and TX (there are some custom IP cores for DSP developed by our company which 
need this functionality). 

> 8. It would probably make sense to have sdma_init() fail with -EEXIST if
> a SDMA device with the specified phandle already exists (-1 being an
> exception).

Maybe this check is needed but 'linux,phandle' is an automatic property added 
by the device tree compiler and I doubt that the FDT code with invalid 
phandles will even compile.

> 
> 9. I didn't resolve the issue of what to name the files / API, assuming
> 'sdma' is a little too generic for things that are now publicly visible.
> If we have to change it, some suggestions are 'mpmcsdma' (long, but
> precise), 'xildma', 'xsdma', or 'xdma' (also perhaps too generic).
> 

Maybe, 'xllsdma' would be good.

> As time permits, I'll work on refactoring the DMA engine driver to use
> the sdma driver - I'll post change requests for anything else I need
> rather than modifying the sdma code directly.
> 

Feel free to contact me directly or through the mailing list. 

> Regards,
> ------------------------------------------------------------------------
>  Steven J. Magnani               "I claim this network for MARS!
>  www.digidescorp.com              Earthling, return my space modulator!"
> 
>  #include <standard.disclaimer>
> 


Regards, Sergey Temerkhanov, 
Cifronic ZAO.

-- 
Regards, Sergey Temerkhanov,
Cifronic ZAO
