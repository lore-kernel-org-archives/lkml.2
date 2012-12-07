Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2LGTHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:07:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2LGTHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:07:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: Sharing PCIE driver between Microblaze and Arm zynq
Date: Fri, 7 Dec 2012 19:07:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, linux-arch@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        John Linn <John.Linn@xilinx.com>, John Williams <jwilliams@xilinx.com>,
        linux-pci@vger.kernel.org
References: <CAHTX3dLxbVxn+D+AV7L0VsGYFOjas3AJ_3M_xncVfxp02FCy=Q@mail.gmail.com> <CAErSpo6xRdwzTuPPqnmvmHSp7awnV7=Z85eWFfktb_hm9Aad_A@mail.gmail.com> <50C1BA9D.5010406@monstr.eu>
In-Reply-To: <50C1BA9D.5010406@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212071907.38366.arnd@arndb.de>
X-Provags-ID: V02:K0:81hdw/VP69uYdZHi9+B7ye2F40ejhPTtnOzik580/Fl
 a8ofNy8c97SGzAd/cN1z0W2sbCpVfXLF9CORtGaTkQs7x1+o8o
 zZL2cr+LcbiUOCRvZb7o7dVIJ1pJOC4xt+hZBnyqnmjUtFRzZw
 7I8VgUKEVPwxPckn+3WqLIkizWreFJYcR1edgLGHohRiTfxK27
 cfbY/BeEb/kDzdPB6lOMqHeBdNberttAL2ovXUlAFz9ApHRVIU
 Awm/lbVgTHcssVlsTvY/VJrG7C0P116LtZMV6Y+HWH0TLsaFRC
 MB1iPLT1hOwlvyFH8NXthA7+ruUcUJQo+RzEUK86bJV7g7c+ES
 Y1PpD3AVzMbeTPjAurLs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2012, Michal Simek wrote:
> On 12/06/2012 10:27 PM, Bjorn Helgaas wrote:
> > [+cc linux-pci]
> >
> > On Thu, Dec 6, 2012 at 7:23 AM, Michal Simek <michal.simek@xilinx.com> wrote:
> >> Hi guys,
> >>
> >> I have a question regarding to sharing generic OF pcie driver between
> >> two architectures MB and ARM Zynq.
> >> Is drivers/pci/pcie location good for it?
> >> Make no sense to have the same driver in two locations.
> >
> > I think you're talking about a PCI host bridge driver.  It would
> > definitely be nice to move toward a generic, shared driver.  Host
> > bridge drivers are responsible for enumerating the PCI hierarchy below
> > the bridge.  Enumeration is not really PCIe-specific, so I wouldn't
> > put it in drivers/pci/pcie.
> 
> Not a PCI expert, just trying to find out the proper location for this shared driver.

I'd suggest creating a drivers/pci/host directory. We will have more of
these in the future. AFAIK, there is no fully generic (architecture
independent) way to interface a PCI host driver to the PCI subsystem,
but I think we are getting closer to that. You are probably fairly
free to modify the microblaze architecture specific code though if needed.

> >> Is using readl/writel IO functions in this driver the best option
> >> which we can have?
> >> Or is there any other recommendation?
> >
> > I'm not really a driver person, but if you're writing a new driver,
> > wouldn't you use the iomap interfaces (ioremap(), ioread32(), etc)
> > rather than readl()?
> 
> That driver exists but it is not in mainline and it is better to directly
> add it to proper location with correct io functions.
> The question is if ioread/iowrite functions are correct one.
> PowerPC io-defs.h suggests that readl/writel should be used for PCI.

ioread32/iowrite32 are defined to behave the same way readl/writel regarding
addressing modes and barriers, but also allow operating on __iomem pointers
that were returned from ioport_map(). You probably don't need that.

Some architectures like powerpc have their own accessors for on-chip MMIO
areas, but ARM does not. The PowerPC rule is that you must use either
readl/writel or ioread32/iowrite32 to access devices connected to a PCI
bus, but you would not necessarily do that for the PCI host controller
itself on PowerPC.

	Arnd

	Arnd
