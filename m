Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2EHJpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:45:40 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:37920 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000Ab2EHJpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:45:17 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 05/12] pinctrl/nomadik: implement pin multiplexing
Date: Tue, 8 May 2012 11:44:54 +0200
Message-ID: <1336470294-23625-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Implements basic pinmux for the Nomadik pin controller.

The plan is to split the existing singular pin config interface
nmk_config_pin(), nmk_config_pins(), that will configure muxing
and other settings at the same time, into two interfaces
by splitting the code in pinmux and pinctrl and eventually
deleting the old interface and its helper functions when all
users are gone.

nmk_gpio_set_mode() and nmk_gpio_get_mode() are two older
interfaces for just configuring muxing/altfunctions that
will also be replaced in the end.

We take some extra care to handle the glitch-avoidance here,
but it is simpler now since there is only one altsetting per
pingroup so we know immediately if we need to avoid altfunc
C glitches for a certain group.

As part of the makeover implement the .request() and .free()
calls on the GPIO chips and have them call back into the
pinctrl layer to reserve GPIOs.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig                  |    1 +
 drivers/pinctrl/pinctrl-nomadik-db8500.c |  130 ++++++++++++++++++
 drivers/pinctrl/pinctrl-nomadik.c        |  217 ++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-nomadik.h        |   20 ++-
 4 files changed, 366 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index cd17599..0c738fd 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -40,6 +40,7 @@ config PINCTRL_MMP2
 config PINCTRL_NOMADIK
 	bool "Nomadik pin controller driver"
 	depends on ARCH_U8500
+	select PINMUX
 
 config PINCTRL_DB8500
 	bool "DB8500 pin controller driver"
diff --git a/drivers/pinctrl/pinctrl-nomadik-db8500.c b/drivers/pinctrl/pinctrl-nomadik-db8500.c
index f3c0482..dbc9660 100644
--- a/drivers/pinctrl/pinctrl-nomadik-db8500.c
+++ b/drivers/pinctrl/pinctrl-nomadik-db8500.c
@@ -711,11 +711,141 @@ static const struct nmk_pingroup nmk_db8500_groups[] = {
 	DB8500_PIN_GROUP(spi2_oc1_1, NMK_GPIO_ALT_C),
 };
 
