Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab1JUImI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 04:42:08 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:35972 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753818Ab1JUImG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 04:42:06 -0400
Message-ID: <4EA13053.7080306@ti.com>
Date: Fri, 21 Oct 2011 14:11:55 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract regulator_init_data
References: <1318263578-7407-1-git-send-email-rnayak@ti.com> <1318263578-7407-4-git-send-email-rnayak@ti.com> <20111018132032.GD30703@S2100-06.ap.freescale.net> <4E9EB61C.1040207@ti.com> <20111019144215.GA32007@S2100-06.ap.freescale.net> <4E9FAF42.5060200@ti.com> <20111020061408.GE32007@S2100-06.ap.freescale.net> <4EA00F7C.1080005@ti.com> <20111021082309.GA337@S2100-06.ap.freescale.net>
In-Reply-To: <20111021082309.GA337@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Do you have any RFC patch/code which could explain better what you are
>> suggesting we do here?
>>>
> Here is what I changed based on your patches.  It only changes
> drivers/regulator/core.c.
>
> ---8<-------
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 9a5ebbe..8fe132d 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1211,7 +1211,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>                  node = of_get_regulator(dev, id);
>                  if (node)
>                          list_for_each_entry(rdev,&regulator_list, list)
> -                               if (node == rdev->dev.parent->of_node)
> +                               if (node == rdev->dev.of_node)
>                                          goto found;
>          }
>          list_for_each_entry(map,&regulator_map_list, list) {
> @@ -2642,9 +2642,6 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>              regulator_desc->type != REGULATOR_CURRENT)
>                  return ERR_PTR(-EINVAL);
>
> -       if (!init_data)
> -               return ERR_PTR(-EINVAL);
> -
>          /* Only one of each should be implemented */
>          WARN_ON(regulator_desc->ops->get_voltage&&
>                  regulator_desc->ops->get_voltage_sel);
> @@ -2675,12 +2672,8 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>          INIT_LIST_HEAD(&rdev->list);
>          BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);
>
> -       /* preform any regulator specific init */
> -       if (init_data->regulator_init) {
> -               ret = init_data->regulator_init(rdev->reg_data);
> -               if (ret<  0)
> -                       goto clean;
> -       }
> +       /* find device_node and attach it */
> +       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);

so would this do a complete dt search for every regulator?
we would also need the driver names and dt names to match for this to
work, right?

The approach otherwise looks fine to me and should work for both cases
of one device per regulator and one device for all regulators.

>
>          /* register with sysfs */
>          rdev->dev.class =&regulator_class;
> @@ -2693,6 +2686,20 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>                  goto clean;
>          }
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
> +               if (ret<  0)
> +                       goto clean;
> +       }
> +
>          dev_set_drvdata(&rdev->dev, rdev);
>
>          /* set regulator constraints */
> @@ -2719,7 +2726,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>                          node = of_get_regulator(dev, supply);
>                          if (node)
>                                  list_for_each_entry(r,&regulator_list, list)
> -                                       if (node == r->dev.parent->of_node)
> +                                       if (node == r->dev.of_node)
>                                                  goto found;
>                  }
>
> ------->8---
>
> And my dts file looks like something below.
>
> 	ecspi@70010000 { /* ECSPI1 */
> 		fsl,spi-num-chipselects =<2>;
> 		cs-gpios =<&gpio3 24 0>, /* GPIO4_24 */
> 			<&gpio3 25 0>; /* GPIO4_25 */
> 		status = "okay";
>
> 		pmic: mc13892@0 {
> 			#address-cells =<1>;
> 			#size-cells =<0>;
> 			compatible = "fsl,mc13892";
> 			spi-max-frequency =<6000000>;
> 			reg =<0>;
> 			mc13xxx-irq-gpios =<&gpio0 8 0>; /* GPIO1_8 */
>
> 			regulators {
> 				sw1reg: mc13892_sw1 {
> 					regulator-min-uV =<600000>;
> 					regulator-max-uV =<1375000>;
> 					regulator-change-voltage;
> 					regulator-boot-on;
> 					regulator-always-on;
> 				};
>
> 				sw2reg: mc13892_sw2 {
> 					regulator-min-uV =<900000>;
> 					regulator-max-uV =<1850000>;
> 					regulator-change-voltage;
> 					regulator-boot-on;
> 					regulator-always-on;
> 				};
>
> 				......
> 			};
>
> 			leds {
> 				......
> 			};
>
> 			buttons {
> 				......
> 			};
> 		};
>
> 		flash: at45db321d@1 {
> 			......
> 		};
> 	};
> };
>

