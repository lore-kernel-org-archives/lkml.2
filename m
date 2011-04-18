Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab1DRVCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:02:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53658 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751750Ab1DRVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:02:36 -0400
Date: Mon, 18 Apr 2011 22:03:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        airlied@linux.ie, Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] drm: Add a driver for kvm emulated Cirrus
Message-ID: <20110418220306.7799d850@lxorguk.ukuu.org.uk>
In-Reply-To: <1303157094-11425-1-git-send-email-mjg@redhat.com>
References: <1303157094-11425-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So has this been benchmarked - intuitively I'd agree and expect that a
shadowfb driver ought to give best performance.

> +/* Map the framebuffer from the card and configure the core */
> +static int cirrus_vram_init(struct cirrus_device *cdev)
> +{
> +	int ret;
> +
> +	/* BAR 0 is VRAM */
> +	cdev->mc.vram_base = pci_resource_start(cdev->ddev->pdev, 0);
> +	/* We have 4MB of VRAM */
> +	cdev->mc.vram_size = 4 * 1024 * 1024;

For real hardware at least you should check that the pci resource is at
least 4Mb long before doing this, otherwise the resulting progression in
the fail case is that you map some other device into user address space,
which isn't good!

> +static void cirrus_encoder_mode_set(struct drm_encoder *encoder,
> +				struct drm_display_mode *mode,
> +				struct drm_display_mode *adjusted_mode)
> +{
> +	struct drm_device *dev = encoder->dev;
> +	struct cirrus_device *cdev = dev->dev_private;
> +
> +	unsigned char tmp;
> +
> +	switch (encoder->crtc->fb->bits_per_pixel) {
> +	case 8:
> +		tmp = 0x0;
> +		break;
> +	case 16:
> +		/* Enable 16 bit mode */
> +		WREG_HDR(0x01);

If you switch back from 16 does this not need clearing ?


Alan
