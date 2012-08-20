Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2HTJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:09:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39845 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab2HTJJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:09:52 -0400
MIME-Version: 1.0
In-Reply-To: <1344689809-6223-2-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1344689809-6223-2-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 20 Aug 2012 11:09:51 +0200
Message-ID: <CACRpkda0wUW4E3y=ucGRFu5fwwyFWo2dc=4qBaH6CFSOW2ZL_A@mail.gmail.com>
Subject: Re: [PATCH 01/11] pinctrl: mvebu: pinctrl driver core
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 2:56 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> This patch adds a pinctrl driver core for Marvell SoCs plus DT
> binding documentation. This core driver will be used by SoC family
> specific drivers, i.e. Armada XP, Armada 370, Dove, Kirkwood, aso.

Thanks for dealing with this, much appreaciated!

Are you taking this patch series through some Marvell tree or do you want
me to carry it in the pinctrl tree?

(...)
> +++ b/Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt
> @@ -0,0 +1,46 @@
> +* Marvell SoC pinctrl core driver for mpp
> +
> +The pinctrl driver enables Marvell SoCs to configure the multi-purpose pins
> +(mpp) to a specific function. For each SoC family there is a SoC specific
> +driver using this core driver.
> +
> +Please refer to pinctrl-bindings.txt in this directory for details of the
> +common pinctrl bindings used by client devices, including the meaning of the
> +phrase "pin configuration node".
> +
> +A Marvell SoC pin configuration node is a node of a group of pins which can
> +be used for a specific device or function. Each node requires one or more
> +mpp pins or group of pins and a mpp function common to all pins.
> +
> +Required properties for pinctrl driver:
> +- compatible: "marvell,<soc>-pinctrl"
> +  Please refer to each marvell,<soc>-pinctrl.txt binding doc for supported SoCs.
> +
> +Required properties for pin configuration node:
> +- marvell,pins: string array of mpp pins or group of pins to be muxed.
> +- marvell,function: string representing to function to mux to for all
> +    marvell,pins given in this pin configuration node. The function has to be
> +    common for all marvell,pins. Please refer to marvell,<soc>-pinctrl.txt for
> +    valid pin/pin group names and available function names for each SoC.
> +
> +Examples:
> +
> +uart1: serial@12100 {
> +       compatible = "ns16550a";
> +       reg = <0x12100 0x100>;
> +       reg-shift = <2>;
> +       interrupts = <7>;
> +       clock-frequency = <166666667>;

It's got nothing to do with this patch, but getting a clock frequency
out of the DT instead of getting it from the clk_get_rate(clk) and
the clock tree seems absurd... (But maybe this platform does not
even have a clk implementation?)

> +
> +       pinctrl-0 = <&pmx_uart1_sw>;
> +};
> +
> +pinctrl: pinctrl@d0200 {
> +       compatible = "marvell,dove-pinctrl";
> +       reg = <0xd0200 0x20>;
> +
> +       pmx_uart1_sw: pmx-uart1-sw {
> +               marvell,pins = "mpp_uart1";
> +               marvell,function = "uart1";
> +       };
> +};

This looks very good.

(...)
> +#include <linux/pinctrl/consumer.h>

Why are you including this header?
(There are valid reasons, state them in a comment,
e.g. /* to access pinctrl_gpio* in GPIO portions */)

> +struct mvebu_pinctrl_function {
> +       unsigned fid;
> +       const char *name;
> +       const char *setting;
> +       const char **groups;
> +       unsigned num_groups;
> +};
> +
> +struct mvebu_pinctrl_group {
> +       const char *name;
> +       struct mvebu_mpp_ctrl *ctrl;
> +       struct mvebu_mpp_ctrl_setting *settings;
> +       unsigned num_settings;
> +       unsigned gid;
> +       unsigned *pins;
> +       unsigned npins;
> +};
> +
> +struct mvebu_pinctrl {
> +       struct device *dev;
> +       struct pinctrl_dev *pctldev;
> +       struct pinctrl_desc desc;
> +       void __iomem *base;
> +       struct mvebu_pinctrl_group *groups;
> +       unsigned num_groups;
> +       struct mvebu_pinctrl_function *functions;
> +       unsigned num_functions;
> +       unsigned variant;
> +};

There is some other "variant" field elsewhere that is
a u8, is this correct? In this and the other case, should
this "variant" rather be an enum?

