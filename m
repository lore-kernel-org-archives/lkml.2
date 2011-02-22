Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1BVPkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:40:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49485 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1BVPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:40:08 -0500
Date: Tue, 22 Feb 2011 15:40:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@linux.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
Message-ID: <20110222154002.GB9720@srcf.ucam.org>
References: <20110222121704.19437.4650.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222121704.19437.4650.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:17:46PM +0000, Alan Cox wrote:
> This is an initial staging driver for the GMA500. It's been stripped out
> of the PVR drivers and crunched together from various bits of code and
> different kernels.
> 
> Currently it's unaccelerated but still pretty snappy even compositing with
> the frame buffer X server.
> 
> Lots of work is needed to rework the ttm and bo interfaces from being 
> ripped out and then 2D acceleration wants putting back for framebuffer 
> and somehow eventually via DRM.

There's a pretty significant amount of code duplication between the 
modesetting part of this and i915. In an idea world they'd be abstracted 
enough to avoid that, but I suspect that the risk of breaking i915 
(which is something people actually care about) in favour of making the 
gma500 code (which is something people care about in a very different 
way) probably doesn't make it worth it right now.

> I'm not a DRM expert so if there is anyone with a GMA500 who actually knows
> something about DRI internals then help would be most welcome.

I managed to palm mine off on a 9-year old, but we'll see if we can find 
something.

TTM is outside my comfort level, so we'll need to wait for some feedback 
from others on that. You may also want to Cc: dri-devel to get more eyes 
on it.

> @@ -0,0 +1,167 @@
> +/*
> + *  psb backlight using HAL

We're not using HAL so much these days.

> +	/* return locally cached var instead of HW read (due to DPST etc.) */
> +	return psb_brightness;

Ugh. We're really supposed to be doing readback from the hardware here, 
in case the firmware's changed something behind our back.

> +	value = (CoreClock * MHz) / BLC_PWM_FREQ_CALC_CONSTANT;

This hardware is spectacular.

