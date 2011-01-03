Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1ACImm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 03:42:42 -0500
Received: from smtp.nokia.com ([147.243.1.48]:18749 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab1ACIml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 03:42:41 -0500
Message-ID: <4D218BEC.7010503@nokia.com>
Date: Mon, 03 Jan 2011 10:42:20 +0200
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101228 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "ext tapio.vihuri@nokia.com" <tapio.vihuri@nokia.com>
CC: dmitry.torokhov@gmail.com, randy.dunlap@oracle.com,
        alsa-devel@alsa-project.org, ilkka.koskinen@nokia.com,
        linux-kernel@vger.kernel.org, samu.p.onkalo@nokia.com
Subject: Re: [alsa-devel] [PATCH v2 2/3] ECI: introducing ECI bus driver
References: <1293716219-26089-1-git-send-email-tapio.vihuri@nokia.com>	<1293716219-26089-2-git-send-email-tapio.vihuri@nokia.com> <1293716219-26089-3-git-send-email-tapio.vihuri@nokia.com>
In-Reply-To: <1293716219-26089-3-git-send-email-tapio.vihuri@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/30/10 15:36, ext tapio.vihuri@nokia.com wrote:
> From: Tapio Vihuri <tapio.vihuri@nokia.com>
> 
> ECI bus controller is kind of bridge between host CPU I2C and ECI accessory
> ECI communication.

It is kind of misleading to call this driver as a bus driver IMHO.
For what I gathered, this is a driver for a micro-controller, which
implements the ECI communication.
This could be a generic driver for the micro-controller, but two lines
makes it x86 specific...

...

> +#include <asm/intel_scu_ipc.h>

...

> +static int __init ecibus_probe(struct platform_device *pdev)
> +{
> +       struct ecibus_data *ed;
> +       struct ecibus_platform_data *pdata = pdev->dev.platform_data;
> +       struct i2c_adapter *adapter;
> +       int ret;
> +
> +       if (!pdata) {
> +               dev_err(&pdev->dev, "platform_data not available: %d\n",
> +                               __LINE__);
> +               return -EINVAL;
> +       }
> +
> +       ed = kzalloc(sizeof(*ed), GFP_KERNEL);
> +       if (!ed)
> +               return -ENOMEM;
> +
> +       platform_set_drvdata(pdev, ed);
> +       ed->dev = &pdev->dev;
> +       ed->ecibus_rst_gpio = pdata->ecibus_rst_gpio;
> +       ed->ecibus_sw_ctrl_gpio = pdata->ecibus_sw_ctrl_gpio;
> +       ed->ecibus_int_gpio = pdata->ecibus_int_gpio;
> +
> +       if (ed->ecibus_rst_gpio == 0 || ed->ecibus_sw_ctrl_gpio == 0 ||
> +                       ed->ecibus_int_gpio == 0) {
> +               ret = -ENXIO;
> +               goto gpio_err;
> +       }
> +
> +       the_ed = ed;
> +
> +       adapter = i2c_get_adapter(1);

What happens if the mc is on another bus?
Shall you have platform data for this?
Or even better, use i2c device/driver probing for this driver?

> +       if (adapter)
> +               ed->client = i2c_new_device(adapter, &ecibus_i2c);
> +       if (!ed->client) {
> +               dev_err(ed->dev, "could not get i2c device %s at 0x%02x: %d\n",
> +                               ecibus_i2c.type, ecibus_i2c.addr, __LINE__);
> +               kfree(ed);
> +
> +               return -ENODEV;
> +       }
> +
> +       ret = ecibus_initialize_debugfs(ed);
> +       if (ret)
> +               dev_err(ed->dev, "could not create debugfs entries: %d\n",
> +                               __LINE__);
> +
> +       ret = gpio_request(ed->ecibus_rst_gpio, "ECI_RSTn");
> +       if (ret) {
> +               dev_err(ed->dev, "could not request ECI_RSTn gpio %d: %d\n",
> +                               ed->ecibus_rst_gpio, __LINE__);
> +               goto rst_gpio_err;
> +       }
> +
> +       gpio_direction_output(ed->ecibus_rst_gpio, 0);
> +       gpio_set_value(ed->ecibus_rst_gpio, 1);
> +
> +       ret = gpio_request(ed->ecibus_sw_ctrl_gpio, "ECI_SW_CTRL");
> +       if (ret) {
> +               dev_err(ed->dev, "could not request ECI_SW_CTRL gpio %d: %d\n",
> +                               ed->ecibus_sw_ctrl_gpio, __LINE__);
> +               goto sw_ctrl_gpio_err;
> +       }
> +
> +       gpio_direction_input(ed->ecibus_sw_ctrl_gpio);
> +
> +       ret = gpio_request(ed->ecibus_int_gpio, "ECI_INT");
> +       if (ret) {
> +               dev_err(ed->dev, "could not request ECI_INT gpio %d: %d\n",
> +                               ed->ecibus_int_gpio, __LINE__);
> +               goto int_gpio_err;
> +       }
> +
> +       gpio_direction_input(ed->ecibus_int_gpio);
> +
> +       ret = request_threaded_irq(gpio_to_irq(ed->ecibus_int_gpio), NULL,
> +                       ecibus_irq_handler, IRQF_TRIGGER_RISING, "ECI_INT", ed);
> +       if (ret) {
> +               dev_err(ed->dev, "could not request irq %d: %d\n",
> +                               gpio_to_irq(ed->ecibus_int_gpio), __LINE__);
> +               goto int_irq_err;
> +       }
> +
> +       /* Register itself to the ECI accessory driver */
> +       ed->eci_callback = eci_register(&ecibus_hw_ops);
> +       if (IS_ERR(ed->eci_callback)) {
> +               ret = PTR_ERR(ed->eci_callback);
> +               goto eci_register_err;
> +
> +       }
> +
> +       /*
> +        * Turn on vprog2
> +        * Some decent power ctrl interface, please
> +        */
> +       intel_scu_ipc_iowrite8(AvP_MSIC_VPROG2, AvP_MSIC_VPROG2_2V5_ON);

Is this some sort of power enable for the controller itself?
If it is, why not use a callback from the platform to enable/disable the
power, so the driver will be platform independent, and you do this intel
specific thing in arch/ platform code.
If this is not related to the mc itself, then this shall not be part of
this driver.

...

> +static int __exit ecibus_remove(struct platform_device *pdev)
> +{
> +       struct ecibus_data *ed = platform_get_drvdata(pdev);
> +
> +       gpio_set_value(ed->ecibus_rst_gpio, 0);
> +       gpio_free(ed->ecibus_rst_gpio);
> +
> +       gpio_free(ed->ecibus_sw_ctrl_gpio);
> +
> +       free_irq(gpio_to_irq(ed->ecibus_int_gpio), ed);
> +       gpio_free(ed->ecibus_int_gpio);
> +
> +       ecibus_uninitialize_debugfs();
> +       i2c_unregister_device(ed->client);
> +
> +       /*
> +        * Turn off vprog2
> +        * Some decent power ctrl interface, please
> +        */
> +       intel_scu_ipc_iowrite8(AvP_MSIC_VPROG2, AvP_MSIC_VPROG2_2V5_OFF);

Same applies here for the intel dependency.

-- 
Péter
