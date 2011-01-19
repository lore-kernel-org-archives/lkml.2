Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1ASOrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:47:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52788 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab1ASOrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:47:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas.bonn@gmail.com>
Subject: Re: [PATCH] asm-generic/io.h: Fix io{read,write}{16,32}be for big endian systems
Date: Wed, 19 Jan 2011 15:47:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Lars-Peter Clausen" <lars@metafoo.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1295374261-19609-1-git-send-email-lars@metafoo.de> <201101191058.30096.arnd@arndb.de> <AANLkTimaTOBfC18TUyTDZ-9CLGv8qGJG714-d7Jk7NVr@mail.gmail.com>
In-Reply-To: <AANLkTimaTOBfC18TUyTDZ-9CLGv8qGJG714-d7Jk7NVr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101191547.14493.arnd@arndb.de>
X-Provags-ID: V02:K0:1ecBLc0n0lOQ6FwWM0QCgdLKCo0RXzPkw5AIvCNS8Hr
 2bWwauMQu52dTpnbxpGN3UP2ugFQq5tgUbvw6BzOIgC0iVPKJ9
 InwkMkWcWfO6Kyjx/m9vDEMZdRHQjwam/har3i56u93C4TWJRn
 95eTPQEr2+8+mnYnhBNbN4p4av8kBhl4k4IZOB8y+wGqfhY2P5
 ZTRb3x91dVCOxzc4ILvBg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 January 2011, Jonas Bonn wrote:
> The ioread/write accessors are supposed to be a platform-agnostic
> interface and have a builtin assumption about the endianess of the
> device/bus.  Device drivers that use ioread32 are explicity accessing
> a little-endian device; ioread32be explicitly a big-endian device.
> It's not really for the architecture to redefine these.  The same
> applies to the readl/readw accessors as well, as far as I understand
> it.

Yes. The difference between readl and ioread32 is that readl is
defined to work on PCI MMIO areas that are mapped through ioremap
(and may work on other things, depending on the architecture),
while ioread32 must work on both PCI MMIO and PCI PIO registers
mapped with ioremap, ioport_map or pci_iomap. All of these devices
are expected to have fixed endianess, which is independent of the
CPU endianess.

> What's needed is another way of accessing device memory that doesn't
> carry the endianess implication.  For the Wishbone bus, used by the
> OpenRISC processor, I still haven't found a more satisfactory solution
> than to define "wishbone accessors" that map to the underlying
> io-accessors of the desired endianess.  These allow the endianess of
> the bus to be set at compile time and hopefully for all wishbone
> device drivers to do the right thing.
> 
> #ifdef CONFIG_WISHBONE_BIG_ENDIAN
> #define wb_ioread8(p) ioread8(p)
> #define wb_ioread16(p) ioread16be(p)
> #define wb_ioread32(p) ioread32be(p)
> #define wb_iowrite8(p) iowrite8(p)
> #define wb_iowrite16(p) iowrite16be(p)
> #define wb_iowrite32(p) iowrite32be(p)
> #else
> #define wb_ioread8(p) ioread8(p)
> #define wb_ioread16(p) ioread16(p)
> #define wb_ioread32(p) ioread32(p)
> #define wb_iowrite8(p) iowrite8(p)
> #define wb_iowrite16(p) iowrite16(p)
> #define wb_iowrite32(p) iowrite32(p)
> #endif /* CONFIG_WISHBONE_BIG_ENDIAN */

Right. A number of buses do the same right now, for similar reasons.

> That said, there are architectures that do redefine the endianess of
> the io-accessors to mean "native endianess", but this must have
> implications for a large number of the drivers in the kernel tree and,
> in my opinion, must be technically _incorrect_.  A driver written with
> ioread32 shouldn't have the endianess of the access changed by the
> architecture underneath it... or are others of a different opinion?

I think you are absolutely right.

> >> > * change the common ioread*/iowrite* functions to all be based on
> >> >   the __raw_* I/O versions, not just the big-endian ones. The
> >> >   space overhead you quoted is enough of a justification for that.
> >>
> 
> Doing this breaks the endianess assumption built into the io-accessors.

To be clearer, I did not suggest 

#define ioread32(p) __raw_readl(p)
#define ioread32be(p) __raw_readl(p)

but instead

#define ioread32(p) le32_to_cpu(__raw_readl(p))
#define ioread32be(p) be32_to_cpu(__raw_readl(p))

You can consider this as the least invasive variant as long as you never
intend to run Linux on the other endianess. Many powerpc and arm CPUs
have variable endianess, but Linux assumes that powerpc is always big-endian
and ARM is always little-endian for the majority of the boards, even
if it would be possible to configure them differently. Strictly speaking,
you are right that it is not technically correct to use a fixed-endian
accessor to talk to a native-endian device, but as long as the kernel is
also fixed-endian, it will not cause actual harm.

Besides, something I've seen a few times now is that native-endian
SoC devices end up getting put behind bus bridges with a fixed-endianess
eventually, and you have to change the code again. See usb-ohci for a
common example.

	Arnd
