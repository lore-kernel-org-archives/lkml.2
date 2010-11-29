Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0K2UOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:14:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:47632 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab0K2UOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:14:54 -0500
Subject: Re: [sodaville] [PATCH 03/11] x86/dtb: Add a device tree for CE4100
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mitch Bradley <wmb@firmworks.com>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
In-Reply-To: <4CF400B1.6060100@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
	 <1290808645.32570.158.camel@pasglop>	<20101128160449.GC30784@www.tglx.de>
	 <1290984809.32570.208.camel@pasglop>  <4CF400B1.6060100@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 07:14:34 +1100
Message-ID: <1291061674.32570.307.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 20:36 +0100, Sebastian Andrzej Siewior wrote:
> 
> This also works with the flat tree, right?

Yes, of course. You use similar references in your interrupt-map :-)

> Okay, so we want this for a quirk at a later point in time. Now I
> understand.

More precisely, if something has to depend on a specific
revision/errata/feature, in the future, it would be problematic to have
to modify the device-tree.

The "rule" for compatible is to be a list going from a reasonably
precise description of the specific device to the more generic
programming interface the device implements.

> Would "isa-bridge" be acceptable? So I don't have to add a new bus to
> the probe list for every new SoC.

Just call it 'isa', as for device_type, we shouldn't need it.

The default "probe list" is crap. If you want to have platform devices
instanciated for the ISA devices from the device-tree, I'd rather you
explicitely do it from the architecture code. As Scott said, "isa"
doesn't quite qualify as a "generic" simple bus.

> Yes. of_address_to_resource() will do the right thing in this case. It
> can only be used after unflatten_device_tree() and I need this
> earlier.

This probably means you are doing the unflattening too late...

> Now using unflatten_device_tree() earlier isn't that easy, or is it.
> I defered the ioapic init a little, so it is now called from
> x86_init.mpparse.get_smp_config() so I have alloc_bootmem() working.

You can probably do the unflattening way before alloc_bootmem is
available.

The unflattening does a first pass to scan for the size, so all you need
is a way to get a single contiguous chunk of memory, I'm sure x86 has
ways to provide that sort of thing really early before bootmem is
initialized (what about memblock btw ?).

> So unflatten_device_tree() seems to work here. The ugly part comes
> now:
> early_init_dt_alloc_memory_arch() expects u64 which works with
> phys_to_virt() and the other way around. This isn't really the case
> with
> what __alloc_bootmem(). This looks like phys_map to me. Since the dtb
> code
> simply uses phys_to_virt() it doesn't really matter. So it works and
> I 
> probably can use of_address_to_resource().

Yeah just __pa what alloc_bootmem returns but as I said, it should
probably be unflattened earlier than that.

Peter (CC) should be able to help finding the right spot/API there.

Cheers,
Ben.

> > Cheers,
> > Ben.
> 
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/ 

