Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab2KEKyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:54:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58193 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951Ab2KEKym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:54:42 -0500
Date: Mon, 5 Nov 2012 10:54:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        lenb@kernel.org, rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121105105440.GA22994@opensource.wolfsonmicro.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com> <1351928793-14375-3-git-send-email-mika.westerberg@linux.intel.com> <CAErSpo5q64uEse3aYYZkuQrD+9AJ9HFP_VVB1TabYfO-_BvY3g@mail.gmail.com> <20121103201310.GQ16648@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121103201310.GQ16648@intel.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 10:13:10PM +0200, Mika Westerberg wrote:
> On Sat, Nov 03, 2012 at 01:42:02PM -0600, Bjorn Helgaas wrote:

> > > +       case ACPI_RESOURCE_TYPE_IRQ:
> > > +               info->gsi = res->data.irq.interrupts[0];
> > > +               info->triggering = res->data.irq.triggering;
> > > +               info->polarity = res->data.irq.polarity;
> > > +               break;

> > > +       case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
> > > +               info->gsi = res->data.extended_irq.interrupts[0];
> > > +               info->triggering = res->data.extended_irq.triggering;
> > > +               info->polarity = res->data.extended_irq.polarity;

> > A driver doesn't seem like the right place for _CRS parsing code.  I
> > think the intent of _CRS is to describe resources that need to be
> > coordinated across all devices, e.g., MMIO space, I/O port space, and
> > IRQs.  Since these resources require system-wide coordination, even
> > when we don't have drivers for some devices, the ACPI core should be
> > able to parse _CRS without needing any device-specific knowledge.

> I think the driver is the only one who really knows the resources it needs
> in order to talk the hardware.

Generic SPI drivers expect the subsystem to supply them with an
interrupt number; if there is a single interrupt it seems reasonable for
the generic code to continue to do that for them when they're
instantiated from ACPI.  On the other hand if there are muliple
interrupts it should probably give up and punt to the driver.

> The purpose of the above code is to extract the resources in a suitable
> form so that we can create a struct spi_device out of them automatically,
> in a similar way than the Device Tree does.

Definitely agreed.
