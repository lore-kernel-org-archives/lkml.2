Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1JXJYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:24:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45460 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab1JXJYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:24:20 -0400
Date: Mon, 24 Oct 2011 11:24:11 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Rajendra Nayak <rnayak@ti.com>, broonie@opensource.wolfsonmicro.com,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024092411.GE8708@ponder.secretlab.ca>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111018132032.GD30703@S2100-06.ap.freescale.net>
 <4E9EB61C.1040207@ti.com>
 <20111019144215.GA32007@S2100-06.ap.freescale.net>
 <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021082309.GA337@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 04:23:12PM +0800, Shawn Guo wrote:
> On Thu, Oct 20, 2011 at 05:39:32PM +0530, Rajendra Nayak wrote:
> > On Thursday 20 October 2011 11:44 AM, Shawn Guo wrote:
> > >On Thu, Oct 20, 2011 at 10:48:58AM +0530, Rajendra Nayak wrote:
> > >>>Let's look at mc13892-regulator driver.  There are 23 regulators defined
> > >>>in array mc13892_regulators.  Needless to say, there is a dev behind
> > >>>mc13892-regulator driver.  And when getting probed, this driver will
> > >>>call regulator_register() to register those 23 regulators individually.
> > >>>That said, for non-dt world, we have 1 + 23 'dev' with that 1 as the
> > >>>parent of all other 23 'dev' (wrapped by regulator_dev).  But with the
> > >>>current DT implementation, we will have at least 1 + 23 * 2 'dev'.
> > >>>These extra 23 'dev' is totally new with DT.
> > >>>
> > >>
> > >>but thats only because the mc13892-regulator driver is implemeted in
> > >>such a way that all the regulators on the platform are bundled in as
> > >>*one* device.
> > >
> > >I did not look into too many regulator drivers, but I expect this is
> > >way that most regulator drivers are implemented in.  Having
> > >mc13892-regulator being probed 23 times to register these 23 regulators
> > >just makes less sense to me.
> > >
> > >>It would again depend on how you would pass these from
> > >>the DT, if you indeed stick to the same way of bundling all regulators
> > >>as one device from DT, the mc13892-regulator probe would just get called
> > >>once and there would be one device associated, no?
> > >>
> > >Yes, I indeed would stick to the same way of bundling the registration
> > >of all regulators with mc13892-regulator being probed once.  The problem
> > >I have with the current regulator core DT implementation is that it
> > >assumes the device_node of rdev->dev (dev wrapped in regulator_dev) is
> > >being attached to rdev->dev.parent rather than itself.  Back to
> > >mc13892-regulator example, that said, it requires the dev of
> > >mc13892-regulator have the device_node of individual regulator attached
> > >to.  IOW, the current implementation forces mc13892-regulator to be
> > >probed 23 times to register those 23 regulators.  This is wrong to me.
> > 
> > I think I now understand to some extent the problem that you seem to be
> > reporting. It is mainly with drivers which bundle all regulators and
> > pass them as one device and would want to do so with DT too.
> > 
> > however I am still not clear on how what you seem to suggest would
> > solve this problem. Note that not all drivers do it this way, and
> > there are drivers where each regulator is considered as one device
> > and I suspect they would remain that way with DT too. And hence we
> > need to support both.
> > 
> > Do you have any RFC patch/code which could explain better what you are
> > suggesting we do here?
> > >
> Here is what I changed based on your patches.  It only changes
> drivers/regulator/core.c.
> 
> ---8<-------
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 9a5ebbe..8fe132d 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1211,7 +1211,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>                 node = of_get_regulator(dev, id);
>                 if (node)
>                         list_for_each_entry(rdev, &regulator_list, list)
> -                               if (node == rdev->dev.parent->of_node)
> +                               if (node == rdev->dev.of_node)
>                                         goto found;
>         }
>         list_for_each_entry(map, &regulator_map_list, list) {
> @@ -2642,9 +2642,6 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>             regulator_desc->type != REGULATOR_CURRENT)
>                 return ERR_PTR(-EINVAL);
> 
> -       if (!init_data)
> -               return ERR_PTR(-EINVAL);
> -
>         /* Only one of each should be implemented */
>         WARN_ON(regulator_desc->ops->get_voltage &&
>                 regulator_desc->ops->get_voltage_sel);
> @@ -2675,12 +2672,8 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>         INIT_LIST_HEAD(&rdev->list);
>         BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);
> 
> -       /* preform any regulator specific init */
> -       if (init_data->regulator_init) {
> -               ret = init_data->regulator_init(rdev->reg_data);
> -               if (ret < 0)
> -                       goto clean;
> -       }
> +       /* find device_node and attach it */
> +       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);
> 
>         /* register with sysfs */
>         rdev->dev.class = &regulator_class;
> @@ -2693,6 +2686,20 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>                 goto clean;
>         }
> 
> +       if (!init_data) {
> +               /* try to get init_data from device tree */
> +               init_data = of_get_regulator_init_data(&rdev->dev);
> +               if (!init_data)
> +                       return ERR_PTR(-EINVAL);
> +       }
> +
> +       /* preform any regulator specific init */
> +       if (init_data->regulator_init) {
> +               ret = init_data->regulator_init(rdev->reg_data);
> +               if (ret < 0)
> +                       goto clean;
> +       }
> +
>         dev_set_drvdata(&rdev->dev, rdev);
> 
>         /* set regulator constraints */
> @@ -2719,7 +2726,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>                         node = of_get_regulator(dev, supply);
>                         if (node)
>                                 list_for_each_entry(r, &regulator_list, list)
> -                                       if (node == r->dev.parent->of_node)
> +                                       if (node == r->dev.of_node)
>                                                 goto found;
>                 }
> 
> ------->8---
> 
> And my dts file looks like something below.
> 
> 	ecspi@70010000 { /* ECSPI1 */
> 		fsl,spi-num-chipselects = <2>;
> 		cs-gpios = <&gpio3 24 0>, /* GPIO4_24 */
> 			   <&gpio3 25 0>; /* GPIO4_25 */
> 		status = "okay";
> 
> 		pmic: mc13892@0 {
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 			compatible = "fsl,mc13892";
> 			spi-max-frequency = <6000000>;
> 			reg = <0>;
> 			mc13xxx-irq-gpios = <&gpio0 8 0>; /* GPIO1_8 */
> 
> 			regulators {
> 				sw1reg: mc13892_sw1 {
> 					regulator-min-uV = <600000>;
> 					regulator-max-uV = <1375000>;
> 					regulator-change-voltage;
> 					regulator-boot-on;
> 					regulator-always-on;
> 				};
> 
> 				sw2reg: mc13892_sw2 {
> 					regulator-min-uV = <900000>;
> 					regulator-max-uV = <1850000>;
> 					regulator-change-voltage;
> 					regulator-boot-on;
> 					regulator-always-on;
> 				};
> 
> 				......
> 			};

To follow up from my earlier comment, this .dts structure looks fine
and reasonable to me, and it would also be fine for the mc13892 driver
to use for_each_child_of_node() to find all the children of the
regulators node.  Even finding the 'regulators' node by name from the
mc13892 driver is perfectly fine provided for_each_child_of_node is
used to find it.  All of this is okay because it is under the umbrella
of the "fsl,mc13892" binding.

What isn't okay is doing a whole tree search for nodes by name because
there is a high likelyhood of getting a conflict (and yes, I realized
that this example has the device name encoded into the node name, but
that doesn't change the fact that deep searches by name are bad
practice).

g.

