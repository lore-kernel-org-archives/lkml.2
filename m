Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621Ab0HMNeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:34:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60824 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198Ab0HMNeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:34:22 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: "V, Hemanth" <hemanthv@ti.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 13 Aug 2010 08:34:07 -0500
Subject: RE: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver
Thread-Topic: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver
Thread-Index: Acs66emzlg1cykdvRZe1F4aBsCQIGwAAJcrQ
Message-ID: <C9D59C82B94F474B872F2092A87F261412470D0874@dlee07.ent.ti.com>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
 <4BF6753B.60201@cam.ac.uk> <0ebd01cb3ae5$a0dcfc70$LocalHost@wipblrx0099946>
In-Reply-To: <0ebd01cb3ae5$a0dcfc70$LocalHost@wipblrx0099946>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hemanth
I have a few comments on this patch.

+static ssize_t cma3000_store_attr_mdfftmr(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
+	unsigned long val;
+	int error;
+
+	error = strict_strtoul(buf, 0, &val);
+	if (error)
+		return error;
+
+	mutex_lock(&data->mutex);
+	data->pdata.mdfftmr = val;
+
+	disable_irq(data->client->irq);
You should use disable_irq_nosync here.  This may not work properly on SMP.

> +	if (val == CMARANGE_2G) {
> +		ctrl |= CMA3000_RANGE2G;
> +		data->pdata.g_range = CMARANGE_2G;
> +	} else if (val == CMARANGE_8G) {
> +		ctrl |= CMA3000_RANGE8G;
> +		data->pdata.g_range = CMARANGE_8G;

Why are you modifying the platform data?  Why not just keep it in a global or a glocal structure and modify it that way?
> +	} else {
> +		error = -EINVAL;
> +		goto err_op_failed;
> +	}
> +
> +	g_range = data->pdata.g_range;
> +	fuzz_x = data->pdata.fuzz_x;
> +	fuzz_y = data->pdata.fuzz_y;
> +	fuzz_z = data->pdata.fuzz_z;
Why are you storing these locally and then using them once can't we eliminate these completely and just pass the platform data values into the set params?
> +
> +	disable_irq(data->client->irq);
You should use disable_irq_nosync here.  This may not work properly on SMP.

> +	cma3000_set(data, CMA3000_CTRL, ctrl, "ctrl");
> +
> +	input_set_abs_params(data->input_dev, ABS_X, -g_range,
> +				g_range, fuzz_x, 0);
> +	input_set_abs_params(data->input_dev, ABS_Y, -g_range,
> +				g_range, fuzz_y, 0);
> +	input_set_abs_params(data->input_dev, ABS_Z, -g_range,
> +				g_range, fuzz_z, 0);
Don't necessarily agree with modifying the parameters for the input device on the fly.  Some implementations may be a read once on init and do not go back and check this.


+		ret = request_threaded_irq(data->client->irq, NULL,
+					cma3000_thread_irq,
+					irqflags | IRQF_ONESHOT,
+					data->client->name, data);

This is implemented wrong.  You are doing a lot of processing in the IRQ context here.  Especially calls out to a peripheral.  The NULL should be your handler thread where you do all the device processing.

Also this implementation only suggests that the HW has the IRQ connected what about devices that the IRQ line was not connected?

I have changed this driver to adjust all the issues above.  Let me know if you want the patches or the files.

Dan

-----Original Message-----
From: linux-input-owner@vger.kernel.org [mailto:linux-input-owner@vger.kernel.org] On Behalf Of V, Hemanth
Sent: Friday, August 13, 2010 7:47 AM
To: Jonathan Cameron; Andrew Morton
Cc: linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; linux-omap@vger.kernel.org
Subject: Re: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver

----- Original Message ----- 
From: "Jonathan Cameron" <jic23@cam.ac.uk>
To: "Hemanth V" <hemanthv@ti.com>
Cc: <linux-input@vger.kernel.org>; <linux-kernel@vger.kernel.org>; 
<linux-omap@vger.kernel.org>
Sent: Friday, May 21, 2010 5:27 PM
Subject: Re: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver


> On 05/21/10 07:52, Hemanth V wrote:
>> From: Hemanth V <hemanthv@ti.com>
>> Date: Thu, 20 May 2010 20:18:17 +0530
>> Subject: [PATCH] input: CMA3000 Accelerometer Driver
>>
>> This patch adds support for CMA3000 Tri-axis accelerometer, which
>> supports Motion detect, Measurement and Free fall modes.
>> CMA3000 supports both I2C/SPI bus for communication, currently the
>> driver supports I2C based communication.
>>
>> Driver reports acceleration data through input subsystem and supports
>> sysfs for configuration changes.
>>
>> This is V2 of patch, which fixes open source review comments
>>
>
> Hi,
>
> The driver is nice and clean.
>
> Still leaving aside the long argued question of whether this should be
> in input.  If you care for my views on that there are plenty or other
> threads! There are a few things I'd still like to suggest:
>

Jonathan, Andrew

Is there any way forward for this patch, I am unable to induce any response
from the input maintainer

Thanks
Hemanth 

--
To unsubscribe from this list: send the line "unsubscribe linux-input" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