> +struct mrst_panel_descriptor_v1{
> +	uint32_t Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */

Caps *and* underscores? Checkpatch.pl needs a -Wtaste switch.

> +	uint16_t Panel_MIPI_Display_Descriptor;
> +			/*16 bits, Defined as follows: */
> +			/* if MIPI, 0x0000 if LVDS */

"Defined as follows if MIPI, 0x000 if LVDS"?

> +struct gct_ioctl_arg{

This never seems to be used. I'd be kind of terrified if it ever needed 
to be. In fact, are any of these vbt structures used at the moment?

> +int drm_psb_force_pipeb;

Unused.

> +int drm_idle_check_interval = 5;

Unused.

> +int gfxrtdelay = 2 * 1000;

Unused.

> +MODULE_PARM_DESC(force_pipeb, "Forces PIPEB to become primary fb");

Unused.

> +MODULE_PARM_DESC(ta_mem_size, "TA memory size in kiB");

Seems unused?

> +MODULE_PARM_DESC(ospm, "switch for ospm support");

What does OSPM translate as these days?

> +MODULE_PARM_DESC(rtpm, "Specifies Runtime PM delay for GFX");

Seems unused?

> +MODULE_PARM_DESC(hdmi_edid, "EDID info for HDMI monitor");

Thankfully unused.

> +static struct pci_device_id pciidlist[] = {
> +	{ 0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108 },
> +	{ 0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109 },

What hardware does this translate to at the moment? There's various bits 
that suggest Moorestown support, but I'm not clear whether it's included 
here or whether it's just the Poulsbo parts.

> +#if 1 /* FIXME remove it after PO */

P0?

> +		DRM_ERROR("Gatt must be 256M aligned. This is a bug.\n");

FW_BUG?

> +	DRM_INFO("Run drivers on Poulsbo platform!\n");

?

> +	/**
> +	 *  Init lid switch timer.
> +	 *  NOTE: must do this after psb_intel_opregion_init
> +	 *  and psb_backlight_init
> +	 */
> +	if (dev_priv->lid_state)
> +		psb_lid_timer_init(dev_priv);

Gak. Shouldn't there be an SCI on state change on opregion systems?

> +#define DRIVER_NAME "pvrsrvkm"
> +#define DRIVER_DESC "drm driver for the Intel GMA500"
> +#define DRIVER_AUTHOR "Intel Corporation"
> +#define OSPM_PROC_ENTRY "ospm"
> +#define RTPM_PROC_ENTRY "rtpm"

Debugfs?

> +++ b/drivers/staging/gma500/psb_gfx.mod.c

I don't think you need this one :)

> +void psb_intel_destory_bios(struct drm_device *dev)

Oh if only...

> +/*
> + * Driver<->VBIOS interaction occurs through scratch bits in
> + * GR18 & SWF*.
> + */

Do you actually support this? I'm pretty sure it's all ignored in i915, 
for better or worse.

> +#define BIT0  0x00000001
> +#define BIT1  0x00000002
> +#define BIT2  0x00000004
> +#define BIT3  0x00000008
> +#define BIT4  0x00000010
> +#define BIT5  0x00000020
> +#define BIT6  0x00000040
> +#define BIT7  0x00000080
> +#define BIT8  0x00000100
> +#define BIT9  0x00000200
> +#define BIT10 0x00000400
> +#define BIT11 0x00000800
> +#define BIT12 0x00001000
> +#define BIT13 0x00002000
> +#define BIT14 0x00004000
> +#define BIT15 0x00008000
> +#define BIT16 0x00010000
> +#define BIT17 0x00020000
> +#define BIT18 0x00040000
> +#define BIT19 0x00080000
> +#define BIT20 0x00100000
> +#define BIT21 0x00200000
> +#define BIT22 0x00400000
> +#define BIT23 0x00800000
> +#define BIT24 0x01000000
> +#define BIT25 0x02000000
> +#define BIT26 0x04000000
> +#define BIT27 0x08000000
> +#define BIT28 0x10000000
> +#define BIT29 0x20000000
> +#define BIT30 0x40000000
> +#define BIT31 0x80000000

You have *got* to be kidding.

> +/* ************************************************************************* *\
> +The display module performs a software reset.
> +Registers are written with their SW Reset default values.
> +\* ************************************************************************* */

I'd be kind of happier if we kept to one style of boxing per header...

> diff --git a/drivers/staging/gma500/psb_intel_opregion.c b/drivers/staging/gma500/psb_intel_opregion.c

I know I said that I wasn't convinced there was a benefit in trying to 
use the existing 915 code, but our opregion implementation is 
sufficiently best-effort right now that I think this should really be 
merged with the existing one and that split out as a separate module. We 
completely ignore opregion-based lid handling now, which may contribute 
to the number of lid state bugs we have on intel.

> +++ b/drivers/staging/gma500/psb_intel_sdvo.c

Does PSB really support SDVO? I thought by that period the only thing 
it'd be used for was plug-in SDVO cards, which doesn't seem so likely 
with PSB.

> +/*
> + * It is used to enable VBLANK interrupt
> + */
> +int psb_enable_vblank(struct drm_device *dev, int pipe)

I was confused until I read the comment. Wait.

> diff --git a/drivers/staging/gma500/psb_powermgmt.c b/drivers/staging/gma500/psb_powermgmt.c

I have to say that the code in here scares me, but we'll see how it 
works...

> +#ifdef CONFIG_MDFD_GL3

Ugh. No way to determine this at runtime? Having to build this 
per-device sounds like a recipe for sadness.

> diff --git a/drivers/staging/gma500/psb_pvr_glue.c b/drivers/staging/gma500/psb_pvr_glue.c

Do we need this at all without the PVR code?

> +void psb_lid_timer_init(struct drm_psb_private *dev_priv)
> +{
> +	struct timer_list *lid_timer = &dev_priv->lid_timer;
> +	unsigned long irq_flags;
> +
> +	spin_lock_init(&dev_priv->lid_lock);
> +	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);
> +
> +	init_timer(lid_timer);
> +
> +	lid_timer->data = (unsigned long)dev_priv;
> +	lid_timer->function = psb_lid_timer_func;
> +	lid_timer->expires = jiffies + PSB_LID_DELAY;

So we're waking up 10 times a second just to check the lid state?

> diff --git a/drivers/staging/gma500/psb_ttm_fence.c b/drivers/staging/gma500/psb_ttm_fence.c

This really looks like it's intended to be core TTM functionality, so it 
should probably go past dri-devel.

This is definitely the best gma500 driver we've seen yet, but it seems 
like there's two directions it can go. If the intention for now is to 
provide a kernel-quality unaccelerated 2D driver then there's a *lot* 
more code that can just be ripped out. If we want the acceleration to 
work then there's an argument that we should be abstracting that into a 
more generic SGX layer that other drivers can make use of. Does omapfb 
have any acceleration? If so, is there anything we can build on there?

Other than that, I think there's a few bogosities here. The only thing 
I'd really ask about in terms of whether it's ready to go in staging is 
whether all of those ioctls need to be exposed at the moment. Beyond 
that I'd like to see the opregion code unified, but for the most part 
we're talking about the kind of cleanups that staging is meant for.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
