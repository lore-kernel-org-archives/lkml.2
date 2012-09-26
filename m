Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2IZQ6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:58:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59070 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757402Ab2IZQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:57:58 -0400
Message-ID: <1348678677.15175.18.camel@joe-AO722>
Subject: Re: [PATCH] drivers: phy: add generic PHY framework
From: Joe Perches <joe@perches.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: akpm@linux-foundation.org, davem@davemloft.net, santosh.shilimkar@ti.com,
        grant.likely@secretlab.ca, balbi@ti.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        robherring2@gmail.com, richard.zhao@freescale.com,
        B29397@freescale.com, alexander.shishkin@linux.intel.com,
        mkl@pengutronix.de, marex@denx.de, p.paneri@samsung.com,
        devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com
Date: Wed, 26 Sep 2012 09:57:57 -0700
In-Reply-To: <1348671675-20830-1-git-send-email-kishon@ti.com>
References: <1348671675-20830-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 20:31 +0530, Kishon Vijay Abraham I wrote:
> The PHY framework provides a set of API's for the PHY drivers to
> create/destroy a PHY and API's 

Just some trivial notes.

> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
[]
> @@ -0,0 +1,445 @@
[]
> +static void devm_phy_release(struct device *dev, void *res)
> +{
> +	struct phy *phy = *(struct phy **)res;

That's a bit twisted isn't it?
Perhaps
	struct phy *phy = res;

[]

> +static int devm_phy_match(struct device *dev, void *res, void *match_data)
> +{
> +	return res == match_data;

static bool devm_phy_match(etc...)

[]

> +struct phy *devm_of_phy_get(struct device *dev, const char *phandle, u8 index)
> +{
> +	struct phy *phy = NULL, **ptr;
> +	struct device_node *node;
> +
> +	if (!dev->of_node) {
> +		dev_dbg(dev, "device does not have a device node entry\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	node = of_parse_phandle(dev->of_node, phandle, index);
> +	if (!node) {
> +		dev_dbg(dev, "failed to get %s phandle in %s node\n", phandle,
> +			dev->of_node->full_name);
> +		return ERR_PTR(-ENODEV);
> +	}
> +
> +	ptr = devres_alloc(devm_phy_release, sizeof(*ptr), GFP_KERNEL);

Is this the right size?

Because ptr is **, perhaps sizeof(struct phy) is clearer.

> +	if (!ptr) {
> +		dev_dbg(dev, "failed to allocate memory for devres\n");

alloc failures generally don't need specific OOM messages
as the general alloc OOM dumps stack.

> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	mutex_lock(&phy_list_mutex);
> +
> +	phy = of_phy_lookup(dev, node);
> +	if (IS_ERR(phy) || !phy->dev.class ||
> +			!try_module_get(phy->dev.class->owner)) {

I think it's tasteful coding style to align like:

	if (IS_ERR(phy) || !phy->dev.class ||
	    !try_module_get(phy->dev.class->owner)) {
[]

> +struct phy *phy_create(struct device *dev, struct phy_descriptor *desc)
> +{
> +	int ret;
> +	struct phy *phy;
> +	struct phy_bind *phy_bind;
> +	const char *devname = NULL;
> +
> +	if (!dev || !desc) {
> +		dev_err(dev, "no descriptor/device provided for PHY\n");
> +		ret = -EINVAL;
> +		goto err0;
> +	}
> +
> +	if (!desc->ops) {
> +		dev_err(dev, "no PHY ops provided\n");
> +		ret = -EINVAL;
> +		goto err0;
> +	}
> +
> +	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		dev_err(dev, "no memory for PHY\n");

No OOM message required...

[]

> +static int __init phy_core_init(void)
> +{
> +	phy_class = class_create(THIS_MODULE, "phy");
> +	if (IS_ERR(phy_class)) {
> +		pr_err("failed to create phy class --> %ld\n",
> +			PTR_ERR(phy_class));

You might add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any include so that pr_<levels> are prefixed.

cheers, Joe

