Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab1COBwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 21:52:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41717 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab1COBwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 21:52:40 -0400
Date: Tue, 15 Mar 2011 01:52:26 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Keith Packard <keithp@keithp.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI/Intel: Rework Opregion support
Message-ID: <20110315015226.GA26454@srcf.ucam.org>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com> <1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk> <cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 02:18:02AM +0100, Indan Zupancic wrote:
> > +
> > +	if (dev->set_backlight)
> > +		dev->set_backlight(dev->drm_dev, bclp * max / 255);
> 
> I would hide the max backlight from the opregion code and move this
> calculation into set_brightness. Then change the interface to one
> based on a scale from 0-255 or 0-100, which fits better with what
> opregion actually does. On the other hand, it's the same code in
> a different place, so it doesn't make much difference.

That would require an extra layer of indirection in every driver, so 
keeping it here seems reasonable.

> > +void igd_opregion_enable_asle(struct opregion_dev *dev)
> > +{
> > +	struct opregion_asle *asle = dev->opregion.asle;
> > +
> > +	if (asle && dev->enable_asle) {
> > +		dev->enable_asle(dev->drm_dev);
> > +
> > +		asle->tche = ASLE_ALS_EN | ASLE_BLC_EN | ASLE_PFIT_EN |
> > +			ASLE_PFMB_EN;
> 
> Shouldn't which flags are set depend on which callback functions are set?
> Then you can remove all the function != NULL tests too. e.g:

Our experience is that we should give BIOSes the full set of support 
flags even if we don't actually do anything with them. That way we avoid 
cases where BIOS authors refuse to do anything with partial 
implementations (even if we support everything they use) and we get 
feedback when we actually find cases of advanced functionality in the 
real world.

> > +	if (IS_MOBILE(dev)) {
> > +		dev_priv->opregion_dev.max_backlight = intel_panel_get_max_backlight(dev);
> > +		dev_priv->opregion_dev.set_backlight = intel_panel_set_backlight;
> > +	}
> > +	dev_priv->opregion_dev.enable_asle = intel_enable_asle;
> > +	dev_priv->opregion_dev.drm_dev = dev;
> 
> So we have a drm_device->drm_i915_private->opregion_dev.drm_device loop,
> which is a bit messy, but consistent with other existing code.

Anyone who wants to clean that up is welcome to do so, but really I 
optimised for ease of transition here.

> >
> > -	/* XXX Should this validation be moved to intel_opregion.c? */
> > -	if (dev_priv->opregion.vbt) {
> > -		struct vbt_header *vbt = dev_priv->opregion.vbt;
> > +	/* XXX Should this validation be moved to acpi_igd_opregion.c? */
> 
> Should it? Seems like a good moment to do so.

Now that we've got multiple consumers it's probably not helpful to move 
the (potentially chip-specific) VBT handling to general code. We've got 
zero documentation on how GMA500 handles VBT, and not a great deal more 
for i915.

> About the naming, as this is Intel-only intel_opregion seems clearer than
> igd-opregion, which sounds like it could be anything.

It's Intel-only in implementation, not in specification. As much as I 
dislike vendor-neutral specs that have been pushed and implemented by a 
single vendor, I'd rather not make the naming Intel-specific if there's 
a chance someone else can end up depending on it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
