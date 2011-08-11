Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab1HKRrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:47:55 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58639 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1HKRrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:47:53 -0400
Subject: Re: [PATCH v2] hwmon: add caseopen detection to w83627ehf driver
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Ian Dobson <i.dobson@planet-ian.com>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1313009786-29885-1-git-send-email-mad_soft@inbox.ru>
References: <1313009786-29885-1-git-send-email-mad_soft@inbox.ru>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 11 Aug 2011 10:46:54 -0700
Message-ID: <1313084814.2214.100.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 16:56 -0400, Dmitry Artamonow wrote:
> Export caseopen alarm status into userspace for Winbond W83627*
> and Nuvoton NCT677[56] chips and implement alarm clear knob.
> Second caseopen alarm on NCT6776 is also supported.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

Hi Dmitry,

please consider the changes suggested below.

Thanks,
Guenter

> ---
>  drivers/hwmon/w83627ehf.c |   80 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 80 insertions(+), 0 deletions(-)
> 
> Changes from v1:
> * support for Nuvoton NCT677[56] is added (including second caseopen on NCT6776)
> * now data->caseopen contains raw register value, extraction of needed bits
>   is done in show_caseopen()
> * store_caseopen_clear() is renamed to clear_caseopen()
> 
> diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
> index f2b377c..6964b15 100644
> --- a/drivers/hwmon/w83627ehf.c
> +++ b/drivers/hwmon/w83627ehf.c
> @@ -197,6 +197,9 @@ static const u16 W83627EHF_REG_TEMP_CONFIG[] = { 0, 0x152, 0x252, 0 };
>  #define W83627EHF_REG_ALARM2		0x45A
>  #define W83627EHF_REG_ALARM3		0x45B
>  
> +#define W83627EHF_REG_CASEOPEN_DET	0x42 /* SMI STATUS #2 */
> +#define W83627EHF_REG_CASEOPEN_CLR	0x46 /* SMI MASK #3 */
> +
>  /* SmartFan registers */
>  #define W83627EHF_REG_FAN_STEPUP_TIME 0x0f
>  #define W83627EHF_REG_FAN_STEPDOWN_TIME 0x0e
> @@ -468,6 +471,7 @@ struct w83627ehf_data {
>  	s16 temp_max[9];
>  	s16 temp_max_hyst[9];
>  	u32 alarms;
> +	u8 caseopen;
>  
>  	u8 pwm_mode[4]; /* 0->DC variable voltage, 1->PWM variable duty cycle */
>  	u8 pwm_enable[4]; /* 1->manual
> @@ -873,6 +877,9 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
>  			       (w83627ehf_read_value(data,
>  					W83627EHF_REG_ALARM3) << 16);
>  
> +		data->caseopen = w83627ehf_read_value(data,
> +						W83627EHF_REG_CASEOPEN_DET);
> +
>  		data->last_updated = jiffies;
>  		data->valid = 1;
>  	}
> @@ -1654,6 +1661,66 @@ show_vid(struct device *dev, struct device_attribute *attr, char *buf)
>  }
>  static DEVICE_ATTR(cpu0_vid, S_IRUGO, show_vid, NULL);
>  
> +
> +/* Case open detection */
> +
> +static ssize_t
> +show_caseopen(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct w83627ehf_data *data = w83627ehf_update_device(dev);
> +	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
> +	int nr = sensor_attr->index;
> +	switch (nr) {
> +	case 0:
> +		return sprintf(buf, "%d\n", (data->caseopen >> 4) & 0x1);
> +	case 1:
> +		return sprintf(buf, "%d\n", (data->caseopen >> 6) & 0x1);
> +	default:
> +		return -ENXIO;
> +	}

	struct w83627ehf_data *data = w83627ehf_update_device(dev);
	
	return sprintf(buf, "%d", 
		!!(data->caseopen & to_sensor_dev_attr_2(attr)->index));

> +}
> +
> +static ssize_t
> +clear_caseopen(struct device *dev, struct device_attribute *attr,
> +			const char *buf, size_t count)
> +{
> +	struct w83627ehf_data *data = dev_get_drvdata(dev);
> +	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
> +	int nr = sensor_attr->index;
> +	unsigned long val;
> +	unsigned int reg, mask = 0;

Initializing mask is unnecessary, and sensor_attr / nr variables are not
really necessary - see below.

> +
> +	if (strict_strtoul(buf, 10, &val) || val != 0)
> +		return -EINVAL;
> +
> +	switch (nr) {
> +	case 0:
> +		mask = 0x80;
> +		break;
> +	case 1:
> +		mask = 0x40;
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
> +
	
	mask = to_sensor_dev_attr_2(attr)->nr;

> +	mutex_lock(&data->update_lock);
> +	reg = w83627ehf_read_value(data, W83627EHF_REG_CASEOPEN_CLR);
> +	w83627ehf_write_value(data, W83627EHF_REG_CASEOPEN_CLR, reg | mask);
> +	w83627ehf_write_value(data, W83627EHF_REG_CASEOPEN_CLR, reg & ~mask);
> +	data->valid = 0;	/* Force cache refresh */
> +	mutex_unlock(&data->update_lock);
> +
> +	return count;
> +}
> +
> +static struct sensor_device_attribute sda_caseopen[] = {
> +	SENSOR_ATTR(intrusion0_alarm, S_IWUSR | S_IRUGO, show_caseopen,
> +			clear_caseopen, 0),
> +	SENSOR_ATTR(intrusion1_alarm, S_IWUSR | S_IRUGO, show_caseopen,
> +			clear_caseopen, 1),

	SENSOR_ATTR_2(intrusion0_alarm, S_IWUSR | S_IRUGO,
			show_caseopen, clear_caseopen, 0x80, 0x10),
	SENSOR_ATTR_2(intrusion1_alarm, S_IWUSR | S_IRUGO,
			show_caseopen, clear_caseopen, 0x40, 0x40),

> +};
> +
>  /*
>   * Driver and device management
>   */
> @@ -1710,6 +1777,9 @@ static void w83627ehf_device_remove_files(struct device *dev)
>  		device_remove_file(dev, &sda_temp_type[i].dev_attr);
>  	}
>  
> +	device_remove_file(dev, &sda_caseopen[0].dev_attr);
> +	device_remove_file(dev, &sda_caseopen[1].dev_attr);
> +
>  	device_remove_file(dev, &dev_attr_name);
>  	device_remove_file(dev, &dev_attr_cpu0_vid);
>  }
> @@ -2261,6 +2331,16 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
>  			goto exit_remove;
>  	}
>  
> +	err = device_create_file(dev, &sda_caseopen[0].dev_attr);
> +	if (err)
> +		goto exit_remove;
> +
> +	if (sio_data->kind == nct6776) {
> +		err = device_create_file(dev, &sda_caseopen[1].dev_attr);
> +		if (err)
> +			goto exit_remove;
> +	}
> +
>  	err = device_create_file(dev, &dev_attr_name);
>  	if (err)
>  		goto exit_remove;


