Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab2AaAUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:20:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab2AaAUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:20:09 -0500
Date: Tue, 31 Jan 2012 02:22:05 +0200
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
Message-ID: <20120131002203.GA14344@redhat.com>
References: <cover.1327877053.git.mst@redhat.com>
 <201201301551.46907.arnd@arndb.de>
 <20120130161818.GA9345@redhat.com>
 <201201302004.33083.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201302004.33083.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 08:04:32PM +0000, Arnd Bergmann wrote:
> On Monday 30 January 2012, Michael S. Tsirkin wrote:
> > > 
> > > +/*
> > > + * Create a virtual mapping cookie for a port on a given PCI device.
> > > + * Do not call this directly, it exists to make it easier for architectures
> > > + * to override.
> > > + */
> > > +#ifdef CONFIG_NO_GENERIC_PCI_IOPORT_MAP
> > > +extern void __iomem *__pci_ioport_map(struct pci_dev *dev, unsigned long port,
> > > +                                     unsigned int nr);
> > > +#else
> > > +static inline void __iomem *__pci_ioport_map(struct pci_dev *dev,
> > > +                              unsigned long port, unsigned int nr)
> > > +{
> > > +       return ioport_map(port, nr);
> > > +}
> > > +#endif
> > > 
> > >       Arnd
> > 
> > It would be nicer in that it would
> > make the kernel a bit smaller for generic architectures
> > but this would need to go into a separate header:
> > it depends on io.h and io.h depends on pci_iomap.h.
> 
> Adding extra dependencies is not good here, I agree.
> Maybe  a better solution is to use a macro instead of an inline
> function then:
> 
> #define  __pci_ioport_map(dev, port, nr) ioport_map(port, nr)
> 
> In general, macros should be avoided, but I think it's the
> best tradeoff in this case.
> 
> 	Arnd

I have an idea: we can make the generic one inline
if we keep it in the .c file. So something like
the below on top of my patch will probably work.
Ack?

diff --git a/include/asm-generic/pci_iomap.h b/include/asm-generic/pci_iomap.h
index 2aff58e..2ec1bdb 100644
--- a/include/asm-generic/pci_iomap.h
+++ b/include/asm-generic/pci_iomap.h
@@ -15,11 +15,6 @@ struct pci_dev;
 #ifdef CONFIG_PCI
 /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-/* Create a virtual mapping cookie for a port on a given PCI device.
- * Do not call this directly, it exists to make it easier for architectures
- * to override. */
-extern void __iomem *__pci_ioport_map(struct pci_dev *dev, unsigned long port,
-				      unsigned int nr);
 #else
 static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
 {
@@ -27,4 +22,12 @@ static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned lon
 }
 #endif
 
+#ifdef CONFIG_NO_GENERIC_PCI_IOPORT_MAP
+/* Create a virtual mapping cookie for a port on a given PCI device.
+ * Do not call this directly, it exists to make it easier for architectures
+ * to override. */
+extern void __iomem *__pci_ioport_map(struct pci_dev *dev, unsigned long port,
+				      unsigned int nr);
+#endif
+
 #endif /* __ASM_GENERIC_IO_H */
diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
index 1dfda29..8102f28 100644
--- a/lib/pci_iomap.c
+++ b/lib/pci_iomap.c
@@ -12,9 +12,9 @@
 #ifndef CONFIG_NO_GENERIC_PCI_IOPORT_MAP
 /* Architectures can override ioport mapping while
  * still using the rest of the generic infrastructure. */
-void __iomem *__pci_ioport_map(struct pci_dev *dev,
-			       unsigned long port,
-			       unsigned int nr)
+static inline void __iomem *__pci_ioport_map(struct pci_dev *dev,
+					     unsigned long port,
+					     unsigned int nr)
 {
 	return ioport_map(port, nr);
 }
