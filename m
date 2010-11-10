Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab0KJOkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:40:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45002 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab0KJOkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:40:07 -0500
Message-ID: <A7D5E17F2F864F3FA81621B9042F0360@wipblrx0099946>
From: "Hemanth V" <hemanthv@ti.com>
To: "Murphy, Dan" <dmurphy@ti.com>, <linux-input@vger.kernel.org>,
        <dmitry.torokhov@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
References: <61033.10.24.255.18.1283926671.squirrel@dbdmail.itg.ti.com> <C9D59C82B94F474B872F2092A87F26141272E78492@dlee07.ent.ti.com>
Subject: Re: [PATCH V3 1/2] input: CMA3000 Accelerometer driver
Date: Wed, 10 Nov 2010 20:09:56 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5843
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Murphy, Dan" <dmurphy@ti.com>

<SNIP>

>
>> +static ssize_t cma3000_store_attr_grange(struct device *dev,
>> +                                  struct device_attribute *attr,
>> +                                  const char *buf, size_t count)
>> +{
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +     struct cma3000_accl_data *data = platform_get_drvdata(pdev);
>> +     unsigned long val;
>> +     int error, g_range, fuzz_x, fuzz_y, fuzz_z;
>> +     uint8_t ctrl;
>> +
>> +     error = strict_strtoul(buf, 0, &val);
>> +     if (error)
>> +             goto err_op1_failed;
>> +
>> +     mutex_lock(&data->mutex);
>> +     ctrl = CMA3000_READ(data, CMA3000_CTRL, "ctrl");
>> +     if (ctrl < 0) {
>> +             error = ctrl;
>> +             goto err_op2_failed;
>> +     }
>> +
>> +     ctrl &= ~CMA3000_GRANGEMASK;
>> +
>> +     if (val == CMARANGE_2G) {
>> +             ctrl |= CMA3000_RANGE2G;
>> +             data->pdata.g_range = CMARANGE_2G;
>> +     } else if (val == CMARANGE_8G) {
>> +             ctrl |= CMA3000_RANGE8G;
>> +             data->pdata.g_range = CMARANGE_8G;
>> +     } else {
>> +             error = -EINVAL;
>> +             goto err_op2_failed;
>> +     }
>> +
>> +     g_range = data->pdata.g_range;
>> +     fuzz_x = data->pdata.fuzz_x;
>> +     fuzz_y = data->pdata.fuzz_y;
>> +     fuzz_z = data->pdata.fuzz_z;
> Can you explain why you store these locally and not just pass in the pdata 
> values directly to the calls below?  This seems to be unneeded code.

I believe this was discussed previously also, basically for ease of reading.
Try passing these huge arguments to functions calls below

>> +
>> +     disable_irq(data->client->irq);
>> +     error = CMA3000_SET(data, CMA3000_CTRL, ctrl, "ctrl");
>> +     if (error < 0)
>> +             goto err_op3_failed;
>> +
>> +     input_set_abs_params(data->input_dev, ABS_X, -g_range,
>> +                             g_range, fuzz_x, 0);
>> +     input_set_abs_params(data->input_dev, ABS_Y, -g_range,
>> +                             g_range, fuzz_y, 0);
>> +     input_set_abs_params(data->input_dev, ABS_Z, -g_range,
>> +                             g_range, fuzz_z, 0);
>> +
>> +err_op3_failed:
>> +     enable_irq(data->client->irq);
>> +err_op2_failed:
>> +     mutex_unlock(&data->mutex);
>> +err_op1_failed:
>> +     return error ? error : count;
>> +}
>> +
>> +static ssize_t cma3000_show_attr_mdthr(struct device *dev,
>> +                                   struct device_attribute *attr,
>> +                                   char *buf)
>> +{
>> +     uint8_t mode;
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +     struct cma3000_accl_data *data = platform_get_drvdata(pdev);
>> +
>> +     mode = CMA3000_READ(data, CMA3000_MDTHR, "mdthr");
>> +     if (mode < 0)
>> +             return mode;
>> +
>> +     return sprintf(buf, "%d\n", mode);
>> +}
>> +
>> +static ssize_t cma3000_store_attr_mdthr(struct device *dev,
>> +                                    struct device_attribute *attr,
>> +                                    const char *buf, size_t count)
>> +{
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +     struct cma3000_accl_data *data = platform_get_drvdata(pdev);
>> +     unsigned long val;
>> +     int error;
>> +
>> +     error = strict_strtoul(buf, 0, &val);
>> +     if (error)
>> +             goto err_op_failed;
>> +
>
> I am a little concerned that you do not check the value passed in here.
> Is there not a range of values you will accept and not accept?

These are bit level description i.e each bit corresponds to a particular mg 
value,
hence not a issue.

>
>> +     mutex_lock(&data->mutex);
>> +     data->pdata.mdthr = val;
>> +     disable_irq(data->client->irq);
>> +     error = CMA3000_SET(data, CMA3000_MDTHR, val, "mdthr");
>> +     enable_irq(data->client->irq);
>> +     mutex_unlock(&data->mutex);
>> +
>> +err_op_failed:
>> +     /* If error value non zero, return error */
>> +     return error ? error : count;
>> +}
>> +
>> +static ssize_t cma3000_show_attr_mdfftmr(struct device *dev,
>> +                                     struct device_attribute *attr,
>> +                                     char *buf)
>> +{
>> +     uint8_t mode;
>> +
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +     struct cma3000_accl_data *data = platform_get_drvdata(pdev);
>> +
>> +     mode = CMA3000_READ(data, CMA3000_MDFFTMR, "mdfftmr");
>> +     if (mode < 0)
>> +             return mode;
>> +
>> +     return sprintf(buf, "%d\n", mode);
>> +}
>> +
>> +static ssize_t cma3000_store_attr_mdfftmr(struct device *dev,
>> +                                     struct device_attribute *attr,
>> +                                     const char *buf, size_t count)
>> +{
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +     struct cma3000_accl_data *data = platform_get_drvdata(pdev);
>> +     unsigned long val;
>> +     int error;
>> +
>> +     error = strict_strtoul(buf, 0, &val);
>> +     if (error)
>> +             goto err_op_failed;
>> +
>
> I am a little concerned that you do not check the value passed in here.
> Is there not a range of values you will accept and not accept?

Same comments as above

>
>> +     mutex_lock(&data->mutex);
>> +     data->pdata.mdfftmr = val;
>> +     disable_irq(data->client->irq);
>> +     error = CMA3000_SET(data, CMA3000_MDFFTMR, val, "mdthr");
>> +     enable_irq(data->client->irq);
>> +     mutex_unlock(&data->mutex);
>> +
>> +err_op_failed:
>> +     /* If error value non zero, return error */
>> +     return error ? error : count;
>> +}
>> +
>> +static ssize_t cma3000_show_attr_ffthr(struct device *dev,
>> +                                     struct device_attribute *attr,
>> +                                     char *buf)
>> +{
>> +     uint8_t mode;
>> +
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +     struct cma3000_accl_data *data = platform_get_drvdata(pdev);
>> +
>> +     mode = CMA3000_READ(data, CMA3000_FFTHR, "ffthr");
>> +     if (mode < 0)
>> +             return mode;
>> +
>> +     return sprintf(buf, "%d\n", mode);
>> +}
>> +
>> +static ssize_t cma3000_store_attr_ffthr(struct device *dev,
>> +                                    struct device_attribute *attr,
>> +                                    const char *buf, size_t count)
>> +{
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +     struct cma3000_accl_data *data = platform_get_drvdata(pdev);
>> +     unsigned long val;
>> +     int error;
>> +
>> +     error = strict_strtoul(buf, 0, &val);
>> +     if (error)
>> +             goto err_op_failed;
>> +
>
> Repeating myself here but.
> I am a little concerned that you do not check the value passed in here.
> Is there not a range of values you will accept and not accept?

Same comments as above

>
>> +     mutex_lock(&data->mutex);
>> +     data->pdata.ffthr = val;
>> +     disable_irq(data->client->irq);
>> +     error = CMA3000_SET(data, CMA3000_FFTHR, val, "mdthr");
>> +     enable_irq(data->client->irq);
>> +     mutex_unlock(&data->mutex);
>> +
>> +err_op_failed:
>> +     /* If error value non zero, return error */
>> +     return error ? error : count;
>> +}
>> +
>> +static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO,
>> +             cma3000_show_attr_mode, cma3000_store_attr_mode);
>> +
>> +static DEVICE_ATTR(grange, S_IWUSR | S_IRUGO,
>> +             cma3000_show_attr_grange, cma3000_store_attr_grange);
>> +
>> +static DEVICE_ATTR(mdthr, S_IWUSR | S_IRUGO,
>> +             cma3000_show_attr_mdthr, cma3000_store_attr_mdthr);
>> +
>> +static DEVICE_ATTR(mdfftmr, S_IWUSR | S_IRUGO,
>> +             cma3000_show_attr_mdfftmr, cma3000_store_attr_mdfftmr);
>> +
>> +static DEVICE_ATTR(ffthr, S_IWUSR | S_IRUGO,
>> +             cma3000_show_attr_ffthr, cma3000_store_attr_ffthr);
>> +
>> +
>> +static struct attribute *cma_attrs[] = {
>> +     &dev_attr_mode.attr,
>> +     &dev_attr_grange.attr,
>> +     &dev_attr_mdthr.attr,
>> +     &dev_attr_mdfftmr.attr,
>> +     &dev_attr_ffthr.attr,
>> +     NULL,
>> +};
>> +
>> +static struct attribute_group cma3000_attr_group = {
>> +     .attrs = cma_attrs,
>> +};
>> +
>> +static void decode_mg(struct cma3000_accl_data *data, int *datax,
>> +                             int *datay, int *dataz)
>> +{
>> +     /* Data in 2's complement, convert to mg */
>> +     *datax = (((s8)(*datax)) * (data->bit_to_mg));
>> +     *datay = (((s8)(*datay)) * (data->bit_to_mg));
>> +     *dataz = (((s8)(*dataz)) * (data->bit_to_mg));
>> +}
>> +
>> +static irqreturn_t cma3000_thread_irq(int irq, void *dev_id)
>> +{
>> +     struct cma3000_accl_data *data = dev_id;
>> +     int  datax, datay, dataz;
>> +     u8 ctrl, mode, range, intr_status;
>> +
>> +     intr_status = CMA3000_READ(data, CMA3000_INTSTATUS, "interrupt
>> status");
>> +     if (intr_status < 0)
>> +             return IRQ_NONE;
>> +
>> +     /* Check if free fall is detected, report immediately */
>> +     if (intr_status & CMA3000_INTSTATUS_FFDET) {
>> +             input_report_abs(data->input_dev, ABS_MISC, 1);
>> +             input_sync(data->input_dev);
>> +     } else {
>> +             input_report_abs(data->input_dev, ABS_MISC, 0);
>> +     }
>> +
>> +     datax = CMA3000_READ(data, CMA3000_DOUTX, "X");
>> +     datay = CMA3000_READ(data, CMA3000_DOUTY, "Y");
>> +     dataz = CMA3000_READ(data, CMA3000_DOUTZ, "Z");
>> +
>> +     ctrl = CMA3000_READ(data, CMA3000_CTRL, "ctrl");
>> +     mode = (ctrl & CMA3000_MODEMASK) >> 1;
>> +     range = (ctrl & CMA3000_GRANGEMASK) >> 7;
>> +
>> +     data->bit_to_mg = mode_to_mg[mode][range];
>> +
>> +     /* Interrupt not for this device */
>> +     if (data->bit_to_mg == 0)
>
> You return here but you still have an open report that is not completed 
> from the free fall.  Is that an issue?
>
> And shouldn't an interrupt check be done earlier in this handler?

No free fall event report is complete and interrupt check is also
being done, refer code segment above

>
>> +             return IRQ_NONE;
>> +
>> +     /* Decode register values to milli g */
>> +     decode_mg(data, &datax, &datay, &dataz);
>> +
>> +     input_report_abs(data->input_dev, ABS_X, datax);
>> +     input_report_abs(data->input_dev, ABS_Y, datay);
>> +     input_report_abs(data->input_dev, ABS_Z, dataz);
>> +     input_sync(data->input_dev);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int cma3000_reset(struct cma3000_accl_data *data)
>> +{
>> +     int ret;
>> +
>> +     /* Reset sequence */
>> +     CMA3000_SET(data, CMA3000_RSTR, 0x02, "Reset");
>> +     CMA3000_SET(data, CMA3000_RSTR, 0x0A, "Reset");
>> +     CMA3000_SET(data, CMA3000_RSTR, 0x04, "Reset");
>> +
>> +     /* Settling time delay */
>> +     mdelay(10);
>
> Why do you use mdelay instead of msleep?  Do you really need to block 
> during this time?  Is this settling time defined in the data sheet?  And 
> why
> is this 10ms and not 30ms as defined in other delay use cases?
>

Yes these delays are defined in data sheet. Since this is called during 
probe mdelay is used.

>> +
>> +     ret = CMA3000_READ(data, CMA3000_STATUS, "Status");
>> +     if (ret < 0) {
>> +             dev_err(&data->client->dev, "Reset failed\n");
>> +             return ret;
>> +     } else if (ret & CMA3000_STATUS_PERR) {
>> +             dev_err(&data->client->dev, "Parity Error\n");
>> +             return -EIO;
>> +     } else {
>> +             return 0;
>> +     }
>> +}
>> +
>> +int cma3000_poweron(struct cma3000_accl_data *data)
>> +{
>> +     uint8_t ctrl = 0, mdthr, mdfftmr, ffthr, mode;
>> +     int g_range, ret;
>> +
>> +     g_range = data->pdata.g_range;
>> +     mode = data->pdata.mode;
>> +     mdthr = data->pdata.mdthr;
>> +     mdfftmr = data->pdata.mdfftmr;
>> +     ffthr = data->pdata.ffthr;
>> +
>> +     if (mode < CMAMODE_DEFAULT || mode > CMAMODE_POFF) {
> When would this case be exercised?  In the set mode interface there is a 
> range check for mode so technically the mode cannot be set out of range.

This mode is from platform data, hence this check is required.

>
>> +             data->pdata.mode = CMAMODE_MOTDET;
>> +             mode = data->pdata.mode;
>> +             dev_info(&data->client->dev,
>> +                     "Invalid mode specified, assuming Motion 
>> Detect\n");
>> +     }
>> +
>> +     if (g_range == CMARANGE_2G) {
>> +             ctrl = (mode << 1) | CMA3000_RANGE2G;
>> +     } else if (g_range == CMARANGE_8G) {
>> +             ctrl = (mode << 1) | CMA3000_RANGE8G;
>> +     } else {
>> +             dev_info(&data->client->dev,
>> +                     "Invalid G range specified, assuming 8G\n");
>> +             ctrl = (mode << 1) | CMA3000_RANGE8G;
>> +             data->pdata.g_range = CMARANGE_8G;
>> +     }
>> +#if defined CONFIG_INPUT_CMA3000_I2C || defined
>> CONFIG_INPUT_CMA3000_I2C_MODULE
>> +     ctrl |= CMA3000_BUSI2C;
>> +#endif
>> +
>> +     CMA3000_SET(data, CMA3000_MDTHR, mdthr, "Motion Detect Threshold");
>> +     CMA3000_SET(data, CMA3000_MDFFTMR, mdfftmr, "Time register");
>> +     CMA3000_SET(data, CMA3000_FFTHR, ffthr, "Free fall threshold");
>> +     ret = CMA3000_SET(data, CMA3000_CTRL, ctrl, "Mode setting");
>> +     if (ret < 0)
>> +             return -EIO;
>> +
>> +     mdelay(CMA3000_SETDELAY);
>
> Why do you use mdelay instead of msleep?  Do you really need to block 
> during this time?

Same comment as previous

>
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL(cma3000_poweron);
> Why do you export this call and expose it in the header file?

This is required for modules to work.

>
>> +
>> +int cma3000_poweroff(struct cma3000_accl_data *data)
>> +{
>> +     int ret;
>> +
>> +     ret = CMA3000_SET(data, CMA3000_CTRL, CMAMODE_POFF, "Mode 
>> setting");
>> +     mdelay(CMA3000_SETDELAY);
>
> Why do you use mdelay instead of msleep?  Do you really need to block 
> during this time?

Same comment as above

>
>> +
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL(cma3000_poweroff);
>
> Why do you export this call and expose it in the header file?

Same comment as above
>
>> +
>> +int cma3000_init(struct cma3000_accl_data *data)
>> +{
>> +     int ret = 0, fuzz_x, fuzz_y, fuzz_z, g_range;
>> +     uint32_t irqflags;
>> +
>> +     if (data->client->dev.platform_data == NULL) {
>> +             dev_err(&data->client->dev, "platform data not found\n");
>> +             goto err_op1_failed;
>> +     }
>> +
>> +     /* if no IRQ return error */
>> +     if (data->client->irq == 0) {
>> +             ret = -ENODEV;
>> +             goto err_op1_failed;
>> +     }
>> +
>> +     memcpy(&(data->pdata), data->client->dev.platform_data,
>> +             sizeof(struct cma3000_platform_data));
>> +
>> +     ret = cma3000_reset(data);
>> +     if (ret)
>> +             goto err_op1_failed;
>> +
>> +     ret = CMA3000_READ(data, CMA3000_REVID, "Revid");
>> +     if (ret < 0)
>> +             goto err_op1_failed;
>> +
>> +     pr_info("CMA3000 Acclerometer : Revision %x\n", ret);
>> +
>> +     /* Bring it out of default power down state */
>> +     ret = cma3000_poweron(data);
>> +     if (ret < 0)
>> +             goto err_op1_failed;
>> +
>> +     fuzz_x = data->pdata.fuzz_x;
>> +     fuzz_y = data->pdata.fuzz_y;
>> +     fuzz_z = data->pdata.fuzz_z;
>> +     g_range = data->pdata.g_range;
>> +     irqflags = data->pdata.irqflags;
>> +
>> +     data->input_dev = input_allocate_device();
>> +     if (data->input_dev == NULL) {
>> +             ret = -ENOMEM;
>> +             dev_err(&data->client->dev,
>> +                     "Failed to allocate input device\n");
>> +             goto err_op1_failed;
>> +     }
>> +
>> +     data->input_dev->name = "cma3000-acclerometer";
>> +
>> +#if defined CONFIG_INPUT_CMA3000_I2C || defined
>> CONFIG_INPUT_CMA3000_I2C_MODULE
>> +     data->input_dev->id.bustype = BUS_I2C;
>> +#endif
>> +
>> +      __set_bit(EV_ABS, data->input_dev->evbit);
>> +      __set_bit(EV_MSC, data->input_dev->evbit);
>> +
>> +     input_set_abs_params(data->input_dev, ABS_X, -g_range,
>> +                             g_range, fuzz_x, 0);
>> +     input_set_abs_params(data->input_dev, ABS_Y, -g_range,
>> +                             g_range, fuzz_y, 0);
>> +     input_set_abs_params(data->input_dev, ABS_Z, -g_range,
>> +                             g_range, fuzz_z, 0);
>> +     input_set_abs_params(data->input_dev, ABS_MISC, 0,
>> +                             1, 0, 0);
>> +
>> +     mutex_init(&data->mutex);
>> +
>> +     ret = request_threaded_irq(data->client->irq, NULL,
>> +                             cma3000_thread_irq,
>> +                             irqflags | IRQF_ONESHOT,
>> +                             data->client->name, data);
>> +
>> +     if (ret < 0) {
>> +             dev_err(&data->client->dev,
>> +                     "request_threaded_irq failed\n");
>> +             goto err_op2_failed;
>> +     }
>> +
>> +     ret = sysfs_create_group(&data->client->dev.kobj,
>> &cma3000_attr_group);
>> +     if (ret) {
>> +             dev_err(&data->client->dev,
>> +                     "failed to create sysfs entries\n");
>> +             goto err_op2_failed;
>> +     }
>> +
>> +     ret = input_register_device(data->input_dev);
>> +     if (ret) {
>> +             dev_err(&data->client->dev,
>> +                     "Unable to register input device\n");
>> +             goto err_op2_failed;
>
> Shouldn't you have and err_op3 here to remove the created group on 
> failure?

Yes this needs to be added, will fix

>
>> +     }
>> +
>> +     return 0;
>> +
>
> These error cases do not seem to be complete.
> Some of the missing cases are the removal of the sysfs group, destroying 
> of the request_thread_irq and freeing of the input device before
> registering it.  I hope these are not handled in a different API this 
> makes the code hard to verify and validate proper error handling.

Yes, will fix sysfs and irq freeing. Freeing for input device refers
to allocation done through input_allocate_device

>
>> +err_op2_failed:
>> +     mutex_destroy(&data->mutex);
>> +err_op1_failed:
>> +     if (data->input_dev != NULL)
>> +             input_free_device(data->input_dev);
>> +
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL(cma3000_init);
>
>
> Why do you export this call and expose it in the header file?

Same comment as above

>
>> +
>> +int cma3000_exit(struct cma3000_accl_data *data)
>> +{
>> +     int ret;
>> +
>> +     ret = cma3000_poweroff(data);
>> +
>> +     if (data->client->irq)
>> +             free_irq(data->client->irq, data);
>> +
>> +     sysfs_remove_group(&data->client->dev.kobj, &cma3000_attr_group);
>> +     mutex_destroy(&data->mutex);
>> +     input_unregister_device(data->input_dev);
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL(cma3000_exit);
>
> Why do you export this call and expose it in the header file?

Same comment as above

>
>> +
>> +MODULE_DESCRIPTION("CMA3000-D0x Accelerometer Driver");
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Hemanth V <hemanthv@ti.com>");
>> diff --git a/drivers/input/misc/cma3000_d0x.h
>> b/drivers/input/misc/cma3000_d0x.h
>> new file mode 100644
>> index 0000000..107b5fa
>> --- /dev/null
>> +++ b/drivers/input/misc/cma3000_d0x.h
>> @@ -0,0 +1,53 @@
>> +/*
>> + * cma3000_d0x.h
>> + * VTI CMA3000_D0x Accelerometer driver
>> + *
>> + * Copyright (C) 2010 Texas Instruments
>> + * Author: Hemanth V <hemanthv@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> it
>> + * under the terms of the GNU General Public License version 2 as
>> published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef _INPUT_CMA3000_H
>> +#define _INPUT_CMA3000_H
>> +
>> +#include <linux/i2c.h>
>> +#include <linux/input.h>
>> +
>> +struct cma3000_accl_data;
>> +
>> +struct cma3000_bus_ops {
>> +     u16 bustype;
>> +     int (*read) (struct cma3000_accl_data *, u8, char *);
>> +     int (*write) (struct cma3000_accl_data *, u8, u8, char *);
>> +};
>> +
>> +struct cma3000_accl_data {
>> +#if defined CONFIG_INPUT_CMA3000_I2C || defined
>> CONFIG_INPUT_CMA3000_I2C_MODULE
>> +     struct i2c_client *client;
>> +#endif
>> +     struct input_dev *input_dev;
>> +     struct cma3000_platform_data pdata;
>> +
>> +     /* mutex for sysfs operations */
>> +     struct mutex mutex;
>> +     const struct cma3000_bus_ops *bus_ops;
>> +     int bit_to_mg;
>> +};
>> +
>> +int cma3000_init(struct cma3000_accl_data *);
>> +int cma3000_exit(struct cma3000_accl_data *);
>> +int cma3000_poweron(struct cma3000_accl_data *);
>> +int cma3000_poweroff(struct cma3000_accl_data *);
>> +
>> +#endif
>> diff --git a/drivers/input/misc/cma3000_d0x_i2c.c
>> b/drivers/input/misc/cma3000_d0x_i2c.c
>> new file mode 100644
>> index 0000000..c605465
>> --- /dev/null
>> +++ b/drivers/input/misc/cma3000_d0x_i2c.c
>> @@ -0,0 +1,144 @@
>> +/*
>> + * cma3000_d0x_i2c.c
>> + *
>> + * Implements I2C interface for VTI CMA300_D0x Accelerometer driver
>> + *
>> + * Copyright (C) 2010 Texas Instruments
>> + * Author: Hemanth V <hemanthv@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> it
>> + * under the terms of the GNU General Public License version 2 as
>> published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/i2c.h>
>> +#include <linux/input/cma3000.h>
>> +#include "cma3000_d0x.h"
>> +
>> +static int cma3000_set(struct cma3000_accl_data *accl, u8 reg, u8 val,
>> +                     char *msg)
>> +{
>> +     int ret = i2c_smbus_write_byte_data(accl->client, reg, val);
>> +     if (ret < 0)
>> +             dev_err(&accl->client->dev,
>> +                     "i2c_smbus_write_byte_data failed (%s)\n", msg);
>> +     return ret;
>> +}
>> +
>> +static int cma3000_read(struct cma3000_accl_data *accl, u8 reg, char
>> *msg)
>> +{
>> +     int ret = i2c_smbus_read_byte_data(accl->client, reg);
>> +     if (ret < 0)
>> +             dev_err(&accl->client->dev,
>> +                     "i2c_smbus_read_byte_data failed (%s)\n", msg);
>> +     return ret;
>> +}
>> +
>> +static const struct cma3000_bus_ops cma3000_i2c_bops = {
>> +     .bustype = BUS_I2C,
>> +     .read = cma3000_read,
>> +     .write = cma3000_set,
>> +};
>> +
>> +static int __devinit cma3000_accl_probe(struct i2c_client *client,
>> +                                     const struct i2c_device_id *id)
>> +{
>> +     int ret;
>> +     struct cma3000_accl_data *data = NULL;
>> +
>> +     data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +     if (data == NULL) {
>> +             ret = -ENOMEM;
>> +             goto err_op_failed;
>> +     }
>> +
>> +     data->client = client;
>> +     i2c_set_clientdata(client, data);
>> +     data->bus_ops = &cma3000_i2c_bops;
>> +
>> +     ret = cma3000_init(data);
>> +     if (ret)
>> +             goto err_op_failed;
>> +
>> +     return 0;
>> +
>> +err_op_failed:
>> +
>> +     if (data != NULL)
>> +             kfree(data);
>> +
>> +     return ret;
>> +}
>> +
>> +static int __devexit cma3000_accl_remove(struct i2c_client *client)
>> +{
>> +     struct cma3000_accl_data *data = i2c_get_clientdata(client);
>> +     int ret;
>> +
>> +     ret = cma3000_exit(data);
>> +     i2c_set_clientdata(client, NULL);
>> +     kfree(data);
>> +
>> +     return ret;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int cma3000_accl_suspend(struct i2c_client *client, pm_message_t
>> mesg)
>> +{
>> +     struct cma3000_accl_data *data = i2c_get_clientdata(client);
>> +
>> +     return cma3000_poweroff(data);
>> +}
>> +
>> +static int cma3000_accl_resume(struct i2c_client *client)
>> +{
>> +     struct cma3000_accl_data *data = i2c_get_clientdata(client);
>> +
>> +     return cma3000_poweron(data);
>> +}
>> +#endif
>> +
>> +static const struct i2c_device_id cma3000_id[] = {
>> +     { "cma3000_d01", 0 },
>> +     { },
>> +};
>> +
>> +static struct i2c_driver cma3000_accl_driver = {
>> +     .probe          = cma3000_accl_probe,
>> +     .remove         = cma3000_accl_remove,
>> +     .id_table       = cma3000_id,
>> +#ifdef CONFIG_PM
>> +     .suspend        = cma3000_accl_suspend,
>> +     .resume         = cma3000_accl_resume,
>
> Nitpicking.  Spacing is off.
>
>> +#endif
>> +     .driver = {
>> +             .name = "cma3000_accl"
>> +     },
>> +};
>> +
>> +static int __init cma3000_accl_init(void)
>> +{
>> +     return i2c_add_driver(&cma3000_accl_driver);
>> +}
>> +
>> +static void __exit cma3000_accl_exit(void)
>> +{
>> +     i2c_del_driver(&cma3000_accl_driver);
>> +}
>> +
>> +module_init(cma3000_accl_init);
>> +module_exit(cma3000_accl_exit);
>> +
>> +MODULE_DESCRIPTION("CMA3000-D0x Accelerometer Driver");
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Hemanth V <hemanthv@ti.com>");
>> diff --git a/include/linux/input/cma3000.h 
>> b/include/linux/input/cma3000.h
>> new file mode 100644
>> index 0000000..a3d9fc7
>> --- /dev/null
>> +++ b/include/linux/input/cma3000.h
>> @@ -0,0 +1,60 @@
>> +/*
>> + * cma3000.h
>> + * VTI CMA300_Dxx Accelerometer driver
>> + *
>> + * Copyright (C) 2010 Texas Instruments
>> + * Author: Hemanth V <hemanthv@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> it
>> + * under the terms of the GNU General Public License version 2 as
>> published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef _LINUX_CMA3000_H
>> +#define _LINUX_CMA3000_H
>> +
>> +#define CMAMODE_DEFAULT    0
>> +#define CMAMODE_MEAS100    1
>> +#define CMAMODE_MEAS400    2
>> +#define CMAMODE_MEAS40     3
>> +#define CMAMODE_MOTDET     4
>> +#define CMAMODE_FF100      5
>> +#define CMAMODE_FF400      6
>> +#define CMAMODE_POFF       7
>> +
>> +#define CMARANGE_2G   2000
>> +#define CMARANGE_8G   8000
>> +
>> +/**
>> + * struct cma3000_i2c_platform_data - CMA3000 Platform data
>> + * @fuzz_x: Noise on X Axis
>> + * @fuzz_y: Noise on Y Axis
>> + * @fuzz_z: Noise on Z Axis
>> + * @g_range: G range in milli g i.e 2000 or 8000
>> + * @mode: Operating mode
>> + * @mdthr: Motion detect threshold value
>> + * @mdfftmr: Motion detect and free fall time value
>> + * @ffthr: Free fall threshold value
>> + */
>> +
>> +struct cma3000_platform_data {
>> +     int fuzz_x;
>> +     int fuzz_y;
>> +     int fuzz_z;
>> +     int g_range;
>> +     uint8_t  mode;
>> +     uint8_t  mdthr;
>> +     uint8_t  mdfftmr;
>> +     uint8_t  ffthr;
>> +     uint32_t  irqflags;
>> +};
>> +
>> +#endif
>> --


