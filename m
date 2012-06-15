Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2FOLML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:12:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45989 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2FOLMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:12:09 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FB5C6@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FB5C6@DQHE02.ent.ti.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 15 Jun 2012 19:11:48 +0800
Message-ID: <CAF+7xW=Cb3b64khdNsnyfkJiS4Yt+j8tGFQExAoddXrtu=+5=Q@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: add new regulator driver for lp872x
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +static int lp872x_init_dvs(struct lp872x *lp)
> +{
> +       int ret, gpio;
> +       struct lp872x_dvs *dvs = lp->pdata->dvs;
> +
> +       ret = lp872x_check_dvs_validity(lp);
> +       if (ret) {
> +               dev_warn(lp->dev, "invalid dvs data: %d\n", ret);
> +               return ret;
> +       }
> +
> +       gpio = dvs->gpio;
> +
> +       if (!gpio_is_valid(gpio)) {
> +               dev_err(lp->dev, "invalid gpio: %d\n", gpio);
> +               return -EINVAL;
> +       }
> +
> +       ret = gpio_request(gpio, "LP872X DVS");
devm_gpio_request

> +       if (ret) {
> +               dev_err(lp->dev, "gpio request err: %d\n", ret);
> +               return ret;
> +       }
> +
> +       gpio_direction_output(gpio, dvs->init_state);
> +       lp->dvs_pin = dvs->init_state;
> +       lp->dvs_gpio = gpio;
> +
> +       return 0;
> +}
> +
> +static void lp872x_deinit_dvs(struct lp872x *lp)
> +{
> +       if (lp->dvs_gpio)
> +               gpio_free(lp->dvs_gpio);
> +}

If you are using devm_gpio_request in lp872x_init_dvs() , you can just
kill lp872x_deinit_dvs() function.


> +static struct regulator_init_data
> +*lp872x_find_regulator_init_data(int idx, struct lp872x *lp)
> +{
> +       int i;
> +       int base = lp->chipid == LP8725 ? LP8725_ID_BASE : 0;
> +       int id = idx + base;
> +
> +       for (i = 0 ; i < LP872X_MAX_REGULATORS ; i++)
> +               if (lp->pdata->regulator_data[i].id == id)
> +                       break;
                            return lp->pdata->regulator_data[i].init_data;
> +
> +       return (i == LP872X_MAX_REGULATORS) ? NULL :
> +                       lp->pdata->regulator_data[i].init_data;
            return NULL; // seems better readability this way
> +}
> +

> +module_i2c_driver(lp872x_driver);

I think you need to use subsys_initcall() here.

Regulators need to be available early in init in order to allow them
to be available for consumers when requested.
