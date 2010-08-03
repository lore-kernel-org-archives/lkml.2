Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab0HCQgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:36:11 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:34530 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755510Ab0HCQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:36:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pmgwnMwsgiqKcB8Wmzlj1BsKvJb5Tjy/tYsdHiSYXd8zx4o/HTe+/Mfpa9C4S1pkz/t8ePoiF9kff/DpP+4BNSXbh0fb1eUi13D2hAe5OD2oORbYReMEzUeLpgv2gUGD;
Date: Tue, 3 Aug 2010 09:36:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Frans Pop <elendil@planet.nl>, Thomas Gleixner <tglx@linutronix.de>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] parisc: superio: do not use PCI resources before
 pci_enable_device()
Message-ID: <20100803093605.21248480@virtuousgeek.org>
In-Reply-To: <1280851880.2774.36.camel@mulgrave.site>
References: <1280850253-6128-1-git-send-email-segooon@gmail.com>
	<1280851880.2774.36.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 11:11:20 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2010-08-03 at 19:44 +0400, Kulikov Vasiliy wrote:
> >  drivers/parisc/superio.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
> > index f7806d8..c8a36a2 100644
> > --- a/drivers/parisc/superio.c
> > +++ b/drivers/parisc/superio.c
> > @@ -169,8 +169,6 @@ superio_init(struct pci_dev *pcidev)
> >  	/* ...then properly fixup the USB to point at suckyio PIC */
> >  	sio->usb_pdev->irq = superio_fixup_irq(sio->usb_pdev);
> >  
> > -	printk(KERN_INFO PFX "Found NS87560 Legacy I/O device at %s (IRQ %i)\n",
> > -	       pci_name(pdev), pdev->irq);
> >  
> >  	pci_read_config_dword (pdev, SIO_SP1BAR, &sio->sp1_base);
> >  	sio->sp1_base &= ~1;
> > @@ -204,6 +202,9 @@ superio_init(struct pci_dev *pcidev)
> >  	ret = pci_enable_device(pdev);
> >  	BUG_ON(ret < 0);	/* not too much we can do about this... */
> >  
> > +	printk(KERN_INFO PFX "Found NS87560 Legacy I/O device at %s (IRQ %i)\n",
> > +	       pci_name(pdev), pdev->irq);
> > +
> >  	/*
> >  	 * Next project is programming the onboard interrupt controllers.
> >  	 * PDC hasn't done this for us, since it's using polled I/O.
> 
> This really makes no sense; we want the information printed before we
> start all the discovery prints, not after.  I assume lots of
> initialisers want this too, so it looks particularly silly not to have
> pci_name() returning the correct value until enable time.
> 
> If this is just the name initially assigned may change, this definitely
> isn't true for parisc, and even for other things, it would be better to
> print something than nothing.

Right.  Some of these "enable before use" patches are ok, for example
in some cases the IRQ may not be fully set up or resources may not be
enabled, so re-ordering things makes sense.

But just printing these values at init time should be harmless.  So
perhaps a smarter static check script is in order.

-- 
Jesse Barnes, Intel Open Source Technology Center
