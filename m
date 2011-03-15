Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab1COLNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:13:24 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:39151 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188Ab1COLNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:13:20 -0400
Message-ID: <5060ae708cceef8df998d3f59be5d246.squirrel@webmail.greenhost.nl>
In-Reply-To: <b7da2f$qnp1ps@fmsmga001.fm.intel.com>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
    <1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk>
    <cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
    <b7da2f$qnp1ps@fmsmga001.fm.intel.com>
Date: Tue, 15 Mar 2011 12:13:11 +0100 (CET)
Subject: Re: [PATCH] ACPI/Intel: Rework Opregion support
From: "Indan Zupancic" <indan@nul.nu>
To: "Chris Wilson" <chris@chris-wilson.co.uk>
Cc: "Dave Airlie" <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        "Matthew Garrett" <mjg@redhat.com>, "Alan Cox" <alan@linux.intel.com>,
        "Keith Packard" <keithp@keithp.com>, "Len Brown" <lenb@kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: b76837ecbba1170f708de966edddc2d0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, March 15, 2011 09:37, Chris Wilson wrote:
> On Tue, 15 Mar 2011 02:18:02 +0100 (CET), "Indan Zupancic" <indan@nul.nu> wrote:
>> Hello,
>>
>> Some nitpicks below.
>>
>> On Mon, March 14, 2011 18:59, Chris Wilson wrote:
>> > Note: neither the opregion_dev interface or the alse_set_* properly report
>> > failures. As such we have a slight change in behaviour on Ironlake+
>> > platforms and an uncorrected bug for earlier chipsets.
>> > -Chris
>>
>> What uncorrected bug?
>
> For later chipsets we currently report the failure to respond to the ALSE
> requests, for earlier we do not. The patch harmonises the two code paths
> reusing the earlier code for later chipsets, hence the change in behaviour
> and potential regression. Alternatively, actually reporting the failure
> for earlier chipsets may also break existing setups.

Ah, okay, for the ASLE_SET_ALS_ILLUM/ASLE_SET_PFIT/ASLE_SET_PWM_FREQ cases.
Hopefully this change doesn't cause regressions, that would be sad.

>> And are there earlier chipsets with ASLE support at all, besides gen 4?
>> If there are no gen 2 or gen 3 chipsets with ASLE then the backlight
>> code can be simplified further.
>
> The OpRegion interface was devised midway through gen3 (afaik), and you
> find it on some i915-class hw and not others. In theory, there is nothing
> to prevent a BIOS/ACPI from being rewritten for it to be of use in gen2,
> and who knows one such beast may already exist (considering much to our
> horror you can still buy gen2 chipsets).

Pity, if they're still sold any bets are off.

>> > diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
>> > index 4e5ff59..51565bb 100644
>> > --- a/drivers/gpu/drm/i915/intel_panel.c
>> > +++ b/drivers/gpu/drm/i915/intel_panel.c
>> > @@ -261,8 +261,8 @@ intel_panel_detect(struct drm_device *dev)
>> >  	 * appears to be either the BIOS or Linux ACPI fault */
>> >  #if 0
>> >  	/* Assume that the BIOS does not lie through the OpRegion... */
>> > -	if (dev_priv->opregion.lid_state)
>> > -		return ioread32(dev_priv->opregion.lid_state) & 0x1 ?
>> > +	if (dev_priv->opregion_dev.opregion.acpi)
>> > +		return ioread32(&dev_priv->opregion_dev.opregion.acpi->clid) & 0x1 ?
>>
>> What guarantees that opregion.acpi != NULL here?
>
> You mean other than the explicit test for opregion.acpi != NULL?

I'm blind. I checked all the rest of the code, but not the line just above it.
Gah!

>> Or perhaps just remove that #if 0 code chunk altogether?
>
> Read the changelog and thread on the patch that disabled this logic, the

I just subscribed to intel-gfx, seemed like a good idea after the reject.

> failure (or at least inconsistent behaviour with the expectations of the
> HP BIOS authors) appears to be in how we initialise ACPI on the HP
> machines that causes the initial value of lid state to be incorrect. Since
> one of the laptops that Dave tests drm-next on is a HP, he was bitten by
> the bug and temporarily (we hope) disabled the logic. Or else once again,
> we will continue to light up the panel on a closed laptop.

Hopefully it's fixed by the next BIOS upgrade by HP...

Everything would be a lot simpler if the BIOSes were open source.

It's shocking with what you guys have to deal with.

Good luck and thanks for all the hard work!

Indan


