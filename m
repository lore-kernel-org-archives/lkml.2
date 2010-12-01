Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0LALWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:22:00 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:50011 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0LALV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:21:58 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4CF6316D.5090402@cam.ac.uk>
Date: Wed, 01 Dec 2010 11:28:45 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101123 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Chethan Krishna N <chethan.krishna@stericsson.com>
CC: khali@linux-fr.org, guenter.roeck@ericsson.com, linus.walleij@linaro.org,
        preetham.rao@stericsson.com, linux-kernel@vger.kernel.org,
        mian-yousaf.kaukab@linaro.org, lm-sensors@lm-sensors.org,
        Dmitry Torokhov <dtor@mail.ru>, Hemanth V <hemanthv@ti.com>,
        Eric Piel <eric.piel@tremplin-utc.net>
Subject: Re: [lm-sensors] [PATCH] lsm303dlh: Adding Accelerometer and	Magnetometer
 support
References: <1291180447-16570-1-git-send-email-chethan.krishna@stericsson.com>
In-Reply-To: <1291180447-16570-1-git-send-email-chethan.krishna@stericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/10 05:14, Chethan Krishna N wrote:
> From: Chethan Krishna N <chethan.krishna@stericsson.com>
> 
> lsm303dlh accelerometer magnetometer device support added.
> Also provides input device support through interrupts.
> 
For this review I'm ignoring the debate on where this goes.
Obviously, further review will be needed after that is cleared up.

Also I'll be concentrating for now on my favourite area: interfaces.
(I review from the end so most comments are in the magnetometer driver).

My main gripes are:
* Lots of magic numbers.  They lead to a completely non generalizable
interface and so aren't an option in mainline except in the rare cases
where you can really argue no other device is likely to have similar
controls.
* Lots of naming that I haven't seen elsewhere.  There are magnetometers
and accelerometers in tree. Take a look at how they do this stuff.
Few other comments on things I happened to notice whilst passing by.

Code itself is mostly pretty cleaner so should take long to cleanup
one you've found a home.

Have run out of time so haven't done much review of accelerometer side.
Sorry but what is there may be helpful to you in the meantime and most
of the magnetometer comments look like they apply to the accelerometer.
As an aside, how similar is the accelerometer part to those currently
supported by the lis3* driver already in the tree?

Jonathan


> Signed-off-by: Chethan Krishna N <chethan.krishna@stericsson.com>
> ---
>  drivers/hwmon/Kconfig       |   23 +
>  drivers/hwmon/Makefile      |    1 +
>  drivers/hwmon/lsm303dlh_a.c | 1112 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/hwmon/lsm303dlh_m.c |  764 +++++++++++++++++++++++++++++
>  include/linux/lsm303dlh.h   |   56 +++
>  5 files changed, 1956 insertions(+), 0 deletions(-)
>  mode change 100644 => 100755 drivers/hwmon/Kconfig
>  create mode 100644 drivers/hwmon/lsm303dlh_a.c
>  create mode 100644 drivers/hwmon/lsm303dlh_m.c
>  create mode 100644 include/linux/lsm303dlh.h
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> old mode 100644
> new mode 100755
> index a56f6ad..1b678d5
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -614,6 +614,29 @@ config SENSORS_LM93
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called lm93.
>  
> +config SENSORS_LSM303DLH
> +	tristate "ST LSM303DLH 3-axis accelerometer and 3-axis magnetometer"
> +	depends on I2C
> +	default n
> +	help
> +	  This driver provides support for the LSM303DLH chip which includes a
> +	  3-axis accelerometer and a 3-axis magnetometer.
> +
> +	  This driver can also be built as modules.  If so, the module for
> +	  accelerometer will be called lsm303dlh_a and for magnetometer it will
> +	  be called lsm303dlh_m.
Those names really aren't that clear. I'd just call them lsm303dlh_accelerometer
and lsm303dlh_magnetometer (or accel and magnet would do).

