Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0HPJpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 05:45:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39144 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab0HPJpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 05:45:30 -0400
Message-ID: <3776.10.24.255.18.1281951917.squirrel@dbdmail.itg.ti.com>
In-Reply-To: <C9D59C82B94F474B872F2092A87F261412470D0874@dlee07.ent.ti.com>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
    <4BF6753B.60201@cam.ac.uk>
    <0ebd01cb3ae5$a0dcfc70$LocalHost@wipblrx0099946>
    <C9D59C82B94F474B872F2092A87F261412470D0874@dlee07.ent.ti.com>
Date: Mon, 16 Aug 2010 15:15:17 +0530 (IST)
Subject: RE: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver
From: "Hemanth V" <hemanthv@ti.com>
To: "Murphy, Dan" <dmurphy@ti.com>
Cc: "Jonathan Cameron" <jic23@cam.ac.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Murphy, Dan" <dmurphy@ti.com>
> Hemanth
> I have a few comments on this patch.
>
> +static ssize_t cma3000_store_attr_mdfftmr(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&data->mutex);
> +	data->pdata.mdfftmr = val;
> +
> +	disable_irq(data->client->irq);
> You should use disable_irq_nosync here.  This may not work properly on SMP.

Can u explain why disable_irq will not work on SMP.

>
>> +	if (val == CMARANGE_2G) {
>> +		ctrl |= CMA3000_RANGE2G;
>> +		data->pdata.g_range = CMARANGE_2G;
>> +	} else if (val == CMARANGE_8G) {
>> +		ctrl |= CMA3000_RANGE8G;
>> +		data->pdata.g_range = CMARANGE_8G;
>
> Why are you modifying the platform data?  Why not just keep it in a global or a glocal structure and modify it that way?

If you look carefully, the variable data is indeed a local structure.

>> +	} else {
>> +		error = -EINVAL;
>> +		goto err_op_failed;
>> +	}
>> +
>> +	g_range = data->pdata.g_range;
>> +	fuzz_x = data->pdata.fuzz_x;
>> +	fuzz_y = data->pdata.fuzz_y;
>> +	fuzz_z = data->pdata.fuzz_z;
> Why are you storing these locally and then using them once can't we eliminate these completely and just pass the platform data values into the set
> params?

I belive this is already discussed and agreed upon in the previous thread of discussion.
Pl refer the same.

>> +
>> +	disable_irq(data->client->irq);
> You should use disable_irq_nosync here.  This may not work properly on SMP.
>

Same comment as above

>> +	cma3000_set(data, CMA3000_CTRL, ctrl, "ctrl");
>> +
>> +	input_set_abs_params(data->input_dev, ABS_X, -g_range,
>> +				g_range, fuzz_x, 0);
>> +	input_set_abs_params(data->input_dev, ABS_Y, -g_range,
>> +				g_range, fuzz_y, 0);
>> +	input_set_abs_params(data->input_dev, ABS_Z, -g_range,
>> +				g_range, fuzz_z, 0);
> Don't necessarily agree with modifying the parameters for the input device on the fly.  Some implementations may be a read once on init and do not
> go back and check this.

Its the user space code that can modify the grange if required, so I suppose it will need to check
these values after modifying the range.

>
>
> +		ret = request_threaded_irq(data->client->irq, NULL,
> +					cma3000_thread_irq,
> +					irqflags | IRQF_ONESHOT,
> +					data->client->name, data);
>
> This is implemented wrong.  You are doing a lot of processing in the IRQ context here.  Especially calls out to a peripheral.  The NULL should be
> your handler thread where you do all the device processing.

Are u sure u are referring to threaded irq, all the processing is being done in thread
context. Pl refer documentation for more details on threaded irqs.

>
> Also this implementation only suggests that the HW has the IRQ connected what about devices that the IRQ line was not connected?
>
This is currently not implemented, since I am not aware of any boards with this configuration. A polling method could be added
in future if the need arises.



