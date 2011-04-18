Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1DRVUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:20:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59123 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1DRVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:20:20 -0400
Date: Mon, 18 Apr 2011 22:20:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@linux.ie, Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] drm: Add a driver for kvm emulated Cirrus
Message-ID: <20110418212013.GA1778@srcf.ucam.org>
References: <1303157094-11425-1-git-send-email-mjg@redhat.com>
 <20110418220306.7799d850@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418220306.7799d850@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:03:06PM +0100, Alan Cox wrote:
> So has this been benchmarked - intuitively I'd agree and expect that a
> shadowfb driver ought to give best performance.

No, but it's noticably nicer to use under virt-manager. I'll try to come 
up with some numbers.

> > +/* Map the framebuffer from the card and configure the core */
> > +static int cirrus_vram_init(struct cirrus_device *cdev)
> > +{
> > +	int ret;
> > +
> > +	/* BAR 0 is VRAM */
> > +	cdev->mc.vram_base = pci_resource_start(cdev->ddev->pdev, 0);
> > +	/* We have 4MB of VRAM */
> > +	cdev->mc.vram_size = 4 * 1024 * 1024;
> 
> For real hardware at least you should check that the pci resource is at
> least 4Mb long before doing this, otherwise the resulting progression in
> the fail case is that you map some other device into user address space,
> which isn't good!

True. The PCI table is restrictive enough that it won't bind to real 
hardware, so I don't know if it's worth it to be paranoid.

> > +static void cirrus_encoder_mode_set(struct drm_encoder *encoder,
> > +				struct drm_display_mode *mode,
> > +				struct drm_display_mode *adjusted_mode)
> > +{
> > +	struct drm_device *dev = encoder->dev;
> > +	struct cirrus_device *cdev = dev->dev_private;
> > +
> > +	unsigned char tmp;
> > +
> > +	switch (encoder->crtc->fb->bits_per_pixel) {
> > +	case 8:
> > +		tmp = 0x0;
> > +		break;
> > +	case 16:
> > +		/* Enable 16 bit mode */
> > +		WREG_HDR(0x01);
> 
> If you switch back from 16 does this not need clearing ?

Nope. qemu just looks at this to distinguish between 15 and 16 bit, and 
I've no intention of supporting 15 bit...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
