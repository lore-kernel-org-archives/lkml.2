Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2DQSgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:36:03 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41023 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab2DQSgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:36:00 -0400
MIME-Version: 1.0
In-Reply-To: <4F734460.4060605@samsung.com>
References: <1332582590-16382-1-git-send-email-thomas.abraham@linaro.org>
	<1332582590-16382-3-git-send-email-thomas.abraham@linaro.org>
	<4F734460.4060605@samsung.com>
Date: Wed, 18 Apr 2012 00:05:59 +0530
Message-ID: <CAJuYYwRsHynt6pBHUgk72Z-UjHj3DM=s4pV4dzbb2hTAZOUSAw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] regulator: add device tree support for max8997
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        Rajendra Nayak <rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2012 22:33, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> On 24.03.2012 10:49, Thomas Abraham wrote:
>
> Hi Thomas!
>
>> Add device tree based discovery support for max8997.
> ...
>> +Regulators: The regulators of max8997 that have to be instantiated should be
>> +included in a sub-node named 'regulators'. Regulator nodes included in this
>> +sub-node should be of the format as below. Note: The 'n' in LDOn and BUCKn
>> +represents the LDO or BUCK number as per the datasheet of max8997.
>> +
>> +    For LDO's:
>> +             LDOn {
>> +                     standard regulator bindings here
>> +             };
>> +
>> +    For BUCK's:
>> +             BUCKn {
>> +                     standard regulator bindings here
>> +             };
>> +
>
>
> Small note - driver supports[1] configuring following regulators by
> using respective DT node names:
>
>  - EN32KHz_AP
>  - EN32KHz_CP
>  - ENVICHG
>  - ESAFEOUT1
>  - ESAFEOUT2
>  - CHARGER
>  - CHARGER_CV
>  - CHARGER_TOPOFF
>
> I wonder if these should be mentioned in documentation too.
>
> [1] These are used in e.g. mach-nuri.c

Yes, I missed the above regulators in the documentation. I have
included them now and will resubmit this patch.

>
>> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c> index 9657929..dce8aaf 100644
>
>> --- a/drivers/regulator/max8997.c
>> +++ b/drivers/regulator/max8997.c
> ..
>> +static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
>> +                                     struct max8997_platform_data *pdata)
>> +{
>> +     struct device_node *pmic_np, *regulators_np, *reg_np;
>> +     struct max8997_regulator_data *rdata;
>> +     unsigned int i, dvs_voltage_nr = 1, ret;
>> +
>> +     pmic_np = iodev->dev->of_node;
>> +     if (!pmic_np) {
>> +             dev_err(iodev->dev, "could not find pmic sub-node\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     regulators_np = of_find_node_by_name(pmic_np, "regulators");
>> +     if (!regulators_np) {
>> +             dev_err(iodev->dev, "could not find regulators sub-node\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* count the number of regulators to be supported in pmic */
>> +     pdata->num_regulators = 0;
>> +     for_each_child_of_node(regulators_np, reg_np)
>> +             pdata->num_regulators++;
>> +
>> +     rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
>> +                             pdata->num_regulators, GFP_KERNEL);
>> +     if (!rdata) {
>> +             dev_err(iodev->dev, "could not allocate memory for "
>> +                                             "regulator data\n");
>> +             return -ENOMEM;
>> +     }
>
>> +     pdata->regulators = rdata;
>
>> +     for_each_child_of_node(regulators_np, reg_np) {
>> +             for (i = 0; i < ARRAY_SIZE(regulators); i++)
>> +                     if (!of_node_cmp(reg_np->name, regulators[i].name))
>> +                             break;
>> +             rdata->id = i;
>
>
> rdata->id will be equal to ARRAY_SIZE(regulators) when one adds DT node
> name (below "regulators") which is different from what can be found in
> regulators[] table.
>
> On my test machine this results in hard lockup - possibly because
> something tries to access regulators[ARRAY_SIZE(regulators)]
> later on.
>
> Following patch fixes this on my machine (using DTS with misspelled LDO1 for LDx1):
>
> diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
> index dce8aaf..c20fd72 100644
> --- a/drivers/regulator/max8997.c
> +++ b/drivers/regulator/max8997.c
> @@ -1011,6 +1011,13 @@ static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
>                for (i = 0; i < ARRAY_SIZE(regulators); i++)
>                        if (!of_node_cmp(reg_np->name, regulators[i].name))
>                                break;
> +
> +               if (i == ARRAY_SIZE(regulators)) {
> +                       dev_warn(iodev->dev, "don't know how to configure regulator %s\n",
> +                                reg_np->name);
> +                       continue;
> +               }
> +
>                rdata->id = i;
>                rdata->initdata = of_get_regulator_init_data(
>                                                iodev->dev, reg_np);
>

Thanks for this fix. I have merged this change into this patch.

Regards,
Thomas.

>
> Regards,
> --
> Karol Lewandowski | Samsung Poland R&D Center | Linux/Platform
