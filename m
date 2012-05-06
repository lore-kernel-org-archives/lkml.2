Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2EFVIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 17:08:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44620 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab2EFVIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 17:08:47 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.255.206]
In-Reply-To: <1335388200-18504-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1335388200-18504-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 7 May 2012 00:00:35 +0300
Message-ID: <CAK=WgbYisX2A-DHZy6-AhFFTR3QuxJ0OcVaz+JcpzJOwxT3eWA@mail.gmail.com>
Subject: Re: Remoteproc adaptations for ST-Ericsson modems
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Thu, Apr 26, 2012 at 12:10 AM,  <sjur.brandeland@stericsson.com> wrote:
> 1. Support for non-ELF binaries:
> I'd like to see a solution for finding the ”resource_table” in non-ELF
> binaries and loading a non-ELF file.

Yes, several different vendors already indicated they need this.

So far It seems though that the non-ELF folks are waiting for someone
else to step up and implement this :)

> I have put together a patch below
> doing this by ”overloading” the functions find_rsc_table() and load().

Nice start!

I think we might want a slightly different abstraction though: instead
of allowing drivers to override the default ELF loader, we probably
want to have a set of external loader implementations, which drivers
could then pick when they register with the core (something like i2c's
algos).

This would make it possible for drivers to easily share the same
loader implementation without having to duplicate any loader code. A
nice exercise is then going to be extracting the ELF handling code
from remoteproc_core into its own external loader implementation.

Drivers should still be able to implement their own proprietary loader
if they want to, but if there's a chance it's going to be shared with
others, then they should implement it as an external loader.

> 2. Physical addressing:
> Support for specifying physical memory locations in resource table.
> We need some way to specify physical memory locations instead of using
> carveouts. The physical address will be outside the allocatable Linux
> memory.

Can you please share more details about the use case ? is this a
hardware limitation or a policy (i.e. by reserving memory using the
boot argument mem=) ?

Can you make this memory allocatable via the DMA API (e.g. via CMA or
dma_declare_coherent_memory) ?

> User-space life-cycle interface:
> The modem life-cycle is managed from user-space. It would be nice to
> have e.g. sysfs entries for start and stop of the modem from
> remoteproc.

Sounds fair. Feel free to suggest an interface.

> Skip the dependency on a driver:
> Current solution assume that remoteproc is initiated from device
> driver.

What do you mean by "initiated" ? powered on ?

> In the current C2C driver implementation we have internally,
> the device and driver is hidden underneath a functional API.
> So it doesn't necessarily make sense for us that remoteproc requires
> a device and driver as input.

Not sure I'm following. Care to elaborate ?

> Skip load of firmware during early boot:
> I probably missed something, but this feature doesn't make sense
> to me.

This mechanism registers the virito devices that are supported by the firmware.

Relevant drivers (if any) will then get probed, and may then power up
the remote processor (if needed).

> Also it causes big warning from sysfs if I don't finish
> the async loading before starting the blocking loading of firmware.

Can you explain how you triggered this ? Are you using rproc_get_by_name() ?

> And I fail to see the need for it.

Without it, no virtio driver is going to be probed - we don't
statically register virtio devices, because we don't know what kind of
functionality the remote processor supports without loading the
firmware first.

> I think it would be nice to be able to turn this feature off.

Care to explain why ? what exactly do you want to do that you can't today ?

> Below is a stab at supporting non-ELF binaries and disabling the
> pre-loading of ELF. Please consider this as an idea - I'd be quite
> happy if you take over the initiative and come up with a competely
> different solution...

It's in the TODO list of remoteproc, but unfortunately not a high
priority for me...

Thanks,
Ohad.
