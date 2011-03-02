Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1CBIYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:24:39 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:46825 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755738Ab1CBIYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:24:37 -0500
Date: Wed, 2 Mar 2011 10:23:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hema HK <hemahk@ti.com>,
        Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, Thomas Weber <weber@corscience.de>
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
Message-ID: <20110302082331.GB2480@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110302165746.814a45a3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302165746.814a45a3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 04:57:46PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/musb/musb_core.h between commit
> 59b479e0985f0b795d68331d6443a7f89c47768d ("omap: Start using
> CONFIG_SOC_OMAP") from the omap tree and commit
> da68ccec210c45eb99e461ad31b499b4e7043c41 ("usb: musb: Remove platform
> context save/restore API") from the usb tree.
> 
> The latter removed the code modified by the former, so I did that.

Yeah, I was about to send a resolution to Tony. Here's what I came up
with (too big though):

commit d12f1cd19b7e79087df1ea197ffe81b0b67f2bc3
Merge: abba63e 53689ac
Author: Felipe Balbi <balbi@ti.com>
Date:   Tue Mar 1 17:14:26 2011 +0200

    Merge branch 'for-next' into tst
    
    Conflicts:
    	arch/arm/mach-omap2/board-4430sdp.c
    	arch/arm/mach-omap2/board-omap3evm.c
    	arch/arm/mach-omap2/usb-musb.c
    	arch/arm/plat-omap/include/plat/usb.h
    	drivers/usb/musb/musb_core.h
    
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --cc arch/arm/mach-omap2/board-3430sdp.c
index 8950ecc,7542ba5..d7aa25f
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@@ -801,10 -813,10 +801,10 @@@ static void __init omap_3430sdp_init(vo
  	omap_serial_init();
  	usb_musb_init(&musb_board_data);
  	board_smc91x_init();
 -	board_flash_init(sdp_flash_partitions, chip_sel_3430);
 +	board_flash_init(sdp_flash_partitions, chip_sel_3430, 0);
  	sdp3430_display_init();
  	enable_board_wakeup_source();
- 	usb_ehci_init(&ehci_pdata);
+ 	usbhs_init(&usbhs_bdata);
  }
  
  MACHINE_START(OMAP_3430SDP, "OMAP3430 3430SDP board")
diff --cc arch/arm/mach-omap2/board-3630sdp.c
index 8d1c435,deed2db..d474697
--- a/arch/arm/mach-omap2/board-3630sdp.c
+++ b/arch/arm/mach-omap2/board-3630sdp.c
@@@ -209,9 -209,9 +209,9 @@@ static void __init omap_sdp_init(void
  	zoom_peripherals_init();
  	zoom_display_init();
  	board_smc91x_init();
 -	board_flash_init(sdp_flash_partitions, chip_sel_sdp);
 +	board_flash_init(sdp_flash_partitions, chip_sel_sdp, NAND_BUSWIDTH_16);
  	enable_board_wakeup_source();
- 	usb_ehci_init(&ehci_pdata);
+ 	usbhs_init(&usbhs_bdata);
  }
  
  MACHINE_START(OMAP_3630SDP, "OMAP 3630SDP board")
diff --cc arch/arm/mach-omap2/board-am3517crane.c
index ae3a83d,e3a194f..36bff55
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@@ -56,12 -56,13 +56,12 @@@ static void __init am3517_crane_init_ea
  
  	omap2_init_common_infrastructure();
  	omap2_init_common_devices(NULL, NULL);
 -	omap_init_irq();
  }
  
- static struct ehci_hcd_omap_platform_data ehci_pdata __initdata = {
- 	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
- 	.port_mode[1] = EHCI_HCD_OMAP_MODE_UNKNOWN,
- 	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+ static struct usbhs_omap_board_data usbhs_bdata __initdata = {
+ 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
+ 	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
+ 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
  
  	.phy_reset  = true,
  	.reset_gpio_port[0]  = GPIO_USB_NRESET,
diff --cc arch/arm/mach-omap2/board-igep0020.c
index 54e6318,f9f5344..0d3b0ad
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@@ -685,10 -697,9 +685,10 @@@ static void __init igep2_init(void
  	/* Register I2C busses and drivers */
  	igep2_i2c_init();
  	platform_add_devices(igep2_devices, ARRAY_SIZE(igep2_devices));
 +	omap_display_init(&igep2_dss_data);
  	omap_serial_init();
  	usb_musb_init(&musb_board_data);
- 	usb_ehci_init(&ehci_pdata);
+ 	usbhs_init(&usbhs_bdata);
  
  	igep2_flash_init();
  	igep2_leds_init();
diff --cc arch/arm/mach-omap2/board-omap3evm.c
index 7341f96,38a2d91..e307fa4
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@@ -733,13 -631,18 +733,13 @@@ static void __init omap3_evm_init_early
  	omap_board_config_size = ARRAY_SIZE(omap3_evm_config);
  	omap2_init_common_infrastructure();
  	omap2_init_common_devices(mt46h32m32lf6_sdrc_params, NULL);
 -	omap_init_irq();
  }
  
- static struct ehci_hcd_omap_platform_data ehci_pdata __initdata = {
 -static struct platform_device *omap3_evm_devices[] __initdata = {
 -	&omap3_evm_dss_device,
 -};
 -
+ static struct usbhs_omap_board_data usbhs_bdata __initdata = {
  
- 	.port_mode[0] = EHCI_HCD_OMAP_MODE_UNKNOWN,
- 	.port_mode[1] = EHCI_HCD_OMAP_MODE_PHY,
- 	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+ 	.port_mode[0] = OMAP_USBHS_PORT_MODE_UNUSED,
+ 	.port_mode[1] = OMAP_EHCI_PORT_MODE_PHY,
+ 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
  
  	.phy_reset  = true,
  	/* PHY reset GPIO will be runtime programmed based on EVM version */
diff --cc arch/arm/mach-omap2/board-omap4panda.c
index 3dd241b,ed61c1f..a7d89da
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@@ -84,12 -80,13 +84,12 @@@ static void __init omap4_panda_init_ear
  {
  	omap2_init_common_infrastructure();
  	omap2_init_common_devices(NULL, NULL);
 -	gic_init_irq();
  }
  
- static const struct ehci_hcd_omap_platform_data ehci_pdata __initconst = {
- 	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
- 	.port_mode[1] = EHCI_HCD_OMAP_MODE_UNKNOWN,
- 	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+ static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
+ 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
+ 	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
+ 	.port_mode[2] = OMAP_USBHS_PORT_MODE_UNUSED,
  	.phy_reset  = false,
  	.reset_gpio_port[0]  = -EINVAL,
  	.reset_gpio_port[1]  = -EINVAL,
diff --cc arch/arm/mach-omap2/board-zoom.c
index 7e3f159,1dd195a..15c8806
--- a/arch/arm/mach-omap2/board-zoom.c
+++ b/arch/arm/mach-omap2/board-zoom.c
@@@ -122,11 -123,11 +122,11 @@@ static void __init omap_zoom_init(void
  	} else if (machine_is_omap_zoom3()) {
  		omap3_mux_init(board_mux, OMAP_PACKAGE_CBP);
  		omap_mux_init_gpio(ZOOM3_EHCI_RESET_GPIO, OMAP_PIN_OUTPUT);
- 		usb_ehci_init(&ehci_pdata);
+ 		usbhs_init(&usbhs_bdata);
  	}
  
 -	board_nand_init(zoom_nand_partitions,
 -			ARRAY_SIZE(zoom_nand_partitions), ZOOM_NAND_CS);
 +	board_nand_init(zoom_nand_partitions, ARRAY_SIZE(zoom_nand_partitions),
 +						ZOOM_NAND_CS, NAND_BUSWIDTH_16);
  	zoom_debugboard_init();
  	zoom_peripherals_init();
  	zoom_display_init();
diff --cc arch/arm/mach-omap2/usb-musb.c
index a9d4d14,241fc94..77071a6
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@@ -132,35 -212,12 +132,38 @@@ void __init usb_musb_init(struct omap_m
  	musb_plat.mode = board_data->mode;
  	musb_plat.extvbus = board_data->extvbus;
  
 -	if (platform_device_register(&musb_device) < 0)
 -		printk(KERN_ERR "Unable to register HS-USB (MUSB) device\n");
 +	if (cpu_is_omap3517() || cpu_is_omap3505()) {
 +		oh_name = "am35x_otg_hs";
 +		name = "musb-am35x";
 +	} else {
 +		oh_name = "usb_otg_hs";
 +		name = "musb-omap2430";
 +	}
  
+ 	if (cpu_is_omap44xx())
+ 		omap4430_phy_init(dev);
+ 
 +	oh = omap_hwmod_lookup(oh_name);
 +	if (!oh) {
 +		pr_err("Could not look up %s\n", oh_name);
 +		return;
 +	}
 +
 +	od = omap_device_build(name, bus_id, oh, &musb_plat,
 +			       sizeof(musb_plat), omap_musb_latency,
 +			       ARRAY_SIZE(omap_musb_latency), false);
 +	if (IS_ERR(od)) {
 +		pr_err("Could not build omap_device for %s %s\n",
 +						name, oh_name);
 +		return;
 +	}
 +
 +	pdev = &od->pdev;
 +	dev = &pdev->dev;
 +	get_device(dev);
 +	dev->dma_mask = &musb_dmamask;
 +	dev->coherent_dma_mask = musb_dmamask;
 +	put_device(dev);
  }
  
  #else
diff --cc arch/arm/plat-omap/include/plat/usb.h
index 0771927,fe449f1..e4f61c8
--- a/arch/arm/plat-omap/include/plat/usb.h
+++ b/arch/arm/plat-omap/include/plat/usb.h
@@@ -88,14 -107,9 +107,13 @@@ extern int omap4430_phy_power(struct de
  extern int omap4430_phy_set_clk(struct device *dev, int on);
  extern int omap4430_phy_init(struct device *dev);
  extern int omap4430_phy_exit(struct device *dev);
- 
+ extern int omap4430_phy_suspend(struct device *dev, int suspend);
  #endif
  
 +extern void am35x_musb_reset(void);
 +extern void am35x_musb_phy_power(u8 on);
 +extern void am35x_musb_clear_irq(void);
 +extern void am35x_musb_set_mode(u8 musb_mode);
- 
  /*
   * FIXME correct answer depends on hmc_mode,
   * as does (on omap1) any nonzero value for config->otg port number

-- 
balbi
