Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1COIh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:37:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:50416 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736Ab1COIh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:37:56 -0400
Message-Id: <b7da2f$qnp1ps@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,321,1297065600"; 
   d="scan'208";a="897353532"
Date: Tue, 15 Mar 2011 08:37:51 +0000
To: Indan Zupancic <indan@nul.nu>
Subject: Re: [PATCH] ACPI/Intel: Rework Opregion support
Cc: Dave Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@linux.intel.com>,
        Keith Packard <keithp@keithp.com>, Len Brown <lenb@kernel.org>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com> <1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk> <cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 02:18:02 +0100 (CET), "Indan Zupancic" <indan@nul.nu> wrote:
> Hello,
> 
> Some nitpicks below.
> 
> On Mon, March 14, 2011 18:59, Chris Wilson wrote:
> > Note: neither the opregion_dev interface or the alse_set_* properly report
> > failures. As such we have a slight change in behaviour on Ironlake+
> > platforms and an uncorrected bug for earlier chipsets.
> > -Chris
> 
> What uncorrected bug?

For later chipsets we currently report the failure to respond to the ALSE
requests, for earlier we do not. The patch harmonises the two code paths
reusing the earlier code for later chipsets, hence the change in behaviour
and potential regression. Alternatively, actually reporting the failure
for earlier chipsets may also break existing setups.

> And are there earlier chipsets with ASLE support at all, besides gen 4?
> If there are no gen 2 or gen 3 chipsets with ASLE then the backlight
> code can be simplified further.

The OpRegion interface was devised midway through gen3 (afaik), and you
find it on some i915-class hw and not others. In theory, there is nothing
to prevent a BIOS/ACPI from being rewritten for it to be of use in gen2,
and who knows one such beast may already exist (considering much to our
horror you can still buy gen2 chipsets).

> > diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
> > index 4e5ff59..51565bb 100644
> > --- a/drivers/gpu/drm/i915/intel_panel.c
> > +++ b/drivers/gpu/drm/i915/intel_panel.c
> > @@ -261,8 +261,8 @@ intel_panel_detect(struct drm_device *dev)
> >  	 * appears to be either the BIOS or Linux ACPI fault */
> >  #if 0
> >  	/* Assume that the BIOS does not lie through the OpRegion... */
> > -	if (dev_priv->opregion.lid_state)
> > -		return ioread32(dev_priv->opregion.lid_state) & 0x1 ?
> > +	if (dev_priv->opregion_dev.opregion.acpi)
> > +		return ioread32(&dev_priv->opregion_dev.opregion.acpi->clid) & 0x1 ?
> 
> What guarantees that opregion.acpi != NULL here?

You mean other than the explicit test for opregion.acpi != NULL?

> Or perhaps just remove that #if 0 code chunk altogether?

Read the changelog and thread on the patch that disabled this logic, the
failure (or at least inconsistent behaviour with the expectations of the
HP BIOS authors) appears to be in how we initialise ACPI on the HP
machines that causes the initial value of lid state to be incorrect. Since
one of the laptops that Dave tests drm-next on is a HP, he was bitten by
the bug and temporarily (we hope) disabled the logic. Or else once again,
we will continue to light up the panel on a closed laptop.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
