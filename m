Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab1JNNur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:50:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44016 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1JNNuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:50:44 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH v2 2/4] ata_piix: unify code for programming PIO and MWDMA timings
Date: Fri, 14 Oct 2011 15:43:09 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9-0.7-desktop-00073-g37cf951-dirty; KDE/4.6.0; x86_64; ; )
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201110131539.11190.bzolnier@gmail.com> <4E9824AC.6020902@mvista.com>
In-Reply-To: <4E9824AC.6020902@mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110141543.27060.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:

> Hello.
> 
> On 13-10-2011 17:39, Bartlomiej Zolnierkiewicz wrote:
> 
> > From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> > Subject: [PATCH v2] ata_piix: unify code for programming PIO and MWDMA timings
> 
> > Besides making things noticably simpler it results in ~2% decrease in
> > the driver LOC count and also ~2% decrease in the driver binary size
> > (as measured on x86-32).
> 
> > Fix piix_set_piomode() documentation while at it.
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> 
>     I'm still inclined to NAK this patch.
> 
> > ---
> > v2: remove use_mwdma variable and fix comment style
> 
> > earlier references:
> > https://lkml.org/lkml/2011/2/8/99
> >
> >   drivers/ata/ata_piix.c |  111 ++++++++++++++++---------------------------------
> >   1 file changed, 38 insertions(+), 73 deletions(-)
> 
> > Index: b/drivers/ata/ata_piix.c
> > ===================================================================
> > --- a/drivers/ata/ata_piix.c
> > +++ b/drivers/ata/ata_piix.c
> [...]
> > @@ -811,31 +822,20 @@ static void do_pata_set_dmamode(struct a
> [...]
> > -	if (ap->udma_mask)
> > -		pci_read_config_byte(dev, 0x48,&udma_enable);
> 
>     Don't think you should remove this.
> 
> > -
> >   	if (speed>= XFER_UDMA_0) {
> > -		unsigned int udma = adev->dma_mode - XFER_UDMA_0;
> > +		unsigned int udma = speed - XFER_UDMA_0;
> >   		u16 udma_timing;
> >   		u16 ideconf;
> >   		int u_clock, u_speed;
> >
> > +		spin_lock_irqsave(&piix_lock, flags);
> > +
> > +		pci_read_config_byte(dev, 0x48, &udma_enable);
> 
>     But you should also clear the UDMA enable bit when setting an MWDMA mode, no?
> 
> > +
> >   		/*
> >   		 * UDMA is handled by a combination of clock switching and
> >   		 * selection of dividers
> > @@ -868,56 +868,21 @@ static void do_pata_set_dmamode(struct a
> >   			   performance (WR_PingPong_En) */
> >   			pci_write_config_word(dev, 0x54, ideconf);
> >   		}
> > +
> > +		pci_write_config_byte(dev, 0x48, udma_enable);
> > +
> > +		spin_unlock_irqrestore(&piix_lock, flags);
> >   	} else {
> > -		/*
> > -		 * MWDMA is driven by the PIO timings. We must also enable
> > -		 * IORDY unconditionally along with TIME1. PPE has already
> > -		 * been set when the PIO timing was set.
> > -		 */
> > -		unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
> > -		unsigned int control;
> > -		u8 slave_data;
> > +		/* MWDMA is driven by the PIO timings. */
> > +		unsigned int mwdma = speed - XFER_MW_DMA_0;
> >   		const unsigned int needed_pio[3] = {
> >   			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
> >   		};
> >   		int pio = needed_pio[mwdma] - XFER_PIO_0;
> >
> [...]
> > -		if (ap->udma_mask)
> > -			udma_enable&= ~(1<<  devid);
> 
>     Still don't understand why you're removing this code.
> 
> > -
> > -		pci_write_config_word(dev, master_port, master_data);
> > +		/* XFER_PIO_0 is never used currently */
> > +		piix_set_timings(ap, adev, pio);
> >   	}
> > -	/* Don't scribble on 0x48 if the controller does not support UDMA */
> > -	if (ap->udma_mask)
> > -		pci_write_config_byte(dev, 0x48, udma_enable);
> 
>     Should have kept this one too...

We still have following code at the end of piix_set_timings():

	/* Ensure the UDMA bit is off - it will be turned back on if
	   UDMA is selected */

	if (ap->udma_mask) {
		pci_read_config_byte(dev, 0x48, &udma_enable);
		udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
		pci_write_config_byte(dev, 0x48, udma_enable);
	}

so everything should be OK.

