Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2DNNsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 09:48:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60698 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2DNNsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 09:48:23 -0400
Date: Sat, 14 Apr 2012 15:48:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120414134814.GA3852@pengutronix.de>
References: <1334333915-1174-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334333915-1174-1-git-send-email-b29396@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:40:02 up 153 days, 21:27, 15 users,  load average: 0.05, 0.03,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 12:18:33AM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The driver has mux and config support while the gpio is still
> not supported.
> For select input setting, the driver will handle it internally
> and do not need user to take care of it.
> 
> The pinctrl-imx core driver will parse the dts file and dynamically
> create the pinmux functions and groups.
> 
> Each IMX SoC pinctrl driver should register pins with a pin register map
> including mux register and config register and select input map to core
> for proper operations.
> 
> +
> +iomuxc@020e0000 {
> +	compatible = "fsl,imx6q-iomuxc";
> +	reg = <0x020e0000 0x4000>;
> +
> +	/* shared pinctrl settings */
> +	usdhc4 {
> +		pinctrl_usdhc4_1: usdhc4grp-1 {
> +			fsl,pins =	"MX6Q_PAD_SD4_CMD",
> +					"MX6Q_PAD_SD4_CLK",
> +					"MX6Q_PAD_SD4_DAT0",
> +					"MX6Q_PAD_SD4_DAT1",
> +					"MX6Q_PAD_SD4_DAT2",
> +					"MX6Q_PAD_SD4_DAT3",
> +					"MX6Q_PAD_SD4_DAT4",
> +					"MX6Q_PAD_SD4_DAT5",
> +					"MX6Q_PAD_SD4_DAT6",
> +					"MX6Q_PAD_SD4_DAT7";

Do we really want to have all combinations of all pins in the devicetree
as strings? This is going to be huge.

> +			fsl,mux = <0 0 1 1 1 1 1 1 1 1>;

Still we lose the precious information which pin can be put into which
mode which means that you have to look at the datasheet each time a pin
is missing.

> +
> +static int imx_dt_node_to_map(struct pinctrl_dev *pctldev,
> +			struct device_node *np,
> +			struct pinctrl_map **map, unsigned *num_maps)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +	const struct imx_config_properties *imx_config;
> +	struct pinctrl_map *new_map;
> +	struct device_node *parent;
> +	u32 val, config, map_num;
> +	void *new_config;
> +	int i, ret;
> +
> +	/* first check if there's a config map */
> +	config = 0;
> +	for (i = 0; i < info->nconf_properties; i++) {
> +		imx_config = &info->conf_properties[i];
> +		ret = of_property_read_u32(np, imx_config->property, &val);
> +		if (!ret) {
> +			dev_dbg(info->dev, "config property %s: 0x%x\n",
> +				imx_config->property, val);
> +			if (val > imx_config->mask)
> +				dev_warn(info->dev, "The config(%s) value 0x%x exceeds the range",
> +					imx_config->property, val);
> +			config |= val << imx_config->off;
> +		}
> +	}
> +
> +	map_num = config ? 2 : 1;
> +	new_map = kmalloc(sizeof(struct pinctrl_map) * map_num, GFP_KERNEL);
> +	if (!new_map)
> +		return -ENOMEM;
> +
> +	/* generate mux map */
> +	parent = of_get_parent(np);
> +	if (!parent)
> +		return -EINVAL;
> +
> +	new_map[0].type = PIN_MAP_TYPE_MUX_GROUP;
> +	new_map[0].data.mux.function = parent->name;
> +	new_map[0].data.mux.group = np->name;
> +
> +	if (config) {
> +		new_config = kmemdup(&config, sizeof(config), GFP_KERNEL);

Check result?

> +		/* generate config map */
> +		new_map[1].type = PIN_MAP_TYPE_CONFIGS_GROUP;
> +		new_map[1].data.configs.group_or_pin = np->name;
> +		new_map[1].data.configs.configs = (unsigned long *)new_config;

No need to cast void pointers.

> +		new_map[1].data.configs.num_configs = 1;
> +	}
> +
> +	*map = new_map;
> +	*num_maps = map_num;
> +
> +	dev_dbg(pctldev->dev, "map: num %d function %s group %s config 0x%x\n",
> +		map_num, new_map->data.mux.function,
> +		new_map->data.mux.group, config);
> +
> +	return 0;
> +}
> +
> +static void imx_dt_free_map(struct pinctrl_dev *pctldev,
> +				struct pinctrl_map *map, unsigned num_maps)
> +{
> +	int i;
> +
> +	for (i = 0; i < num_maps; i++)
> +		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
> +			kfree(map[i].data.configs.configs);
> +
> +	kfree(map);
> +}
> +
> +static struct pinctrl_ops imx_pctrl_ops = {
> +	.get_groups_count = imx_get_groups_count,
> +	.get_group_name = imx_get_group_name,
> +	.get_group_pins = imx_get_group_pins,
> +	.pin_dbg_show = imx_pin_dbg_show,
> +	.dt_node_to_map = imx_dt_node_to_map,
> +	.dt_free_map = imx_dt_free_map,
> +
> +};
> +
> +static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
> +			   unsigned group)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +	const struct imx_pin_reg *pin_reg;
> +	const unsigned *pins, *mux;
> +	unsigned int num_pins, pin_id;
> +	int i;
> +
> +	/*
> +	 * Configure the mux mode for each pin in the group for a specific
> +	 * function.
> +	 */
> +	pins = info->groups[group].pins;
> +	num_pins = info->groups[group].num_pins;
> +	mux = info->groups[group].mux_mode;
> +
> +	WARN_ON(!pins || !num_pins || !mux);
> +
> +	dev_dbg(ipmx->dev, "enable function %s group %s\n",
> +		info->functions[selector].name, info->groups[group].name);
> +
> +	for (i = 0; i < num_pins; i++) {
> +		pin_id = pins[i];
> +
> +		pin_reg = imx_find_pin_reg(info, pin_id, 1, mux[i]);
> +		if (!pin_reg)
> +			return -EINVAL;
> +
> +		if (!pin_reg->mux_reg) {
> +			dev_err(ipmx->dev, "Pin(%s) does not support mux function\n",
> +				info->pins[pin_id].name);
> +			return -EINVAL;
> +		}
> +
> +		writel(mux[i], ipmx->base + pin_reg->mux_reg);
> +		dev_dbg(ipmx->dev, "write: offset 0x%x val 0x%x\n",
> +			pin_reg->mux_reg, mux[i]);
> +
> +		/* some pins also need select input setting, set it if found */
> +		if (pin_reg->input_reg) {
> +			writel(pin_reg->input_val, ipmx->base + pin_reg->input_reg);
> +			dev_dbg(ipmx->dev,
> +				"==>select_input: offset 0x%x val 0x%x\n",
> +				pin_reg->input_reg, pin_reg->input_val);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void imx_pmx_disable(struct pinctrl_dev *pctldev, unsigned func_selector,
> +			    unsigned group_selector)
> +{
> +	/* nothing to do here */
> +}
> +
> +static int imx_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +
> +	return info->nfunctions;
> +}
> +
> +static const char *imx_pmx_get_func_name(struct pinctrl_dev *pctldev,
> +					  unsigned selector)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +
> +	return info->functions[selector].name;
> +}
> +
> +static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned selector,
> +			       const char * const **groups,
> +			       unsigned * const num_groups)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +
> +	*groups = info->functions[selector].groups;
> +	*num_groups = info->functions[selector].num_groups;
> +
> +	return 0;
> +}
> +
> +static struct pinmux_ops imx_pmx_ops = {
> +	.get_functions_count = imx_pmx_get_funcs_count,
> +	.get_function_name = imx_pmx_get_func_name,
> +	.get_function_groups = imx_pmx_get_groups,
> +	.enable = imx_pmx_enable,
> +	.disable = imx_pmx_disable,
> +};
> +
> +static int imx_pinconf_get(struct pinctrl_dev *pctldev,
> +			     unsigned pin_id, unsigned long *config)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +	const struct imx_pin_reg *pin_reg;
> +
> +	pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
> +	if (!pin_reg)
> +		return -EINVAL;
> +
> +	if (!pin_reg->conf_reg) {
> +		dev_err(info->dev, "Pin(%s) does not support config function\n",
> +			info->pins[pin_id].name);
> +		return -EINVAL;
> +	}
> +
> +	*config = readl(ipmx->base + pin_reg->conf_reg);
> +
> +	return 0;
> +}
> +
> +static int imx_pinconf_set(struct pinctrl_dev *pctldev,
> +			     unsigned pin_id, unsigned long config)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +	const struct imx_pin_reg *pin_reg;
> +
> +	pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
> +	if (!pin_reg)
> +		return -EINVAL;
> +
> +	if (!pin_reg->conf_reg) {
> +		dev_err(info->dev, "Pin(%s) does not support config function\n",
> +			info->pins[pin_id].name);
> +		return -EINVAL;
> +	}
> +
> +	writel(config, ipmx->base + pin_reg->conf_reg);
> +
> +	return 0;
> +}
> +
> +static int imx_pinconf_group_get(struct pinctrl_dev *pctldev,
> +				   unsigned group, unsigned long *config)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +
> +	*config = info->groups[group].config;
> +	dev_dbg(ipmx->dev, "get group %s config 0x%lx\n",
> +		info->groups[group].name, *config);
> +
> +	return 0;
> +}
> +
> +static int imx_pinconf_group_set(struct pinctrl_dev *pctldev,
> +				   unsigned group, unsigned long config)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +	const struct imx_pin_reg *pin_reg;
> +	const unsigned *pins;
> +	unsigned int num_pins, pin_id;
> +	int i;
> +
> +	pins = info->groups[group].pins;
> +	num_pins = info->groups[group].num_pins;
> +
> +	WARN_ON(!pins || !num_pins);
> +
> +	dev_dbg(ipmx->dev, "set group %s config 0x%lx\n",
> +		info->groups[group].name, config);
> +
> +	for (i = 0; i < num_pins; i++) {
> +		pin_id = pins[i];
> +
> +		pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
> +		if (!pin_reg)
> +			return -EINVAL;
> +
> +		if (!pin_reg->conf_reg) {
> +			dev_err(ipmx->dev, "Pin(%s) does not support config function\n",
> +				info->pins[pin_id].name);
> +			return -EINVAL;
> +		}
> +
> +		writel(config, ipmx->base + pin_reg->conf_reg);
> +		dev_dbg(ipmx->dev, "write: offset 0x%x val 0x%lx\n",
> +			pin_reg->conf_reg, config);
> +	}
> +
> +	/* save the current group config value */
> +	info->groups[group].config = config;
> +
> +	return 0;
> +}
> +
> +static void imx_pinconf_dbg_show(struct pinctrl_dev *pctldev,
> +				   struct seq_file *s, unsigned pin_id)
> +{
> +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> +	struct imx_pinctrl_info *info = ipmx->info;
> +	const struct imx_pin_reg *pin_reg;
> +	unsigned long config;
> +
> +	pin_reg = imx_find_pin_reg(info, pin_id, 0, 0);
> +	if (!pin_reg) {
> +		seq_printf(s, "N/A");
> +		return;
> +	}
> +
> +	config = readl(ipmx->base + pin_reg->conf_reg);
> +	seq_printf(s, "0x%lx", config);
> +}
> +
> +static void imx_pinconf_group_dbg_show(struct pinctrl_dev *pctldev,
> +					 struct seq_file *s, unsigned group)
> +{
> +	unsigned long config;
> +	int ret;
> +
> +	ret = imx_pinconf_group_get(pctldev, group, &config);
> +	if (!ret)
> +		seq_printf(s, "0x%lx", config);
> +}
> +
> +struct pinconf_ops imx_pinconf_ops = {
> +	.pin_config_get = imx_pinconf_get,
> +	.pin_config_set = imx_pinconf_set,
> +	.pin_config_group_get = imx_pinconf_group_get,
> +	.pin_config_group_set = imx_pinconf_group_set,
> +	.pin_config_dbg_show = imx_pinconf_dbg_show,
> +	.pin_config_group_dbg_show = imx_pinconf_group_dbg_show,
> +};
> +
> +static struct pinctrl_desc imx_pmx_desc = {
> +	.name = DRIVER_NAME,
> +	.pctlops = &imx_pctrl_ops,
> +	.pmxops = &imx_pmx_ops,
> +	.confops = &imx_pinconf_ops,
> +	.owner = THIS_MODULE,
> +};
> +
> +#ifdef CONFIG_OF
> +static unsigned int imx_pmx_pin_name_to_id(struct imx_pinctrl_info *info,
> +					const char *s)
> +{
> +	unsigned int i;
> +	const struct pinctrl_pin_desc *desc;
> +
> +	BUG_ON(!info || !info->pins || !info->npins);
> +
> +	for (i = 0; i < info->npins; i++) {
> +		desc = info->pins + i;
> +		if (desc->name && !strcmp(s, desc->name))
> +			return desc->number;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int __devinit imx_pmx_parse_groups(struct device_node *np,
> +				struct imx_pin_group *grp,
> +				struct imx_pinctrl_info *info, u32 index)
> +{
> +	struct property *prop;
> +	const char *s;
> +	int ret, len;
> +	u32 i = 0;
> +
> +	dev_dbg(info->dev, "group(%d): %s\n", index, np->name);
> +
> +	/* Initialise group */
> +	grp->name = np->name;
> +	grp->num_pins = of_property_count_strings(np, "fsl,pins");
> +	if (grp->num_pins < 0) {
> +		dev_err(info->dev, "failed to get fsl,pins\n");
> +		return grp->num_pins;
> +	}
> +
> +	grp->pins = devm_kzalloc(info->dev, grp->num_pins * sizeof(unsigned int),
> +				GFP_KERNEL);
> +	grp->mux_mode = devm_kzalloc(info->dev, grp->num_pins * sizeof(unsigned int),
> +				GFP_KERNEL);
> +
> +	of_property_for_each_string(np, "fsl,pins", prop, s) {
> +		ret = imx_pmx_pin_name_to_id(info, s);
> +		if (ret < 0) {
> +			dev_err(info->dev, "failed to get pin: %s\n", s);
> +			return ret;
> +		}
> +		grp->pins[i++] = ret;
> +	}
> +
> +	if (i != grp->num_pins) {
> +		dev_err(info->dev, "parsed wrong pins number?\n");
> +		return -EINVAL;
> +	}
> +
> +	/* group sanity check */
> +	if (of_get_property(np, "fsl,mux", &len) &&
> +		len != grp->num_pins * sizeof(unsigned int)) {
> +		dev_err(info->dev, "fsl,mux length is not equal to fsl,pins\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = of_property_read_u32_array(np, "fsl,mux",
> +			grp->mux_mode, grp->num_pins);
> +	if (ret) {
> +		dev_err(info->dev, "failed to get fsl,mux\n");
> +		return ret;
> +	}
> +
> +#ifdef DEBUG
> +	IMX_PMX_DUMP("pins", grp->pins, grp->num_pins);
> +	IMX_PMX_DUMP("mux", grp->mux_mode, grp->num_pins);
> +#endif
> +	return 0;
> +}
> +
> +static int __devinit imx_pmx_parse_functions(struct device_node *np,
> +			struct imx_pinctrl_info *info, u32 index)
> +{
> +	struct device_node *child;
> +	struct imx_pmx_func *func;
> +	struct imx_pin_group *grp;
> +	int ret;
> +	static u32 grp_index;
> +	u32 i = 0;
> +
> +	dev_dbg(info->dev, "parse function(%d): %s\n", index, np->name);
> +
> +	func = &info->functions[index];
> +
> +	/* Initialise function */
> +	func->name = np->name;
> +	func->num_groups = of_get_child_count(np);
> +	if (func->num_groups <= 0) {
> +		dev_err(info->dev, "no groups defined\n");
> +		return -EINVAL;
> +	}
> +	func->groups = devm_kzalloc(info->dev,
> +			func->num_groups * sizeof(char *), GFP_KERNEL);
> +
> +	for_each_child_of_node(np, child) {
> +		func->groups[i] = child->name;
> +		grp = &info->groups[grp_index++];
> +		ret = imx_pmx_parse_groups(child, grp, info, i++);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (i != func->num_groups) {
> +		dev_err(info->dev, "parsed wrong groups number?\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
> +				struct imx_pinctrl_info *info)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct device_node *child;
> +	int ret;
> +	u32 nfuncs = 0;
> +	u32 i = 0;
> +
> +	if (!np)
> +		return -ENODEV;
> +
> +	nfuncs = of_get_child_count(np);
> +	if (nfuncs <= 0) {
> +		dev_err(&pdev->dev, "no functions defined\n");
> +		return -EINVAL;
> +	}
> +
> +	info->nfunctions = nfuncs;
> +	info->functions = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct imx_pmx_func),
> +					GFP_KERNEL);
> +	if (!info->functions)
> +		return -ENOMEM;
> +
> +	info->ngroups = 0;
> +	for_each_child_of_node(np, child)
> +		info->ngroups += of_get_child_count(child);
> +	info->groups = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct imx_pin_group),
> +					GFP_KERNEL);
> +	if (!info->groups)
> +		return -ENOMEM;
> +
> +	for_each_child_of_node(np, child) {
> +		ret = imx_pmx_parse_functions(child, info, i++);
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to parse function\n");
> +			return ret;
> +		}
> +	}
> +
> +	if (i != info->nfunctions) {
> +		dev_err(info->dev, "parsed wrong functions number?\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +#else
> +static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
> +				struct imx_pinctrl_info *info)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
> +static inline void imx_pmx_desc_init(struct pinctrl_desc *pmx_desc,
> +				const struct imx_pinctrl_info *info)
> +{
> +	pmx_desc->pins = info->pins;
> +	pmx_desc->npins = info->npins;
> +}
> +
> +static const struct of_device_id imx_pmx_dt_ids[] = {
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, imx_pmx_dt_ids);
> +
> +static int __init imx_pmx_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *of_id =
> +			of_match_device(imx_pmx_dt_ids, &pdev->dev);
> +	struct device *dev = &pdev->dev;
> +	struct imx_pmx *ipmx;
> +	struct resource *res;
> +	struct imx_pinctrl_info *info;
> +	resource_size_t res_size;
> +	int ret;
> +
> +	info = of_id->data;
> +	if (!info || !info->pins || !info->npins
> +		  || !info->pin_regs || !info->npin_regs
> +		  || !info->conf_properties || !info->nconf_properties) {
> +		dev_err(&pdev->dev, "wrong pinctrl info\n");
> +		return -EINVAL;
> +	}
> +	info->dev = &pdev->dev;
> +
> +	/* Create state holders etc for this driver */
> +	ipmx = devm_kzalloc(&pdev->dev, sizeof(*ipmx), GFP_KERNEL);
> +	if (!ipmx)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENOENT;
> +
> +	res_size = resource_size(res);
> +	if (!devm_request_mem_region(dev, res->start, res_size, res->name))
> +		return -EBUSY;
> +
> +	ipmx->base = devm_ioremap_nocache(dev, res->start, res_size);
> +	if (!ipmx->base)
> +		return -EBUSY;
> +
> +	imx_pmx_desc_init(&imx_pmx_desc, info);
> +	ret = imx_pmx_probe_dt(pdev, info);
> +	if (ret) {
> +		dev_err(&pdev->dev, "fail to probe dt properties\n");
> +		return ret;
> +	}

So this driver only works with dt? Why can it be compiled without it
then?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
