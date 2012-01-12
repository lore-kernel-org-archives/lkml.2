Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2ALJt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:49:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57342 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2ALJt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:49:56 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
References: <1326353738-26864-1-git-send-email-thomas.abraham@linaro.org>
	<1326353738-26864-3-git-send-email-thomas.abraham@linaro.org>
Date: Thu, 12 Jan 2012 18:49:56 +0900
X-Google-Sender-Auth: kQuLFdemhaD15UYojaDL5khtvaM
Message-ID: <CAJ0PZbSVKiyuZAxJ7-c6T2eM4Lmyj4KDDmx5JBSbwDRxME68Tw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] regulator: add device tree support for max8997
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 4:35 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
> Add device tree based discovery support for max8997.
>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  .../devicetree/bindings/regulator/max8997-pmic.txt |  120 ++++++++++++++++
>  drivers/mfd/max8997.c                              |   72 ++++++++++-
>  drivers/regulator/max8997.c                        |  143 +++++++++++++++++++-
>  include/linux/mfd/max8997.h                        |    1 +
>  4 files changed, 334 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/max8997-pmic.txt
>
> diff --git a/Documentation/devicetree/bindings/regulator/max8997-pmic.txt b/Documentation/devicetree/bindings/regulator/max8997-pmic.txt
> new file mode 100644
> index 0000000..0c4559d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/max8997-pmic.txt
> @@ -0,0 +1,120 @@
> +* Maxim MAX8997 Voltage and Current Regulator
> +
> +The Maxim MAX8997 is a multi-function device which includes volatage and
> +current regulators, rtc, charger controller and other sub-blocks. It is
> +interfaced to the host controller using a i2c interface. Each sub-block is
> +addressed by the host system using different i2c slave address. This document
> +describes the bindings for 'pmic' sub-block of max8997.
> +
> +Required properties:
> +- compatible: Should be "maxim,max8997-pmic".
> +- reg: Specifies the i2c slave address of the pmic block. It should be 0x66.
> +
> +Optional properties:
> +- interrupt-parent: Specifies the phandle of the interrupt controller to which
> +  the interrupts from max8997 are delivered to.
> +- interrupts: Interrupt specifiers for two interrupt sources.
> +  - First interrupt specifier is for 'irq1' interrupt.
> +  - Second interrupt specifier is for 'alert' interrupt.
> +- max8997,pmic-buck1-uses-gpio-dvs: 'buck1' can be controlled by gpio dvs.
> +- max8997,pmic-buck2-uses-gpio-dvs: 'buck2' can be controlled by gpio dvs.
> +- max8997,pmic-buck5-uses-gpio-dvs: 'buck5' can be controlled by gpio dvs.
> +
> +Additional properties required if either of the optional properties are used:
> +- max8997,pmic-ignore-gpiodvs-side-effect: When GPIO-DVS mode is used for
> +  multiple bucks, changing the voltage value of one of the bucks may affect
> +  that of another buck, which is the side effect of the change (set_voltage).
> +  Use this property to ignore such side effects and change the voltage.
> +
> +- max8997,pmic-buck125-default-dvs-idx: Default voltage setting selected from
> +  the possible 8 options selectable by the dvs gpios. The value of this
> +  property should be between 0 and 7. If not specified or if out of range, the
> +  default value of this property is set to 0.
> +
> +- max8997,pmic-buck125-dvs-gpios: GPIO specifiers for three host gpio's used
> +  for dvs. The format of the gpio specifier depends in the gpio controller.
> +
> +- max8997,pmic-buck1-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
> +  units for buck1 when changing voltage using gpio dvs.
> +
> +- max8997,pmic-buck2-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
> +  units for buck2 when changing voltage using gpio dvs.
> +
> +- max8997,pmic-buck5-dvs-voltage: A set of 8 voltage values in micro-volt (uV)
> +  units for buck5 when changing voltage using gpio dvs.
> +

These three values are _not_ optional.

If they are omitted and at least one of buck1/2/5 is supplying
critical power to the system, which they do in Exynos boards, system
will not boot properly.

In order to work properly, at least the first element of each array
should have a proper value (preferrably the maximum safety voltage if
this gpio-dvs feature is not used) if others are filled with zeros.

If GPIO-DVS mode is enabled, all the 8 elements of each array should
be filled with proper values.


[]
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index d26e864..053d0b7 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
[]
> @@ -32,6 +33,7 @@
>  struct max8997_data {
>        struct device *dev;
> @@ -958,6 +960,138 @@ static struct regulator_desc regulators[] = {
>        },
>  };
>
> +#if CONFIG_OF

#ifdef?

[]
> +static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
> +                                       struct max8997_platform_data *pdata)
> +{
[]
> +       if (pdata->buck1_gpiodvs) {
> +               if (of_property_read_u32_array(pmic_np,
> +                               "max8997,pmic-buck1-dvs-voltage",
> +                               pdata->buck1_voltage, 8)) {
> +                       dev_err(iodev->dev, "buck1 voltages not specified\n");
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       if (pdata->buck2_gpiodvs) {
> +               if (of_property_read_u32_array(pmic_np,
> +                               "max8997,pmic-buck2-dvs-voltage",
> +                               pdata->buck2_voltage, 8)) {
> +                       dev_err(iodev->dev, "buck2 voltages not specified\n");
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       if (pdata->buck5_gpiodvs) {
> +               if (of_property_read_u32_array(pmic_np,
> +                               "max8997,pmic-buck5-dvs-voltage",
> +                               pdata->buck5_voltage, 8)) {
> +                       dev_err(iodev->dev, "buck5 voltages not specified\n");
> +                       return -EINVAL;
> +               }
> +       }

As mentioned above, these array should be loaded to probe function
even if buck?_gpiodvs is false.

[]



Cheers!
MyungJoo


-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
