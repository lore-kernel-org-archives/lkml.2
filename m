Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0GBKMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:12:08 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:55903 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0GBKMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:12:06 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C2DBBE3.1020804@cam.ac.uk>
Date: Fri, 02 Jul 2010 11:13:55 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
       "sfking@fdwdc.com" <sfking@fdwdc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] digital compass hmc5843
References: <0680EC522D0CC943BC586913CF3768C003B360319D@dbde02.ent.ti.com> <4C2CBB40.5070104@cam.ac.uk> <0680EC522D0CC943BC586913CF3768C003B3603331@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003B3603331@dbde02.ent.ti.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
>>> + * From Datasheet
>>> + * The table shows the minimum data output
>>> + * Value       | Minimum data output rate(Hz)
>>> + * 0           | 0.5
>>> + * 1           | 1
>>> + * 2           | 2
>>> + * 3           | 5
>>> + * 4           | 10 (default)
>>> + * 5           | 20
>>> + * 6           | 50
>>> + * 7           | Not used
>>> + */
>> Thanks for chaning this, but the abi does specifiy units....
>>> +static ssize_t show_avail_samp_freq(struct device *dev,
>>> +                       struct device_attribute *attr, char *buf)
>>> +{
>>> +       char freq[] = {"5 , 10, 20, 50, 100, 200 ,500"};
>>> +       return sprintf(buf, "In units of 1/10 hz: %s\n", freq);
>> Gah.  This has to be machine readable or no userspace program
>> is ever going to be able to use it.  So a simple list. The abi
>> specifies the units (Hz).
>>> +}
>> The IIO_CONST_ATTR macro makes this easy. There is even a convenient
>> macro for this case.
> 
> I think that having a Hz as units will have its own issues. First the decimal implementation. However I am open to the implementation.
> Also do you know of a driver that takes care of this.
None of the current drivers go below 1Hz so not quite the same.
lis3l02dq (accelerometer) does the match against a list, but it
is done numerically rather than via string matches as would be needed
here.
> 
>>
>> static IIO_CONST_ATTR_SAMP_FREQ_AVAIL("0.5 1 2 5 10 20 50");
>>
>>
>> Then strncmp with the options to set the value up.  The rounding approach
>> gets tricky with a non integer value so probably easier to only allow
>> these
>> values.
> 
> Allowing only this value will result in default/ reject case and will keep the previous value, may confuse the application
Then the application is ignoring the interface spec that says it must read _available files if they are there.
This way the rounding behaviour is left to userspace and what the application prefers rather
than in kernel actually making it the most flexible option.
> 
>>
>>> +static IIO_DEV_ATTR_AVAIL_SAMP_FREQ(show_avail_samp_freq);
>>> +
>>> +static s32 hmc5843_set_rate(struct i2c_client *client,
>>> +                               u8 rate)
>>> +{
>>> +       struct hmc5843_data *data = i2c_get_clientdata(client);
>>> +       u8 reg_val;
>>> +
>>> +       reg_val = (data->meas_conf) |  (rate << RATE_OFFSET);
>>> +       if (rate >= RATE_NOT_USED) {
>>> +               dev_err(&client->dev,
>>> +                       "This data output rate is not supported \n");
>>> +               return -EINVAL;
>>> +       }
>>> +       return i2c_smbus_write_byte_data(client, HMC5843_CONFIG_REG_A,
>> reg_val);
>>> +}
>>> +
>>> +static ssize_t set_sampling_frequency(struct device *dev,
>>> +                                       struct device_attribute *attr,
>>> +                                       const char *buf, size_t count)
>>> +{
>>> +
>>> +       struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +       struct i2c_client *client = to_i2c_client(indio_dev-
>>> dev.parent);
>>> +       struct hmc5843_data *data = i2c_get_clientdata(client);
>>> +       unsigned long rate = 0;
>>> +       unsigned long reg_val;
>>> +       int error;
>>> +
>>> +       error = strict_strtoul(buf, 10, &rate);
>>> +       if (error)
>>> +               return error;
>>> +       if (rate < 10)
>>> +               reg_val = RATE_5;
>>> +       else if (rate < 20)
>>> +               reg_val = RATE_10;
>>> +       else if (rate < 50)
>>> +               reg_val = RATE_20;
>>> +       else if (rate < 100)
>>> +               reg_val = RATE_50;
>>> +       else if (rate < 200)
>>> +               reg_val = RATE_100;
>>> +       else if (rate < 500)
>>> +               reg_val = RATE_200;
>>> +       else
>>> +               reg_val = RATE_500;
>>> +
>>> +       dev_dbg(dev, "set rate to %lu\n", reg_val);
>>> +       if (hmc5843_set_rate(client, reg_val) == -EINVAL)
>>> +               return -EINVAL;
>>> +       data->rate = rate;
>>> +       return count;
>>> +}
>>> +
>>> +static ssize_t show_sampling_frequency(struct device *dev,
>>> +                       struct device_attribute *attr, char *buf)
>>> +{
>>> +       struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +       struct i2c_client *client = to_i2c_client(indio_dev-
>>> dev.parent);
>>> +       struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
>>> +       u32 rate;
>>> +
>>> +       rate = i2c_smbus_read_byte_data(client,  this_attr->address);
>>> +       if (rate < 0)
>>> +               return -EINVAL;
>>> +       rate = (rate & RATE_BITMASK) >> RATE_OFFSET;
>> This also becomes a query into a string array to allow that 0.5 value.
>>> +       return sprintf(buf, "%d\n", samp_freq_to_regval[rate]);
>>> +}
>>> +static IIO_DEVICE_ATTR(sampling_frequency,
>>> +                       S_IWUSR | S_IRUGO,
>>> +                       show_sampling_frequency,
>>> +                       set_sampling_frequency,
>>> +                       HMC5843_CONFIG_REG_A);
>>
>> It isn't always helpful to just have documentation like this in the
>> kernel code. Please add an abi description to staging/iio/Documentation/
>>
>> Also, if at all possible, can get this to conform to equivalent of
>> in0_scale (see the sysfs-class-iio file). Abi says that magn parameters
>> are to be converted to Gauss (maybe we should make that milli-gauss?)
>>
> I would like to see milli units as we generally take the hwmon approach and most of the units there are milli.
Agreed. I'll check with Barry Song (writer of other exising driver) before changing it.
> 
>> Thus we need an additional attribute saying what is available.
>>
>> static IIO_CONST_ATTR(magn_scale_available, "0.000000617284 0.00000076923
>> <others> 0.00000357143");
>> The numbers correspond to A where value_in_gauss=A*raw_reading + B/
>>
>> We then match against these exact values (or go for nearest) on the
>> gain_store
>> and output the relevant value on gain_show.
>>
>> Although these values correspond directly to table 12 in the datasheet,
>> I'm
>> a little confused by this table. Perhaps you can clarify?
>>
>> Take the top line, Maximum value is 2047 counts.  So if we have 1620
>> counts/ milli gauss
>> then this equals a couple of milli gauss not 0.7 gauss?
> 
> My understanding is that the range and gain are trade off between the range of the field it is sensitive to and the granularity of the reported values.
Agreed, but my point stands.  The two columns cannot both be true.
If one has a range 0.7 gauss then one cannot have a gain of 1620 counts per milli g without
a lot more accurate adc.  There simply aren't enough bits.
>>> +/*
>>> + * From Datasheet
>>> + *     Nominal gain settings
>>> + * Value       | Sensor Input Field Range(Ga)  | Gain(counts/ milli-
>> gauss)
>>> + *0            |(+-)0.7                        |1620
>>> + *1            |(+-)1.0                        |1300
>>> + *2            |(+-)1.5                        |970
>>> + *3            |(+-)2.0                        |780
>>> + *4            |(+-)3.2                        |530
>>> + *5            |(+-)3.8                        |460
>>> + *6            |(+-)4.5                        |390
>>> + *7            |(+-)6.5                        |280
>>> + */
>>> +static ssize_t show_range(struct device *dev,
>>> +                               struct device_attribute *attr,
>>> +                               char *buf)
>>> +{
>>> +       u8 range;
>>> +       struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +       struct i2c_client *client = to_i2c_client(indio_dev-
>>> dev.parent);
>>> +       struct hmc5843_data *data = i2c_get_clientdata(client);
>>> +
>>> +       range = data->range;
>> No units please.  That just makes things tricky for userspace whilst
>> giving no
>> additional information as the ABI specifies the allowed units.  You also
>> encourage
>> people to apply units to the values they write to these attributes.
>>> +       return sprintf(buf, " %dmGa\n",
>> regval_to_input_field_mg[range]);
>>> +}
>>> +
>>> +static ssize_t set_range(struct device *dev,
>>> +                       struct device_attribute *attr,
>>> +                       const char *buf,
>>> +                       size_t count)
>>> +{
>>> +       struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +       struct i2c_client *client = to_i2c_client(indio_dev-
>>> dev.parent);
>>> +       struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
>>> +       struct hmc5843_data *data = i2c_get_clientdata(client);
>>> +       unsigned long range = 0;
>>> +       int error;
>>> +
>>> +       error = strict_strtoul(buf, 10, &range);
>>> +       if (error)
>>> +               return error;
>>> +       dev_dbg(dev, "set range to %lu\n", range);
>>> +
>>> +       if (range > RANGE_6_5)
>>> +               return -EINVAL;
>>> +
>>> +       data->range = range;
>>> +       range = range << RANGE_GAIN_OFFSET;
>>> +       if (i2c_smbus_write_byte_data(client, this_attr->address, range)
>> ==
>>> +
>> -EINVAL)
>>> +               return -EINVAL;
>>> +
>>> +       return count;
>>> +}
>>> +
>>> +static IIO_DEVICE_ATTR(magn_range,
>>> +                       S_IWUSR | S_IRUGO,
>>> +                       show_range,
>>> +                       set_range,
>>> +                       HMC5843_CONFIG_REG_B);
>>> +
>>> +static ssize_t show_gain(struct device *dev,
>>> +                       struct device_attribute *attr,
>>> +                       char *buf)
>>> +{
>>> +       struct iio_dev *indio_dev = dev_get_drvdata(dev);
>>> +       struct i2c_client *client = to_i2c_client(indio_dev-
>>> dev.parent);
>>> +       struct hmc5843_data *data = i2c_get_clientdata(client);
>>> +       return sprintf(buf, "%d\n", regval_to_counts_per_mg[data-
>>> range]);
>>> +}
>>> +static IIO_DEVICE_ATTR(magn_gain, S_IRUGO, show_gain, NULL , 0);
>>> +
>>> +
>>> +static struct attribute *hmc5843_attributes[] = {
>>> +       &iio_dev_attr_meas_conf.dev_attr.attr,
>>> +       &iio_dev_attr_operating_mode.dev_attr.attr,
>>> +       &iio_dev_attr_sampling_frequency.dev_attr.attr,
>>> +       &iio_dev_attr_magn_range.dev_attr.attr,
>>> +       &iio_dev_attr_magn_gain.dev_attr.attr,
>>> +       &iio_dev_attr_magn_x_raw.dev_attr.attr,
>>> +       &iio_dev_attr_magn_y_raw.dev_attr.attr,
>>> +       &iio_dev_attr_magn_z_raw.dev_attr.attr,
>>> +       &iio_dev_attr_available_sampling_frequency.dev_attr.attr,
>>> +       NULL
>>> +};
>>> +
>>> +static const struct attribute_group hmc5843_group = {
>>> +       .attrs = hmc5843_attributes,
>>> +};
>>> +
>>> +static int hmc5843_detect(struct i2c_client *client,
>>> +                         struct i2c_board_info *info)
>>> +{
>>> +       unsigned char id_str[HMC5843_ID_REG_LENGTH];
>>> +
>>> +       if (client->addr != HMC5843_I2C_ADDRESS)
>>> +               return -ENODEV;
>>> +
>>> +       if (i2c_smbus_read_i2c_block_data(client, HMC5843_ID_REG_A,
>>> +                               HMC5843_ID_REG_LENGTH, id_str)
>>> +                       != HMC5843_ID_REG_LENGTH)
>>> +               return -ENODEV;
>>> +
>>> +       if (0 != strncmp(id_str, HMC5843_ID_STRING,
>> HMC5843_ID_REG_LENGTH))
>>> +               return -ENODEV;
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +/* Called when we have found a new HMC5843. */
>>> +static void hmc5843_init_client(struct i2c_client *client)
>>> +{
>>> +       struct hmc5843_data *data = i2c_get_clientdata(client);
>>> +       hmc5843_set_meas_conf(client, data->meas_conf);
>>> +       hmc5843_set_rate(client, data->rate);
>>> +       hmc5843_configure(client, data->operating_mode);
>>> +       i2c_smbus_write_byte_data(client, HMC5843_CONFIG_REG_B, data-
>>> range);
>>> +       pr_info("HMC5843 initialized\n");
>>> +}
>>> +
>>> +static int hmc5843_probe(struct i2c_client *client,
>>> +                        const struct i2c_device_id *id)
>>> +{
>>> +       struct hmc5843_data *data;
>>> +       int err = 0;
>>> +
>>> +       data = kzalloc(sizeof(struct hmc5843_data), GFP_KERNEL);
>>> +       if (!data) {
>>> +               err = -ENOMEM;
>>> +               goto exit;
>>> +       }
>>> +
>>> +       /* default settings at probe */
>>> +
>>> +       data->meas_conf = CONF_NORMAL;
>>> +       data->range = RANGE_1_0;
>>> +       data->operating_mode = MODE_CONVERSION_CONTINUOUS;
>>> +
>>> +       i2c_set_clientdata(client, data);
>>> +
>>> +       /* Initialize the HMC5843 chip */
>>> +       hmc5843_init_client(client);
>>> +
>>> +       data->indio_dev = iio_allocate_device();
>>> +       if (!data->indio_dev) {
>>> +               err = -ENOMEM;
>>> +               goto exit_free;
>>> +       }
>>> +       data->indio_dev->attrs = &hmc5843_group;
>>> +       data->indio_dev->dev.parent = &client->dev;
>>> +       data->indio_dev->dev_data = (void *)(data);
>>> +       data->indio_dev->driver_module = THIS_MODULE;
>>> +       data->indio_dev->modes = INDIO_DIRECT_MODE;
>>> +       err = iio_device_register(data->indio_dev);
>>> +       if (err)
>>> +               goto exit_free;
>>> +       return 0;
>>> +exit_free:
>>> +       kfree(data);
>>> +exit:
>>> +       return err;
>>> +}
>>> +
>>> +static int hmc5843_remove(struct i2c_client *client)
>>> +{
>>> +       struct hmc5843_data *data = i2c_get_clientdata(client);
>>> +        /*  sleep mode to save power */
>>> +       hmc5843_configure(client, MODE_SLEEP);
>>> +       iio_device_unregister(data->indio_dev);
>>> +       sysfs_remove_group(&client->dev.kobj, &hmc5843_group);
>>> +       kfree(i2c_get_clientdata(client));
>>> +       return 0;
>>> +}
>>> +
>>> +static int hmc5843_suspend(struct i2c_client *client, pm_message_t
>> mesg)
>>> +{
>>> +       hmc5843_configure(client, MODE_SLEEP);
>>> +       return 0;
>>> +}
>>> +
>>> +static int hmc5843_resume(struct i2c_client *client)
>>> +{
>>> +       struct hmc5843_data *data = i2c_get_clientdata(client);
>>> +       hmc5843_configure(client, data->operating_mode);
>>> +       return 0;
>>> +}
>>> +
>>> +static const struct i2c_device_id hmc5843_id[] = {
>>> +       { "hmc5843", 0 },
>>> +       { }
>>> +};
>>> +
>>> +static struct i2c_driver hmc5843_driver = {
>>> +       .driver = {
>>> +               .name   = "hmc5843",
>>> +       },
>>> +       .id_table       = hmc5843_id,
>>> +       .probe          = hmc5843_probe,
>>> +       .remove         = hmc5843_remove,
>>> +       .detect         = hmc5843_detect,
>>> +       .address_list   = normal_i2c,
>>> +       .suspend        = hmc5843_suspend,
>>> +       .resume         = hmc5843_resume,
>>> +};
>>> +
>>> +static int __init hmc5843_init(void)
>>> +{
>> You still need to remove this pair of printks.
>>> +       printk(KERN_INFO "init!\n");
>>> +       return i2c_add_driver(&hmc5843_driver);
>>> +}
>>> +
>>> +static void __exit hmc5843_exit(void)
>>> +{
>>> +       printk(KERN_INFO "exit!\n");
>>> +       i2c_del_driver(&hmc5843_driver);
>>> +}
>>> +
>>> +MODULE_AUTHOR("Shubhrajyoti Datta <shubhrajyoti@ti.com");
>>> +MODULE_DESCRIPTION("HMC5843 driver");
>>> +MODULE_LICENSE("GPL");
>>> +
>>> +module_init(hmc5843_init);
>>> +module_exit(hmc5843_exit);
>>> --
>>> 1.5.4.7
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> 
> 