> +struct mvebu_pinctrl_group *mvebu_pinctrl_find_group_by_pid(
> +       struct mvebu_pinctrl *pctl, unsigned pid)
> +{
> +       unsigned n;
> +       for (n = 0; n < pctl->num_groups; n++) {
> +               if (pid >= pctl->groups[n].pins[0] &&
> +                   pid < pctl->groups[n].pins[0] +
> +                       pctl->groups[n].npins)
> +                       return &pctl->groups[n];
> +       }
> +       return NULL;
> +}
> +
> +struct mvebu_pinctrl_group *mvebu_pinctrl_find_group_by_name(
> +       struct mvebu_pinctrl *pctl, const char *name)
> +{
> +       unsigned n;
> +       for (n = 0; n < pctl->num_groups; n++) {
> +               if (strcmp(name, pctl->groups[n].name) == 0)
> +                       return &pctl->groups[n];
> +       }
> +       return NULL;
> +}
> +
> +struct mvebu_mpp_ctrl_setting *mvebu_pinctrl_find_setting_by_val(
> +       struct mvebu_pinctrl *pctl, struct mvebu_pinctrl_group *grp,
> +       unsigned long config)
> +{
> +       unsigned n;
> +       for (n = 0; n < grp->num_settings; n++) {
> +               if (config == grp->settings[n].val) {
> +                       if (!pctl->variant || (pctl->variant &
> +                                              grp->settings[n].variant))
> +                               return &grp->settings[n];
> +               }
> +       }
> +       return NULL;
> +}
> +
> +struct mvebu_mpp_ctrl_setting *mvebu_pinctrl_find_setting_by_name(
> +       struct mvebu_pinctrl *pctl, struct mvebu_pinctrl_group *grp,
> +       const char *name)
> +{
> +       unsigned n;
> +       for (n = 0; n < grp->num_settings; n++) {
> +               if (strcmp(name, grp->settings[n].name) == 0) {
> +                       if (!pctl->variant || (pctl->variant &
> +                                              grp->settings[n].variant))
> +                               return &grp->settings[n];
> +               }
> +       }
> +       return NULL;
> +}
> +
> +struct mvebu_mpp_ctrl_setting *mvebu_pinctrl_find_gpio_setting(
> +       struct mvebu_pinctrl *pctl, struct mvebu_pinctrl_group *grp)
> +{
> +       unsigned n;
> +       for (n = 0; n < grp->num_settings; n++) {
> +               if (grp->settings[n].flags &
> +                       (MVEBU_SETTING_GPO | MVEBU_SETTING_GPI)) {
> +                       if (!pctl->variant || (pctl->variant &
> +                                               grp->settings[n].variant))
> +                               return &grp->settings[n];
> +               }
> +       }
> +       return NULL;
> +}
> +
> +struct mvebu_pinctrl_function *mvebu_pinctrl_find_function_by_name(
> +       struct mvebu_pinctrl *pctl, const char *name)
> +{
> +       unsigned n;
> +       for (n = 0; n < pctl->num_functions; n++) {
> +               if (strcmp(name, pctl->functions[n].name) == 0)
> +                       return &pctl->functions[n];
> +       }
> +       return NULL;
> +}
> +
> +static int mvebu_common_mpp_get(struct mvebu_pinctrl *pctl,
> +                               struct mvebu_pinctrl_group *grp,
> +                               unsigned long *config)
> +{
> +       unsigned pin = grp->gid;
> +       unsigned off = (pin / 8) * 4;
> +       unsigned shift = (pin % 8) * 4;

Some magic numbers here. Either use relevant #define:s or
put an inline comment that explains what is going on.

> +
> +       *config = readl(pctl->base + off);
> +       *config >>= shift;
> +       *config &= 0xf;

Here too...

> +
> +       return 0;
> +}
> +
> +static int mvebu_common_mpp_set(struct mvebu_pinctrl *pctl,
> +                               struct mvebu_pinctrl_group *grp,
> +                               unsigned long config)
> +{
> +       unsigned pin = grp->gid;
> +       unsigned off = (pin / 8) * 4;
> +       unsigned shift = (pin % 8) * 4;
> +       unsigned long reg;
> +
> +       reg = readl(pctl->base + off);
> +       reg &= ~(0xf << shift);
> +       reg |= (config << shift);
> +       writel(reg, pctl->base + off);
> +
> +       return 0;
> +}

Same comment as previous function.

(...)
> +static void mvebu_pinctrl_dt_free_map(struct pinctrl_dev *pctldev,
> +                               struct pinctrl_map *map, unsigned num_maps)
> +{
> +       kfree(map);
> +}

Is it possible to use devm_* managed devm_kzalloc() for this map
so you don't need to free it explicitly?

(Maybe not, just checking.)

The rest of this file is looking so good that I find nothing to comment on.

