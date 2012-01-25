Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab2AYWIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:08:31 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18066 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2AYWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:08:30 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19CaAb2QLu76gZDDn6kd01Q
Date: Wed, 25 Jan 2012 14:08:24 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 3/4] pinctrl: Add checks for empty names in
 pinmux_search_function
Message-ID: <20120125220824.GW22818@atomide.com>
References: <20120120161610.21955.25082.stgit@kaulin.local>
 <20120120161730.21955.40332.stgit@kaulin.local>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAB384@HQMAIL01.nvidia.com>
 <20120120174157.GQ22818@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120174157.GQ22818@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [120120 09:09]:
> * Stephen Warren <swarren@nvidia.com> [120120 08:28]:
> > Tony Lindgren wrote at Friday, January 20, 2012 9:18 AM:
> > > Otherwise we can get the following when dealing with
> > > buggy data in a pinmux driver:
> > > 
> > > Unable to handle kernel NULL pointer dereference at virtual address 00000000
> > 
> > > diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> > > index 06b8943..ffe633d 100644
> > > --- a/drivers/pinctrl/pinmux.c
> > > +++ b/drivers/pinctrl/pinmux.c
> > > @@ -584,6 +584,13 @@ static int pinmux_search_function(struct pinctrl_dev *pctldev,
> > >  							   selector);
> > >  		int ret;
> > > 
> > > +		if (!fname) {
> > > +			pr_warning("no name for function%i\n",
> > > +				   selector);
> > > +			selector++;
> > > +			continue;
> > > +		}
> > > +
> > >  		if (!strcmp(map->function, fname)) {
> > >  			/* Found the function, check pin group */
> > >  			ret = pinmux_check_pin_group(pctldev, selector,
> > 
> > Shouldn't this be BUG_ON(!fname)?
> >
> > There are lots of other places that pmxops->get_function_name() is
> > called. Wouldn't it be better to enhance e.g. pinmux_check_ops() to
> > validate that all functions have a name during pinctrl registration?
> 
> Maybe yeah. I'll take a look next week when I'm back home.

There's a little bit of a init order issue here to add checking for
the function names during registration. That's because we don't allocate
pctldev until after pinmux_check_ops() in pinctrl_register. This means
we can't currently call ops->list_functions until unless we change the
init order.

To fix this we need to allocate pctldev earlier, and then change the
*_check_ops functions to use pctldev, see below.

Regards,

Tony


From: Tony Lindgren <tony@atomide.com>
Date: Tue, 24 Jan 2012 16:28:08 -0800
Subject: [PATCH] pinctrl: Add checks for empty function names

This is needed as otherwise we can get the following when dealing
with buggy data in a pinmux driver for pinmux_search_function:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
...
PC is at strcmp+0xc/0x34
LR is at pinmux_get+0x350/0x8f4
...

As we need pctldev initialized to call ops->list_functions, let's
initialize it before check_ops calls and pass the pctldev to the
check_ops functions. Do this for both pinmux and pinconf check_ops
functions.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -583,40 +583,40 @@ struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
 	if (pctldesc->name == NULL)
 		return NULL;
 
+	pctldev = kzalloc(sizeof(struct pinctrl_dev), GFP_KERNEL);
+	if (pctldev == NULL)
+		return NULL;
+
+	/* Initialize pin control device struct */
+	pctldev->owner = pctldesc->owner;
+	pctldev->desc = pctldesc;
+	pctldev->driver_data = driver_data;
+	INIT_RADIX_TREE(&pctldev->pin_desc_tree, GFP_KERNEL);
+	spin_lock_init(&pctldev->pin_desc_tree_lock);
+	INIT_LIST_HEAD(&pctldev->gpio_ranges);
+	mutex_init(&pctldev->gpio_ranges_lock);
+	pctldev->dev = dev;
+
 	/* If we're implementing pinmuxing, check the ops for sanity */
 	if (pctldesc->pmxops) {
-		ret = pinmux_check_ops(pctldesc->pmxops);
+		ret = pinmux_check_ops(pctldev);
 		if (ret) {
 			pr_err("%s pinmux ops lacks necessary functions\n",
 			       pctldesc->name);
-			return NULL;
+			goto out_err;
 		}
 	}
 
 	/* If we're implementing pinconfig, check the ops for sanity */
 	if (pctldesc->confops) {
-		ret = pinconf_check_ops(pctldesc->confops);
+		ret = pinconf_check_ops(pctldev);
 		if (ret) {
 			pr_err("%s pin config ops lacks necessary functions\n",
 			       pctldesc->name);
-			return NULL;
+			goto out_err;
 		}
 	}
 
-	pctldev = kzalloc(sizeof(struct pinctrl_dev), GFP_KERNEL);
-	if (pctldev == NULL)
-		return NULL;
-
-	/* Initialize pin control device struct */
-	pctldev->owner = pctldesc->owner;
-	pctldev->desc = pctldesc;
-	pctldev->driver_data = driver_data;
-	INIT_RADIX_TREE(&pctldev->pin_desc_tree, GFP_KERNEL);
-	spin_lock_init(&pctldev->pin_desc_tree_lock);
-	INIT_LIST_HEAD(&pctldev->gpio_ranges);
-	mutex_init(&pctldev->gpio_ranges_lock);
-	pctldev->dev = dev;
-
 	/* Register all the pins */
 	pr_debug("try to register %d pins on %s...\n",
 		 pctldesc->npins, pctldesc->name);
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -205,8 +205,10 @@ int pin_config_group_set(const char *dev_name, const char *pin_group,
 }
 EXPORT_SYMBOL(pin_config_group_set);
 
-int pinconf_check_ops(const struct pinconf_ops *ops)
+int pinconf_check_ops(struct pinctrl_dev *pctldev)
 {
+	const struct pinconf_ops *ops = pctldev->desc->confops;
+
 	/* We must be able to read out pin status */
 	if (!ops->pin_config_get && !ops->pin_config_group_get)
 		return -EINVAL;
--- a/drivers/pinctrl/pinconf.h
+++ b/drivers/pinctrl/pinconf.h
@@ -13,7 +13,7 @@
 
 #ifdef CONFIG_PINCONF
 
-int pinconf_check_ops(const struct pinconf_ops *ops);
+int pinconf_check_ops(struct pinctrl_dev *pctldev);
 void pinconf_init_device_debugfs(struct dentry *devroot,
 				 struct pinctrl_dev *pctldev);
 int pin_config_get_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
@@ -23,7 +23,7 @@ int pin_config_set_for_pin(struct pinctrl_dev *pctldev, unsigned pin,
 
 #else
 
-static inline int pinconf_check_ops(const struct pinconf_ops *ops)
+static inline int pinconf_check_ops(struct pinctrl_dev *pctldev)
 {
 	return 0;
 }
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -904,8 +904,11 @@ void pinmux_disable(struct pinmux *pmx)
 }
 EXPORT_SYMBOL_GPL(pinmux_disable);
 
-int pinmux_check_ops(const struct pinmux_ops *ops)
+int pinmux_check_ops(struct pinctrl_dev *pctldev)
 {
+	const struct pinmux_ops *ops = pctldev->desc->pmxops;
+	unsigned selector = 0;
+
 	/* Check that we implement required operations */
 	if (!ops->list_functions ||
 	    !ops->get_function_name ||
@@ -914,6 +917,18 @@ int pinmux_check_ops(const struct pinmux_ops *ops)
 	    !ops->disable)
 		return -EINVAL;
 
+	/* Check that all functions registered have names */
+	while (ops->list_functions(pctldev, selector) >= 0) {
+		const char *fname = ops->get_function_name(pctldev,
+							   selector);
+		if (!fname) {
+			pr_err("pinmux ops has no name for function%u\n",
+				selector);
+			return -EINVAL;
+		}
+		selector++;
+	}
+
 	return 0;
 }
 
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -12,7 +12,7 @@
  */
 #ifdef CONFIG_PINMUX
 
-int pinmux_check_ops(const struct pinmux_ops *ops);
+int pinmux_check_ops(struct pinctrl_dev *pctldev);
 void pinmux_init_device_debugfs(struct dentry *devroot,
 				struct pinctrl_dev *pctldev);
 void pinmux_init_debugfs(struct dentry *subsys_root);
@@ -21,7 +21,7 @@ void pinmux_unhog_maps(struct pinctrl_dev *pctldev);
 
 #else
 
-static inline int pinmux_check_ops(const struct pinmux_ops *ops)
+static inline int pinmux_check_ops(struct pinctrl_dev *pctldev)
 {
 	return 0;
 }
