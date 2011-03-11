Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1CKJOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:14:49 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:13949 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1CKJOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:14:44 -0500
X-IronPort-AV: E=Sophos;i="4.62,302,1297036800"; 
   d="scan'208";a="4738007"
Subject: Re: [GIT PATCH v2 0/14] xen: events: cleanups + ween off nr_irqs
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110310232329.GA11684@dumpdata.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
	 <20110310225726.GA2983@dumpdata.com>  <20110310232329.GA11684@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 11 Mar 2011 09:14:42 +0000
Message-ID: <1299834882.17339.1803.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 23:23 +0000, Konrad Rzeszutek Wilk wrote:
> > > There is no ideal sequencing of this series vs e7bcecb7b1d2 (most should
> > > have gone in before, but the penultimate patch really needed to be
> > > simultaneous) so I haven't bothered to try and pull anything from tip
> > > into this branch -- it should all be resolved during the merge window
> > > and bisection won't be too broken since the "eat into GSI space"
> > > workaround only appears to be needed on a small number of older
> > > platforms (qemu being the main exception).
> > 
> > <nods>
> > > 
> > > I have tested:
> > >       * Domain 0 on real h/w and under qemu
> > >       * PV guest, including migration and passthrough of both VF and PF.
> > >       * PVHVM guest, including migration and passthrough of both VF and
> > >         PF.
> > 
> > I am having difficulties with passthrough of an USB device. Somehow the
> > irq count is not going up at all (both in dom0 and domU) and it looks to
> > be doing just simple polling. I've rebased the xen-pciback to be on top
> > of your changes and apply cleanly. The whole lot is now in #master
> > 
> > MSI and MSI-X devices work just fine in both Dom0 and DomU case so
> > it is something special with the legacy IRQs. Probably forgot something
> > simple...
> 
> This looks like it would fix the culprit:
> [edit: not entirely]
> 
> diff --git a/drivers/xen/pciback/conf_space_header.c b/drivers/xen/pciback/conf_space_header.c
> index 22ad0f5..3eeb197 100644
> --- a/drivers/xen/pciback/conf_space_header.c
> +++ b/drivers/xen/pciback/conf_space_header.c
> @@ -6,6 +6,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/pci.h>
> +#include <xen/events.h>
>  #include "pciback.h"
>  #include "conf_space.h"
>  
> @@ -246,7 +247,7 @@ static int pciback_read_device(struct pci_dev *dev, int offset,
>  static int interrupt_read(struct pci_dev *dev, int offset, u8 * value,
>                           void *data)
>  {
> -       *value = (u8) dev->irq;
> +       *value = (u8) dev->irq ? xen_pirq_from_irq(dev->irq) : 0;
>  
>         return 0;
>  }
> 
> Thought I am not sure if this is absolutly correct. Are the PIRQs == GSI

not necessarily. PIRQs (at least as used here) are also an internal Xen
concept which shouldn't be exposed outside of the lowlevel event
handling.

>  or should
> we provide another piece of code to extract info->u.pirq.gsi?

I think we've got one already. But I'll need to have a think about what
the correct return is here.

> I also see this when using xen-pciback.hide=..
> 
> pciback 0000:00:1d.7: found PCI INT A -> IRQ 14
> pciback 0000:00:1d.7: sharing IRQ 14 with 0000:00:1d.0
> pciback 0000:00:1d.0: found PCI INT A -> IRQ 14
> pciback 0000:00:1d.0: sharing IRQ 14 with 0000:00:1d.7
> pciback 0000:00:1d.1: found PCI INT B -> IRQ 5
> pciback 0000:00:1d.1: sharing IRQ 5 with 0000:00:16.3
> pciback 0000:00:1d.1: sharing IRQ 5 with 0000:00:16.7
> pciback 0000:00:1d.1: sharing IRQ 5 with 0000:00:1a.2
> ..
> .. which are clearly the Linux IRQ's, not the PIRQ/GSI values,
> so some other patch for the xen-pciback will be needed as well.

Hmm, yes. 

Ian.

