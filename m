Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1BVQPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:15:41 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41217 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754548Ab1BVQPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:15:40 -0500
Date: Tue, 22 Feb 2011 16:17:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
Message-ID: <20110222161709.0ca0f76a@lxorguk.ukuu.org.uk>
In-Reply-To: <20110222154002.GB9720@srcf.ucam.org>
References: <20110222121704.19437.4650.stgit@localhost.localdomain>
	<20110222154002.GB9720@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's a pretty significant amount of code duplication between the 
> modesetting part of this and i915. In an idea world they'd be abstracted 
> enough to avoid that, but I suspect that the risk of breaking i915 
> (which is something people actually care about) in favour of making the 
> gma500 code (which is something people care about in a very different 
> way) probably doesn't make it worth it right now.

I was specifically instructed by Keith Packard not to do so.

> > +struct mrst_panel_descriptor_v1{
> > +	uint32_t Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
> 
> Caps *and* underscores? Checkpatch.pl needs a -Wtaste switch.

There is plenty of that - hence staging. I think what we actually need is
an emacs and vim "C with taste" mode which errors hungarian notation and
the like ;)

[April 1st project for someone maybe or perhaps a masters project in
runtime enforcement/correction to CodingStyle :  "I'm sorry Dave I
can't let you save that, it's not passing Checkpatch.pl"]
 
> > +	uint16_t Panel_MIPI_Display_Descriptor;
> > +			/*16 bits, Defined as follows: */
> > +			/* if MIPI, 0x0000 if LVDS */
> 
> "Defined as follows if MIPI, 0x000 if LVDS"?

I don't believe MIPI is supported on PSB anyway. There is a fair bit more
that can come out.

> > +struct gct_ioctl_arg{
> 
> This never seems to be used. I'd be kind of terrified if it ever needed 
> to be. In fact, are any of these vbt structures used at the moment?

Probably not - staging, this is the kind of stuff to get cleaned up with
many eyes and more expertise

> > +MODULE_PARM_DESC(ospm, "switch for ospm support");
> 
> What does OSPM translate as these days?

Basically the management hooks for power. For PSB they don't matter, in
fact the SCH errata document implies they shouldn't get used on PSB. For
MRST we need the hook points but to rewrite the functionality underneath
properly to talk to an alternative power management system - like the one
the kernel provides us with.

> > +	/**
> > +	 *  Init lid switch timer.
> > +	 *  NOTE: must do this after psb_intel_opregion_init
> > +	 *  and psb_backlight_init
> > +	 */
> > +	if (dev_priv->lid_state)
> > +		psb_lid_timer_init(dev_priv);
> 
> Gak. Shouldn't there be an SCI on state change on opregion systems?

Beats me. I try not to touch anything involving or related to ACPI

> You have *got* to be kidding.

You didnt see it before I started !

> I know I said that I wasn't convinced there was a benefit in trying to 
> use the existing 915 code, but our opregion implementation is 

I'm not fussed on this, but whoever wants to make that call can have a
kitten throwing contest with KeithP.

> > +++ b/drivers/staging/gma500/psb_intel_sdvo.c
> 
> Does PSB really support SDVO? I thought by that period the only thing 
> it'd be used for was plug-in SDVO cards, which doesn't seem so likely 
> with PSB.

I don't know - there is lots to prune. There are PSB using deviced with
dual outputs and I've no idea if internally its done via SDVO (eg some of
the Dell Mini 10's apparently have an HDMI port hung off something)
 
> > +/*
> > + * It is used to enable VBLANK interrupt
> > + */
> > +int psb_enable_vblank(struct drm_device *dev, int pipe)
> 
> I was confused until I read the comment. Wait.
> 
> > diff --git a/drivers/staging/gma500/psb_powermgmt.c b/drivers/staging/gma500/psb_powermgmt.c
> 
> I have to say that the code in here scares me, but we'll see how it 
> works...

The power code needs what is technically know as a rewrite. But the hooks
are in the right place and to add Moorestown support we need the hooks
there.

> > +#ifdef CONFIG_MDFD_GL3
> 
> Ugh. No way to determine this at runtime? Having to build this 
> per-device sounds like a recipe for sadness.

It's actually not part of PSB or MRST so that can go.

> > +	lid_timer->data = (unsigned long)dev_priv;
> > +	lid_timer->function = psb_lid_timer_func;
> > +	lid_timer->expires = jiffies + PSB_LID_DELAY;
> 
> So we're waking up 10 times a second just to check the lid state?

Don't we totally rock

> like there's two directions it can go. If the intention for now is to 
> provide a kernel-quality unaccelerated 2D driver then there's a *lot* 
> more code that can just be ripped out. If we want the acceleration to 
> work then there's an argument that we should be abstracting that into a 
> more generic SGX layer that other drivers can make use of. Does omapfb 
> have any acceleration? If so, is there anything we can build on there?

I doubt there is much you can share. The register layout depends on the
chip version (read the imagination kernel driver "GPL" splat from
Imagination and weep), the mode setting is device dependant and I don't
know about the 2D but I believe it's also not quite the same.

I do want to get 2D acceleration working, we have all the open bits for
that including compositing.

Opregion does look like there should be one only.

> Other than that, I think there's a few bogosities here. The only thing 
> I'd really ask about in terms of whether it's ready to go in staging is 
> whether all of those ioctls need to be exposed at the moment.

Staging = no API guarantee, so I'm fairly happy about it - and having it
for testing is handy.

Alan
