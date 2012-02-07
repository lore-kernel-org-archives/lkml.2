Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2BGBo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:44:59 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59846 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2BGBo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:44:58 -0500
Date: Mon, 6 Feb 2012 17:44:51 -0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Dong Aisheng <dongas86@gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: Add simple pinmux driver using device tree
 data
Message-ID: <20120207014449.GA2424@r65073-Latitude-D630>
References: <20120203205049.4089.74610.stgit@kaulin.local>
 <20120203205508.4089.35304.stgit@kaulin.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203205508.4089.35304.stgit@kaulin.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 12:55:08PM -0800, Tony Lindgren wrote:
> Add simple pinmux driver using device tree data.
> 
> Currently this driver only works on omap2+ series of
> processors, where there is either an 8 or 16-bit mux
> register for each pin. Support for other similar pinmux
> controllers could be added.
> 
> Note that this patch does not yet support pinconf_ops
> or GPIO. Further, alternative mux modes are not yet
> handled.
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  .../devicetree/bindings/pinmux/pinctrl-simple.txt  |   62 +
>  drivers/pinctrl/Kconfig                            |    6 
>  drivers/pinctrl/Makefile                           |    1 
>  drivers/pinctrl/pinctrl-simple.c                   | 1286 ++++++++++++++++++++
>  4 files changed, 1355 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pinmux/pinctrl-simple.txt
>  create mode 100644 drivers/pinctrl/pinctrl-simple.c
> 
It's so great to eventually see some codes after such an extensive
discussion on the binding.  The code looks nice to me except a few
trivial comments below.  The only thing I'm concerned is the register
level implementation is not so generic to cover controllers like imx
one, where pinmux and pinconf have separate registers.  If we can make
that part as generic as pin table creating, function/pingroup/mapping
generating, the patch will be good for imx to migrate to.

> diff --git a/Documentation/devicetree/bindings/pinmux/pinctrl-simple.txt b/Documentation/devicetree/bindings/pinmux/pinctrl-simple.txt
> new file mode 100644
> index 0000000..ca1a48d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinmux/pinctrl-simple.txt
> @@ -0,0 +1,62 @@
> +Generic simple device tree based pinmux driver
> +
> +Required properties:
> +- compatible :  one of:
> +	- "pinctrl-simple"
> +	- "ti,omap2420-pinmux"
> +	- "ti,omap2430-pinmux"
> +	- "ti,omap3-pinmux"
> +	- "ti,omap4-pinmux"
> +- reg : offset and length of the register set for the mux registers
> +- #pinmux-cells : width of the pinmux array, currently only 2 is supported
> +- pinctrl-simple,register-width : pinmux register access width
> +- pinctrl-simple,function-mask : mask of allowed pinmux function bits
> +- pinctrl-simple,function-off : function off mode for disabled state
> +- pinctrl-simple,pinconf-mask : mask of allowed pinconf bits
> +
> +Example:
> +
> +	/* SoC common file, such as omap4.dtsi */
> +	omap4_pmx_core: pinmux@4a100040 {
> +		compatible = "ti,omap4-pinmux";
> +		reg = <0x4a100040 0x0196>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		#pinmux-cells = <2>;
> +		pinctrl-simple,register-width = <16>;
> +		pinctrl-simple,function-mask = <0x7>;
> +		pinctrl-simple,function-off = <0x7>;
> +		pinctrl-simple,pinconf-mask = <0xfff8>;
> +	};
> +
> +	omap4_pmx_wkup: pinmux@4a31e040 {
> +		compatible = "ti,omap4-pinmux";
> +		reg = <0x4a31e040 0x0038>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		#pinmux-cells = <2>;
> +		pinctrl-simple,register-width = <16>;
> +		pinctrl-simple,function-mask = <0x7>;
> +		pinctrl-simple,function-off = <0x7>;
> +		pinctrl-simple,pinconf-mask = <0xfff8>;
> +	};
> +
> +	uart3: serial@48020000 {
> +		compatible = "ti,omap4-uart";
> +		ti,hwmods = "uart3";
> +		clock-frequency = <48000000>;
> +	}
> +
> +	/* board specific .dts file, such as omap4-sdp.dts */
> +	pinmux@4a100040 {
> +		pmx_uart3: pinconfig-uart3 {
> +			mux = <0x0104 0x100
> +			       0x0106 0x0>;
> +                        };

The line is some leftover which should be deleted?

> +                };
> +	};
> +
> +	serial@48020000 {
> +        	pinctrl = <&pmx_uart3>;
> +	};
> +
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index afaf885..73848b1 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -42,6 +42,12 @@ config PINCTRL_COH901
>  	  COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
>  	  ports of 8 GPIO pins each.
>  
> +config PINCTRL_SIMPLE
> +	tristate "Simple device tree based pinmux driver"
> +	depends on OF
> +	help
> +	  This selects the device tree based generic pinmux driver.
> +

We would call it pinctrl instead pinmux driver?

