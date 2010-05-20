Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0ETIE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:04:27 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:41492 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab0ETIEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sAFmTWmgNrGPFZF2s6RxhZNDOeT1eoJs9oWJInwX91DqQ/XJOSNZHeafKch6lDlfKy
         qWQ90nb2d9mf9BZvKXQTKLa0GrgVyFcLSe4KWU36sDJe60YgkXMYYRYkSnmLH4ZpwYdi
         XuyKxohdGQqdaCjxGiE+a+zMF2LX2BA1laRiU=
MIME-Version: 1.0
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 20 May 2010 16:04:02 +0800
Message-ID: <AANLkTilpV71K2L2N1B85yRnlTc302KbMUz2P5kuvktyl@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 1:43 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> At Tilera we have been running Linux 2.6.26 on our architecture for a
> while and distributing the sources to our customers.  We just sync'ed up
> our sources to 2.6.34 and would like to return it to the community more
> widely, so I'm hoping to take advantage of the merge window for 2.6.35
> to integrate support for our architecture.
>
> The "tile" architecture supports the Tilera chips, both our current
> 32-bit chips and our upcoming 64-bit architecture.  The chips are
> multicore, with 64 (or 36) cores per chip on our current product line,
> and up to 100 cores on the upcoming 64-bit architecture.  They also
> include multiple built-in memory controllers, 10 Gb Ethernet, PCIe,
> and a number of other I/Os.  There's more info at http://www.tilera.com.
>
> The architecture is somewhat MIPS-like, but VLIW, with up to three
> instructions per bundle.  The system architecture is nicely orthogonal,
> with four privilege levels that can be assigned to each of forty-odd
> separate protection domains, many with an associated interrupt, e.g.
> ITLB/DTLB misses, timer, performance counters, various interrupts
> associated with the generic networks that connect the cores, etc.
> A hypervisor (kind of like the Alpha PAL) runs at a higher privilege
> level to support Linux via software-interrupt calls.
>
> The Linux we ship has some additional performance and functionality
> customization in the generic code, but appended is the patch that just
> adds the minimum amount of functionality into the platform-independent
> code to hook in the tile architecture code in arch/tile.  We will
> attempt to push the other changes to the platform-independent code
> piece by piece, after the initial architecture support is in.
> We will also push up the 64-bit TILE-Gx support once that architecture
> is fully frozen (e.g. instruction encodings finalized).
>
> We are using the http://www.tilera.com/scm/ web site to push
> Tilera-modified sources back up to the community.  At the moment, the
> arch/tile hierarchy is there (as a bzipped tarball) as well as a copy
> of the patch appended to this email.  In addition, our gcc, binutils,
> and gdb sources are available on the web site.  We have not yet started
> the community return process for gcc, binutils, and gdb, so they are in
> a preliminary form at this point.
>
> The git://www.tilera.com server is up, but without content yet, since
> we realized this week that we need to upgrade the web server to
> a 64-bit kernel to support a decent git server, so though we plan to
> make the code available via git in the future, it isn't yet.
>
> As far as the platform-independent changes go, two of the changes in the
> appended patch are uncontroversial, one adding a stanza to MAINTAINERS,
> and one adding a line to drivers/pci/Makefile to request "setup-bus.o
> setup-irq.o" for tile PCI.
>
> A slightly more interesting one-line change is to <linux/mm.h>,
> to support lowmem PAs above the 4GB limit.  We use NUMA to manage
> the multiple memory controllers attached to the chip, and map some of
> each controller into kernel LOWMEM to load-balance memory bandwidth for
> kernel-intensive apps.  The controllers can each manage up to 16GB, so we
> use bits above the 4GB limit in the PA to indicate the controller number.
> It turns out that generic Linux almost tolerates this, but requires one
> cast in lowmem_page_address() to avoid shifting the high PA bits out of
> a 32-bit PFN type.
>
> The final change is just a PCI quirk for our TILEmpower platform, which
> explains itself in the comment.  This is not a critical change from our
> point of view, but without it you can't use the SATA disks attached to
> the PCI controller on that platform, so we're hoping it can be accepted
> as part of the initial tile architecture submission as well.
>
> I'd appreciate being cc'ed on any comments on the patch or the tile
> architecture support, since although I try to follow LKML, the volume
> can be somewhat overwhelming.
>
>
> --- linux-2.6.34/MAINTAINERS    2010-05-16 17:17:36.000000000 -0400
> +++ tilera-source/MAINTAINERS   2010-05-17 18:00:12.651112000 -0400
> @@ -5436,6 +5436,12 @@
>  S:     Maintained
>  F:     sound/soc/codecs/twl4030*
>
> +TILE ARCHITECTURE
> +M:     Chris Metcalf <cmetcalf@tilera.com>
> +W:     http://www.tilera.com/scm/
> +S:     Supported
> +F:     arch/tile/
> +
>  TIPC NETWORK LAYER
>  M:     Jon Maloy <jon.maloy@ericsson.com>
>  M:     Allan Stephens <allan.stephens@windriver.com>
> --- linux-2.6.34/include/linux/mm.h     2010-05-16 17:17:36.000000000 -0400
> +++ tilera-source/include/linux/mm.h    2010-05-17 12:54:33.540145000 -0400
> @@ -592,7 +592,7 @@
>
>  static __always_inline void *lowmem_page_address(struct page *page)
>  {
> -       return __va(page_to_pfn(page) << PAGE_SHIFT);
> +       return __va((phys_addr_t)page_to_pfn(page) << PAGE_SHIFT);

Here doesn't make sense. you give a u64 type cast, but change the
meaning of pfn. Is pfn phys_addr_t? Anyway, page_to_pfn can be
re-fulfilled in your arch, but not change it in common code.

>  }
>
>  #if defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL)
> --- linux-2.6.34/drivers/pci/Makefile   2010-05-09 21:36:28.000000000 -0400
> +++ tilera-source/drivers/pci/Makefile  2010-05-13 15:03:05.615238000 -0400
> @@ -49,6 +49,7 @@
>  obj-$(CONFIG_X86_VISWS) += setup-irq.o
>  obj-$(CONFIG_MN10300) += setup-bus.o
>  obj-$(CONFIG_MICROBLAZE) += setup-bus.o
> +obj-$(CONFIG_TILE) += setup-bus.o setup-irq.o
>
>  #
>  # ACPI Related PCI FW Functions
> --- linux-2.6.34/drivers/pci/quirks.c   2010-05-16 17:17:36.000000000 -0400
> +++ tilera-source/drivers/pci/quirks.c  2010-05-17 13:26:22.347178000 -0400
> @@ -2094,6 +2094,23 @@
>                        quirk_unhide_mch_dev6);
>
>
> +/*
> + * The Tilera Blade V1.0 platform needs to set the link speed
> + * to 2.5GT(Giga-Transfers)/s (Gen 1). The default link speed
> + * setting is 5GT/s (Gen 2). 0x98 is the Link Control2 PCIe
> + * capability register of the PEX8624 PCIe switch. The switch
> + * supports link speed auto negotiation. This is expected to
> + * be fixed in the next release of the Blade platform.
> + */
> +static void __devinit quirk_tile_blade(struct pci_dev *dev)
> +{
> +       if (blade_pci) {
> +               pci_write_config_dword(dev, 0x98, 0x1);
> +               mdelay(50);
> +       }
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_PLX, 0x8624, quirk_tile_blade);

Your patch is not compilable, and the subject doesn't match well with
the content. I think you need re-organize patches.

> +
>  #ifdef CONFIG_PCI_MSI
>  /* Some chipsets do not support MSI. We cannot easily rely on setting
>  * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
