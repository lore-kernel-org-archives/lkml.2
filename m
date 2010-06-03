Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab0FCJjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:39:32 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63016 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0FCJjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AU/iqMJkCFQcCRcsgWAqsX2iV61efRjleZYBno8naIv27Sv7m9NwfAt82epjzEQMxH
         X/D/p5JrizBS+W9bvK5bbVtH9yTpS8bITj3Gi9ZGDNtMuTT+56JnCAwGf+kPGe0R9Zec
         K6UnTAwH7CI5TTXsmAJKqo77I4brSS5QSEN1E=
Date: Thu, 3 Jun 2010 13:39:23 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Luming Yu <luming.yu@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc1 ahci regression
Message-ID: <20100603093923.GA25856@oksana.dev.rtsoft.ru>
References: <AANLkTikWak8i-Kaj-e-EUFWE66tfMmp2UPhGJCKkK1zK@mail.gmail.com>
 <20100603075402.GA11093@oksana.dev.rtsoft.ru>
 <AANLkTil6k_4YwdvLai_VUlVjgz030ctu7djVGHu0qgd2@mail.gmail.com>
 <20100603084104.GA17431@oksana.dev.rtsoft.ru>
 <AANLkTilSNOgD1HrvYBMEsza5-IIeBS1U7AHChO1vJKuf@mail.gmail.com>
 <AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTima_jbwafiHQsncQzdX04ZcjO_8QIpq5UOohi3x@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 05:18:40PM +0800, Luming Yu wrote:
[...]
> Linux version 2.6.32-25.el6.x86_64

Hm. Can you really boot the kernels that has
365cfa1ed5 applied and reverted?

That is, do

$ git reset --hard 365cfa1ed5
$ make
$ ...boot...

And then

$ git reset --hard 365cfa1ed5^
$ make
$ ...boot...

And compare these kernels, not any other.

But based on the 2.6.32 log:

> pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
> pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
> pci 0000:00:1f.2: reg 10 io port: [0xf110-0xf117]
> pci 0000:00:1f.2: reg 14 io port: [0xf100-0xf103]
> pci 0000:00:1f.2: reg 18 io port: [0xf0f0-0xf0f7]
> pci 0000:00:1f.2: reg 1c io port: [0xf0e0-0xf0e3]
> pci 0000:00:1f.2: reg 20 io port: [0xf020-0xf03f]
> pci 0000:00:1f.2: reg 24 32bit mmio: [0xfbf00000-0xfbf007ff]
> pci 0000:00:1f.2: PME# supported from D3hot
> pci 0000:00:1f.2: PME# disabled
[...]

Here is AHCI, "1f.2", I can see it. Good.

There's no such thing in the kernel that doesn't boot. That's
for sure not AHCI driver fault. For the reference, that's
what you have in the non-working kernel:

pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
pci 0000:00:01.0: PCI bridge to [bus 01-02]
pci 0000:00:02.0: PCI bridge to [bus 03-03]
pci 0000:00:03.0: PCI bridge to [bus 04-04]
pci 0000:00:04.0: PCI bridge to [bus 05-05]

(Or maybe it's just newer kernel don't print it for some
reason, I don't know, that's why it's always a good idea to
boot exact kernels that we're debugging).

> dracut: rd_NO_MD: removing MD RAID activation
> pata_jmicron 0000:0f:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> ahci 0000:00:1f.2: version 3.0
> ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19

Good. But there's no such thing in the non-working kernel,
and that's  because non-working kernel doesn't see the PCI
device at all.

So, I still think that you screwed with bisecting or
booting correct kernel ;-), or there's a very subtle bug, which
I don't see yet...

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