>  endmenu
>  
>  endif
> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> index 827601c..4b05649 100644
> --- a/drivers/pinctrl/Makefile
> +++ b/drivers/pinctrl/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_PINCONF)		+= pinconf.o
>  obj-$(CONFIG_PINCTRL_SIRF)	+= pinctrl-sirf.o
>  obj-$(CONFIG_PINCTRL_U300)	+= pinctrl-u300.o
>  obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
> +obj-$(CONFIG_PINCTRL_SIMPLE)	+= pinctrl-simple.o
> diff --git a/drivers/pinctrl/pinctrl-simple.c b/drivers/pinctrl/pinctrl-simple.c
> new file mode 100644
> index 0000000..370e0c3
> --- /dev/null
> +++ b/drivers/pinctrl/pinctrl-simple.c
> @@ -0,0 +1,1286 @@
> +/*
> + * Generic simple device tree based pinmux driver
> + *
> + * Copyright (C) 2012 Texas Instruments, Inc.
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/list.h>
> +
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_address.h>
> +
> +#include <linux/pinctrl/pinctrl.h>
> +#include <linux/pinctrl/pinmux.h>
> +#include <linux/pinctrl/machine.h>
> +
> +#include "core.h"
> +
> +#define PMX_MUX_NAME			"mux"
> +#define PMX_PINCTRL_NAME		"pinctrl"
> +#define PMX_MUX_CELLS			"#pinmux-cells"
> +#define DRIVER_NAME			"pictrl-simple"
> +#define REG_NAME_LEN			(sizeof(unsigned long) + 1)
> +
> +static LIST_HEAD(smux_maps);		/* Global device to pinmux map */
> +static LIST_HEAD(smux_pingroups);	/* Global list of pingroups */
> +static LIST_HEAD(smux_functions);	/* Global list of functions */
> +static DEFINE_MUTEX(smux_mutex);
> +
> +/**
> + * struct smux_pingroup - pingroups for a function
> + * @smux:	pinmux controller instance
> + * @np:		pinggroup device node pointer
> + * @name:	pingroup name
> + * @gpins:	array of the pins in the group
> + * @ngpins:	number of pins in the group
> + */
> +struct smux_pingroup {
> +	struct smux_device *smux;
> +	struct device_node *np;
> +	char *name;
> +	int *gpins;
> +	int ngpins;
> +	struct list_head node;
> +};
> +
> +/**
> + * struct smux_func_vals - mux function register offset and default value pair
> + * @reg:	register virtual address
> + * @defval:	default value
> + */
> +struct smux_func_vals {
> +	void __iomem *reg;
> +	unsigned defval;
> +};
> +
> +/**
> + * struct smux_function - pinmux function
> + * @smux:	pinmux controller instance
> + * @np:		mux device node pointer
> + * @name:	pinmux function name
> + * @vals:	register and default values array
> + * @nvals:	number of entries in vals array
> + * @pgnames:	array of pingroup names the function uses
> + * @npgnames:	number of pingroup names the function uses
> + * @node:	list node
> + *
> + * Note that np is needed to match pinctrl entry to mux entry.
> + */
> +struct smux_function {
> +	struct smux_device *smux;
> +	struct device_node *np;
> +	char *name;
> +	struct smux_func_vals *vals;
> +	unsigned nvals;
> +	const char **pgnames;
> +	int npgnames;
> +	struct list_head node;
> +};
> +
> +/**
> + * struct smux_map - wrapper for device to pinmux map
> + * @smux:	pinmux controller instance
> + * @map:	device to pinmux map
> + * @node:	list node
> + */
> +struct smux_map {
> +	struct smux_device *smux;
> +	struct pinmux_map map;
> +	struct list_head node;
> +};
> +
> +/**
> + * struct smux_data - data arrays needed by pinctrl framework
> + * @pa:		pindesc array
> + * @ma:		pinmap array
> + * @cur:	index to current element
> + * @max:	last element in the array
> + *
> + */
> +struct smux_data {
> +	union {
> +		struct pinctrl_pin_desc *pa;
> +		struct pinmux_map *ma;
> +	};
> +	int cur;
> +	int max;
> +};
> +
> +/**
> + * struct smux_device - mux device instance
> + * @res:	resources
> + * @base:	virtual address of the controller
> + * @size:	size of the ioremapped area
> + * @dev:	device entry
> + * @pctl:	pin controller device
> + * @width:	bits per mux register
> + * @fmask:	function register mask
> + * @fshift:	function register shift
> + * @foff:	value to turn mux off
> + * @cmask:	pinconf mask
> + * @fmax:	max number of functions in fmask
> + * @cells:	width of the mux array
> + * @names:	array of register names for pins
> + * @pins:	physical pins on the SoC
> + * @maps:	device to mux function mappings
> + * @pgtree:	pingroup index radix tree
> + * @ftree:	function index radix tree
> + * @ngroups:	number of pingroups
> + * @nfuncs:	number of functions
> + * @pctlops:	pin controller functions
> + * @pmxops:	pin mux functions
> + * @desc:	pin controller descriptor
> + * @read:	register read function to use
> + * @write:	register write function to use
> + */
> +struct smux_device {
> +	struct resource *res;
> +	void __iomem *base;
> +	unsigned size;
> +	struct device *dev;
> +	struct pinctrl_dev *pctl;
> +
> +	unsigned width;
> +	unsigned fmask;
> +	unsigned fshift;
> +	unsigned foff;
> +	unsigned cmask;
> +	unsigned fmax;
> +	unsigned cells;
> +
> +	char *names;
> +	struct smux_data pins;
> +	struct smux_data maps;
> +	struct radix_tree_root pgtree;
> +	struct radix_tree_root ftree;
> +	unsigned ngroups;
> +	unsigned nfuncs;
> +
> +	struct pinctrl_ops *pctlops;
> +	struct pinmux_ops *pmxops;
> +	struct pinctrl_desc *desc;
> +
> +	unsigned (*read)(void __iomem *reg);
> +	void (*write)(unsigned val, void __iomem *reg);
> +};
> +
> +static unsigned __maybe_unused smux_readb(void __iomem *reg)
> +{
> +	return readb(reg);
> +}
> +
> +static unsigned __maybe_unused smux_readw(void __iomem *reg)
> +{
> +	return readw(reg);
> +}
> +
> +static unsigned __maybe_unused smux_readl(void __iomem *reg)
> +{
> +	return readl(reg);
> +}
> +
> +static void __maybe_unused smux_writeb(unsigned val, void __iomem *reg)
> +{
> +	writeb(val, reg);
> +}
> +
> +static void __maybe_unused smux_writew(unsigned val, void __iomem *reg)
> +{
> +	writew(val, reg);
> +}
> +
> +static void __maybe_unused smux_writel(unsigned val, void __iomem *reg)
> +{
> +	writel(val, reg);
> +}
> +
> +static int smux_list_groups(struct pinctrl_dev *pctldev, unsigned gselector)
> +{
> +	struct smux_device *smux;
> +
> +	smux = pinctrl_dev_get_drvdata(pctldev);
> +	if (gselector >= smux->ngroups)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static const char *smux_get_group_name(struct pinctrl_dev *pctldev,
> +					unsigned gselector)
> +{
> +	struct smux_device *smux;
> +	struct smux_pingroup *group;
> +
> +	smux = pinctrl_dev_get_drvdata(pctldev);
> +	group = radix_tree_lookup(&smux->pgtree, gselector);
> +	if (!group) {
> +		dev_err(smux->dev, "%s could not find pingroup%i\n",
> +					__func__, gselector);
> +		return NULL;
> +	}
> +
> +	return group->name;
> +}
> +
> +static int smux_get_group_pins(struct pinctrl_dev *pctldev,
> +					unsigned gselector,
> +					const unsigned **pins,
> +					unsigned *npins)
> +{
> +	struct smux_device *smux;
> +	struct smux_pingroup *group;
> +
> +	smux = pinctrl_dev_get_drvdata(pctldev);
> +	group = radix_tree_lookup(&smux->pgtree, gselector);
> +	if (!group) {
> +		dev_err(smux->dev, "%s could not find pingroup%i\n",
> +					__func__, gselector);
> +		return -EINVAL;
> +	}
> +
> +	*pins = group->gpins;
> +	*npins = group->ngpins;
> +
> +	return 0;
> +}
> +
> +static void smux_pin_dbg_show(struct pinctrl_dev *pctldev,
> +					struct seq_file *s,
> +					unsigned offset)
> +{
> +	seq_printf(s, " " DRIVER_NAME);
> +}
> +
> +static struct pinctrl_ops smux_pinctrl_ops = {
> +	.list_groups = smux_list_groups,
> +	.get_group_name = smux_get_group_name,
> +	.get_group_pins = smux_get_group_pins,
> +	.pin_dbg_show = smux_pin_dbg_show,
> +};
> +
> +static int smux_list_functions(struct pinctrl_dev *pctldev, unsigned fselector)
> +{
> +	struct smux_device *smux;
> +
> +	smux = pinctrl_dev_get_drvdata(pctldev);
> +	if (fselector >= smux->nfuncs)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static const char *smux_get_function_name(struct pinctrl_dev *pctldev,
> +						unsigned fselector)
> +{
> +	struct smux_device *smux;
> +	struct smux_function *func;
> +
> +	smux = pinctrl_dev_get_drvdata(pctldev);
> +	func = radix_tree_lookup(&smux->ftree, fselector);
> +	if (!func) {
> +		dev_err(smux->dev, "%s could not find function%i\n",
> +					__func__, fselector);
> +		return NULL;
> +	}
> +
> +	return func->name;
> +}
> +
> +static int smux_get_function_groups(struct pinctrl_dev *pctldev,
> +					unsigned fselector,
> +					const char * const **groups,
> +					unsigned * const ngroups)
> +{
> +	struct smux_device *smux;
> +	struct smux_function *func;
> +
> +	smux = pinctrl_dev_get_drvdata(pctldev);
> +	func = radix_tree_lookup(&smux->ftree, fselector);
> +	if (!func) {
> +		dev_err(smux->dev, "%s could not find function%i\n",
> +					__func__, fselector);
> +		return -EINVAL;
> +	}
> +	*groups = func->pgnames;
> +	*ngroups = func->npgnames;
> +
> +	return 0;
> +}
> +
> +static int smux_enable(struct pinctrl_dev *pctldev, unsigned fselector,
> +	unsigned group)
> +{
> +	struct smux_device *smux;
> +	struct smux_function *func;
> +	int i;
> +
> +	smux = pinctrl_dev_get_drvdata(pctldev);
> +	func = radix_tree_lookup(&smux->ftree, fselector);
> +	if (!func)
> +		return -EINVAL;
> +
> +	dev_dbg(smux->dev, "enabling function%i %s\n",
> +		fselector, func->name);
> +
> +	for (i = 0; i < func->nvals; i++) {
> +		struct smux_func_vals *vals;
> +		unsigned val;
> +
> +		vals = &func->vals[i];
> +		val = smux->read(vals->reg);
> +		val &= ~(smux->cmask | smux->fmask);
> +		val |= vals->defval;
> +		smux->write(val, vals->reg);
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * REVISIT: We may not always have a single disable value for a register,
> + * but this can be handled with alternative modes once the DT binding is
> + * available for those.
> + */
> +static void smux_disable(struct pinctrl_dev *pctldev, unsigned fselector,
> +					unsigned group)
> +{
> +	struct smux_device *smux;
> +	struct smux_function *func;
> +	int i;
> +
> +	smux = pinctrl_dev_get_drvdata(pctldev);
> +	func = radix_tree_lookup(&smux->ftree, fselector);
> +	if (!func) {
> +		dev_err(smux->dev, "%s could not find function%i\n",
> +					__func__, fselector);
> +		return;
> +	}
> +
> +	dev_dbg(smux->dev, "disabling function%i %s\n",
> +		fselector, func->name);
> +
> +	for (i = 0; i < func->nvals; i++) {
> +		struct smux_func_vals *vals;
> +		unsigned val;
> +
> +		vals = &func->vals[i];
> +		val = smux->read(vals->reg);
> +		val &= ~(smux->cmask | smux->fmask);
> +		val |= smux->foff << smux->fshift;
> +		smux->write(val, vals->reg);
> +	}
> +}
> +
> +static int smux_request_gpio(struct pinctrl_dev *pctldev,
> +			struct pinctrl_gpio_range *range, unsigned offset)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static struct pinmux_ops smux_pinmux_ops = {
> +	.list_functions = smux_list_functions,
> +	.get_function_name = smux_get_function_name,
> +	.get_function_groups = smux_get_function_groups,
> +	.enable = smux_enable,
> +	.disable = smux_disable,
> +	.gpio_request_enable = smux_request_gpio,
> +};
> +
> +static int smux_pinconf_get(struct pinctrl_dev *pctldev,
> +				unsigned pin, unsigned long *config)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int smux_pinconf_set(struct pinctrl_dev *pctldev,
> +				unsigned pin, unsigned long config)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int smux_pinconf_group_get(struct pinctrl_dev *pctldev,
> +				unsigned group, unsigned long *config)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int smux_pinconf_group_set(struct pinctrl_dev *pctldev,
> +				unsigned group, unsigned long config)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static void smux_pinconf_dbg_show(struct pinctrl_dev *pctldev,
> +				struct seq_file *s, unsigned offset)
> +{
> +}
> +
> +static void smux_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
> +				struct seq_file *s, unsigned selector)
> +{
> +}
> +
> +static struct pinconf_ops smux_pinconf_ops = {
> +	.pin_config_get = smux_pinconf_get,
> +	.pin_config_set = smux_pinconf_set,
> +	.pin_config_group_get = smux_pinconf_group_get,
> +	.pin_config_group_set = smux_pinconf_group_set,
> +	.pin_config_dbg_show = smux_pinconf_dbg_show,
> +	.pin_config_group_dbg_show = smux_pinconf_group_dbg_show,
> +};
> +
> +static struct pinctrl_desc smux_pinctrl_desc = {
> +	.name = DRIVER_NAME,
> +	.pctlops = &smux_pinctrl_ops,
> +	.pmxops = &smux_pinmux_ops,
> +	.confops = &smux_pinconf_ops,
> +	.owner = THIS_MODULE,
> +};
> +
> +/**
> + * smux_add_pin() - add a pin to the static per controller pin array
> + * @smux: smux driver instance
> + * @offset: register offset from base
> + */
> +static int __init smux_add_pin(struct smux_device *smux, unsigned offset)
> +{
> +	struct pinctrl_pin_desc *pin;
> +	char *name;
> +	int i;
> +
> +	i = smux->pins.cur;
> +	if (i > smux->pins.max + 1) {
> +		dev_err(smux->dev, "too many pins, max %i\n",
> +					smux->pins.max);
> +		return -ENOMEM;
> +	}
> +
> +	pin = &smux->pins.pa[i];
> +	name = &smux->names[i];
> +	sprintf(name, "%lx",
> +		(unsigned long)smux->res->start + offset);
> +	pin->name = name;
> +	pin->number = i;
> +	smux->pins.cur++;
> +
> +	return i;
> +}
> +
> +/**
> + * smux_allocate_pin_table() - adds all the pins for the pinmux controller
> + * @smux: smux driver instance
> + *
> + * In case of errors, resources are freed in smux_free_resources.
> + */
> +static int __init smux_allocate_pin_table(struct smux_device *smux)
> +{
> +	int mux_bytes, i;
> +
> +	mux_bytes = smux->width / BITS_PER_BYTE;
> +	smux->pins.max = smux->size / mux_bytes;
> +
> +	dev_dbg(smux->dev, "allocating %i muxable pins\n",
> +				smux->pins.max);
> +	smux->pins.pa = devm_kzalloc(smux->dev,
> +				sizeof(*smux->pins.pa) * smux->pins.max,
> +				GFP_KERNEL);
> +	if (!smux->pins.pa)
> +		return -ENOMEM;
> +
> +	smux->names = devm_kzalloc(smux->dev,
> +				REG_NAME_LEN * smux->pins.max,
> +				GFP_KERNEL);
> +	if (!smux->names)
> +		return -ENOMEM;
> +
> +	smux->desc->pins = smux->pins.pa;
> +	smux->desc->npins = smux->pins.max--;
> +
Hmm, why do you have pins.max minus 1 here and most of the places where
it gets used plus 1?  Keep it as it is and use pins.max - 1 in that
only place I have seen?

> +	for (i = 0; i <= smux->desc->npins; i++) {
> +		unsigned offset;
> +		int res;
> +
> +		offset = i * mux_bytes;
> +		res = smux_add_pin(smux, offset);
> +		if (res < 0) {
> +			dev_err(smux->dev, "error adding pins: %i\n", res);
> +			return res;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * smux_add_function() - adds a new function to the function list
> + * @smux: smux driver instance
> + * @np: device node of the mux entry
> + * @name: name of the function
> + * @vals: array of mux register value pairs used by the function
> + * @nvals: number of mux register value pairs
> + * @pgnames: array of pingroup names for the function
> + * @npgnames: number of pingroup names
> + */
> +static int __init smux_add_function(struct smux_device *smux,
> +					struct device_node *np,
> +					const char *name,
> +					struct smux_func_vals *vals,
> +					unsigned nvals,
> +					const char **pgnames,
> +					unsigned npgnames)
> +{
> +	struct smux_function *function;
> +
> +	function = devm_kzalloc(smux->dev, sizeof(*function), GFP_KERNEL);
> +	if (!function)
> +		return -ENOMEM;
> +
> +	function->name = kstrdup(name, GFP_KERNEL);
> +	if (!function->name) {
> +		devm_kfree(smux->dev, function);
> +		return -ENOMEM;
> +	}
> +
> +	function->np = np;
> +	function->smux = smux;
> +	function->vals = vals;
> +	function->nvals = nvals;
> +	function->pgnames = pgnames;
> +	function->npgnames = npgnames;
> +
> +	mutex_lock(&smux_mutex);
> +	list_add_tail(&function->node, &smux_functions);
> +	radix_tree_insert(&smux->ftree, smux->nfuncs, function);
> +	smux->nfuncs++;
> +	mutex_unlock(&smux_mutex);
> +
> +	return 0;
> +}
> +
> +/**
> + * smux_add_pingroup() - add a pingroup to the pingroup list
> + * @smux: smux driver instance
> + * @np: device node of the mux entry
> + * @name: name of the pingroup
> + * @gpins: array of the pins that belong to the group
> + * @ngpins: number of pins in the group
> + */
> +static int __init smux_add_pingroup(struct smux_device *smux,
> +					struct device_node *np,
> +					const char *name,
> +					int *gpins,
> +					int ngpins)
> +{
> +	struct smux_pingroup *pingroup;
> +
> +	pingroup = devm_kzalloc(smux->dev, sizeof(*pingroup), GFP_KERNEL);
> +	if (!pingroup)
> +		return -ENOMEM;
> +
> +	pingroup->name = kstrdup(name, GFP_KERNEL);
> +	if (!pingroup->name) {
> +		devm_kfree(smux->dev, pingroup);
> +		return -ENOMEM;
> +	}
> +
> +	pingroup->np = np;
> +	pingroup->smux = smux;
> +	pingroup->gpins = gpins;
> +	pingroup->ngpins = ngpins;
> +
> +	mutex_lock(&smux_mutex);
> +	list_add_tail(&pingroup->node, &smux_pingroups);
> +	radix_tree_insert(&smux->pgtree, smux->ngroups, pingroup);
> +	smux->ngroups++;
> +	mutex_unlock(&smux_mutex);
> +
> +	return 0;
> +}
> +
> +/**
> + * smux_get_pin_by_offset() - get a pin index based on the register offset
> + * @smux: smux driver instance
> + * @offset: register offset from the base
> + *
> + * Note that this is OK for now as the pins are in a static array and
> + * the radix tree number stays the same.
> + */
> +static int __init smux_get_pin_by_offset(struct smux_device *smux,
> +						unsigned offset)
> +{
> +	unsigned index;
> +
> +	if (offset >= smux->size) {
> +		dev_err(smux->dev, "mux offset out of range: %04x (%04x)\n",
> +			offset, smux->size);
> +		return -EINVAL;
> +	}
> +
> +	index = offset / (smux->width / BITS_PER_BYTE);
> +
> +	return index;
> +}
> +
> +/**
> + * smux_parse_one_pinmux_entry() - parses a device tree mux entry
> + * @smux: smux driver instance
> + * @np: device node of the mux entry
> + *
> + * Note that this currently supports only #pinmux-cells = 2.
> + * This could be improved to parse controllers that have multiple
> + * registers per mux.
> + */
> +static int __init smux_parse_one_pinmux_entry(struct smux_device *smux,
> +						struct device_node *np)
> +{
> +	struct smux_func_vals *vals;
> +	const __be32 *mux;
> +	int size, rows, *pins, index = 0, found = 0, res = -ENOMEM;
> +	const char **pgnames;
> +
> +	if (smux->cells != 2) {
> +		dev_err(smux->dev, "unhandled %s: %i\n",
> +					PMX_MUX_CELLS,
> +					smux->cells);
> +		return -EINVAL;
> +	}
> +
> +	mux = of_get_property(np, PMX_MUX_NAME, &size);
> +	if ((!mux) || (size < sizeof(*mux) * smux->cells)) {
> +		dev_err(smux->dev, "bad data for mux %s\n",
> +					np->full_name);
> +		return -EINVAL;
> +	}
> +	size /= sizeof(*mux);	/* Number of elements in array */
> +	rows = size / smux->cells;
> +
> +	vals = devm_kzalloc(smux->dev, sizeof(*vals) * rows, GFP_KERNEL);
> +	if (!vals)
> +		return -ENOMEM;
> +
> +	pins = devm_kzalloc(smux->dev, sizeof(*pins) * rows, GFP_KERNEL);
> +	if (!pins)
> +		goto free_vals;
> +
> +	pgnames = devm_kzalloc(smux->dev, sizeof(*pgnames), GFP_KERNEL);
> +	if (!pgnames)
> +		goto free_pins;
> +
> +	while (index < size) {
> +		unsigned offset, defval;
> +		int pin;
> +
> +		offset = be32_to_cpup(mux + index++);
> +		defval = be32_to_cpup(mux + index++);
> +		vals[found].reg = smux->base + offset;
> +		vals[found].defval = defval;
> +
> +		pin = smux_get_pin_by_offset(smux, offset);
> +		if (pin < 0) {
> +			dev_info(smux->dev,
> +				"could not add functions for mux %ux\n",
> +					offset);
> +			break;
> +		}
> +		pins[found++] = pin;
> +	}
> +
> +	pgnames[0] = np->name;
> +	res = smux_add_function(smux, np, np->name, vals, found, pgnames, 1);
> +	if (res < 0)
> +		goto free_pgnames;
> +
> +	res = smux_add_pingroup(smux, np, np->name, pins, found);
> +	if (res < 0)
> +		goto free_pgnames;
> +
> +	return 0;
> +
> +free_pgnames:
> +	devm_kfree(smux->dev, pgnames);
> +
> +free_pins:
> +	devm_kfree(smux->dev, pins);
> +
> +free_vals:
> +	devm_kfree(smux->dev, vals);
> +
> +	return res;
> +}
> +
> +/**
> + * smux_get_function_by_node() - find a function by node
> + * @smux: smux driver instance
> + * @np: device node of the mux entry
> + */
> +static struct smux_function *
> +__init smux_get_function_by_node(struct smux_device *smux,
> +					struct device_node *np)
> +{
> +	struct smux_function *function;
> +
> +	mutex_lock(&smux_mutex);
> +	list_for_each_entry(function, &smux_functions, node) {
> +		if (smux != function->smux)
> +			continue;
> +
> +		if (function->np == np)
> +			goto unlock;
> +	}
> +	function = NULL;
> +
> +unlock:
> +	mutex_unlock(&smux_mutex);
> +
> +	return function;
> +}
> +
> +/**
> + * smux_rename_function() - renames a function added earlier
> + * @function: existing function
> + * @new_name: new name for the function
> + *
> + * This is needed to avoid adding multiple function entries.
> + * We first parse all the device tree mux entries, and then
> + * parse the device pinconfig entries. This allows us to rename
> + * mux entry to match the device pinconfig naming.
> + */
> +static int __init smux_rename_function(struct smux_function *function,
> +					const char *new_name)
> +{
> +	char *name;
> +
> +	if (!new_name)
> +		return -EINVAL;
> +
> +	name = kstrdup(new_name, GFP_KERNEL);
> +	if (!name)
> +		return -ENOMEM;
> +
> +	mutex_lock(&smux_mutex);
> +	kfree(function->name);
> +	function->name = name;
> +	mutex_unlock(&smux_mutex);
> +
> +	return 0;
> +}
> +
> +/**
> + * smux_add_map() - adds a new map to the map list
> + * @smux: smux driver instance
> + * @np: device node of the mux entry
> + *
> + * Note that pctldev will get populated later on as it is
> + * not available until after pinctrl_register().
> + */
> +static int __init smux_add_map(struct smux_device *smux,
> +				struct device_node *np)
> +{
> +	struct platform_device *pdev = NULL;
> +	struct smux_map *smap;
> +	struct pinmux_map *map;
> +	const char *new_name;
> +	int ret;
> +
> +	pdev = of_find_device_by_node(np);
> +	new_name = np->full_name;
> +
> +	mutex_lock(&smux_mutex);
> +	list_for_each_entry(smap, &smux_maps, node) {
> +		const char *existing_name = smap->map.name;
> +
> +		if (smap->smux != smux)
> +			continue;
> +
> +		if (!strcmp(new_name, existing_name)) {
> +			dev_info(smux->dev, "map already exists for %s\n",
> +				existing_name);
> +			ret = -EEXIST;
> +			goto unlock;
> +		}
> +	}
> +
> +	smap = devm_kzalloc(smux->dev, sizeof(*smap), GFP_KERNEL);
> +	if (!smap) {
> +		ret = -ENOMEM;
> +		goto unlock;
> +	}
> +	smap->smux = smux;
> +	if (smux->pctl && smux->pctl->dev)
> +		smap->map.ctrl_dev = smux->pctl->dev;
> +	map = &smap->map;
> +
> +	map->dev = smux->dev;
> +	map->name = kstrdup(new_name, GFP_KERNEL);
> +	if (!map->name) {
> +		ret = -ENOMEM;
> +		devm_kfree(smux->dev, smap);
> +		goto unlock;
> +	}
> +	map->function = map->name;
> +	list_add_tail(&smap->node, &smux_maps);
> +	ret = 0;
> +
> +unlock:
> +	mutex_unlock(&smux_mutex);
> +
> +	return ret;
> +}
> +
> +/**
> + * smux_parse_one_pinctrl_entry() - parses a device tree pinctrl entry
> + * @smux: smux driver instance
> + * @np: device node for mux entry
> + */
> +static int __init smux_parse_one_pinctrl_entry(struct smux_device *smux,
> +						struct device_node *np)
> +{
> +	int count = 0;
> +
> +	do {
> +		struct device_node *mux_np;
> +		struct smux_function *function;
> +		int res;
> +
> +		mux_np = of_parse_phandle(np, PMX_PINCTRL_NAME,
> +					count);
> +		if (!mux_np)
> +			break;
> +
> +		function = smux_get_function_by_node(smux, mux_np);
> +		if (!function)
> +			break;
> +
> +		res = smux_rename_function(function, np->full_name);
> +		if (res < 0) {
> +			dev_err(smux->dev, "could not rename %s to %s\n",
> +				function->name, np->full_name);
> +			break;
> +		}
> +
> +		res = smux_add_map(smux, np);
> +		if (res < 0) {
> +			dev_err(smux->dev, "could not add mapping for %s\n",
> +					np->full_name);
> +			break;
> +		}
> +	} while (++count);
> +
> +	return count;
> +}
> +
> +/**
> + * smux_load_mux_register() - parses all the device tree mux entries
> + * @smux: smux driver instance
> + */
> +static int __init smux_load_mux_registers(struct smux_device *smux)
> +{
> +	struct device_node *np;
> +	int ret;
> +
> +	for_each_child_of_node(smux->dev->of_node, np) {
> +		ret = smux_parse_one_pinmux_entry(smux, np);
> +	}
> +
> +	for_each_node_with_property(np, PMX_PINCTRL_NAME) {
> +		ret = smux_parse_one_pinctrl_entry(smux, np);
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * smux_populate_map() - populates device map for pinmux_register_mappings()
> + * @smux: smux driver instance
> + *
> + * Note that we need to fill in the ctrl_dev here as it's not known earlier
> + * before pinctrl_register().
> + */
> +static int __init smux_populate_map(struct smux_device *smux)
> +{
> +	struct smux_map *smap;
> +	int i = 0, ret;
> +
> +	mutex_lock(&smux_mutex);
> +	list_for_each_entry(smap, &smux_maps, node) {
> +		if (smap->smux != smux)
> +			continue;
> +		smap->map.ctrl_dev = smux->pctl->dev;
> +		i++;
> +	}
> +	if (!i) {
> +		dev_err(smux->dev, "no maps found\n");
> +		ret = -ENODEV;
> +		goto unlock;
> +	}
> +
> +	dev_dbg(smux->dev, "allocating %i entries for map table\n", i);
> +	smux->maps.ma = devm_kzalloc(smux->dev, sizeof(*smux->maps.ma) * i,
> +					GFP_KERNEL);
> +	if (!smux->maps.ma) {
> +		ret = -ENOMEM;
> +		goto unlock;
> +	}
> +
> +	i = 0;
> +	list_for_each_entry(smap, &smux_maps, node) {
> +		struct pinmux_map *map = &smux->maps.ma[i];
> +
> +		if (smap->smux != smux)
> +			continue;
> +
> +		*map = smap->map;
> +		i++;
> +	}
> +	smux->maps.max = i - 1;
> +	ret = i;
> +
> +unlock:
> +	mutex_unlock(&smux_mutex);
> +
> +	return ret;
> +}
> +
> +/**
> + * smux_free_maps() - free memory used by device maps
> + * @smux: smux driver instance
> + */
> +static void smux_free_maps(struct smux_device *smux)
> +{
> +	struct list_head *pos, *tmp;
> +
> +	mutex_lock(&smux_mutex);
> +	list_for_each_safe(pos, tmp, &smux_maps) {
> +		struct smux_map *smap;
> +
> +		smap = list_entry(pos, struct smux_map, node);
> +		if (smap->smux != smux)
> +			continue;
> +
> +		kfree(smap->map.name);
> +		list_del(&smap->node);
> +		devm_kfree(smux->dev, smap);
> +	}
> +	if (smux->maps.ma)
> +		devm_kfree(smux->dev, smux->maps.ma);
> +	mutex_unlock(&smux_mutex);
> +}
> +
> +/**
> + * smux_free_funcs() - free memory used by functions
> + * @smux: smux driver instance
> + */
> +static void smux_free_funcs(struct smux_device *smux)
> +{
> +	struct list_head *pos, *tmp;
> +	int i;
> +
> +	mutex_lock(&smux_mutex);
> +	for (i = 0; i < smux->nfuncs; i++) {
> +		struct smux_function *func;
> +
> +		func = radix_tree_lookup(&smux->ftree, i);
> +		if (!func)
> +			continue;
> +		radix_tree_delete(&smux->ftree, i);
> +	}
> +	list_for_each_safe(pos, tmp, &smux_functions) {
> +		struct smux_function *function;
> +
> +		function = list_entry(pos, struct smux_function, node);
> +		if (function->smux != smux)
> +			continue;
> +
> +		kfree(function->name);
> +		if (function->vals)
> +			devm_kfree(smux->dev, function->vals);
> +		if (function->pgnames)
> +			devm_kfree(smux->dev, function->pgnames);
> +		list_del(&function->node);
> +		devm_kfree(smux->dev, function);
> +	}
> +	mutex_unlock(&smux_mutex);
> +}
> +
> +/**
> + * smux_free_pingroups() - free memory used by pingroups
> + * @smux: smux driver instance
> + */
> +static void smux_free_pingroups(struct smux_device *smux)
> +{
> +	struct list_head *pos, *tmp;
> +	int i;
> +
> +	mutex_lock(&smux_mutex);
> +	for (i = 0; i < smux->ngroups; i++) {
> +		struct smux_pingroup *pingroup;
> +
> +		pingroup = radix_tree_lookup(&smux->pgtree, i);
> +		if (!pingroup)
> +			continue;
> +		radix_tree_delete(&smux->pgtree, i);
> +	}
> +	list_for_each_safe(pos, tmp, &smux_pingroups) {
> +		struct smux_pingroup *pingroup;
> +
> +		pingroup = list_entry(pos, struct smux_pingroup, node);
> +		if (pingroup->smux != smux)
> +			continue;
> +
> +		kfree(pingroup->name);
> +		list_del(&pingroup->node);
> +		devm_kfree(smux->dev, pingroup);
> +	}
> +	mutex_unlock(&smux_mutex);
> +}
> +
> +/**
> + * smux_free_resources() - free memory used by this driver
> + * @smux: smux driver instance
> + */
> +static void smux_free_resources(struct smux_device *smux)
> +{
> +	if (smux->pctl)
> +		pinctrl_unregister(smux->pctl);
> +
> +	smux_free_maps(smux);
> +	smux_free_funcs(smux);
> +	smux_free_pingroups(smux);
> +
> +	if (smux->pins.pa)
> +		devm_kfree(smux->dev, smux->pins.pa);
> +	if (smux->names)
> +		devm_kfree(smux->dev, smux->names);
> +}
> +
> +/**
> + * smux_register() - initializes and registers with pinctrl framework
> + * @smux: smux driver instance
> + */
> +static int __init smux_register(struct smux_device *smux)
> +{
> +	int ret;
> +
> +	if (!smux->dev->of_node)
> +		return -ENODEV;
> +
> +	smux->pctlops = &smux_pinctrl_ops;
> +	smux->pmxops = &smux_pinmux_ops;

I do not see where these two pointers inside smux be used anywhere.
And also they can be got from smux below anyway.  So why bothering?

Regards,
Shawn

> +	smux->desc = &smux_pinctrl_desc;
> +
> +	ret = smux_allocate_pin_table(smux);
> +	if (ret < 0)
> +		goto free;
> +
> +	ret = smux_load_mux_registers(smux);
> +	if (ret < 0)
> +		goto free;
> +
> +	smux->pctl = pinctrl_register(smux->desc, smux->dev, smux);
> +	if (!smux->pctl) {
> +		dev_err(smux->dev, "could not register simple pinmux driver\n");
> +		ret = -EINVAL;
> +		goto free;
> +	}
> +
> +	ret = smux_populate_map(smux);
> +	if (ret < 0)
> +		goto free;
> +
> +	ret = pinmux_register_mappings(smux->maps.ma,
> +					smux->maps.max + 1);
> +	if (ret < 0)
> +		goto free;
> +
> +	dev_info(smux->dev, "pins: %i pingroups: %i functions: %i maps: %i\n",
> +				smux->pins.max + 1, smux->ngroups,
> +				smux->nfuncs, smux->maps.max + 1);
> +
> +	return 0;
> +
> +free:
> +	smux_free_resources(smux);
> +
> +	return ret;
> +}
> +
> +static struct of_device_id smux_of_match[];
> +static int __devinit smux_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	const u32 *val;
> +	struct resource res;
> +	struct smux_device *smux;
> +	int len, ret;
> +
> +	match = of_match_device(smux_of_match, &pdev->dev);
> +	if (!match)
> +		return -EINVAL;
> +
> +	smux = devm_kzalloc(&pdev->dev, sizeof(*smux), GFP_KERNEL);
> +	if (!smux) {
> +		dev_err(&pdev->dev, "could not allocate\n");
> +		return -ENOMEM;
> +	}
> +	smux->dev = &pdev->dev;
> +
> +	val = of_get_property(pdev->dev.of_node,
> +				"pinctrl-simple,register-width", &len);
> +	if (!val || len != 4) {
> +		dev_err(smux->dev, "mux register width not specified\n");
> +		ret = -EINVAL;
> +		goto free;
> +	}
> +	smux->width = be32_to_cpup(val);
> +
> +	val = of_get_property(pdev->dev.of_node,
> +				"pinctrl-simple,function-mask", &len);
> +	if (!val || len != 4) {
> +		dev_err(smux->dev, "function register mask not specified\n");
> +		ret = -EINVAL;
> +		goto free;
> +	}
> +	smux->fmask = be32_to_cpup(val);
> +	smux->fshift = ffs(smux->fmask) - 1;
> +	smux->fmax = smux->fmask >> smux->fshift;
> +
> +	val = of_get_property(pdev->dev.of_node,
> +				"pinctrl-simple,function-off", &len);
> +	if (!val || len != 4) {
> +		dev_err(smux->dev, "function off mode not specified\n");
> +		ret = -EINVAL;
> +		goto free;
> +	}
> +	smux->foff = be32_to_cpup(val);
> +
> +	val = of_get_property(pdev->dev.of_node,
> +				"pinctrl-simple,pinconf-mask", &len);
> +	if (!val || len != 4) {
> +		dev_err(smux->dev, "pinconf mask not specified\n");
> +		ret = -EINVAL;
> +		goto free;
> +	}
> +	smux->cmask = be32_to_cpup(val);
> +
> +	val = of_get_property(pdev->dev.of_node, "#pinmux-cells", &len);
> +	if (!val || len != 4) {
> +		dev_err(smux->dev, "#pinmux-cells not specified\n");
> +		ret = -EINVAL;
> +		goto free;
> +	}
> +	smux->cells = be32_to_cpup(val);
> +
> +	ret = of_address_to_resource(pdev->dev.of_node, 0, &res);
> +	if (ret) {
> +		dev_err(smux->dev, "could not get resource\n");
> +		goto free;
> +	}
> +
> +	smux->res = devm_request_mem_region(smux->dev, res.start,
> +			resource_size(&res), DRIVER_NAME);
> +	if (!smux->res) {
> +		dev_err(smux->dev, "could not get mem_region\n");
> +		ret = -EBUSY;
> +		goto free;
> +	}
> +
> +	smux->size = resource_size(smux->res);
> +	smux->base = devm_ioremap(smux->dev, smux->res->start, smux->size);
> +	if (!smux->base) {
> +		dev_err(smux->dev, "could not ioremap\n");
> +		ret = -ENODEV;
> +		goto release;
> +	}
> +
> +	INIT_RADIX_TREE(&smux->pgtree, GFP_KERNEL);
> +	INIT_RADIX_TREE(&smux->ftree, GFP_KERNEL);
> +	platform_set_drvdata(pdev, smux);
> +
> +	switch (smux->width) {
> +	case 8:
> +		smux->read = smux_readb;
> +		smux->write = smux_writeb;
> +		break;
> +	case 16:
> +		smux->read = smux_readw;
> +		smux->write = smux_writew;
> +		break;
> +	case 32:
> +		smux->read = smux_readl;
> +		smux->write = smux_writel;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	ret = smux_register(smux);
> +	if (ret < 0) {
> +		dev_err(smux->dev, "could not add mux registers: %i\n", ret);
> +		goto iounmap;
> +	}
> +
> +	return 0;
> +
> +iounmap:
> +	devm_iounmap(smux->dev, smux->base);
> +release:
> +	devm_release_mem_region(smux->dev,
> +			smux->res->start, resource_size(smux->res));
> +free:
> +	devm_kfree(smux->dev, smux);
> +
> +	return ret;
> +}
> +
> +static int __devexit smux_remove(struct platform_device *pdev)
> +{
> +	struct smux_device *smux = platform_get_drvdata(pdev);
> +
> +	if (!smux)
> +		return 0;
> +
> +	smux_free_resources(smux);
> +	devm_iounmap(smux->dev, smux->base);
> +	devm_release_mem_region(smux->dev,
> +			smux->res->start, resource_size(smux->res));
> +	platform_set_drvdata(pdev, NULL);
> +	devm_kfree(smux->dev, smux);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id smux_of_match[] __devinitdata = {
> +	{ .compatible = DRIVER_NAME, },
> +	{ .compatible = "ti,omap2420-pinmux", },
> +	{ .compatible = "ti,omap2430-pinmux", },
> +	{ .compatible = "ti,omap3-pinmux", },
> +	{ .compatible = "ti,omap4-pinmux", },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, smux_of_match);
> +
> +static struct platform_driver smux_driver = {
> +	.probe		= smux_probe,
> +	.remove		= __devexit_p(smux_remove),
> +	.driver = {
> +		.owner		= THIS_MODULE,
> +		.name		= DRIVER_NAME,
> +		.of_match_table	= smux_of_match,
> +	},
> +};
> +
> +module_platform_driver(smux_driver);
> +
> +MODULE_AUTHOR("Tony Lindgren <tony@atomide.com>");
> +MODULE_DESCRIPTION("Simple device tree pinctrl driver");
> +MODULE_LICENSE("GPL");
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