+/* We use this macro to define the groups applicable to a function */
+#define DB8500_FUNC_GROUPS(a, b...)	   \
+static const char * const a##_groups[] = { b };
+
+DB8500_FUNC_GROUPS(u0, "u0_a_1", "u0_c_1");
+DB8500_FUNC_GROUPS(u1, "u1rxtx_a_1", "u1ctsrts_a_1");
+/*
+ * UART2 can be muxed out with just RX/TX in four places, CTS+RTS is however
+ * only available on two pins in alternative function C
+ */
+DB8500_FUNC_GROUPS(u2, "u2rxtx_b_1", "u2rxtx_c_1", "u2ctsrts_c_1",
+		   "u2rxtx_c_2", "u2rxtx_c_3");
+DB8500_FUNC_GROUPS(ipi2c, "ipi2c_a_1", "ipi2c_a_2");
+/*
+ * MSP0 can only be on a certain set of pins, but the TX/RX pins can be
+ * switched around by selecting the altfunction A or B. The SCK pin is
+ * only available on the altfunction B.
+ */
+DB8500_FUNC_GROUPS(msp0, "msp0txrx_a_1", "msp0tfstck_a_1", "msp0rfstck_a_1",
+		   "msp0txrx_b_1", "msp0sck_b_1");
+DB8500_FUNC_GROUPS(mc0, "mc0_a_1");
+/* MSP0 can swap RX/TX like MSP0 but has no SCK pin available */
+DB8500_FUNC_GROUPS(msp1, "msp1txrx_a_1", "msp1_a_1", "msp1txrx_b_1");
+DB8500_FUNC_GROUPS(lcdb, "lcdb_a_1");
+DB8500_FUNC_GROUPS(lcd, "lcdvsi0_a_1", "lcdvsi1_a_1", "lcd_d0_d7_a_1",
+	"lcd_d8_d11_a_1", "lcd_d12_d23_a_1", "lcd_b_1");
+DB8500_FUNC_GROUPS(kp, "kp_a_1", "kp_b_1", "kp_c_1", "kp_oc1_1");
+DB8500_FUNC_GROUPS(mc2, "mc2_a_1", "mc2rstn_c_1");
+DB8500_FUNC_GROUPS(ssp1, "ssp1_a_1");
+DB8500_FUNC_GROUPS(ssp0, "ssp0_a_1");
+DB8500_FUNC_GROUPS(i2c0, "i2c0_a_1");
+/* The image processor has 8 GPIO pins that can be muxed out */
+DB8500_FUNC_GROUPS(ipgpio, "ipgpio0_a_1", "ipgpio1_a_1", "ipgpio7_b_1",
+	"ipgpio2_b_1", "ipgpio3_b_1", "ipgpio6_c_1", "ipgpio0_c_1",
+	"ipgpio1_c_1", "ipgpio3_c_1", "ipgpio2_c_1", "ipgpio4_c_1",
+	"ipgpio5_c_1", "ipgpio6_c_2", "ipgpio7_c_1", "ipgpio2_c_2",
+	"ipgpio3_c_2", "ipgpio4_c_2", "ipgpio5_c_2");
+/* MSP2 can not invert the RX/TX pins but has the optional SCK pin */
+DB8500_FUNC_GROUPS(msp2, "msp2sck_a_1", "msp2_a_1");
+DB8500_FUNC_GROUPS(mc4, "mc4_a_1", "mc4rstn_c_1");
+DB8500_FUNC_GROUPS(mc1, "mc1_a_1", "mc1dir_a_1");
+DB8500_FUNC_GROUPS(hsi, "hsir1_a_1", "hsit1_a_1");
+DB8500_FUNC_GROUPS(clkout, "clkout_a_1", "clkout_a_2", "clkout_c_1");
+DB8500_FUNC_GROUPS(usb, "usb_a_1");
+DB8500_FUNC_GROUPS(trig, "trig_b_1");
+DB8500_FUNC_GROUPS(i2c4, "i2c4_b_1");
+DB8500_FUNC_GROUPS(i2c1, "i2c1_b_1", "i2c1_b_2");
+DB8500_FUNC_GROUPS(i2c2, "i2c2_b_1", "i2c2_b_2");
+/*
+ * The modem UART can output its RX and TX pins in some different places,
+ * so select one of each.
+ */
+DB8500_FUNC_GROUPS(uartmod, "uartmodtx_b_1", "uartmodrx_b_1", "uartmodrx_b_2",
+		   "uartmodrx_c_1", "uartmod_tx_c_1");
+DB8500_FUNC_GROUPS(stmmod, "stmmod_b_1", "stmmod_c_1");
+DB8500_FUNC_GROUPS(spi3, "spi3_b_1");
+/* Select between CS0 on alt B or PS1 on alt C */
+DB8500_FUNC_GROUPS(sm, "sm_b_1", "smcs0_b_1", "smcleale_c_1", "smps1_c_1");
+DB8500_FUNC_GROUPS(lcda, "lcdaclk_b_1", "lcda_b_1");
+DB8500_FUNC_GROUPS(ddrtrig, "ddrtrig_b_1");
+DB8500_FUNC_GROUPS(pwl, "pwl_b_1", "pwl_b_2", "pwl_b_3", "pwl_b_4");
+DB8500_FUNC_GROUPS(spi1, "spi1_b_1");
+DB8500_FUNC_GROUPS(mc3, "mc3_b_1");
+DB8500_FUNC_GROUPS(ipjtag, "ipjtag_c_1");
+DB8500_FUNC_GROUPS(slim0, "slim0_c_1");
+DB8500_FUNC_GROUPS(ms, "ms_c_1");
+DB8500_FUNC_GROUPS(iptrigout, "iptrigout_c_1");
+DB8500_FUNC_GROUPS(stmape, "stmape_c_1", "stmape_c_2");
+DB8500_FUNC_GROUPS(mc5, "mc5_c_1");
+DB8500_FUNC_GROUPS(usbsim, "usbsim_c_1", "usbsim_c_2");
+DB8500_FUNC_GROUPS(i2c3, "i2c3_c_1", "i2c3_c_2");
+DB8500_FUNC_GROUPS(spi0, "spi0_c_1");
+DB8500_FUNC_GROUPS(spi2, "spi2_oc1_1");
+
+#define FUNCTION(fname)					\
+	{						\
+		.name = #fname,				\
+		.groups = fname##_groups,		\
+		.ngroups = ARRAY_SIZE(fname##_groups),	\
+	}
+
+static const struct nmk_function nmk_db8500_functions[] = {
+	FUNCTION(u0),
+	FUNCTION(u1),
+	FUNCTION(u2),
+	FUNCTION(ipi2c),
+	FUNCTION(msp0),
+	FUNCTION(mc0),
+	FUNCTION(msp1),
+	FUNCTION(lcdb),
+	FUNCTION(lcd),
+	FUNCTION(kp),
+	FUNCTION(mc2),
+	FUNCTION(ssp1),
+	FUNCTION(ssp0),
+	FUNCTION(i2c0),
+	FUNCTION(ipgpio),
+	FUNCTION(msp2),
+	FUNCTION(mc4),
+	FUNCTION(mc1),
+	FUNCTION(hsi),
+	FUNCTION(clkout),
+	FUNCTION(usb),
+	FUNCTION(trig),
+	FUNCTION(i2c4),
+	FUNCTION(i2c1),
+	FUNCTION(i2c2),
+	FUNCTION(uartmod),
+	FUNCTION(stmmod),
+	FUNCTION(spi3),
+	FUNCTION(sm),
+	FUNCTION(lcda),
+	FUNCTION(ddrtrig),
+	FUNCTION(pwl),
+	FUNCTION(spi1),
+	FUNCTION(mc3),
+	FUNCTION(ipjtag),
+	FUNCTION(slim0),
+	FUNCTION(ms),
+	FUNCTION(iptrigout),
+	FUNCTION(stmape),
+	FUNCTION(mc5),
+	FUNCTION(usbsim),
+	FUNCTION(i2c3),
+	FUNCTION(spi0),
+	FUNCTION(spi2),
+};
+
 static const struct nmk_pinctrl_soc_data nmk_db8500_soc = {
 	.gpio_ranges = nmk_db8500_ranges,
 	.gpio_num_ranges = ARRAY_SIZE(nmk_db8500_ranges),
 	.pins = nmk_db8500_pins,
 	.npins = ARRAY_SIZE(nmk_db8500_pins),
+	.functions = nmk_db8500_functions,
+	.nfunctions = ARRAY_SIZE(nmk_db8500_functions),
 	.groups = nmk_db8500_groups,
 	.ngroups = ARRAY_SIZE(nmk_db8500_groups),
 };
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 750703f..5f0db60 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -25,6 +25,9 @@
 #include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+/* Since we request GPIOs from ourself */
+#include <linux/pinctrl/consumer.h>
 
 #include <asm/mach/irq.h>
 
@@ -873,6 +876,25 @@ static int nmk_gpio_init_irq(struct nmk_gpio_chip *nmk_chip)
 }
 
 /* I/O Functions */
