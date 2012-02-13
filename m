Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab2BMQwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:52:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56765 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab2BMQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:52:37 -0500
Date: Mon, 13 Feb 2012 16:52:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Porter <mporter@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
	regulators
Message-ID: <20120213165209.GA31482@n2100.arm.linux.org.uk>
References: <1329151422-2146-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329151422-2146-1-git-send-email-mporter@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 11:43:42AM -0500, Matt Porter wrote:
> This fixes smsc911x support on platforms using gpmc_smsc911x_init().
> Commit c7e963f6888816f04d1f5da0e07bec4e0092f227 added the requirement
> that platforms provide vdd33a and vddvario supplies.

Thanks.  Only one comment on this.

> +static struct platform_device gpmc_smsc911x_regulator = {
> +	.name		= "reg-fixed-voltage",
> +	.id		= 0,

$ grep -A1 reg-fixed-voltage arch/arm/*omap* -r
arch/arm/mach-omap2/board-omap3evm.c:	.name		= "reg-fixed-voltage",
arch/arm/mach-omap2/board-omap3evm.c-	.id		= 1,
--
arch/arm/mach-omap2/board-zoom-peripherals.c:	.name		= "reg-fixed-voltage",
arch/arm/mach-omap2/board-zoom-peripherals.c-	.id		= 1,
--
arch/arm/mach-omap2/board-overo.c:	.name		= "reg-fixed-voltage",
arch/arm/mach-omap2/board-overo.c-	.id		= 1,
--
arch/arm/mach-omap2/board-omap4panda.c:	.name		= "reg-fixed-voltage",
arch/arm/mach-omap2/board-omap4panda.c-	.id		= 1,
--
arch/arm/mach-omap2/board-rm680.c:	.name			= "reg-fixed-voltage",
arch/arm/mach-omap2/board-rm680.c-	.dev			= {
--
arch/arm/mach-omap2/board-igep0020.c:	.name		= "reg-fixed-voltage",
arch/arm/mach-omap2/board-igep0020.c-	.id		= 0,
--
arch/arm/mach-omap2/board-4430sdp.c:	.name		= "reg-fixed-voltage",
arch/arm/mach-omap2/board-4430sdp.c-	.id		= -1,
--
arch/arm/mach-omap2/board-4430sdp.c:	.name		= "reg-fixed-voltage",
arch/arm/mach-omap2/board-4430sdp.c-	.id		= 1,
--
arch/arm/mach-omap2/board-omap3pandora.c:	.name		= "reg-fixed-voltage",
arch/arm/mach-omap2/board-omap3pandora.c-	.id		= 1,

igep0020.c does this:

static struct omap_smsc911x_platform_data smsc911x_cfg = {
        .cs             = IGEP2_SMSC911X_CS,
        .gpio_irq       = IGEP2_SMSC911X_GPIO,
        .gpio_reset     = -EINVAL,
        .flags          = SMSC911X_USE_32BIT | SMSC911X_SAVE_MAC_ADDRESS,
};

static inline void __init igep2_init_smsc911x(void)
{
        gpmc_smsc911x_init(&smsc911x_cfg);
}

so it seems to use the gpmc_smsc stuff as well.  So we're ending up with
two "reg-fixed-voltage" devices both with ID 0.  That's not going to work,
and the driver model/sysfs will give you a nice warning there about that.

I think OMAP (or even the reg-fixed-voltage folk) needs to create an enum
similar to what I did for 8250 to control the allocation of platform
device IDs for this, otherwise we're going to keep on running over this
problem.

/*
 * Allocate 8250 platform device IDs.  Nothing is implied by
 * the numbering here, except for the legacy entry being -1.
 */
enum {
	PLAT8250_DEV_LEGACY = -1,
	PLAT8250_DEV_PLATFORM,
	PLAT8250_DEV_PLATFORM1,
	PLAT8250_DEV_PLATFORM2,
	PLAT8250_DEV_FOURPORT,
	PLAT8250_DEV_ACCENT,
	PLAT8250_DEV_BOCA,
	PLAT8250_DEV_EXAR_ST16C554,
	PLAT8250_DEV_HUB6,
	PLAT8250_DEV_MCA,
	PLAT8250_DEV_AU1X00,
	PLAT8250_DEV_SM501,
};

Added Mark for his comment.
