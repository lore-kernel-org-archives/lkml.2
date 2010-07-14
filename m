Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0GNJh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:37:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60610 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0GNJh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OmMc7E2wr/VzQJAbPPxmolHWvINy69C1ukhBf1ZNnaGhye55Ku7FczUtaV38NRmjxl
         9Dr/clw3Y5usCem/HJfOENoZVi66EYivZwHyEatXISU9fuT20MCwKi+Osv9mrcpa3Qqd
         APgw2xcSX+0rrGH7IDCi7JyR+VUcLOcl46Wko=
Date: Wed, 14 Jul 2010 02:37:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dajun Chen <dajun.chen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 11/11] INPUT/MISC:ONKEY module of DA9052 PMIC device
 driver
Message-ID: <20100714093749.GA8132@core.coreip.homeip.net>
References: <AANLkTiluv_5z-SuBzStm0WawpOPY7Nkk4pzk3PsC29sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiluv_5z-SuBzStm0WawpOPY7Nkk4pzk3PsC29sQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 14, 2010 at 10:10:17AM +0100, Dajun Chen wrote:
> Initial work of Onkey module of the device driver for DA9052 PMIC device
> from Dialog Semiconductor.
> 
> The ONKEY feature for DA9052 Animal board has been supported in this new
> driver patch
> 
> Linux Kernel Version: 2.6.34
> 
> Signed-off-by: D. Chen <dchen@diasemi.com>

Looks mostly sane but formatting is completely butchered by your
mailer, please resend.

