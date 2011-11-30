Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab1K3L6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:58:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab1K3L6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:58:30 -0500
Date: Wed, 30 Nov 2011 13:59:58 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH-RFC 1/2] tile: don't panic on iomap
Message-ID: <20111130115956.GA21413@redhat.com>
References: <cover.1322592494.git.mst@redhat.com>
 <201111292205.11544.arnd@arndb.de>
 <20111130071321.GB17781@redhat.com>
 <201111300909.18431.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111300909.18431.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 09:09:18AM +0000, Arnd Bergmann wrote:
> On Wednesday 30 November 2011, Michael S. Tsirkin wrote:
> > 
> > On Tue, Nov 29, 2011 at 10:05:11PM +0000, Arnd Bergmann wrote:
> > > On Tuesday 29 November 2011, Michael S. Tsirkin wrote:
> > > > diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
> > > > index c9ea165..be6090d 100644
> > > > --- a/arch/tile/include/asm/io.h
> > > > +++ b/arch/tile/include/asm/io.h
> > > > @@ -204,7 +204,8 @@ static inline long ioport_panic(void)
> > > >  
> > > >  static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
> > > >  {
> > > > -       return (void __iomem *) ioport_panic();
> > > > +       pr_info("Trying to map an IO resource - it does not exit on tile.\n");
> > > > +       return NULL;
> > > >  }
> > > 
> > > Why not just set CONFIG_NO_IOPORT and make this unavailable at compile time?
> > > 
> > >       Arnd
> > 
> > Well I think CONFIG_NO_IOPORT only has effect if you pull in asm-generic/io.h.
> > This might work but I have no idea.
> 
> NO_IOPORT ha nothing to do with asm-generic, it just makes lib/iomap.c leave out
> the calls to ioport_map, and prevent all drivers that call ioport_map from being
> built.

Yes. But lib/iomap.c isn't even linked unless GENERIC_IOMAP is set.

> > Presumably whoever wrote that architecture considered and discarded setting GENERIC_IOMAP.
> 
> The tile PCI controller is apparently special in that it does not map the
> PIO region into MMIO space, or make it available in any other way, so generic
> iomap with IOCOND is pointless. Setting NO_IPORT will still mean that drivers
> using ioport_map will not be built. This mostly impacts the legacy (non-AHCI)
> ATA controllers, which I assume are not used on tile anyway.
> 
> 	Arnd


I don't object to setting NO_IPORT at all, but this won't help address
the problem this patch is fixing, which is to use a generic pci_iomap
on tile.

-- 
MST