+
+static int nmk_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	/*
+	 * Map back to global GPIO space and request muxing, the direction
+	 * parameter does not matter for this controller.
+	 */
+	int gpio = chip->base + offset;
+
+	return pinctrl_request_gpio(gpio);
+}
+
+static void nmk_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	int gpio = chip->base + offset;
+
+	pinctrl_free_gpio(gpio);
+}
+
 static int nmk_gpio_make_input(struct gpio_chip *chip, unsigned offset)
 {
 	struct nmk_gpio_chip *nmk_chip =
@@ -1023,6 +1045,8 @@ static inline void nmk_gpio_dbg_show_one(struct seq_file *s,
 
 /* This structure is replicated for each GPIO block allocated at probe time */
 static struct gpio_chip nmk_gpio_template = {
+	.request		= nmk_gpio_request,
+	.free			= nmk_gpio_free,
 	.direction_input	= nmk_gpio_make_input,
 	.get			= nmk_gpio_get_input,
 	.direction_output	= nmk_gpio_make_output,
@@ -1371,9 +1395,202 @@ static struct pinctrl_ops nmk_pinctrl_ops = {
 	.pin_dbg_show = nmk_pin_dbg_show,
 };
 
+static int nmk_pmx_list_funcs(struct pinctrl_dev *pctldev,
+			      unsigned function)
+{
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+
+	if (function >= npct->soc->nfunctions)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const char *nmk_pmx_get_func_name(struct pinctrl_dev *pctldev,
+					 unsigned function)
+{
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+
+	if (function >= npct->soc->nfunctions)
+		return NULL;
+
+	return npct->soc->functions[function].name;
+}
+
+static int nmk_pmx_get_func_groups(struct pinctrl_dev *pctldev,
+				   unsigned function,
+				   const char * const **groups,
+				   unsigned * const num_groups)
+{
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+
+	if (function >= npct->soc->nfunctions)
+		return -EINVAL;
+
+	*groups = npct->soc->functions[function].groups;
+	*num_groups = npct->soc->functions[function].ngroups;
+
+	return 0;
+}
+
+static int nmk_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
+			  unsigned group)
+{
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+	const struct nmk_pingroup *g;
+	static unsigned int slpm[NUM_BANKS];
+	unsigned long flags;
+	bool glitch;
+	int ret = -EINVAL;
+	int i;
+
+	if (group >= npct->soc->ngroups)
+		return -EINVAL;
+	g = &npct->soc->groups[group];
+
+	if (g->altsetting < 0)
+		return -EINVAL;
+
+	dev_dbg(npct->dev, "enable group %s, %u pins\n", g->name, g->npins);
+
+	/* Handle this special glitch on altfunction C */
+	glitch = (g->altsetting == NMK_GPIO_ALT_C);
+
+	if (glitch) {
+		spin_lock_irqsave(&nmk_gpio_slpm_lock, flags);
+
+		/* Initially don't put any pins to sleep when switching */
+		memset(slpm, 0xff, sizeof(slpm));
+
+		/*
+		 * Then mask the pins that need to be sleeping now when we're
+		 * switching to the ALT C function.
+		 */
+		for (i = 0; i < g->npins; i++)
+			slpm[g->pins[i] / NMK_GPIO_PER_CHIP] &= ~BIT(g->pins[i]);
+		nmk_gpio_glitch_slpm_init(slpm);
+	}
+
+	for (i = 0; i < g->npins; i++) {
+		struct pinctrl_gpio_range *range;
+		struct nmk_gpio_chip *nmk_chip;
+		struct gpio_chip *chip;
+		unsigned bit;
+
+		range = nmk_match_gpio_range(pctldev, g->pins[i]);
+		if (!range) {
+			dev_err(npct->dev,
+				"invalid pin offset %d in group %s at index %d\n",
+				g->pins[i], g->name, i);
+			goto out_glitch;
+		}
+		if (!range->gc) {
+			dev_err(npct->dev, "GPIO chip missing in range for pin offset %d in group %s at index %d\n",
+				g->pins[i], g->name, i);
+			goto out_glitch;
+		}
+		chip = range->gc;
+		nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
+		dev_dbg(npct->dev, "setting pin %d to altsetting %d\n", g->pins[i], g->altsetting);
+
+		clk_enable(nmk_chip->clk);
+		bit = g->pins[i] % NMK_GPIO_PER_CHIP;
+		/*
+		 * If the pin is switching to altfunc, and there was an
+		 * interrupt installed on it which has been lazy disabled,
+		 * actually mask the interrupt to prevent spurious interrupts
+		 * that would occur while the pin is under control of the
+		 * peripheral. Only SKE does this.
+		 */
+		nmk_gpio_disable_lazy_irq(nmk_chip, bit);
+
+		__nmk_gpio_set_mode_safe(nmk_chip, bit, g->altsetting, glitch);
+		clk_disable(nmk_chip->clk);
+	}
+
+	/* When all pins are successfully reconfigured we get here */
+	ret = 0;
+
+out_glitch:
+	if (glitch) {
+		nmk_gpio_glitch_slpm_restore(slpm);
+		spin_unlock_irqrestore(&nmk_gpio_slpm_lock, flags);
+	}
+
+	return ret;
+}
+
+static void nmk_pmx_disable(struct pinctrl_dev *pctldev,
+			    unsigned function, unsigned group)
+{
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+	const struct nmk_pingroup *g;
+
+	if (group >= npct->soc->ngroups)
+		return;
+	g = &npct->soc->groups[group];
+
+	if (g->altsetting < 0)
+		return;
+
+	/* Poke out the mux, set the pin to some default state? */
+	dev_dbg(npct->dev, "disable group %s, %u pins\n", g->name, g->npins);
+}
+
+int nmk_gpio_request_enable(struct pinctrl_dev *pctldev,
+			    struct pinctrl_gpio_range *range,
+			    unsigned offset)
+{
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+	struct nmk_gpio_chip *nmk_chip;
+	struct gpio_chip *chip;
+	unsigned bit;
+
+	if (!range) {
+		dev_err(npct->dev, "invalid range\n");
+		return -EINVAL;
+	}
+	if (!range->gc) {
+		dev_err(npct->dev, "missing GPIO chip in range\n");
+		return -EINVAL;
+	}
+	chip = range->gc;
+	nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
+
+	dev_dbg(npct->dev, "enable pin %u as GPIO\n", offset);
+
+	clk_enable(nmk_chip->clk);
+	bit = offset % NMK_GPIO_PER_CHIP;
+	__nmk_gpio_set_mode_safe(nmk_chip, bit, NMK_GPIO_ALT_GPIO, false);
+	clk_disable(nmk_chip->clk);
+
+	return 0;
+}
+
+void nmk_gpio_disable_free(struct pinctrl_dev *pctldev,
+			   struct pinctrl_gpio_range *range,
+			   unsigned offset)
+{
+	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
+
+	dev_dbg(npct->dev, "disable pin %u as GPIO\n", offset);
+	/* Set the pin to some default state, GPIO is usually default */
+}
+
+static struct pinmux_ops nmk_pinmux_ops = {
+	.list_functions = nmk_pmx_list_funcs,
+	.get_function_name = nmk_pmx_get_func_name,
+	.get_function_groups = nmk_pmx_get_func_groups,
+	.enable = nmk_pmx_enable,
+	.disable = nmk_pmx_disable,
+	.gpio_request_enable = nmk_gpio_request_enable,
+	.gpio_disable_free = nmk_gpio_disable_free,
+};
+
 static struct pinctrl_desc nmk_pinctrl_desc = {
 	.name = "pinctrl-nomadik",
 	.pctlops = &nmk_pinctrl_ops,
+	.pmxops = &nmk_pinmux_ops,
 	.owner = THIS_MODULE,
 };
 
diff --git a/drivers/pinctrl/pinctrl-nomadik.h b/drivers/pinctrl/pinctrl-nomadik.h
index e690acc..bc91aed 100644
--- a/drivers/pinctrl/pinctrl-nomadik.h
+++ b/drivers/pinctrl/pinctrl-nomadik.h
@@ -8,6 +8,18 @@
 #define PINCTRL_NMK_DB8500	1
 
 /**
+ * struct nmk_function - Nomadik pinctrl mux function
+ * @name: The name of the function, exported to pinctrl core.
+ * @groups: An array of pin groups that may select this function.
+ * @ngroups: The number of entries in @groups.
+ */
+struct nmk_function {
+	const char *name;
+	const char * const *groups;
+	unsigned ngroups;
+};
+
+/**
  * struct nmk_pingroup - describes a Nomadik pin group
  * @name: the name of this specific pin group
  * @pins: an array of discrete physical pins used in this group, taken
@@ -21,7 +33,7 @@ struct nmk_pingroup {
 	const char *name;
 	const unsigned int *pins;
 	const unsigned npins;
-	u32 altsetting;
+	int altsetting;
 };
 
 /**
@@ -32,7 +44,9 @@ struct nmk_pingroup {
  *		All pins which are also GPIOs must be listed first within the
  *		array, and be numbered identically to the GPIO controller's
  *		numbering.
- * @npins:	The numbmer of entries in @pins.
+ * @npins:	The number of entries in @pins.
+ * @functions:	The functions supported on this SoC.
+ * @nfunction:	The number of entries in @functions.
  * @groups:	An array describing all pin groups the pin SoC supports.
  * @ngroups:	The number of entries in @groups.
  */
@@ -41,6 +55,8 @@ struct nmk_pinctrl_soc_data {
 	unsigned gpio_num_ranges;
 	const struct pinctrl_pin_desc *pins;
 	unsigned npins;
+	const struct nmk_function *functions;
+	unsigned nfunctions;
 	const struct nmk_pingroup *groups;
 	unsigned ngroups;
 };
-- 
1.7.9.2