> +
> +	  Say Y here if you have a device containing lsm303dlh chip.
> +
> +config SENSORS_LSM303DLH_INPUT_DEVICE
> +	bool "ST LSM303DLH INPUT DEVICE"
> +	depends on SENSORS_LSM303DLH
> +	default n
> +	help
> +	  This driver allows device to be used as an input device with
> +	  interrupts, need to be enabled only when input device support
> +	  is required.
> +
>  config SENSORS_LTC4215
>  	tristate "Linear Technology LTC4215"
>  	depends on I2C && EXPERIMENTAL
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 2479b3d..ee3513b 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -78,6 +78,7 @@ obj-$(CONFIG_SENSORS_LM90)	+= lm90.o
>  obj-$(CONFIG_SENSORS_LM92)	+= lm92.o
>  obj-$(CONFIG_SENSORS_LM93)	+= lm93.o
>  obj-$(CONFIG_SENSORS_LM95241)	+= lm95241.o
> +obj-$(CONFIG_SENSORS_LSM303DLH) += lsm303dlh_a.o lsm303dlh_m.o
>  obj-$(CONFIG_SENSORS_LTC4215)	+= ltc4215.o
>  obj-$(CONFIG_SENSORS_LTC4245)	+= ltc4245.o
>  obj-$(CONFIG_SENSORS_LTC4261)	+= ltc4261.o
> diff --git a/drivers/hwmon/lsm303dlh_a.c b/drivers/hwmon/lsm303dlh_a.c
> new file mode 100644
> index 0000000..a3f6e18
> --- /dev/null
> +++ b/drivers/hwmon/lsm303dlh_a.c
> @@ -0,0 +1,1112 @@
> +/*
> + * lsm303dlh_a.c
> + * ST 3-Axis Accelerometer Driver
> + *
> + * Copyright (C) 2010 STMicroelectronics
> + * Author: Carmine Iascone (carmine.iascone@st.com)
> + * Author: Matteo Dameno (matteo.dameno@st.com)
> + *
> + * Copyright (C) 2010 STEricsson
> + * Author: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
> + * Updated:Preetham Rao Kaskurthi <preetham.rao@stericsson.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <mach/gpio.h>
> +#endif
> +
> +#include <linux/lsm303dlh.h>
> +#include <linux/regulator/consumer.h>
> +
> + /* lsm303dlh accelerometer registers */
> + #define WHO_AM_I    0x0F
> +
> + /* ctrl 1: pm2 pm1 pm0 dr1 dr0 zenable yenable zenable */
> + #define CTRL_REG1       0x20    /* power control reg */
> + #define CTRL_REG2       0x21    /* power control reg */
> + #define CTRL_REG3       0x22    /* power control reg */
> + #define CTRL_REG4       0x23    /* interrupt control reg */
> + #define CTRL_REG5       0x24    /* interrupt control reg */
> +
> + #define STATUS_REG      0x27    /* status register */
> +
> + #define AXISDATA_REG    0x28    /* axis data */
> +
> + #define INT1_CFG  0x30    /* interrupt 1 configuration */
> + #define INT1_SRC  0x31    /* interrupt 1 source reg    */
> + #define INT1_THS  0x32    /* interrupt 1 threshold */
> + #define INT1_DURATION  0x33    /* interrupt 1 threshold */
> +
> + #define INT2_CFG  0x34    /* interrupt 2 configuration */
> + #define INT2_SRC  0x35    /* interrupt 2 source reg    */
> + #define INT2_THS  0x36    /* interrupt 2 threshold */
> + #define INT2_DURATION  0x37    /* interrupt 2 threshold */
> +
> + /* Sensitivity adjustment */
> + #define SHIFT_ADJ_2G 4 /*    1/16*/
> + #define SHIFT_ADJ_4G 3 /*    2/16*/
> + #define SHIFT_ADJ_8G 2 /* ~3.9/16*/
> +
> + /* Control register 1 */
> + #define LSM303DLH_A_CR1_PM_BIT 5
> + #define LSM303DLH_A_CR1_PM_MASK (0x7 << LSM303DLH_A_CR1_PM_BIT)
> + #define LSM303DLH_A_CR1_DR_BIT 3
> + #define LSM303DLH_A_CR1_DR_MASK (0x3 << LSM303DLH_A_CR1_DR_BIT)
> + #define LSM303DLH_A_CR1_EN_BIT 0
> + #define LSM303DLH_A_CR1_EN_MASK (0x7 << LSM303DLH_A_CR1_EN_BIT)
> +
> + /* Control register 2 */
> + #define LSM303DLH_A_CR4_ST_BIT 1
> + #define LSM303DLH_A_CR4_ST_MASK (0x1 << LSM303DLH_A_CR4_ST_BIT)
> + #define LSM303DLH_A_CR4_STS_BIT 3
> + #define LSM303DLH_A_CR4_STS_MASK (0x1 << LSM303DLH_A_CR4_STS_BIT)
> + #define LSM303DLH_A_CR4_FS_BIT 4
> + #define LSM303DLH_A_CR4_FS_MASK (0x3 << LSM303DLH_A_CR4_FS_BIT)
> + #define LSM303DLH_A_CR4_BLE_BIT 6
> + #define LSM303DLH_A_CR4_BLE_MASK (0x3 << LSM303DLH_A_CR4_BLE_BIT)
> + #define LSM303DLH_A_CR4_BDU_BIT 7
> + #define LSM303DLH_A_CR4_BDU_MASK (0x1 << LSM303DLH_A_CR4_BDU_BIT)
> +
> + /* Control register 3 */
> + #define LSM303DLH_A_CR3_I1_BIT 0
> + #define LSM303DLH_A_CR3_I1_MASK (0x3 << LSM303DLH_A_CR3_I1_BIT)
> + #define LSM303DLH_A_CR3_LIR1_BIT 2
> + #define LSM303DLH_A_CR3_LIR1_MASK (0x1 << LSM303DLH_A_CR3_LIR1_BIT)
> + #define LSM303DLH_A_CR3_I2_BIT 3
> + #define LSM303DLH_A_CR3_I2_MASK (0x3 << LSM303DLH_A_CR3_I2_BIT)
> + #define LSM303DLH_A_CR3_LIR2_BIT 5
> + #define LSM303DLH_A_CR3_LIR2_MASK (0x1 << LSM303DLH_A_CR3_LIR2_BIT)
> + #define LSM303DLH_A_CR3_PPOD_BIT 6
> + #define LSM303DLH_A_CR3_PPOD_MASK (0x1 << LSM303DLH_A_CR3_PPOD_BIT)
> + #define LSM303DLH_A_CR3_IHL_BIT 7
> + #define LSM303DLH_A_CR3_IHL_MASK (0x1 << LSM303DLH_A_CR3_IHL_BIT)
> +
> + #define LSM303DLH_A_CR3_I_SELF 0x0
> + #define LSM303DLH_A_CR3_I_OR   0x1
> + #define LSM303DLH_A_CR3_I_DATA 0x2
> + #define LSM303DLH_A_CR3_I_BOOT 0x3
> +
> + #define LSM303DLH_A_CR3_LIR_LATCH 0x1
> +
> + /* Range */
> + #define LSM303DLH_A_RANGE_2G 0x00
> + #define LSM303DLH_A_RANGE_4G 0x01
> + #define LSM303DLH_A_RANGE_8G 0x03
> +
> + /* Mode */
> + #define LSM303DLH_A_MODE_OFF 0x00
> + #define LSM303DLH_A_MODE_NORMAL 0x01
> + #define LSM303DLH_A_MODE_LP_HALF 0x02
> + #define LSM303DLH_A_MODE_LP_1 0x03
> + #define LSM303DLH_A_MODE_LP_2 0x02
> + #define LSM303DLH_A_MODE_LP_5 0x05
> + #define LSM303DLH_A_MODE_LP_10 0x06
> +
> + /* Rate */
> + #define LSM303DLH_A_RATE_50 0x00
> + #define LSM303DLH_A_RATE_100 0x01
> + #define LSM303DLH_A_RATE_400 0x02
> + #define LSM303DLH_A_RATE_1000 0x03
> +
> +/* Multiple byte transfer enable */
> +#define MULTIPLE_I2C_TR 0x80
> +
> +/* Range -2048 to 2047 */
> +struct lsm303dlh_a_t {
> +	short	x;
> +	short	y;
> +	short	z;
> +};
> +
> +/*
> + * accelerometer local data
> + */
> +struct lsm303dlh_a_data {
> +	struct i2c_client *client;
> +	/* lock for sysfs operations */
> +	struct mutex lock;
> +	struct lsm303dlh_a_t data;
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +	struct input_dev *input_dev;
> +	struct input_dev *input_dev2;
> +#endif
> +
> +	struct lsm303dlh_platform_data pdata;
> +	struct regulator *regulator;
> +
> +	unsigned char range;
> +	unsigned char mode;
> +	unsigned char rate;
> +	int shift_adjust;
> +
> +	unsigned char interrupt_control;
> +	unsigned int  interrupt_channel;
> +
> +	unsigned char interrupt_configure[2];
> +	unsigned char interrupt_duration[2];
> +	unsigned char interrupt_threshold[2];
> +};
> +
> +static int lsm303dlh_a_write(struct lsm303dlh_a_data *ddata, u8 reg,
> +		u8 val, char *msg)
> +{
> +	int ret = i2c_smbus_write_byte_data(ddata->client, reg, val);
> +	if (ret < 0)
> +		dev_err(&ddata->client->dev,
> +			"i2c_smbus_write_byte_data failed error %d\
> +			Register (%s)\n", ret, msg);
> +	return ret;
> +}
> +
> +static int lsm303dlh_a_read(struct lsm303dlh_a_data *ddata, u8 reg, char *msg)
> +{
> +	int ret = i2c_smbus_read_byte_data(ddata->client, reg);
> +	if (ret < 0)
> +		dev_err(&ddata->client->dev,
> +			"i2c_smbus_read_byte_data failed error %d\
> +			 Register (%s)\n", ret, msg);
> +	return ret;
> +}
> +
> +static int lsm303dlh_a_restore(struct lsm303dlh_a_data *ddata)
> +{
> +	unsigned char reg;
> +	unsigned char shifted_mode = (ddata->mode << LSM303DLH_A_CR1_PM_BIT);
> +	unsigned char shifted_rate = (ddata->rate << LSM303DLH_A_CR1_DR_BIT);
> +	unsigned char context = (shifted_mode | shifted_rate);
> +	int ret = 0;
> +
> +	/* BDU should be enabled by default/recommened */
> +	reg = ddata->range;
> +	reg |= LSM303DLH_A_CR4_BDU_MASK;
> +
> +	ret = lsm303dlh_a_write(ddata, CTRL_REG1, context,
> +				"CTRL_REG1");
> +	if (ret < 0)
> +		goto fail;
> +
> +	ret = lsm303dlh_a_write(ddata, CTRL_REG4, reg, "CTRL_REG4");
> +
> +	if (ret < 0)
> +		goto fail;
> +
> +	ret = lsm303dlh_a_write(ddata, CTRL_REG3, ddata->interrupt_control,
> +			"CTRL_REG3");
> +
> +	if (ret < 0)
> +		goto fail;
> +
> +	ret = lsm303dlh_a_write(ddata, INT1_CFG, ddata->interrupt_configure[0],
> +			"INT1_CFG");
> +
> +	if (ret < 0)
> +		goto fail;
> +
> +	ret = lsm303dlh_a_write(ddata, INT2_CFG, ddata->interrupt_configure[1],
> +			"INT2_CFG");
> +
> +	if (ret < 0)
> +		goto fail;
> +
> +	ret = lsm303dlh_a_write(ddata, INT1_THS, ddata->interrupt_threshold[0],
> +			"INT1_THS");
> +
> +	if (ret < 0)
> +		goto fail;
> +
> +	ret = lsm303dlh_a_write(ddata, INT2_THS, ddata->interrupt_threshold[1],
> +			"INT2_THS");
> +
> +	if (ret < 0)
> +		goto fail;
> +
> +	ret = lsm303dlh_a_write(ddata, INT1_DURATION,
> +			ddata->interrupt_duration[0], "INT1_DURATION");
> +
> +	if (ret < 0)
> +		goto fail;
> +
> +	ret = lsm303dlh_a_write(ddata, INT1_DURATION,
> +			ddata->interrupt_duration[1], "INT1_DURATION");
> +
> +	if (ret < 0)
> +		goto fail;
Jumping a long way... Loose this test.
> +
> +fail:
> +	return ret;
> +}
> +
> +
> +static int lsm303dlh_a_readdata(struct lsm303dlh_a_data *ddata)
> +{
> +	unsigned char acc_data[6];
> +	short data[3];
> +
> +	int ret = i2c_smbus_read_i2c_block_data(ddata->client,
> +			AXISDATA_REG | MULTIPLE_I2C_TR, 6, acc_data);
> +	if (ret < 0) {
> +		dev_err(&ddata->client->dev,
> +				"i2c_smbus_read_byte_data failed error %d\
> +				Register AXISDATA_REG \n", ret);
> +		return ret;
> +	}
> +
> +	data[0] = (short) (((acc_data[1]) << 8) | acc_data[0]);
> +	data[1] = (short) (((acc_data[3]) << 8) | acc_data[2]);
> +	data[2] = (short) (((acc_data[5]) << 8) | acc_data[4]);
> +
> +	data[0] >>= ddata->shift_adjust;
> +	data[1] >>= ddata->shift_adjust;
> +	data[2] >>= ddata->shift_adjust;
> +
> +	/* taking position and orientation of x,y,z axis into account*/
> +
> +	data[ddata->pdata.axis_map_x] = ddata->pdata.negative_x ?
> +		-data[ddata->pdata.axis_map_x] : data[ddata->pdata.axis_map_x];
> +	data[ddata->pdata.axis_map_y] = ddata->pdata.negative_y ?
> +		-data[ddata->pdata.axis_map_y] : data[ddata->pdata.axis_map_y];
> +	data[ddata->pdata.axis_map_z] = ddata->pdata.negative_z ?
> +		-data[ddata->pdata.axis_map_z] : data[ddata->pdata.axis_map_z];
> +
> +	ddata->data.x = data[ddata->pdata.axis_map_x];
> +	ddata->data.y = data[ddata->pdata.axis_map_y];
> +	ddata->data.z = data[ddata->pdata.axis_map_z];
> +
> +	return ret;
> +}
> +
> +static ssize_t lsm303dlh_a_show_data(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +	int ret = 0;
> +
> +	if (ddata->mode == LSM303DLH_A_MODE_OFF) {
> +		dev_info(&ddata->client->dev,
> +				"device is switched off,make it ON using MODE");
> +		return ret;
> +	}
> +
> +	mutex_lock(&ddata->lock);
> +
> +	ret = lsm303dlh_a_readdata(ddata);
> +
> +	if (ret < 0) {
> +		mutex_unlock(&ddata->lock);
> +		return ret;
> +	}
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return sprintf(buf, "%8x:%8x:%8x\n", ddata->data.x, ddata->data.y,
> +			ddata->data.z);
> +}
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +static irqreturn_t lsm303dlh_a_gpio_irq(int irq, void *device_data)
> +{
> +
> +	struct lsm303dlh_a_data *ddata = device_data;
> +	int ret;
> +	unsigned char reg;
> +	struct input_dev *input;
> +
> +	/* know your interrupt source */
> +	if (irq == gpio_to_irq(ddata->pdata.irq_a1)) {
> +		reg = INT1_SRC;
> +		input = ddata->input_dev;
> +	} else if (irq == gpio_to_irq(ddata->pdata.irq_a2)) {
> +		reg = INT2_SRC;
> +		input = ddata->input_dev2;
> +	} else {
> +		dev_err(&ddata->client->dev, "spurious interrupt");
> +		return IRQ_HANDLED;
> +	}
> +
> +	/* read the axis */
> +	ret = lsm303dlh_a_readdata(ddata);
> +	if (ret < 0)
> +		dev_err(&ddata->client->dev,
> +				"reading data of xyz failed error %d\n", ret);
> +
> +	input_report_abs(input, ABS_X, ddata->data.x);
> +	input_report_abs(input, ABS_Y, ddata->data.y);
> +	input_report_abs(input, ABS_Z, ddata->data.z);
> +	input_sync(input);
> +
> +	/* clear the value by reading it */
> +	ret = lsm303dlh_a_read(ddata, reg, "INTTERUPT SOURCE");
> +	if (ret < 0)
> +		dev_err(&ddata->client->dev,
> +			"clearing interrupt source failed error %d\n", ret);
> +
> +	return IRQ_HANDLED;
> +
> +}
> +#endif
> +
> +static ssize_t lsm303dlh_a_show_interrupt_control(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n", ddata->interrupt_control);
> +}
> +
> +static ssize_t lsm303dlh_a_store_interrupt_control(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +
> +	if (ddata->mode == LSM303DLH_A_MODE_OFF) {
> +		dev_info(&ddata->client->dev,
> +				"device is switched off,make it ON using MODE");
> +		return count;
> +	}
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&ddata->lock);
> +
> +	ddata->interrupt_control = val;
> +
> +	error = lsm303dlh_a_write(ddata, CTRL_REG3, val, "CTRL_REG3");
> +	if (error < 0) {
> +		mutex_unlock(&ddata->lock);
> +		return error;
> +	}
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return count;
> +}
> +
> +static ssize_t lsm303dlh_a_show_interrupt_channel(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n", ddata->interrupt_channel);
> +}
> +
> +static ssize_t lsm303dlh_a_store_interrupt_channel(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	ddata->interrupt_channel = val;
> +
> +	return count;
> +}
> +
> +static ssize_t lsm303dlh_a_show_interrupt_configure(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n",
> +			ddata->interrupt_configure[ddata->interrupt_channel]);
> +}
> +
> +static ssize_t lsm303dlh_a_store_interrupt_configure(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +
> +	if (ddata->mode == LSM303DLH_A_MODE_OFF) {
> +		dev_info(&ddata->client->dev,
> +				"device is switched off,make it ON using MODE");
> +		return count;
> +	}
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&ddata->lock);
> +
> +	ddata->interrupt_configure[ddata->interrupt_channel] = val;
> +
> +	if (ddata->interrupt_channel == 0x0)
> +		error = lsm303dlh_a_write(ddata, INT1_CFG, val, "INT1_CFG");
> +	else
> +		error = lsm303dlh_a_write(ddata, INT2_CFG, val, "INT2_CFG");
> +
> +	if (error < 0) {
> +		mutex_unlock(&ddata->lock);
> +		return error;
> +	}
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return count;
> +}
> +
> +static ssize_t lsm303dlh_a_show_interrupt_duration(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n",
> +			ddata->interrupt_duration[ddata->interrupt_channel]);
> +}
> +
> +static ssize_t lsm303dlh_a_store_interrupt_duration(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +
> +	if (ddata->mode == LSM303DLH_A_MODE_OFF) {
> +		dev_info(&ddata->client->dev,
> +				"device is switched off,make it ON using MODE");
> +		return count;
> +	}
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&ddata->lock);
> +
> +	ddata->interrupt_duration[ddata->interrupt_channel] = val;
> +
> +	if (ddata->interrupt_channel == 0x0)
> +		error = lsm303dlh_a_write(ddata, INT1_DURATION, val,
> +				"INT1_DURATION");
> +	else
> +		error = lsm303dlh_a_write(ddata, INT2_DURATION, val,
> +				"INT2_DURATION");
> +
> +	if (error < 0) {
> +		mutex_unlock(&ddata->lock);
> +		return error;
> +	}
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return count;
> +}
> +
> +static ssize_t lsm303dlh_a_show_interrupt_threshold(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n",
> +			ddata->interrupt_threshold[ddata->interrupt_channel]);
> +}
> +
> +static ssize_t lsm303dlh_a_store_interrupt_threshold(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +
> +	if (ddata->mode == LSM303DLH_A_MODE_OFF) {
> +		dev_info(&ddata->client->dev,
> +				"device is switched off,make it ON using MODE");
> +		return count;
> +	}
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&ddata->lock);
> +
> +	ddata->interrupt_threshold[ddata->interrupt_channel] = val;
> +
> +	if (ddata->interrupt_channel == 0x0)
> +		error = lsm303dlh_a_write(ddata, INT1_THS, val, "INT1_THS");
> +	else
> +		error = lsm303dlh_a_write(ddata, INT2_THS, val, "INT2_THS");
> +
> +	if (error < 0) {
> +		mutex_unlock(&ddata->lock);
> +		return error;
> +	}
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return count;
> +}
> +
> +static ssize_t lsm303dlh_a_show_range(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n", ddata->range >> LSM303DLH_A_CR4_FS_BIT);
> +}
> +
> +static ssize_t lsm303dlh_a_store_range(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	unsigned long bdu_enabled_val;
> +	int error;
> +
> +	if (ddata->mode == LSM303DLH_A_MODE_OFF) {
> +		dev_info(&ddata->client->dev,
> +				"device is switched off,make it ON using MODE");
> +		return count;
> +	}
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	if (val < LSM303DLH_A_RANGE_2G || val > LSM303DLH_A_RANGE_8G)
> +		return -EINVAL;
> +
> +	mutex_lock(&ddata->lock);
> +
> +	ddata->range = val;
> +	ddata->range <<= LSM303DLH_A_CR4_FS_BIT;
> +
> +	/*
> +	 * Block mode update is recommended for not
> +	 * ending up reading different values
> +	 */
> +	bdu_enabled_val = ddata->range;
> +	bdu_enabled_val |= LSM303DLH_A_CR4_BDU_MASK;
> +
> +	error = lsm303dlh_a_write(ddata, CTRL_REG4, bdu_enabled_val,
> +	"CTRL_REG4");
> +	if (error < 0) {
> +		mutex_unlock(&ddata->lock);
> +		return error;
> +	}
> +
> +	switch (val) {
> +	case LSM303DLH_A_RANGE_2G:
> +		ddata->shift_adjust = SHIFT_ADJ_2G;
> +		break;
> +	case LSM303DLH_A_RANGE_4G:
> +		ddata->shift_adjust = SHIFT_ADJ_4G;
> +		break;
> +	case LSM303DLH_A_RANGE_8G:
> +		ddata->shift_adjust = SHIFT_ADJ_8G;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return count;
> +}
> +
> +static ssize_t lsm303dlh_a_show_mode(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n", ddata->mode);
> +}
> +
> +static ssize_t lsm303dlh_a_store_mode(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	unsigned char data;
> +	int error;
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	/* not in correct range */
> +
> +	if (val < LSM303DLH_A_MODE_OFF || val > LSM303DLH_A_MODE_LP_10)
> +		return -EINVAL;
> +
> +	/*  if same mode as existing, return */
> +	if (ddata->mode == val)
> +		return 0;
> +
> +	/* turn on the supplies if already off */
> +	if (ddata->regulator && ddata->mode == LSM303DLH_A_MODE_OFF) {
> +		regulator_enable(ddata->regulator);
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +		enable_irq(gpio_to_irq(ddata->pdata.irq_a1));
> +		enable_irq(gpio_to_irq(ddata->pdata.irq_a2));
> +#endif
> +	}
> +
> +	mutex_lock(&ddata->lock);
> +
> +	data = lsm303dlh_a_read(ddata, CTRL_REG1, "CTRL_REG1");
> +
> +	data &= ~LSM303DLH_A_CR1_PM_MASK;
> +
> +	ddata->mode = val;
> +
> +	data |= ((val << LSM303DLH_A_CR1_PM_BIT) & LSM303DLH_A_CR1_PM_MASK);
> +
> +	error = lsm303dlh_a_write(ddata, CTRL_REG1, data, "CTRL_REG1");
> +	if (error < 0) {
> +		if (ddata->regulator)
> +			regulator_disable(ddata->regulator);
> +		mutex_unlock(&ddata->lock);
> +		return error;
> +	}
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	if (val == LSM303DLH_A_MODE_OFF) {
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +		disable_irq(gpio_to_irq(ddata->pdata.irq_a1));
> +		disable_irq(gpio_to_irq(ddata->pdata.irq_a2));
> +#endif
> +		/*
> +		 * No need to store context here
> +		 * it is not like suspend/resume
> +		 * but fall back to default values
> +		 */
> +		ddata->rate = LSM303DLH_A_RATE_50;
> +		ddata->range = LSM303DLH_A_RANGE_2G;
> +		ddata->shift_adjust = SHIFT_ADJ_2G;
> +
> +		if (ddata->regulator)
> +			regulator_disable(ddata->regulator);
> +
> +	}
> +
> +	return count;
> +}
> +
> +static ssize_t lsm303dlh_a_show_rate(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n", ddata->rate);
> +}
> +
> +static ssize_t lsm303dlh_a_store_rate(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_a_data *ddata = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	unsigned char data;
> +	int error;
> +
> +	if (ddata->mode == LSM303DLH_A_MODE_OFF) {
> +		dev_info(&ddata->client->dev,
> +				"device is switched off,make it ON using MODE");
> +		return count;
> +	}
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	if (val < LSM303DLH_A_MODE_OFF || val > LSM303DLH_A_MODE_LP_10)
> +		return -EINVAL;
> +
> +	mutex_lock(&ddata->lock);
> +
> +	data = lsm303dlh_a_read(ddata, CTRL_REG1, "CTRL_REG1");
> +
> +	data &= ~LSM303DLH_A_CR1_DR_MASK;
> +
> +	ddata->rate = val;
Why is this in the middle of code setting up the value of data?  It's confusing
to read so move it to one end of the other.
> +
> +	data |= ((val << LSM303DLH_A_CR1_DR_BIT) & LSM303DLH_A_CR1_DR_MASK);
> +
> +	error = lsm303dlh_a_write(ddata, CTRL_REG1, data, "CTRL_REG1");
> +	if (error < 0) {
> +		mutex_unlock(&ddata->lock);
> +		return error;
> +	}
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(data, S_IRUGO, lsm303dlh_a_show_data, NULL);
Again, does the device guarantee one 'scan' of data is read. If not
they are different values and hence need separate attributes.
Also, what is data?  Name doesn't tell us anything.
> +
> +static DEVICE_ATTR(range, S_IWUGO | S_IRUGO,
> +		lsm303dlh_a_show_range, lsm303dlh_a_store_range);
Units? Permissible values?
> +
> +static DEVICE_ATTR(mode, S_IWUGO | S_IRUGO,
> +		lsm303dlh_a_show_mode, lsm303dlh_a_store_mode);
Magic numbers
> +
> +static DEVICE_ATTR(rate, S_IWUGO | S_IRUGO,
> +		lsm303dlh_a_show_rate, lsm303dlh_a_store_rate);
> +
> +static DEVICE_ATTR(interrupt_control, S_IWUGO | S_IRUGO,
> +		lsm303dlh_a_show_interrupt_control,
> +		lsm303dlh_a_store_interrupt_control);
So how does interrupt control differ from interrupt configure?
Both look like black magic to me.
> +
> +static DEVICE_ATTR(interrupt_channel, S_IWUGO | S_IRUGO,
> +		lsm303dlh_a_show_interrupt_channel,
> +		lsm303dlh_a_store_interrupt_channel);
What is this?
> +
> +static DEVICE_ATTR(interrupt_configure, S_IWUGO | S_IRUGO,
> +		lsm303dlh_a_show_interrupt_configure,
> +		lsm303dlh_a_store_interrupt_configure);
This smacks of more magic numbers. Undocumented so I have no idea
what they even do. Unless I'm missing something there is no way
this is going into mainline.
> +
> +static DEVICE_ATTR(interrupt_duration, S_IWUGO | S_IRUGO,
> +		lsm303dlh_a_show_interrupt_duration,
> +		lsm303dlh_a_store_interrupt_duration);
> +
> +static DEVICE_ATTR(interrupt_threshold, S_IWUGO | S_IRUGO,
> +		lsm303dlh_a_show_interrupt_threshold,
> +		lsm303dlh_a_store_interrupt_threshold);
Needs documenting.  I've proposed a set (to limited response) of
suggestions on how to name sensor interrupt control attributes.
We are using that set in IIO but are still open to changes if
you want to reopen that discussion.
> +
> +static struct attribute *lsm303dlh_a_attributes[] = {
> +	&dev_attr_data.attr,
> +	&dev_attr_range.attr,
> +	&dev_attr_mode.attr,
> +	&dev_attr_rate.attr,
> +	&dev_attr_interrupt_control.attr,
> +	&dev_attr_interrupt_channel.attr,
> +	&dev_attr_interrupt_configure.attr,
> +	&dev_attr_interrupt_duration.attr,
> +	&dev_attr_interrupt_threshold.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group lsm303dlh_a_attr_group = {
> +	.attrs = lsm303dlh_a_attributes,
> +};
> +
> +static int __devinit lsm303dlh_a_probe(struct i2c_client *client,
> +						const struct i2c_device_id *id)
> +{
> +	int ret;
> +	struct lsm303dlh_a_data *ddata = NULL;
Why assign it to NULL? 
> +
> +	ddata = kzalloc(sizeof(struct lsm303dlh_a_data), GFP_KERNEL);
> +	if (ddata == NULL) {
> +		ret = -ENOMEM;
> +		goto err_op_failed;
> +	}
> +
> +	ddata->client = client;
> +	i2c_set_clientdata(client, ddata);
> +
> +	/* copy platform specific data */
> +	memcpy(&ddata->pdata, client->dev.platform_data, sizeof(ddata->pdata));
> +	ddata->mode = LSM303DLH_A_MODE_OFF;
> +	ddata->rate = LSM303DLH_A_RATE_50;
> +	ddata->range = LSM303DLH_A_RANGE_2G;
> +	ddata->shift_adjust = SHIFT_ADJ_2G;
> +	dev_set_name(&client->dev, ddata->pdata.name_a);
> +
> +	ddata->regulator = regulator_get(&client->dev, "v-accel");
> +	if (IS_ERR(ddata->regulator)) {
> +		dev_err(&client->dev, "failed to get regulator\n");
> +		ret = PTR_ERR(ddata->regulator);
> +		ddata->regulator = NULL;
> +	}
> +
> +	if (ddata->regulator)
> +		regulator_enable(ddata->regulator);
> +
> +	ret = lsm303dlh_a_read(ddata, WHO_AM_I, "WHO_AM_I");
> +	if (ret < 0)
> +		goto exit_free_regulator;
> +
> +	dev_info(&client->dev, "3-Axis Accelerometer, ID : %d\n",
> +			 ret);
> +
> +	mutex_init(&ddata->lock);
> +
> +	ret = sysfs_create_group(&client->dev.kobj, &lsm303dlh_a_attr_group);
> +	if (ret)
> +		goto exit_free_regulator;
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +
> +    /* accelerometer has two interrupts channels
> +       (thresholds,durations and sources)
> +       and can support two input devices */
> +
> +	ddata->input_dev = input_allocate_device();
> +	if (!ddata->input_dev) {
> +		ret = -ENOMEM;
> +		dev_err(&client->dev, "Failed to allocate input device\n");
> +		goto exit_free_regulator;
> +	}
> +
> +	ddata->input_dev2 = input_allocate_device();
> +	if (!ddata->input_dev2) {
> +		ret = -ENOMEM;
> +		dev_err(&client->dev, "Failed to allocate input device\n");
> +		goto err_input_alloc_failed;
> +	}
> +
> +	set_bit(EV_ABS, ddata->input_dev->evbit);
> +	set_bit(EV_ABS, ddata->input_dev2->evbit);
> +
> +	/* x-axis acceleration */
> +	input_set_abs_params(ddata->input_dev, ABS_X, -32768, 32767, 0, 0);
> +	input_set_abs_params(ddata->input_dev2, ABS_X, -32768, 32767, 0, 0);
> +	/* y-axis acceleration */
> +	input_set_abs_params(ddata->input_dev, ABS_Y, -32768, 32767, 0, 0);
> +	input_set_abs_params(ddata->input_dev2, ABS_Y, -32768, 32767, 0, 0);
> +	/* z-axis acceleration */
> +	input_set_abs_params(ddata->input_dev, ABS_Z, -32768, 32767, 0, 0);
> +	input_set_abs_params(ddata->input_dev2, ABS_Z, -32768, 32767, 0, 0);
> +
> +	ddata->input_dev->name = "accelerometer";
> +	ddata->input_dev2->name = "motion";
Guessing this is a motion detector... Dmitry, happy with this in input?
> +
> +	ret = input_register_device(ddata->input_dev);
> +	if (ret) {
> +		dev_err(&client->dev, "Unable to register input device: %s\n",
> +			ddata->input_dev->name);
> +		goto err_input_register_failed;
> +	}
> +
> +	ret = input_register_device(ddata->input_dev2);
> +	if (ret) {
> +		dev_err(&client->dev, "Unable to register input device: %s\n",
> +			ddata->input_dev->name);
> +		goto err_input_register_failed2;
> +	}
> +
> +	/* Register interrupt */
> +	ret = request_threaded_irq(gpio_to_irq(ddata->pdata.irq_a1), NULL,
> +			lsm303dlh_a_gpio_irq,
> +			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> +			"lsm303dlh_a", ddata);
> +	if (ret) {
> +		dev_err(&client->dev, "request irq1 failed\n");
> +		goto err_input_failed;
> +	}
> +
> +	ret = request_threaded_irq(gpio_to_irq(ddata->pdata.irq_a2), NULL,
> +			lsm303dlh_a_gpio_irq,
> +			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
> +			"lsm303dlh_a", ddata);
> +	if (ret) {
> +		dev_err(&client->dev, "request irq2 failed\n");
> +		goto err_input_failed;
> +	}
> +
> +	/* only mode can enable it */
> +	disable_irq(gpio_to_irq(ddata->pdata.irq_a1));
> +	disable_irq(gpio_to_irq(ddata->pdata.irq_a2));
> +
> +#endif
> +
> +	return ret;
> +
Definitely pull the input code out into a function even if you leave it
in this file. It'll make things rather easier to read.
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +err_input_failed:
> +	input_unregister_device(ddata->input_dev2);
> +err_input_register_failed2:
> +	input_unregister_device(ddata->input_dev);
> +err_input_register_failed:
> +	input_free_device(ddata->input_dev2);
> +err_input_alloc_failed:
> +	input_free_device(ddata->input_dev);
> +#endif
> +exit_free_regulator:
> +	if (ddata->regulator) {
> +		regulator_disable(ddata->regulator);
> +		regulator_put(ddata->regulator);
> +	}
> +err_op_failed:
> +	kfree(ddata);
> +	dev_err(&client->dev, "probe function fails %x", ret);
> +	return ret;
> +}
> +
> +static int __devexit lsm303dlh_a_remove(struct i2c_client *client)
> +{
> +	struct lsm303dlh_a_data *ddata;
> +
> +	ddata = i2c_get_clientdata(client);
roll into line above.
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +	input_unregister_device(ddata->input_dev);
> +	input_unregister_device(ddata->input_dev2);
> +	input_free_device(ddata->input_dev);
> +	input_free_device(ddata->input_dev2);
> +#endif
> +	sysfs_remove_group(&client->dev.kobj, &lsm303dlh_a_attr_group);
> +
> +	/* safer to make device off */
> +	if (ddata->mode != LSM303DLH_A_MODE_OFF) {
> +		lsm303dlh_a_write(ddata, CTRL_REG1, 0, "CONTROL");
> +		if (ddata->regulator) {
> +			regulator_disable(ddata->regulator);
> +			regulator_put(ddata->regulator);
> +		}
> +	}
> +
> +	i2c_set_clientdata(client, NULL);
> +	kfree(ddata);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int lsm303dlh_a_suspend(struct device *dev)
> +{
> +	struct lsm303dlh_a_data *ddata;
> +	int ret;
> +
> +	ddata = dev_get_drvdata(dev);
> +
> +	if (ddata->mode == LSM303DLH_A_MODE_OFF)
> +		return 0;
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +	disable_irq(gpio_to_irq(ddata->pdata.irq_a1));
> +	disable_irq(gpio_to_irq(ddata->pdata.irq_a2));
> +#endif
> +
> +	ret = lsm303dlh_a_write(ddata, CTRL_REG1,
> +		LSM303DLH_A_MODE_OFF, "CONTROL");
> +
> +	if (ddata->regulator)
> +		regulator_disable(ddata->regulator);
> +
> +	return ret;
> +}
> +
> +static int lsm303dlh_a_resume(struct device *dev)
> +{
> +	struct lsm303dlh_a_data *ddata;
> +	int ret;
> +
> +	ddata = dev_get_drvdata(dev);
roll into the first line of function.
> +
> +	/* in correct mode, no need to change it */
> +	if (ddata->mode == LSM303DLH_A_MODE_OFF)
> +		return 0;
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +	enable_irq(gpio_to_irq(ddata->pdata.irq_a1));
> +	enable_irq(gpio_to_irq(ddata->pdata.irq_a2));
> +#endif
> +
> +	if (ddata->regulator)
> +		regulator_enable(ddata->regulator);
> +
> +	ret	= lsm303dlh_a_restore(ddata);
Odd spacing.
> +
> +	if (ret < 0)
> +		dev_err(&ddata->client->dev,
> +				"Error while resuming the device");
> +
> +	return ret;
> +}
> +static const struct dev_pm_ops lsm303dlh_a_dev_pm_ops = {
> +	.suspend = lsm303dlh_a_suspend,
> +	.resume  = lsm303dlh_a_resume,
> +};
> +#endif /* CONFIG_PM */
> +
> +static const struct i2c_device_id lsm303dlh_a_id[] = {
> +	{ "lsm303dlh_a", 0 },
> +	{ },
> +};
> +
> +static struct i2c_driver lsm303dlh_a_driver = {
> +	.probe		= lsm303dlh_a_probe,
> +	.remove		= lsm303dlh_a_remove,
> +	.id_table	= lsm303dlh_a_id,
> +	.driver = {
> +		.name = "lsm303dlh_a",
> +	#ifdef CONFIG_PM
> +		.pm	=	&lsm303dlh_a_dev_pm_ops,
> +	#endif
> +	},
> +};
> +
> +static int __init lsm303dlh_a_init(void)
> +{
> +	return i2c_add_driver(&lsm303dlh_a_driver);
> +}
> +
> +static void __exit lsm303dlh_a_exit(void)
> +{
> +	i2c_del_driver(&lsm303dlh_a_driver);
> +}
> +
> +module_init(lsm303dlh_a_init)
> +module_exit(lsm303dlh_a_exit)
> +
> +MODULE_DESCRIPTION("lSM303DLH 3-Axis Accelerometer Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("STMicroelectronics");
> diff --git a/drivers/hwmon/lsm303dlh_m.c b/drivers/hwmon/lsm303dlh_m.c
> new file mode 100644
> index 0000000..58b2765
> --- /dev/null
> +++ b/drivers/hwmon/lsm303dlh_m.c
> @@ -0,0 +1,764 @@
> +/*
> + * lsm303dlh_m.c
> + * ST 3-Axis Magnetometer Driver
> + *
> + * Copyright (C) 2010 STMicroelectronics
> + * Author: Carmine Iascone (carmine.iascone@st.com)
> + * Author: Matteo Dameno (matteo.dameno@st.com)
> + *
> + * Copyright (C) 2010 STEricsson
> + * Author: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
> + * Updated:Preetham Rao Kaskurthi <preetham.rao@stericsson.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <mach/gpio.h>
> +#endif
> +
> +#include <linux/lsm303dlh.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/kernel.h>
> +
> +/* lsm303dlh magnetometer registers */
> +#define IRA_REG_M	0x0A
> +
> +/* Magnetometer registers */
> +#define CRA_REG_M	0x00  /* Configuration register A */
> +#define CRB_REG_M	0x01  /* Configuration register B */
> +#define MR_REG_M	0x02  /* Mode register */
> +#define SR_REG_M    0x09  /* Status register */
> +
> +/* Output register start address*/
> +#define OUT_X_M		0x03
> +#define OUT_Y_M		0x05
> +#define OUT_Z_M		0x07
> +
> +/* Magnetometer X-Y gain  */
> +#define XY_GAIN_1_3	1055 /* XY gain at 1.3G */
> +#define XY_GAIN_1_9	 795 /* XY gain at 1.9G */
> +#define XY_GAIN_2_5	 635 /* XY gain at 2.5G */
> +#define XY_GAIN_4_0	 430 /* XY gain at 4.0G */
> +#define XY_GAIN_4_7	 375 /* XY gain at 4.7G */
> +#define XY_GAIN_5_6	 320 /* XY gain at 5.6G */
> +#define XY_GAIN_8_1	 230 /* XY gain at 8.1G */
> +
> +/* Magnetometer Z gain  */
> +#define Z_GAIN_1_3	950 /* Z gain at 1.3G */
> +#define Z_GAIN_1_9	710 /* Z gain at 1.9G */
> +#define Z_GAIN_2_5	570 /* Z gain at 2.5G */
> +#define Z_GAIN_4_0	385 /* Z gain at 4.0G */
> +#define Z_GAIN_4_7	335 /* Z gain at 4.7G */
> +#define Z_GAIN_5_6	285 /* Z gain at 5.6G */
> +#define Z_GAIN_8_1	205 /* Z gain at 8.1G */
> +
> +/* Control A regsiter. */
> +#define LSM303DLH_M_CRA_DO_BIT 2
> +#define LSM303DLH_M_CRA_DO_MASK (0x7 <<  LSM303DLH_M_CRA_DO_BIT)
> +#define LSM303DLH_M_CRA_MS_BIT 0
> +#define LSM303DLH_M_CRA_MS_MASK (0x3 <<  LSM303DLH_M_CRA_MS_BIT)
> +
> +/* Control B regsiter. */
> +#define LSM303DLH_M_CRB_GN_BIT 5
> +#define LSM303DLH_M_CRB_GN_MASK (0x7 <<  LSM303DLH_M_CRB_GN_BIT)
> +
> +/* Control Mode regsiter. */
> +#define LSM303DLH_M_MR_MD_BIT 0
> +#define LSM303DLH_M_MR_MD_MASK (0x3 <<  LSM303DLH_M_MR_MD_BIT)
> +
> +/* Control Status regsiter. */
> +#define LSM303DLH_M_SR_RDY_BIT 0
> +#define LSM303DLH_M_SR_RDY_MASK (0x1 <<  LSM303DLH_M_SR_RDY_BIT)
> +#define LSM303DLH_M_SR_LOC_BIT 1
> +#define LSM303DLH_M_SR_LCO_MASK (0x1 <<  LSM303DLH_M_SR_LOC_BIT)
> +#define LSM303DLH_M_SR_REN_BIT 2
> +#define LSM303DLH_M_SR_REN_MASK (0x1 <<  LSM303DLH_M_SR_REN_BIT)
> +
> +/* Magnetometer gain setting */
> +#define LSM303DLH_M_RANGE_1_3G  0x01
> +#define LSM303DLH_M_RANGE_1_9G  0x02
> +#define LSM303DLH_M_RANGE_2_5G  0x03
> +#define LSM303DLH_M_RANGE_4_0G  0x04
> +#define LSM303DLH_M_RANGE_4_7G  0x05
> +#define LSM303DLH_M_RANGE_5_6G  0x06
> +#define LSM303DLH_M_RANGE_8_1G  0x07
> +
> +/* Magnetometer capturing mode  */
> +#define LSM303DLH_M_MODE_CONTINUOUS 0
> +#define LSM303DLH_M_MODE_SINGLE 1
> +#define LSM303DLH_M_MODE_SLEEP 3
> +
> +/* Magnetometer output data rate */
> +#define LSM303DLH_M_RATE_00_75 0x00
> +#define LSM303DLH_M_RATE_01_50 0x01
> +#define LSM303DLH_M_RATE_03_00 0x02
> +#define LSM303DLH_M_RATE_07_50 0x03
> +#define LSM303DLH_M_RATE_15_00 0x04
> +#define LSM303DLH_M_RATE_30_00 0x05
> +#define LSM303DLH_M_RATE_75_00 0x06
> +
> +/* Multiple byte transfer enable */
> +#define MULTIPLE_I2C_TR 0x80
> +
> +/*
> + * magnetometer local data
> + */
> +struct lsm303dlh_m_data {
> +	struct i2c_client *client;
> +	/* lock for sysfs operations */
> +	struct mutex lock;
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +	struct input_dev *input_dev;
> +#endif
> +	struct regulator *regulator;
> +	struct lsm303dlh_platform_data pdata;
> +
> +	short gain[3];
> +	short data[3];
> +	unsigned char mode;
> +	unsigned char rate;
> +	unsigned char range;
> +};
> +
Looks (at very brief glance) like you could just move the definition
of set_mode then you wouldn't need this.

> +static int lsm303dlh_m_set_mode(struct lsm303dlh_m_data *ddata,
> +		unsigned char mode);
> +static int lsm303dlh_m_write(struct lsm303dlh_m_data *ddata,
> +		u8 reg, u8 val, char *msg)
> +{
> +	int ret = i2c_smbus_write_byte_data(ddata->client, reg, val);
> +	if (ret < 0)
> +		dev_err(&ddata->client->dev,
> +			"i2c_smbus_write_byte_data failed error %d\
> +			Register (%s)\n", ret, msg);
> +	return ret;
> +}
> +
> +static int lsm303dlh_m_restore(struct lsm303dlh_m_data *ddata)
> +{
> +	int ret = 0;
It's going to tget assigned the next line so don't bother doing it here.
> +
> +	ret = lsm303dlh_m_write(ddata, CRB_REG_M, ddata->range, "SET RANGE");
> +
> +	if (ret < 0)
> +		goto fail;
> +
> +	ret = lsm303dlh_m_write(ddata, CRA_REG_M, ddata->rate, "SET RATE");
> +
> +	if (ret < 0)
> +		goto fail;
> +
> +	ret = lsm303dlh_m_set_mode(ddata, ddata->mode);
> +
> +	if (ret < 0)
> +		goto fail;
That goes an rather short distance. Lose the check.
> +
> +fail:
> +	return ret;
> +}
> +
> +static int lsm303dlh_m_read_multi(struct lsm303dlh_m_data *ddata, u8 reg,
> +		u8 count, u8 *val, char *msg)
> +{
> +	int ret = i2c_smbus_read_i2c_block_data(ddata->client,
> +		   reg | MULTIPLE_I2C_TR, count, val);
> +	if (ret < 0)
> +		dev_err(&ddata->client->dev,
> +			"i2c_smbus_read_i2c_block_data failed error %d\
> +			 Register (%s)\n", ret, msg);
That's a whole lot of error. I'd use a debug macro so it's not there unless
someone is having problems.
> +	return ret;
> +}
> +
Looks suspiciously like a magic number. Could be wrong...
> +static ssize_t lsm303dlh_m_show_rate(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_m_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n", ddata->rate >> LSM303DLH_M_CRA_DO_BIT);
> +}
> +
> +/* set lsm303dlh magnetometer bandwidth */
> +static ssize_t lsm303dlh_m_store_rate(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_m_data *ddata = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	unsigned char data;
> +	int error;
> +
> +	if (ddata->mode == LSM303DLH_M_MODE_SLEEP) {
> +		dev_info(&ddata->client->dev,
> +				"device is switched off,make it ON using MODE");
> +		return count;
> +	}
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&ddata->lock);
> +
> +	data = ((val << LSM303DLH_M_CRA_DO_BIT) & LSM303DLH_M_CRA_DO_MASK);
> +	ddata->rate = data;
Is there a reason to do this in two goes?
> +
> +	error = lsm303dlh_m_write(ddata, CRA_REG_M, data, "SET RATE");
> +
> +	if (error < 0) {
> +		mutex_unlock(&ddata->lock);
> +		return error;
> +	}
Do the mutex unlock then check the error condition to save yourself a couple of lines of code.
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return count;
> +}
> +
> +static int lsm303dlh_m_xyz_read(struct lsm303dlh_m_data *ddata)
> +{
> +	unsigned char xyz_data[6];
> +	int ret = lsm303dlh_m_read_multi(ddata, OUT_X_M,
> +			6, xyz_data, "OUT_X_M");
> +	if (ret < 0)
> +		return -EINVAL;
> +
> +	/* MSB is at lower address */
> +	ddata->data[0] = (short)
> +		(((xyz_data[0]) << 8) | xyz_data[1]);
> +	ddata->data[1] = (short)
> +		(((xyz_data[2]) << 8) | xyz_data[3]);
> +	ddata->data[2] = (short)
> +		(((xyz_data[4]) << 8) | xyz_data[5]);
> +
> +	/* taking orientation of x,y,z axis into account*/
> +
> +	ddata->data[ddata->pdata.axis_map_x] = ddata->pdata.negative_x ?
> +		-ddata->data[ddata->pdata.axis_map_x] :
> +		ddata->data[ddata->pdata.axis_map_x];
> +	ddata->data[ddata->pdata.axis_map_y] = ddata->pdata.negative_y ?
> +		-ddata->data[ddata->pdata.axis_map_y] :
> +		ddata->data[ddata->pdata.axis_map_y];
> +	ddata->data[ddata->pdata.axis_map_z] = ddata->pdata.negative_z ?
> +		-ddata->data[ddata->pdata.axis_map_z] :
> +		ddata->data[ddata->pdata.axis_map_z];
> +
> +	return ret;
> +}
> +
> +static ssize_t lsm303dlh_m_gain(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_m_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%8x:%8x:%8x\n",
> +			ddata->gain[ddata->pdata.axis_map_x],
> +			ddata->gain[ddata->pdata.axis_map_y],
> +			ddata->gain[ddata->pdata.axis_map_z]);
> +}
> +
> +static ssize_t lsm303dlh_m_values(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_m_data *ddata = platform_get_drvdata(pdev);
> +	int ret = 0;
> +
> +	if (ddata->mode == LSM303DLH_M_MODE_SLEEP) {
> +		dev_info(&ddata->client->dev,
> +				"device is switched off,make it ON using MODE");
> +		return ret;
> +	}
> +
> +	mutex_lock(&ddata->lock);
> +
> +	ret = lsm303dlh_m_xyz_read(ddata);
> +	if (ret < 0) {
> +		mutex_unlock(&ddata->lock);
> +		return -EINVAL;
> +	}
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	/* taking orientation of x,y,z axis into account*/
> +
> +	return sprintf(buf, "%8x:%8x:%8x\n",
Not sure I've seen that colon syntax anywhere else in kernel.
> +			ddata->data[ddata->pdata.axis_map_x],
> +			ddata->data[ddata->pdata.axis_map_y],
> +			ddata->data[ddata->pdata.axis_map_z]);
> +}
> +
> +static int lsm303dlh_m_set_mode(struct lsm303dlh_m_data *ddata,
> +		unsigned char mode)
> +{
> +	int ret;
> +
> +	mode = (mode << LSM303DLH_M_MR_MD_BIT);
> +
> +	ret = i2c_smbus_write_byte_data(ddata->client, MR_REG_M, mode);
> +
> +	if (ret < 0)
> +		dev_err(&ddata->client->dev,
> +			"i2c_smbus_write_byte_data failed error %d\
> +			Register (%s)\n", ret, "MODE CONTROL");
Unless the happens often I'd be inclined to not bother with thie error
message. Or moving it into a debugging macro so it gets compiled out if
no one cares.
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +
Why does it need to be a gpio?  Can't see any code that isn't just using
gpio_to_irq on the gpio. Hence just pass the irq number in to start with.
> +static irqreturn_t lsm303dlh_m_gpio_irq(int irq, void *device_data)
> +{
> +	struct lsm303dlh_m_data *ddata = device_data;
> +	int ret;
> +
> +	ret = lsm303dlh_m_xyz_read(ddata);
> +
> +	if (ret < 0) {
> +		dev_err(&ddata->client->dev,
> +				"reading data of xyz failed error %d\n", ret);
> +		return IRQ_NONE;
> +	}
> +
> +	/* taking orientation of x,y,z axis into account*/
> +
> +	input_report_abs(ddata->input_dev, ABS_X,
> +			ddata->data[ddata->pdata.axis_map_x]);
> +	input_report_abs(ddata->input_dev, ABS_Y,
> +		   ddata->data[ddata->pdata.axis_map_y]);
> +	input_report_abs(ddata->input_dev, ABS_Z,
> +		   ddata->data[ddata->pdata.axis_map_z]);
> +	input_sync(ddata->input_dev);
> +
> +	return IRQ_HANDLED;
> +
> +}
> +#endif
> +
> +static ssize_t lsm303dlh_m_show_range(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_m_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n", ddata->range >> LSM303DLH_M_CRB_GN_BIT);
> +}
> +
> +static ssize_t lsm303dlh_m_store_range(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_m_data *ddata = platform_get_drvdata(pdev);
> +	short xy_gain;
> +	short z_gain;
> +	unsigned long range;
> +
> +	int error;
> +
> +	if (ddata->mode == LSM303DLH_M_MODE_SLEEP) {
> +		dev_info(&ddata->client->dev,
> +				"device is switched off,make it ON using MODE");
> +		return count;
> +	}
> +
> +	error = strict_strtoul(buf, 0, &range);
This is looking suspicously like another set of magic numbers....
> +	if (error)
> +		return error;
> +
> +	switch (range) {
> +	case LSM303DLH_M_RANGE_1_3G:
> +		xy_gain = XY_GAIN_1_3;
> +		z_gain = Z_GAIN_1_3;
> +		break;
> +	case LSM303DLH_M_RANGE_1_9G:
> +		xy_gain = XY_GAIN_1_9;
> +		z_gain = Z_GAIN_1_9;
> +		break;
> +	case LSM303DLH_M_RANGE_2_5G:
> +		xy_gain = XY_GAIN_2_5;
> +		z_gain = Z_GAIN_2_5;
> +		break;
> +	case LSM303DLH_M_RANGE_4_0G:
> +		xy_gain = XY_GAIN_4_0;
> +		z_gain = Z_GAIN_4_0;
> +		break;
> +	case LSM303DLH_M_RANGE_4_7G:
> +		xy_gain = XY_GAIN_4_7;
> +		z_gain = Z_GAIN_4_7;
> +		break;
> +	case LSM303DLH_M_RANGE_5_6G:
> +		xy_gain = XY_GAIN_5_6;
> +		z_gain = Z_GAIN_5_6;
> +		break;
> +	case LSM303DLH_M_RANGE_8_1G:
> +		xy_gain = XY_GAIN_8_1;
> +		z_gain = Z_GAIN_8_1;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&ddata->lock);
> +
> +	ddata->gain[ddata->pdata.axis_map_x] = xy_gain;
> +	ddata->gain[ddata->pdata.axis_map_y] = xy_gain;
> +	ddata->gain[ddata->pdata.axis_map_z] = z_gain;
> +
> +	range <<= LSM303DLH_M_CRB_GN_BIT;
> +	range &= LSM303DLH_M_CRB_GN_MASK;
> +
> +	ddata->range = range;
> +
> +	error = lsm303dlh_m_write(ddata, CRB_REG_M, range, "SET RANGE");
> +	mutex_unlock(&ddata->lock);
> +
> +	if (error < 0)
> +		return error;
> +
> +	return count;
> +}
> +
> +static ssize_t lsm303dlh_m_show_mode(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_m_data *ddata = platform_get_drvdata(pdev);
> +
> +	return sprintf(buf, "%d\n", ddata->mode);
> +}
> +
> +static ssize_t lsm303dlh_m_store_mode(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct lsm303dlh_m_data *ddata = platform_get_drvdata(pdev);
> +	unsigned long mode;
> +	int error;
> +
> +	error = strict_strtoul(buf, 0, &mode);
> +	if (error)
> +		return error;
> +
> +	/*  if same mode as existing, return */
> +	if (ddata->mode == mode)
> +		return 0;
> +
> +	/* turn on the supplies if already off */
> +	if (ddata->mode == LSM303DLH_M_MODE_SLEEP) {
> +		regulator_enable(ddata->regulator);
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +	enable_irq(gpio_to_irq(ddata->pdata.irq_m));
> +#endif
> +	}
> +
> +	mutex_lock(&ddata->lock);
> +
> +	error = lsm303dlh_m_set_mode(ddata, mode);
> +
> +	ddata->mode = (mode >> LSM303DLH_M_MR_MD_BIT);
So you set ddata->mode to garabage before handling the error?
It might not matter in this case, but it's pretty uggly from
a review point of view.
> +	mutex_unlock(&ddata->lock);
> +
> +	if (error < 0)
> +		return error;
> +
> +	if (mode == LSM303DLH_M_MODE_SLEEP) {
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +		disable_irq(gpio_to_irq(ddata->pdata.irq_m));
> +#endif
> +
> +		/*
> +		 * No need to store context here, it is not like
> +		 * suspend/resume but fall back to default values
> +		 */
> +		ddata->rate = LSM303DLH_M_RATE_00_75;
> +		ddata->range = LSM303DLH_M_RANGE_1_3G;
> +		ddata->range <<= LSM303DLH_M_CRB_GN_BIT;
> +		ddata->range &= LSM303DLH_M_CRB_GN_MASK;
> +		ddata->gain[ddata->pdata.axis_map_x] = XY_GAIN_1_3;
> +		ddata->gain[ddata->pdata.axis_map_y] = XY_GAIN_1_3;
> +		ddata->gain[ddata->pdata.axis_map_z] = Z_GAIN_1_3;
> +
> +		regulator_disable(ddata->regulator);
> +	}
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(gain, S_IRUGO, lsm303dlh_m_gain, NULL);
This isn't clear. Gain of what?  In IIO we have a nice clear
convention for this. There may be others elsewhere in kernel.
Ah, looking at the function you have 3 separate values. Given
these apply to different channels and are constant I don't think
you can claim they are a single value. Hence under sysfs they need
to be 3 separate attributes.  Is this a gain userspace applies or
one that is occuring inside the device?  Or even one set by platform
data (in which case why does userspace what to know?)

For reference in IIO, if these are applied before the data hits userspace
they would be:
magn_x_calibscale
magn_y_calibscale
magn_z_calibscale

and if they are to be applied in usersapce
magn_x_scale
magn_y_scale
magn_z_scale
 

> +
> +static DEVICE_ATTR(data, S_IRUGO, lsm303dlh_m_values, NULL);
data... Values of what? Fine here where you have a separate device
for a magnetometer, but it doesn't generalize.  Take the big imu's in
IIO. We have parts which truely integrate gyros, accels and magnetometers.
Hence I'd suggest
magn_xyz if the part is such that you can argue that one always obtains a
set captured at the 'same' time. If not, then they aren't a single element
and so under sysfs rules need to be 3 attributes.  Personally I'd advocate
having them as separate attributes as you have the input route to handle
'scans' of the channels for anyone who cares.
> +
> +static DEVICE_ATTR(mode, S_IWUGO | S_IRUGO,
> +		lsm303dlh_m_show_mode, lsm303dlh_m_store_mode);
Magic numbers?  Please don't this.  Firstly it doesn't seem to
be documented so even if there was no alternative it would need
that.  Secondly, nice simple strings are much clearer. Obviously
you will need to match this interface against similar ones elsewhere
in the kernel.  Attributes like this mean that no userspace code can
ever cover more than one part and the userspace code writers have
to have the datasheet in their hand to know what they need to write.
> +
> +static DEVICE_ATTR(range, S_IWUGO | S_IRUGO,
> +		lsm303dlh_m_show_range, lsm303dlh_m_store_range);
We have had a few discussions about this in IIO and eventually concluded
it's a lot easier to handle this as a scale parameter than as a range.
This is partly because we allow all computation of scaling etc to be done
in userspace and partly because range gets tricky to specify for any device
that say goes form -1V to +5V.

Also, what are the units of this? Without datasheet trawling it's not obviousl
> +
> +static DEVICE_ATTR(rate, S_IWUGO | S_IRUGO,
> +		lsm303dlh_m_show_rate, lsm303dlh_m_store_rate);
Check against other devices in tree.
> +
> +static struct attribute *lsm303dlh_m_attributes[] = {
> +	&dev_attr_gain.attr,
> +	&dev_attr_data.attr,
> +	&dev_attr_mode.attr,
> +	&dev_attr_range.attr,
> +	&dev_attr_rate.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group lsm303dlh_m_attr_group = {
> +	.attrs = lsm303dlh_m_attributes,
> +};
> +
> +static int __devinit lsm303dlh_m_probe(struct i2c_client *client,
> +						const struct i2c_device_id *id)
> +{
> +	int ret;
> +	struct lsm303dlh_m_data *ddata = NULL;
No need to set it to NULL. kzalloc will do that anyway
if it fails...
> +	unsigned char version[3];
> +
> +	ddata = kzalloc(sizeof(struct lsm303dlh_m_data), GFP_KERNEL);
> +	if (ddata == NULL) {
> +		ret = -ENOMEM;
> +		goto err_op_failed;
> +	}
> +
> +	ddata->client = client;
> +	i2c_set_clientdata(client, ddata);
> +
> +	/* copy platform specific data */
> +	memcpy(&ddata->pdata, client->dev.platform_data, sizeof(ddata->pdata));
> +
> +	ddata->mode = LSM303DLH_M_MODE_SLEEP;
> +	ddata->rate = LSM303DLH_M_RATE_00_75;
> +	ddata->range = LSM303DLH_M_RANGE_1_3G;
> +	ddata->range <<= LSM303DLH_M_CRB_GN_BIT;
> +	ddata->range &= LSM303DLH_M_CRB_GN_MASK;
> +	ddata->gain[ddata->pdata.axis_map_x] = XY_GAIN_1_3;
> +	ddata->gain[ddata->pdata.axis_map_y] = XY_GAIN_1_3;
> +	ddata->gain[ddata->pdata.axis_map_z] = Z_GAIN_1_3;
> +	dev_set_name(&client->dev, ddata->pdata.name_m);
> +	ddata->regulator = regulator_get(&client->dev, "v-mag");
> +
> +	if (IS_ERR(ddata->regulator)) {
> +		dev_err(&client->dev, "failed to get regulator\n");
> +		ret = PTR_ERR(ddata->regulator);
> +		ddata->regulator = NULL;
> +	}
> +
> +	if (ddata->regulator)
> +		regulator_enable(ddata->regulator);
> +
> +	ret = lsm303dlh_m_read_multi(ddata, IRA_REG_M, 3, version, "IRA_REG_M");
> +	if (ret < 0)
> +		goto exit_free_regulator;
> +
> +	dev_info(&client->dev, "Magnetometer, ID : %x:%x:%x",
> +			version[0], version[1], version[2]);
To be honest... Who cares what the version number is? Or is going to
look in the kernel logs if they do...
> +
> +	mutex_init(&ddata->lock);
> +
> +	ret = sysfs_create_group(&client->dev.kobj, &lsm303dlh_m_attr_group);
> +	if (ret)
> +		goto exit_free_regulator;
> +
See comment below on ripping this stuff out to a separate file and doing
the ifdefs in the header.
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +
> +	ddata->input_dev = input_allocate_device();
> +	if (!ddata->input_dev) {
> +		ret = -ENOMEM;
> +		dev_err(&client->dev, "Failed to allocate input device\n");
> +		goto exit_free_regulator;
> +	}
> +
> +	set_bit(EV_ABS, ddata->input_dev->evbit);
> +
> +	/* x-axis acceleration */
> +	input_set_abs_params(ddata->input_dev, ABS_X, -32768, 32767, 0, 0);
> +	/* y-axis acceleration */
> +	input_set_abs_params(ddata->input_dev, ABS_Y, -32768, 32767, 0, 0);
> +	/* z-axis acceleration */
> +	input_set_abs_params(ddata->input_dev, ABS_Z, -32768, 32767, 0, 0);
> +
> +	ddata->input_dev->name = "magnetometer";
Isn't that a bit vague for naming?  (one for Dmitry and the input guys).
> +
> +	ret = input_register_device(ddata->input_dev);
> +	if (ret) {
> +		dev_err(&client->dev, "Unable to register input device: %s\n",
> +				ddata->input_dev->name);
> +		goto err_input_register_failed;
> +	}
> +
> +	/* register interrupt */
> +	ret = request_threaded_irq(gpio_to_irq(ddata->pdata.irq_m), NULL,
> +		   lsm303dlh_m_gpio_irq,
> +		   IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING, "lsm303dlh_m",
> +		   ddata);
> +	if (ret) {
> +		dev_err(&client->dev, "request irq EGPIO_PIN_1 failed\n");
> +		goto err_input_failed;
> +	}
> +
> +	disable_irq(gpio_to_irq(ddata->pdata.irq_m));
> +#endif
> +
> +	return ret;
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +err_input_failed:
> +	input_unregister_device(ddata->input_dev);
> +err_input_register_failed:
> +	input_free_device(ddata->input_dev);
> +#endif
> +exit_free_regulator:
> +	if (ddata->regulator) {
> +		regulator_disable(ddata->regulator);
> +		regulator_put(ddata->regulator);
> +	}
> +err_op_failed:
> +	dev_err(&client->dev, " lsm303dlh_m_probe failed %x", ret);
Don't think you want that leading space in the string.
> +	kfree(ddata);
> +	return ret;
> +}
> +
> +static int __devexit lsm303dlh_m_remove(struct i2c_client *client)
> +{
> +	struct lsm303dlh_m_data *ddata;
> +
> +	ddata = i2c_get_clientdata(client);
I'd roll the previous two lines together. 
> +

> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +	input_unregister_device(ddata->input_dev);
> +	input_free_device(ddata->input_dev);
> +#endif
> +
> +	sysfs_remove_group(&client->dev.kobj, &lsm303dlh_m_attr_group);
> +
> +	/* safer to make device off */
> +	if (ddata->mode != LSM303DLH_M_MODE_SLEEP) {
> +		lsm303dlh_m_set_mode(ddata, LSM303DLH_M_MODE_SLEEP);
> +		regulator_disable(ddata->regulator);
> +	}
> +
> +	regulator_put(ddata->regulator);
> +	i2c_set_clientdata(client, NULL);
> +	kfree(ddata);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int lsm303dlh_m_suspend(struct device *dev)
> +{
> +	struct lsm303dlh_m_data *ddata;
> +	int ret;
> +
> +	ddata = dev_get_drvdata(dev);
struct lsm303dlh_m_data *ddata = dev_get_drvdata(dev)l
is cleaner than doing it in two lines.
> +
> +	if (ddata->mode == LSM303DLH_M_MODE_SLEEP)
> +		return 0;
> +
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +	disable_irq(gpio_to_irq(ddata->pdata.irq_m));
> +#endif
> +
> +	ret = lsm303dlh_m_set_mode(ddata, LSM303DLH_M_MODE_SLEEP);
> +	if (ret < 0)
> +		return ret;
> +
> +	regulator_disable(ddata->regulator);
> +	return ret;
> +}
> +
> +static int lsm303dlh_m_resume(struct device *dev)
> +{
> +	struct lsm303dlh_m_data *ddata;
> +	int ret;
> +
> +	ddata = dev_get_drvdata(dev);
same as previous one.
> +
> +	/* in correct mode, no need to change it */
> +	if (ddata->mode == LSM303DLH_M_MODE_SLEEP)
> +		return 0;
> +
There are a lot of thes input related ifdefs. 
The prefered option if remotely sensible is to do these
in a header. You then have a separate source file with
implementations that is only compiled in if this option
is enabled and stubs in the header for when it isn't.
> +#ifdef CONFIG_SENSORS_LSM303DLH_INPUT_DEVICE
> +	enable_irq(gpio_to_irq(ddata->pdata.irq_m));
> +#endif
> +
> +	regulator_enable(ddata->regulator);
> +
> +	ret = lsm303dlh_m_restore(ddata);
> +
> +	if (ret < 0)
> +		return ret;
Why?

return lsm303dlh_m_restore(ddata);

 will do just fine. (and lose the int ret; above as well)
> +
> +	return ret;
> +}
> +static const struct dev_pm_ops lsm303dlh_m_dev_pm_ops = {
> +	.suspend = lsm303dlh_m_suspend,
> +	.resume  = lsm303dlh_m_resume,
> +};
> +#endif /* CONFIG_PM */
> +
> +static const struct i2c_device_id lsm303dlh_m_id[] = {
> +	{ "lsm303dlh_m", 0 },
> +	{ },
> +};
> +
> +static struct i2c_driver lsm303dlh_m_driver = {
> +	.probe		= lsm303dlh_m_probe,
> +	.remove		= lsm303dlh_m_remove,
> +	.id_table	= lsm303dlh_m_id,
> +	.driver = {
> +		.name = "lsm303dlh_m",
> +	#ifdef CONFIG_PM
> +		.pm = &lsm303dlh_m_dev_pm_ops,
> +	#endif
> +	},
> +};
> +
> +static int __init lsm303dlh_m_init(void)
> +{
> +	return i2c_add_driver(&lsm303dlh_m_driver);
> +}
> +
> +static void __exit lsm303dlh_m_exit(void)
> +{
> +	i2c_del_driver(&lsm303dlh_m_driver);
> +}
> +
> +module_init(lsm303dlh_m_init);
> +module_exit(lsm303dlh_m_exit);
> +
> +MODULE_DESCRIPTION("lSM303DLH 3-Axis Magnetometer Driver");
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("STMicroelectronics");
> diff --git a/include/linux/lsm303dlh.h b/include/linux/lsm303dlh.h
> new file mode 100644
> index 0000000..d9fd614
> --- /dev/null
> +++ b/include/linux/lsm303dlh.h
> @@ -0,0 +1,56 @@
> +/*
> + * lsm303dlh.h
> + * ST 3-Axis Accelerometer/Magnetometer header file
> + *
> + * Copyright (C) 2010 STMicroelectronics
> + * Author: Carmine Iascone (carmine.iascone@st.com)
> + * Author: Matteo Dameno (matteo.dameno@st.com)
> + *
> + * Copyright (C) 2010 STEricsson
> + * Author: Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
> + * Updated:Preetham Rao Kaskurthi <preetham.rao@stericsson.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __LSM303DLH_H__
> +#define __LSM303DLH_H__
> +
> +#include <linux/ioctl.h>
Why?
> +
> +#ifdef __KERNEL__
Personally I prefer kernel doc for structures like this,
but that's down to whether the maintainer who takes it
cares.
> +struct lsm303dlh_platform_data {
> +
> +	/* name of device for regulator */
> +
> +	const char *name_a; /* acelerometer name */
> +	const char *name_m; /* magnetometer name */
> +
> +	/*  interrupt data */
> +	u32  irq_a1;      /* interrupt line 1 of accelrometer*/
accelerometer
> +	u32  irq_a2;      /* interrupt line 2 of accelrometer*/
> +	u32  irq_m;       /* interrupt line of magnetometer*/
> +
> +	/* position of x,y and z axis */
> +	u8  axis_map_x; /* [0-2] */
> +	u8  axis_map_y; /* [0-2] */
> +	u8  axis_map_z; /* [0-2] */
> +
> +	/* orientation of x,y and z axis */
> +	u8  negative_x; /* [0-1] */
> +	u8  negative_y; /* [0-1] */
> +	u8  negative_z; /* [0-1] */
> +};
> +#endif /* __KERNEL__ */
> +
> +#endif  /* __LSM303DLH_H__ */

