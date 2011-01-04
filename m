Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab1ADBrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 20:47:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:55367 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1ADBrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 20:47:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,269,1291622400"; 
   d="scan'208";a="693244537"
Subject: Re: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core Driver
From: Hong Liu <hong.liu@intel.com>
To: Kevin McNeely <kev@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Trilok Soni <tsoni@codeaurora.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Alan Cox <alan@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1293650268-1561-1-git-send-email-kev@cypress.com>
References: <Kevin McNeely <kev@cypress.com>
	 <1293650268-1561-1-git-send-email-kev@cypress.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 09:50:14 +0800
Message-ID: <1294105814.2570.17.camel@hongdev>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-30 at 03:17 +0800, Kevin McNeely wrote:
[...]

> +
> +void *cyttsp_core_init(struct cyttsp_bus_ops *bus_ops, struct device *dev)
> +{
> +       struct input_dev *input_device;
> +
> +       struct cyttsp *ts = kzalloc(sizeof(*ts), GFP_KERNEL);
> +
> +       if (!ts) {
> +               dev_dbg(ts->dev, "%s: Error, kzalloc\n", __func__);
> +               goto error_alloc_data;
> +       }

ts->dev is not assigned yet.

Thanks,
Hong

> +
> +       if (dev == NULL || bus_ops == NULL) {
> +               kfree(ts);
> +               goto error_alloc_data;
> +       }
> +
> +       mutex_init(&ts->mutex);
> +       ts->dev = dev;
> +       ts->platform_data = dev->platform_data;
> +       ts->bus_ops = bus_ops;
> +       init_completion(&ts->bl_ready);
> +
> +       if (ts->platform_data->init) {
> +               if (ts->platform_data->init()) {
> +                       dev_dbg(ts->dev, "%s: Error, platform init failed!\n",
> +                               __func__);
> +                       goto error_init;
> +               }
> +       }
> +
> +       ts->irq = gpio_to_irq(ts->platform_data->irq_gpio);
> +       if (ts->irq <= 0) {
> +               dev_dbg(ts->dev, "%s: Error, failed to allocate irq\n",
> +                       __func__);
> +                       goto error_init;
> +       }
> +
> +       /* Create the input device and register it. */
> +       input_device = input_allocate_device();
> +       if (!input_device) {
> +               dev_dbg(ts->dev, "%s: Error, failed to allocate input device\n",
> +                       __func__);
> +               goto error_input_allocate_device;
> +       }
> +
> +       ts->input = input_device;
> +       input_device->name = ts->platform_data->name;
> +       snprintf(ts->phys, sizeof(ts->phys), "%s", dev_name(dev));
> +       input_device->phys = ts->phys;
> +       input_device->dev.parent = ts->dev;
> +       ts->bus_type = bus_ops->dev->bus;
> +       input_device->open = cyttsp_open;
> +       input_device->close = cyttsp_close;
> +       input_set_drvdata(input_device, ts);
> +
> +       __set_bit(EV_SYN, input_device->evbit);
> +       __set_bit(EV_KEY, input_device->evbit);
> +       __set_bit(EV_ABS, input_device->evbit);
> +
> +       input_set_abs_params(input_device, ABS_MT_POSITION_X,
> +               0, ts->platform_data->maxx, 0, 0);
> +       input_set_abs_params(input_device, ABS_MT_POSITION_Y,
> +               0, ts->platform_data->maxy, 0, 0);
> +       input_set_abs_params(input_device, ABS_MT_TOUCH_MAJOR,
> +               0, CY_MAXZ, 0, 0);
> +
> +       if (input_register_device(input_device)) {
> +               dev_dbg(ts->dev, "%s: Error, failed to register input device\n",
> +                       __func__);
> +               goto error_input_register_device;
> +       }
> +
> +       goto no_error;
> +
> +error_input_register_device:
> +       input_unregister_device(input_device);
> +error_input_allocate_device:
> +       if (ts->platform_data->exit)
> +               ts->platform_data->exit();
> +error_init:
> +       mutex_destroy(&ts->mutex);
> +       kfree(ts);
> +error_alloc_data:
> +no_error:
> +       return ts;
> +}
> +EXPORT_SYMBOL_GPL(cyttsp_core_init);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard touchscreen driver core");
> +MODULE_AUTHOR("Cypress");


