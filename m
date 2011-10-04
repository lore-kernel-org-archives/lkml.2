Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab1JDEGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 00:06:43 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43907 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab1JDEGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 00:06:40 -0400
Date: Tue, 4 Oct 2011 15:06:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the omap_dss2 tree with the arm-soc
 tree
Message-Id: <20111004150635.1732b731d8c9c77b43af4033@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/mach-omap2/board-ldp.c between commit 8f5b5a41ebc7 ("ARM: OMAP:
Introduce SoC specific early_init") from the arm-soc tree and commit
14dd72d8542f ("OMAP: LDP: Port the display driver to new DSS2") from the
omap_dss2 tree.

Just context changes.  I fixed it up (I think - see below) and can carry
the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-ldp.c
index 5797917,689ed49..0000000
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@@ -179,19 -183,103 +183,97 @@@ static inline void __init ldp_init_smsc
  	gpmc_smsc911x_init(&smsc911x_cfg);
  }
  
- static struct platform_device ldp_lcd_device = {
- 	.name		= "ldp_lcd",
- 	.id		= -1,
+ /* LCD */
+ 
+ static int ldp_backlight_gpio;
+ static int ldp_lcd_enable_gpio;
+ 
+ #define LCD_PANEL_RESET_GPIO		55
+ #define LCD_PANEL_QVGA_GPIO		56
+ 
+ static int ldp_panel_enable_lcd(struct omap_dss_device *dssdev)
+ {
+ 	if (gpio_is_valid(ldp_lcd_enable_gpio))
+ 		gpio_direction_output(ldp_lcd_enable_gpio, 1);
+ 	if (gpio_is_valid(ldp_backlight_gpio))
+ 		gpio_direction_output(ldp_backlight_gpio, 1);
+ 
+ 	return 0;
+ }
+ 
+ static void ldp_panel_disable_lcd(struct omap_dss_device *dssdev)
+ {
+ 	if (gpio_is_valid(ldp_lcd_enable_gpio))
+ 		gpio_direction_output(ldp_lcd_enable_gpio, 0);
+ 	if (gpio_is_valid(ldp_backlight_gpio))
+ 		gpio_direction_output(ldp_backlight_gpio, 0);
+ }
+ 
+ static struct panel_generic_dpi_data ldp_panel_data = {
+ 	.name			= "nec_nl2432dr22-11b",
+ 	.platform_enable	= ldp_panel_enable_lcd,
+ 	.platform_disable	= ldp_panel_disable_lcd,
  };
  
- static struct omap_lcd_config ldp_lcd_config __initdata = {
- 	.ctrl_name	= "internal",
+ static struct omap_dss_device ldp_lcd_device = {
+ 	.name			= "lcd",
+ 	.driver_name		= "generic_dpi_panel",
+ 	.type			= OMAP_DISPLAY_TYPE_DPI,
+ 	.phy.dpi.data_lines	= 18,
+ 	.data			= &ldp_panel_data,
+ };
+ 
+ static struct omap_dss_device *ldp_dss_devices[] = {
+ 	&ldp_lcd_device,
  };
  
- static struct omap_board_config_kernel ldp_config[] __initdata = {
- 	{ OMAP_TAG_LCD,		&ldp_lcd_config },
+ static struct omap_dss_board_info ldp_dss_data = {
+ 	.num_devices	= ARRAY_SIZE(ldp_dss_devices),
+ 	.devices	= ldp_dss_devices,
+ 	.default_device	= &ldp_lcd_device,
  };
  
+ static void __init ldp_display_init(void)
+ {
+ 	int r;
+ 
+ 	static struct gpio gpios[] __initdata = {
+ 		{LCD_PANEL_RESET_GPIO, GPIOF_OUT_INIT_HIGH, "LCD RESET"},
+ 		{LCD_PANEL_QVGA_GPIO, GPIOF_OUT_INIT_HIGH, "LCD QVGA"},
+ 	};
+ 
+ 	r = gpio_request_array(gpios, ARRAY_SIZE(gpios));
+ 	if (r) {
+ 		pr_err("Cannot request LCD GPIOs, error %d\n", r);
+ 		return;
+ 	}
+ 
+ 	omap_display_init(&ldp_dss_data);
+ }
+ 
 -static void __init omap_ldp_init_early(void)
 -{
 -	omap2_init_common_infrastructure();
 -	omap2_init_common_devices(NULL, NULL);
 -}
 -
+ static int ldp_twl_gpio_setup(struct device *dev, unsigned gpio, unsigned ngpio)
+ {
+ 	int r;
+ 
+ 	struct gpio gpios[] = {
+ 		{gpio + 7 , GPIOF_OUT_INIT_LOW, "LCD ENABLE"},
+ 		{gpio + 15, GPIOF_OUT_INIT_LOW, "LCD BACKLIGHT"},
+ 	};
+ 
+ 	r = gpio_request_array(gpios, ARRAY_SIZE(gpios));
+ 	if (r) {
+ 		pr_err("Cannot request LCD GPIOs, error %d\n", r);
+ 		ldp_backlight_gpio = -EINVAL;
+ 		ldp_lcd_enable_gpio = -EINVAL;
+ 		return r;
+ 	}
+ 
+ 	ldp_backlight_gpio = gpio + 15;
+ 	ldp_lcd_enable_gpio = gpio + 7;
+ 
+ 	return 0;
+ }
+ 
  static struct twl4030_gpio_platform_data ldp_gpio_data = {
  	.gpio_base	= OMAP_MAX_GPIO_LINES,
  	.irq_base	= TWL4030_GPIO_IRQ_BASE,
