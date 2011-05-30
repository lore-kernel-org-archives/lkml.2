Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1E3KJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:09:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:6429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab1E3KJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:09:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,290,1304319600"; 
   d="scan'208";a="9374551"
Date: Mon, 30 May 2011 10:56:33 +0100
From: Alan Cox <alan@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] 8250_pci: add -ENODEV code for Intel EG20T PCH
Message-ID: <20110530105633.596ab8ab@bob.linux.org.uk>
In-Reply-To: <20110530074722.GA7947@suse.de>
References: <1306741324-4562-1-git-send-email-tomoya-linux@dsn.okisemi.com>
	<20110530074722.GA7947@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 15:47:22 +0800
Greg KH <gregkh@suse.de> wrote:

> On Mon, May 30, 2011 at 04:42:04PM +0900, Tomoya MORINAGA wrote:
> > Intel EG20T PCH has UART device which is compatible with 8250.
> > Currently, with general configuration, the PCH UART driver is not
> > loaded but 8250 standard driver is loaded. Therefore, in case of
> > using PCH UART driver, need to disable 8250 pci function. However,
> > this procedure is not best solution.
> > 
> > This patch, in 8250_pci, if the device is the PCH or the family IOH,
> > '-ENODEV' is returned.
> > As a result, disabling 8250-pci processing becomes unnecessary.
> > 
> > Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
> > ---
> >  drivers/tty/serial/8250_pci.c |   13 +++++++++++++
> >  1 files changed, 13 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/8250_pci.c
> > b/drivers/tty/serial/8250_pci.c index 738cec9..2678d9d 100644
> > --- a/drivers/tty/serial/8250_pci.c
> > +++ b/drivers/tty/serial/8250_pci.c
> > @@ -2559,6 +2559,19 @@ pciserial_init_one(struct pci_dev *dev,
> > const struct pci_device_id *ent) return -EINVAL;
> >  	}
> >  
> > +#if defined(CONFIG_SERIAL_PCH_UART) ||
> > defined(CONFIG_SERIAL_PCH_UART_MODULE)
> > +	if ((dev->vendor == PCI_VENDOR_ID_INTEL && dev->device ==
> > 0x8811) ||
> > +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device ==
> > 0x8812) ||
> > +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device ==
> > 0x8813) ||
> > +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device ==
> > 0x8814) ||
> > +	   (dev->vendor == 0x10DB && dev->device == 0x8027) ||
> > +	   (dev->vendor == 0x10DB && dev->device == 0x8028) ||
> > +	   (dev->vendor == 0x10DB && dev->device == 0x8029) ||
> > +	   (dev->vendor == 0x10DB && dev->device == 0x800C) ||
> > +	   (dev->vendor == 0x10DB && dev->device == 0x800D))
> > +		return -ENODEV;
> > +#endif
> 
> Why put this with an #if around it?  Why not just always not bind to
> this driver as we have a "correct" driver for the hardware now?

Because if the PCH driver is not available you want to bind it to the
8250 driver, which also works with it but less efficiently.

The giant if probably should be a pci match table however

Alan
