Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0CXIYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:24:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab0CXIYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:24:40 -0400
Message-ID: <4BA9CC64.5010807@redhat.com>
Date: Wed, 24 Mar 2010 09:25:08 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Thunderbird/3.0.1
MIME-Version: 1.0
To: Giel van Schijndel <me@mortis.eu>
CC: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] [RFC] hwmon: f71882fg: Add support for the Fintek
 F71808E
References: <20100323141718.GA23172@salidar.me.mortis.eu> <1269385936-3440-1-git-send-email-me@mortis.eu>
In-Reply-To: <1269385936-3440-1-git-send-email-me@mortis.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

See comments inline.

On 03/24/2010 12:12 AM, Giel van Schijndel wrote:
> Allow device probing to recognise the Fintek F71808E.
>
> Sysfs interface:
>   * Fan/pwm control is the same as for F71889FG
>   * Temperature and voltage sensor handling is largely the same as for
>     the F71889FG
>    - Has one temperature sensor less (doesn't have temp3)
>    - Misses one voltage sensor (doesn't have V6, thus in6_input refers to
>      what in7_input refers for F71889FG)
>
> For the purpose of the sysfs interface fxxxx_in_temp_attr[] is split up
> such that it can largely be reused.
> ---
>   Documentation/hwmon/f71882fg |    4 ++
>   drivers/hwmon/Kconfig        |    6 ++--
>   drivers/hwmon/f71882fg.c     |   80 +++++++++++++++++++++++++++++++++++++----
>   3 files changed, 79 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/hwmon/f71882fg b/Documentation/hwmon/f71882fg
> index a7952c2..1a07fd6 100644
> --- a/Documentation/hwmon/f71882fg
> +++ b/Documentation/hwmon/f71882fg
> @@ -2,6 +2,10 @@ Kernel driver f71882fg
>   ======================
>
>   Supported chips:
> +  * Fintek F71808E
> +    Prefix: 'f71808fg'
> +    Addresses scanned: none, address read from Super I/O config space
> +    Datasheet: Not public
>     * Fintek F71858FG
>       Prefix: 'f71858fg'
>       Addresses scanned: none, address read from Super I/O config space
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index e4595e6..7053608 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -332,11 +332,11 @@ config SENSORS_F71805F
>   	  will be called f71805f.
>
>   config SENSORS_F71882FG
> -	tristate "Fintek F71858FG, F71862FG, F71882FG, F71889FG and F8000"
> +	tristate "Fintek F71808E, F71858FG, F71862FG, F71882FG, F71889FG and F8000"
>   	depends on EXPERIMENTAL
>   	help
> -	  If you say yes here you get support for hardware monitoring
> -	  features of the Fintek F71858FG, F71862FG/71863FG, F71882FG/F71883FG,
> +	  If you say yes here you get support for hardware monitoring features
> +	  of the Fintek F71808E, F71858FG, F71862FG/71863FG, F71882FG/F71883FG,
>   	  F71889FG and F8000 Super-I/O chips.
>
>   	  This driver can also be built as a module.  If so, the module
> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
> index 25e1cad..b290b87 100644
> --- a/drivers/hwmon/f71882fg.c
> +++ b/drivers/hwmon/f71882fg.c
> @@ -45,6 +45,7 @@
>   #define SIO_REG_ADDR		0x60	/* Logical device address (2 bytes) */
>
>   #define SIO_FINTEK_ID		0x1934	/* Manufacturers ID */
> +#define SIO_F71808_ID		0x0901  /* Chipset ID */
>   #define SIO_F71858_ID		0x0507  /* Chipset ID */
>   #define SIO_F71862_ID		0x0601	/* Chipset ID */
>   #define SIO_F71882_ID		0x0541	/* Chipset ID */
> @@ -96,9 +97,10 @@ static unsigned short force_id;
>   module_param(force_id, ushort, 0);
>   MODULE_PARM_DESC(force_id, "Override the detected device ID");
>
> -enum chips { f71858fg, f71862fg, f71882fg, f71889fg, f8000 };
> +enum chips { f71808fg, f71858fg, f71862fg, f71882fg, f71889fg, f8000 };
>
>   static const char *f71882fg_names[] = {
> +	"f71808fg",
>   	"f71858fg",
>   	"f71862fg",
>   	"f71882fg",
> @@ -306,8 +308,8 @@ static struct sensor_device_attribute_2 f71858fg_in_temp_attr[] = {
>   	SENSOR_ATTR_2(temp3_fault, S_IRUGO, show_temp_fault, NULL, 0, 2),
>   };
>
> -/* Temp and in attr common to the f71862fg, f71882fg and f71889fg */
> -static struct sensor_device_attribute_2 fxxxx_in_temp_attr[] = {
> +/* In attr common to the f71862fg, f71882fg and f71889fg */
> +static struct sensor_device_attribute_2 fxxxx_in_attr[] = {
>   	SENSOR_ATTR_2(in0_input, S_IRUGO, show_in, NULL, 0, 0),
>   	SENSOR_ATTR_2(in1_input, S_IRUGO, show_in, NULL, 0, 1),
>   	SENSOR_ATTR_2(in2_input, S_IRUGO, show_in, NULL, 0, 2),
> @@ -317,6 +319,22 @@ static struct sensor_device_attribute_2 fxxxx_in_temp_attr[] = {
>   	SENSOR_ATTR_2(in6_input, S_IRUGO, show_in, NULL, 0, 6),
>   	SENSOR_ATTR_2(in7_input, S_IRUGO, show_in, NULL, 0, 7),
>   	SENSOR_ATTR_2(in8_input, S_IRUGO, show_in, NULL, 0, 8),
> +};
> +
> +/* In attr for the f71808fg */
> +static struct sensor_device_attribute_2 f71808_in_attr[] = {
> +	SENSOR_ATTR_2(in0_input, S_IRUGO, show_in, NULL, 0, 0),
> +	SENSOR_ATTR_2(in1_input, S_IRUGO, show_in, NULL, 0, 1),
> +	SENSOR_ATTR_2(in2_input, S_IRUGO, show_in, NULL, 0, 2),
> +	SENSOR_ATTR_2(in3_input, S_IRUGO, show_in, NULL, 0, 3),
> +	SENSOR_ATTR_2(in4_input, S_IRUGO, show_in, NULL, 0, 4),
> +	SENSOR_ATTR_2(in5_input, S_IRUGO, show_in, NULL, 0, 5),
> +	SENSOR_ATTR_2(in6_input, S_IRUGO, show_in, NULL, 0, 7),
> +	SENSOR_ATTR_2(in7_input, S_IRUGO, show_in, NULL, 0, 8),
> +};
> +
> +/* Temp attr common to the f71808fg, f71862fg, f71882fg and f71889fg */
> +static struct sensor_device_attribute_2 fxxxx_temp_attr[] = {
>   	SENSOR_ATTR_2(temp1_input, S_IRUGO, show_temp, NULL, 0, 1),
>   	SENSOR_ATTR_2(temp1_max, S_IRUGO|S_IWUSR, show_temp_max,
>   		store_temp_max, 0, 1),
> @@ -355,6 +373,10 @@ static struct sensor_device_attribute_2 fxxxx_in_temp_attr[] = {
>   		store_temp_beep, 0, 6),
>   	SENSOR_ATTR_2(temp2_type, S_IRUGO, show_temp_type, NULL, 0, 2),
>   	SENSOR_ATTR_2(temp2_fault, S_IRUGO, show_temp_fault, NULL, 0, 2),
> +};
> +
> +/* Temp and in attr common to the f71862fg, f71882fg and f71889fg */
> +static struct sensor_device_attribute_2 f71862_temp_attr[] = {
>   	SENSOR_ATTR_2(temp3_input, S_IRUGO, show_temp, NULL, 0, 3),
>   	SENSOR_ATTR_2(temp3_max, S_IRUGO|S_IWUSR, show_temp_max,
>   		store_temp_max, 0, 3),
> @@ -989,6 +1011,11 @@ static struct f71882fg_data *f71882fg_update_device(struct device *dev)
>   				data->temp_type[1] = 6;
>   				break;
>   			}
> +		} else if (data->type == f71808fg) {
> +			reg  = f71882fg_read8(data, F71882FG_REG_TEMP_TYPE);
> +			data->temp_type[1] = (reg&  0x02) ? 2 : 4;
> +			data->temp_type[2] = (reg&  0x04) ? 2 : 4;
> +
>   		} else {
>   			reg2 = f71882fg_read8(data, F71882FG_REG_PECI);
>   			if ((reg2&  0x03) == 0x01)
> @@ -1871,7 +1898,8 @@ static ssize_t store_pwm_auto_point_temp(struct device *dev,
>
>   	val /= 1000;
>
> -	if (data->type == f71889fg)
> +	if (data->type == f71889fg
> +	 || data->type == f71808fg)
>   		val = SENSORS_LIMIT(val, -128, 127);
>   	else
>   		val = SENSORS_LIMIT(val, 0, 127);
> @@ -1974,8 +2002,27 @@ static int __devinit f71882fg_probe(struct platform_device *pdev)
>   			/* fall through! */
>   		case f71862fg:
>   			err = f71882fg_create_sysfs_files(pdev,
> -					fxxxx_in_temp_attr,
> -					ARRAY_SIZE(fxxxx_in_temp_attr));
> +					f71862_temp_attr,
> +					ARRAY_SIZE(f71862_temp_attr));
> +			if (err)
> +				goto exit_unregister_sysfs;
> +			err = f71882fg_create_sysfs_files(pdev,
> +					fxxxx_in_attr,
> +					ARRAY_SIZE(fxxxx_in_attr));
> +			if (err)
> +				goto exit_unregister_sysfs;
> +			/* fall through! */

Ugh, please don't fall through, and then have an if below to only do
some parts of the case falling through. This is quite confusing
at first I thought your code was buggy I had to read it twice to notice
the if. Instead just duplicate the following lines:
 > +			err = f71882fg_create_sysfs_files(pdev,
 > +					fxxxx_temp_attr,
 > +					ARRAY_SIZE(fxxxx_temp_attr));
In the f71862fg case, end the f71862fg case with a break and remove
the if test from the f71808fg case.

> +		case f71808fg:
> +			if (data->type == f71808fg) {
> +				err = f71882fg_create_sysfs_files(pdev,
> +						f71808_in_attr,
> +						ARRAY_SIZE(f71808_in_attr));
> +				if (err)
> +					goto exit_unregister_sysfs;
> +			}
> +			err = f71882fg_create_sysfs_files(pdev,
> +					fxxxx_temp_attr,
> +					ARRAY_SIZE(fxxxx_temp_attr));
>   			break;
>   		case f8000:
>   			err = f71882fg_create_sysfs_files(pdev,
> @@ -2002,6 +2049,7 @@ static int __devinit f71882fg_probe(struct platform_device *pdev)
>   		case f71862fg:
>   			err = (data->pwm_enable&  0x15) != 0x15;
>   			break;
> +		case f71808fg:
>   		case f71882fg:
>   		case f71889fg:
>   			err = 0;
> @@ -2047,6 +2095,7 @@ static int __devinit f71882fg_probe(struct platform_device *pdev)
>   					f8000_auto_pwm_attr,
>   					ARRAY_SIZE(f8000_auto_pwm_attr));
>   			break;
> +		case f71808fg:
>   		case f71889fg:
>   			for (i = 0; i<  nr_fans; i++) {
>   				data->pwm_auto_point_mapping[i] =
> @@ -2126,8 +2175,20 @@ static int f71882fg_remove(struct platform_device *pdev)
>   			/* fall through! */
>   		case f71862fg:
>   			f71882fg_remove_sysfs_files(pdev,
> -					fxxxx_in_temp_attr,
> -					ARRAY_SIZE(fxxxx_in_temp_attr));
> +					f71862_temp_attr,
> +					ARRAY_SIZE(f71862_temp_attr));
> +			f71882fg_remove_sysfs_files(pdev,
> +					fxxxx_in_attr,
> +					ARRAY_SIZE(fxxxx_in_attr));
> +			/* fall through! */


Idem.

> +		case f71808fg:
> +			if (data->type == f71808fg)
> +				f71882fg_remove_sysfs_files(pdev,
> +						f71808_in_attr,
> +						ARRAY_SIZE(f71808_in_attr));
> +			f71882fg_remove_sysfs_files(pdev,
> +					fxxxx_temp_attr,
> +					ARRAY_SIZE(fxxxx_temp_attr));
>   			break;
>   		case f8000:
>   			f71882fg_remove_sysfs_files(pdev,
> @@ -2195,6 +2256,9 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
>
>   	devid = force_id ? force_id : superio_inw(sioaddr, SIO_REG_DEVID);
>   	switch (devid) {
> +	case SIO_F71808_ID:
> +		sio_data->type = f71808fg;
> +		break;
>   	case SIO_F71858_ID:
>   		sio_data->type = f71858fg;
>   		break;

Regards,

Hans