> ---
> diff -urpN linux-2.6.34/drivers/input/misc/da9052_onkey.c
> linux-2.6.34_test/drivers/input/misc/da9052_onkey.c
> --- linux-2.6.34/drivers/input/misc/da9052_onkey.c 1970-01-01
> 05:00:00.000000000 +0500
> +++ linux-2.6.34_test/drivers/input/misc/da9052_onkey.c 2010-07-13
> 18:11:26.000000000 +0500
> @@ -0,0 +1,132 @@
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/input.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/reg.h>
> +
> +#define DRIVER_NAME "da9052-onkey"
> +
> +struct da9052_onkey_data {
> + struct da9052 *da9052;
> + struct da9052_eh_nb eh_data;
> + struct input_dev *input;
> +};
> +
> +static void da9052_onkey_report_event(struct da9052_eh_nb *eh_data,
> +      unsigned int event)
> +{
> + struct da9052_onkey_data *da9052_onkey =
> +  container_of(eh_data, struct da9052_onkey_data, eh_data);
> + struct da9052_ssc_msg msg;
> + unsigned int ret;
> +
> + /* Read the Evnet Register */
> + msg.addr = DA9052_EVENTB_REG;
> + da9052_lock(da9052_onkey->da9052);
> + ret = da9052_onkey->da9052->read(da9052_onkey->da9052, &msg);
> + if (ret) {
> +  da9052_unlock(da9052_onkey->da9052);
> +  return;
> + }
> + da9052_unlock(da9052_onkey->da9052);
> + msg.data = msg.data & DA9052_EVENTB_ENONKEY;
> +
> + input_report_key(da9052_onkey->input, KEY_POWER, msg.data);
> + input_sync(da9052_onkey->input);
> +}
> +
> +static int __devinit da9052_onkey_probe(struct platform_device *pdev)
> +{
> + struct da9052_onkey_data *da9052_onkey;
> + int error;
> +
> + da9052_onkey = kzalloc(sizeof(struct da9052_onkey_data), GFP_KERNEL);
> + da9052_onkey->input = input_allocate_device();
> + if (!da9052_onkey) {

Too late to check, you just dereferenced that null pointer 1 line above.

> +  dev_err(&pdev->dev, "failed to allocate data device\n");
> +  error = -ENOMEM;
> +  goto fail1;
> + }
> + da9052_onkey->da9052 = dev_get_drvdata(pdev->dev.parent);
> +
> + if (!da9052_onkey->input) {
> +  dev_err(&pdev->dev, "failed to allocate input device\n");
> +  error = -ENOMEM;
> +  goto fail2;
> + }
> +
> + da9052_onkey->input->evbit[0] = BIT_MASK(EV_KEY);
> + da9052_onkey->input->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
> + da9052_onkey->input->name = "da9052-onkey";
> + da9052_onkey->input->phys = "da9052-onkey/input0";
> + da9052_onkey->input->dev.parent = &pdev->dev;
> +
> + /* Set the EH structure */
> + da9052_onkey->eh_data.eve_type = ONKEY_EVE;
> + da9052_onkey->eh_data.call_back = &da9052_onkey_report_event;
> + error = da9052_onkey->da9052->register_event_notifier(
> +    da9052_onkey->da9052,
> +    &da9052_onkey->eh_data);
> + if (error)
> +  goto fail2;
> +
> + error = input_register_device(da9052_onkey->input);
> + if (error) {
> +  dev_err(&pdev->dev, "Unable to register input\
> +    device,error: %d\n", error);
> +  goto fail3;
> + }
> +
> + platform_set_drvdata(pdev, da9052_onkey);
> +
> + return 0;
> +
> +fail3:
> + da9052_onkey->da9052->unregister_event_notifier(da9052_onkey->da9052,
> +     &da9052_onkey->eh_data);
> +fail2:
> + input_free_device(da9052_onkey->input);
> +fail1:
> + kfree(da9052_onkey);
> + return error;
> +}
> +
> +static int __devexit da9052_onkey_remove(struct platform_device *pdev)
> +{
> + struct da9052_onkey_data *da9052_onkey = pdev->dev.platform_data;

should be da9052_onkey = platform_get_drvdata(pdev)

> + da9052_onkey->da9052->unregister_event_notifier(da9052_onkey->da9052,
> +     &da9052_onkey->eh_data);
> + input_unregister_device(da9052_onkey->input);
> + kfree(da9052_onkey);
> +
> + return 0;
> +}
> +
> +static struct platform_driver da9052_onkey_driver = {
> + .probe  = da9052_onkey_probe,
> + .remove  = __devexit_p(da9052_onkey_remove),
> + .driver  = {
> +  .name = "da9052-onkey",
> +  .owner = THIS_MODULE,
> + }
> +};
> +
> +static int __init da9052_onkey_init(void)
> +{
> + return platform_driver_register(&da9052_onkey_driver);
> +}
> +
> +static void __exit da9052_onkey_exit(void)
> +{
> + platform_driver_unregister(&da9052_onkey_driver);
> +}
> +
> +module_init(da9052_onkey_init);
> +module_exit(da9052_onkey_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("David Dajun Chen <dchen@diasemi.com>");
> +MODULE_DESCRIPTION("Onkey driver for DA9052");
> +MODULE_ALIAS("platform:" DRIVER_NAME);
> diff -urpN linux-2.6.34/drivers/input/misc/Kconfig
> linux-2.6.34_test/drivers/input/misc/Kconfig
> --- linux-2.6.34/drivers/input/misc/Kconfig 2010-05-17 02:17:36.000000000
> +0500
> +++ linux-2.6.34_test/drivers/input/misc/Kconfig 2010-07-13
> 18:11:40.000000000 +0500
> @@ -340,4 +340,14 @@ config INPUT_PCAP
>     To compile this driver as a module, choose M here: the
>     module will be called pcap_keys.
> 
> +config INPUT_DA9052_ONKEY
> + tristate "INPUT_DA9052_ONKEY support"
> + depends on PMIC_DA9052
> + help
> +   Support the ONKEY of Dialog DA9052 PMICs as an input device
> +   reporting power button status.
> +
> +   To compile this driver as a module, choose M here: the module
> +   will be called da9052_onkey.
> +
>  endif
> diff -urpN linux-2.6.34/drivers/input/misc/Makefile
> linux-2.6.34_test/drivers/input/misc/Makefile
> --- linux-2.6.34/drivers/input/misc/Makefile 2010-05-17 02:17:36.000000000
> +0500
> +++ linux-2.6.34_test/drivers/input/misc/Makefile 2010-07-13
> 18:11:34.000000000 +0500
> @@ -32,4 +32,5 @@ obj-$(CONFIG_INPUT_WINBOND_CIR)  += winb
>  obj-$(CONFIG_INPUT_WISTRON_BTNS) += wistron_btns.o
>  obj-$(CONFIG_INPUT_WM831X_ON)  += wm831x-on.o
>  obj-$(CONFIG_INPUT_YEALINK)  += yealink.o
> +obj-$(CONFIG_INPUT_DA9052_ONKEY)  += da9052_onkey.o

Please keep Makefile sorted alphabetically.

Thanks.

-- 
Dmitry
