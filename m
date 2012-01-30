Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab2A3QQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:16:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab2A3QQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:16:27 -0500
Date: Mon, 30 Jan 2012 18:18:19 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael Witten <mfwitten@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] lib: add NO_GENERIC_PCI_IOPORT_MAP
Message-ID: <20120130161818.GA9345@redhat.com>
References: <cover.1327877053.git.mst@redhat.com>
 <d78d91d0166651700cf662a50c87d84da4bdab88.1327877053.git.mst@redhat.com>
 <201201301551.46907.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201301551.46907.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 03:51:46PM +0000, Arnd Bergmann wrote:
> On Monday 30 January 2012, Michael S. Tsirkin wrote:
> > --- a/include/asm-generic/pci_iomap.h
> > +++ b/include/asm-generic/pci_iomap.h
> > @@ -15,6 +15,11 @@ struct pci_dev;
> >  #ifdef CONFIG_PCI
> >  /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
> >  extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
> > +/* Create a virtual mapping cookie for a port on a given PCI device.
> > + * Do not call this directly, it exists to make it easier for architectures
> > + * to override. */
> > +extern void __iomem *__pci_ioport_map(struct pci_dev *dev, unsigned long port,
> > +                                     unsigned int nr);
> >  #else
> >  static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
> >  {
> > index 4b0fdc2..1dfda29 100644
> > --- a/lib/pci_iomap.c
> > +++ b/lib/pci_iomap.c
> > @@ -9,6 +9,16 @@
> >  #include <linux/export.h>
> >  
> >  #ifdef CONFIG_PCI
> > +#ifndef CONFIG_NO_GENERIC_PCI_IOPORT_MAP
> > +/* Architectures can override ioport mapping while
> > + * still using the rest of the generic infrastructure. */
> > +void __iomem *__pci_ioport_map(struct pci_dev *dev,
> > +                              unsigned long port,
> > +                              unsigned int nr)
> > +{
> > +       return ioport_map(port, nr);
> > +}
> > +#endif
> >  /**
> >   * pci_iomap - create a virtual mapping cookie for a PCI BAR
> >   * @dev: PCI device that owns the BAR
> 
> This looks correct, but it would be nicer to express this with an inline
> function and keeping the new #ifdef to the header file, like
> 
> +/*
> + * Create a virtual mapping cookie for a port on a given PCI device.
> + * Do not call this directly, it exists to make it easier for architectures
> + * to override.
> + */
> +#ifdef CONFIG_NO_GENERIC_PCI_IOPORT_MAP
> +extern void __iomem *__pci_ioport_map(struct pci_dev *dev, unsigned long port,
> +                                     unsigned int nr);
> +#else
> +static inline void __iomem *__pci_ioport_map(struct pci_dev *dev,
> +                              unsigned long port, unsigned int nr)
> +{
> +       return ioport_map(port, nr);
> +}
> +#endif
> 
> 	Arnd

It would be nicer in that it would
make the kernel a bit smaller for generic architectures
but this would need to go into a separate header:
it depends on io.h and io.h depends on pci_iomap.h.

Worth it?

-- 
MST
