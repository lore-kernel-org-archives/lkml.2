Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2EHN2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:28:09 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:52151 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843Ab2EHN2I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:28:08 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Date: Tue, 8 May 2012 15:26:28 +0200
Subject: RE: Remoteproc adaptations for ST-Ericsson modems
Thread-Topic: Remoteproc adaptations for ST-Ericsson modems
Thread-Index: Ac0ry1Y2f6M0xTokR62Cbf/zaPb11QBUVb0g
Message-ID: <81C3A93C17462B4BBD7E272753C10579232F20847B@EXDCVYMBSTM005.EQ1STM.local>
References: <1335388200-18504-1-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbYisX2A-DHZy6-AhFFTR3QuxJ0OcVaz+JcpzJOwxT3eWA@mail.gmail.com>
In-Reply-To: <CAK=WgbYisX2A-DHZy6-AhFFTR3QuxJ0OcVaz+JcpzJOwxT3eWA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

>> 2. Physical addressing:
>> Support for specifying physical memory locations in resource table.
>> We need some way to specify physical memory locations instead of using
>> carveouts. The physical address will be outside the allocatable Linux
>> memory.
> 
> Can you please share more details about the use case ? is this a
> hardware limitation or a policy (i.e. by reserving memory using the
> boot argument mem=) ?

For the C2C memory we don't have a IOMMU between memory and modem.
(There is some black magic using a offset register etc, but this is
all setup in the Linux boot loader.) So seen from Linux kernel point
of view we're working with a fixed physical address for the shared
memory.


> Can you make this memory allocatable via the DMA API (e.g. via CMA or
> dma_declare_coherent_memory) ?

Yes, I might be able to do just that. I wasn't aware of this function. 
Nice! This way I don't need any other tweaks for the memory allocation
in remoteproc either - Very nice! 

>> Skip the dependency on a driver:
...
> Not sure I'm following. Care to elaborate ?

I was trying to point out that I might call remoteproc from a
module_init function and not from a device driver. But I'm starting
to realize that both firmware-loading and dma_declare_coherent_memory
requires to work on a device. So let's just forget about this point.



>> Skip load of firmware during early boot:
>> I probably missed something, but this feature doesn't make sense
>> to me.
> 
> This mechanism registers the virito devices that are supported by the
> firmware.
> 
> Relevant drivers (if any) will then get probed, and may then power up
> the remote processor (if needed).
>
> > Also it causes big warning from sysfs if I don't finish
> > the async loading before starting the blocking loading of firmware.
> 
> Can you explain how you triggered this ? Are you using
> rproc_get_by_name() ?

No, I trigger this warning by calling rproc_register() and rproc_boot()
in sequence from a remoteproc client without using rpmsg. If you haven't
finished the asynchronous loading of firmware initiated by 
rproc_register() and call rproc_boot() immediately after you will get
a warning when initiating synchronous firmware loading from rproc_boot().
This is caused by loading the firmware for the same device twice 
simultaneously.


> > And I fail to see the need for it.
> 
> Without it, no virtio driver is going to be probed - we don't
> statically register virtio devices, because we don't know what kind of
> functionality the remote processor supports without loading the
> firmware first.

Ok, I see. You have a chicken and egg problem. And solve this by loading
the firmware twice. If I understand correctly you do something like this:

1. rproc-client does rproc_alloc() and rproc_register()
2. This trigger loading of firmware asynchronously.
3. Resource table is scanned for virtio device and virtio device
   are registered.
4. Registration cause probing of rpmsg virtio driver
5. rpmsg virtio driver calls rproc_boot() from probe function.
6. remote_proc loads downloads firmware, parses the resource table 2nd time.
7. rproc->ops->load() is called and DSP is loaded and started.


>> I think it would be nice to be able to turn this feature off.
> 
> Care to explain why ? what exactly do you want to do that you can't
> today ?

The difference is that I am not planning to call rproc_boot()
from rpmsg, but trigger booting from user space using sysfs. In this
case I don't need to probe any virtio drivers in order to trigger
the call of rproc_boot(). Consequently I don't need to load firmware twice.
So I think I'd like to see the following sequence:

1. rproc-client calls rproc_alloc() and rproc_register()
2. User space initiates booting via sysfs, causing rproc_boot() to be
   called.
3. remoteproc initiates synchronous firmware loading.
4. resource table is scanned once, handling all resource entries
   including virtio device registration.
5. rproc->ops->load() is called and DSP is loaded and started.


It would be good to know if this approach makes sense for you. And if
you agree, I'd like to get your view on how you think we could support
this in remoteproc. ie. do you approve of the feature bit I proposed,
or do you have something else in mind?


>> Below is a stab at supporting non-ELF binaries and disabling the
>> pre-loading of ELF. 
> It's in the TODO list of remoteproc, but unfortunately not a high
> priority for me...

OK, good to know.


Best regards,
Sjur