(...)
> diff --git a/drivers/pinctrl/pinctrl-mvebu.h b/drivers/pinctrl/pinctrl-mvebu.h
(...)
> +/*

Kerneldoc begins with /** have you really tested to generate
kerneldoc?

> + * struct mvebu_mpp_ctrl - describe a mpp control
> + * @name: name of the control group
> + * @pid: first pin id handled by this control
> + * @npins: number of pins controlled by this control
> + * @mpp_get: (optional) special function to get mpp setting
> + * @mpp_set: (optional) special function to set mpp setting
> + * @mpp_gpio_req: (optional) special function to request gpio
> + * @mpp_gpio_dir: (optional) special function to set gpio direction
> + *
> + * if optional mpp_get/_set functions are set these
> + * are used to get/set a specific mode. Otherwise it is
> + * assumed that the mpp control is based on 4-bit groups
> + * in subsequent registers.
> + *
> + * mpp_gpio_req/_dir functions can be used to allow pin settings
> + * with varying gpio pins.
> + */
> +struct mvebu_mpp_ctrl {
> +       const char *name;
> +       u8 pid;
> +       u8 npins;

So, there will never be > 256 pins on a Marvell platform?

Just checking...

> +       unsigned *pins;
> +       int (*mpp_get)(struct mvebu_mpp_ctrl *ctrl, unsigned long *config);
> +       int (*mpp_set)(struct mvebu_mpp_ctrl *ctrl, unsigned long config);
> +       int (*mpp_gpio_req)(struct mvebu_mpp_ctrl *ctrl, u8 pid);
> +       int (*mpp_gpio_dir)(struct mvebu_mpp_ctrl *ctrl, u8 pid, bool input);
> +};
> +
> +/*

/**

> + * struct mvebu_mpp_ctrl_setting - describe a mpp ctrl setting
> + * @val: ctrl setting value

It is not obvious to me what this means, it it possible to elaborate
on how this member is defined and used?

> + * @name: ctrl setting name, e.g. uart2, spi0 - unique per mpp_mode
> + * @subname: (optional) additional ctrl setting name, e.g. rts, cts
> + * @variant: (optional) variant identifier mask

This thing again, there are lots of "variants" around here.
Is it a candidate for an enum?

> + * @flags: (private) flags to store gpi/gpo/gpio capabilities

Write something about the two available flags and what they
mean maybe?

> + *
> + * ctrl setting name will be used to switch to this setting in
> + * DT description, e.g. marvell,function = "uart2". subname
> + * is only for debugging purposes.
> + * If name is one of "gpi", "gpo", "gpio" gpio capabilities are
> + * parsed during initialization.
> + */
> +struct mvebu_mpp_ctrl_setting {
> +       u8 val;
> +       const char *name;
> +       const char *subname;
> +       u8 variant;

enum?

> +       u8 flags;
> +#define  MVEBU_SETTING_GPO     (1 << 0)
> +#define  MVEBU_SETTING_GPI     (1 << 1)

So these are the possible flags I suspect. (Looking good.)

> +};
> +
> +/*
> + * struct mvebu_mpp_mode - link ctrl and settings
> + * @pid: first pin id handled by this mode
> + * @settings: list of settings available for this mode
> + */
> +struct mvebu_mpp_mode {
> +       u8 pid;
> +       struct mvebu_mpp_ctrl_setting *settings;
> +};
> +
> +/*
> + * struct mvebu_pinctrl_soc_info -
> + *       SoC specific info passed to pinctrl-mvebu
> + * @variant: variant mask of soc_info
> + * @controls: list of available mvebu_mpp_ctrls
> + * @ncontrols: number of available mvebu_mpp_ctrls
> + * @modes: list of available mvebu_mpp_modes
> + * @nmodes: number of available mvebu_mpp_modes
> + * @gpioranges: list of pinctrl_gpio_ranges
> + * @ngpioranges: number of available pinctrl_gpio_ranges
> + */
> +struct mvebu_pinctrl_soc_info {
> +       u8 variant;

Why is this an u8 rather than an enum?

> +       struct mvebu_mpp_ctrl *controls;
> +       int ncontrols;
> +       struct mvebu_mpp_mode *modes;
> +       int nmodes;
> +       struct pinctrl_gpio_range *gpioranges;
> +       int ngpioranges;
> +};

(...)
> +#if defined(CONFIG_DEBUG_FS)
> +#define MPP_VAR_FUNCTION(_val, _name, _subname, _mask)         \
> +       _MPP_VAR_FUNCTION(_val, _name, _subname, _mask)
> +#else
> +#define MPP_VAR_FUNCTION(_val, _name, _subname, _mask)         \
> +       _MPP_VAR_FUNCTION(_val, _name, NULL, _mask)
> +#endif

This looks a bit kludgy. Is the purpose to save memory
if debugfs is not used?

This looks good overall.

Yours,
Linus Walleij
