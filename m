Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab1CCIsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:48:39 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:49558 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651Ab1CCIsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:48:37 -0500
Date: Thu, 3 Mar 2011 10:48:29 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anand Gadiyar <gadiyar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, Keshava Munegowda <keshava_mgowda@ti.com>
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
Message-ID: <20110303084829.GB2644@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110302165755.b45124c8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302165755.b45124c8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 04:57:55PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> arch/arm/mach-omap2/board-4430sdp.c between commit
> 1dbea0f5e23b6c647db72fa4a048cb7140625e13 ("arm: omap4: 4430sdp: drop ehci
> support") from the omap tree and commit
> 181b250cf53233a7a7c6d7e1e9df402506712e93 ("arm: omap: usb: create common
> enums and structures for ehci and ohci") from the usb tree.
> 
> The former removed the code modified by the latter, so I did that.

This can be fixed if Greg applies this patch:

commit 076bfacd5bba0f2e419474488c8f8c060c7799d8
Author: Anand Gadiyar <gadiyar@ti.com>
Date:   Wed Feb 16 16:47:19 2011 +0530

    arm: omap4: 4430sdp: drop ehci support
    
    Most revisions of the OMAP4 Blaze/SDP platform do not have
    the EHCI signals routed by default. The pads are routed
    for the alternate HSI functionality instead, and explicit
    board modifications are needed to route the signals to
    the USB PHY on the board.
    
    Also, turning on the PHY connected to the EHCI port causes
    a board reboot during bootup due to an unintended short
    on the rails - this affects many initial revisions of the
    board, and needs a minor board mod to fix (or as a
    workaround, one should not attempt to power on the
    USB PHY).
    
    Given that these boards need explicit board mods to even
    get EHCI working (separate from the accidental short above),
    we should not attempt to enable EHCI by default.
    
    So drop the EHCI support from the board files for the
    Blaze/SDP platforms.
    
    Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
    Cc: Keshava Munegowda <keshava_mgowda@ti.com>
    Cc: Tony Lindgren <tony@atomide.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 1230121..f603f3b 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -44,7 +44,6 @@
 #define ETH_KS8851_IRQ			34
 #define ETH_KS8851_POWER_ON		48
 #define ETH_KS8851_QUART		138
-#define OMAP4SDP_MDM_PWR_EN_GPIO	157
 #define OMAP4_SFH7741_SENSOR_OUTPUT_GPIO	184
 #define OMAP4_SFH7741_ENABLE_GPIO		188
 
@@ -251,16 +250,6 @@ static void __init omap_4430sdp_init_irq(void)
 	gic_init_irq();
 }
 
-static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
-	.port_mode[0]	= OMAP_EHCI_PORT_MODE_PHY,
-	.port_mode[1]	= OMAP_USBHS_PORT_MODE_UNUSED,
-	.port_mode[2]	= OMAP_USBHS_PORT_MODE_UNUSED,
-	.phy_reset	= false,
-	.reset_gpio_port[0]  = -EINVAL,
-	.reset_gpio_port[1]  = -EINVAL,
-	.reset_gpio_port[2]  = -EINVAL,
-};
-
 static struct omap_musb_board_data musb_board_data = {
 	.interface_type		= MUSB_INTERFACE_UTMI,
 	.mode			= MUSB_OTG,
@@ -577,14 +566,6 @@ static void __init omap_4430sdp_init(void)
 	omap_serial_init();
 	omap4_twl6030_hsmmc_init(mmc);
 
-	/* Power on the ULPI PHY */
-	status = gpio_request(OMAP4SDP_MDM_PWR_EN_GPIO, "USBB1 PHY VMDM_3V3");
-	if (status)
-		pr_err("%s: Could not get USBB1 PHY GPIO\n", __func__);
-	else
-		gpio_direction_output(OMAP4SDP_MDM_PWR_EN_GPIO, 1);
-
-	usbhs_init(&usbhs_bdata);
 	usb_musb_init(&musb_board_data);
 
 	status = omap_ethernet_init();

-- 
balbi
