Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab1AGTm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:42:56 -0500
Received: from 27.mail-out.ovh.net ([91.121.30.210]:34387 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754471Ab1AGTmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:42:54 -0500
Message-ID: <4D276CAD.5090604@armadeus.com>
Date: Fri, 07 Jan 2011 20:42:37 +0100
From: Fabien Marteau <fabien.marteau@armadeus.com>
Reply-To: fabien.marteau@armadeus.com
Organization: ARMadeus Systems
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Trilok Soni <tsoni@codeaurora.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver (third version)
References: <4D22ECB6.6090800@armadeus.com> <4D22FE0F.7010206@codeaurora.org>
In-Reply-To: <4D22FE0F.7010206@codeaurora.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 7833448603739840841
X-Ovh-Remote: 82.232.255.99 (arc68-6-82-232-255-99.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 12:01, Trilok Soni wrote:
> Hi Fabien,
> 
> On 1/4/2011 3:17 PM, Fabien Marteau wrote:
>>  Driver for EasyPoint AS5011 2 axis joystick chip. This chip is plugged
>>  on an I2C bus. It has been tested on ARM processor (i.MX27).
>>
>> Third version, according to Dmitry Torokhov and Trilok Soni comments.
>>
>>
>> Signed-off-by: Fabien Marteau <fabien.marteau@armadeus.com>
>> ---
> 
> Looks good. Few comments.
> 
>>  drivers/input/joystick/Kconfig  |    9 +
>>  drivers/input/joystick/Makefile |    1 +
>>  drivers/input/joystick/as5011.c |  377 +++++++++++++++++++++++++++++++++++++++
>>  include/linux/as5011.h          |   35 ++++
> 
> How about moving it to include/linux/input?

It's better yes.

> 
>> +
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/slab.h>
>> +#include <linux/i2c.h>
>> +#include <linux/string.h>
>> +#include <linux/list.h>
>> +#include <linux/sysfs.h>
>> +#include <linux/ctype.h>
>> +#include <linux/hwmon-sysfs.h>
> 
> Are you using anything from this file? Please audit this list and remove
> the files which are not used. Thanks.

Done

> 
>> +
>> +#define SIZE_NAME 30
>> +#define SIZE_EVENT_PATH 40
> 
> I don't find anybody using these #defines. Please remove the defines which
> are not used.

Old useless macro, deleted.

> 
>> +#define AS5011_MAX_AXIS	80
>> +#define AS5011_MIN_AXIS	(-80)
>> +#define AS5011_FUZZ	8
>> +#define AS5011_FLAT	40
>> +
>> +static int as5011_i2c_write(struct i2c_client *client,
>> +			    uint8_t aregaddr,
>> +			    uint8_t avalue)
>> +{
>> +	int ret;
>> +	uint8_t data[2] = { aregaddr, avalue };
>> +
>> +	struct i2c_msg msg = {	client->addr,
>> +				I2C_M_IGNORE_NAK,
>> +				2,
>> +				(uint8_t *)data };
>> +
>> +	ret = i2c_transfer(client->adapter, &msg, 1);
>> +
>> +	if (ret < 0)
>> +		return ret;
>> +	return 1;
>> +}
> 
> We return '0' on success and negative error code for error.

Ok.

> 
>> +
>> +static irqreturn_t button_interrupt(int irq, void *dev_id)
>> +{
>> +	struct as5011_platform_data *plat_dat = dev_id;
>> +	int ret;
>> +
>> +	ret = gpio_get_value(plat_dat->button_gpio);
> 
> I don't find gpio_request call for this gpio anywhere in this driver. I prefer
> that we do that for each gpio we use in the driver itself. Only muxing stuff
> can be left out in your init/exit hooks.

Ok I added it and deleted init/exit hooks.

> 
>> +	if (ret)
>> +		input_report_key(plat_dat->input_dev, BTN_JOYSTICK, 0);
>> +	else
>> +		input_report_key(plat_dat->input_dev, BTN_JOYSTICK, 1);
>> +	input_sync(plat_dat->input_dev);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static void as5011_update_axes(struct as5011_platform_data *plat_dat)
>> +{
>> +	signed char x, y;
>> +
>> +	x = as5011_i2c_read(plat_dat->i2c_client, AS5011_X_RES_INT);
>> +	y = as5011_i2c_read(plat_dat->i2c_client, AS5011_Y_RES_INT);
> 
> I prefer that i2c_read wrapper here would return the actual error code instead,
> and have one function argument to return the "x, y" co-ordinates, that way
> we don't loose the error codes, and return from here itself if i2c read fails.

Ok

> 
>> +	input_report_abs(plat_dat->input_dev, ABS_X, x);
>> +	input_report_abs(plat_dat->input_dev, ABS_Y, y);
>> +	input_sync(plat_dat->input_dev);
>> +}
>> +
>> +static irqreturn_t as5011_int_interrupt(int irq, void *dev_id)
>> +{
>> +	struct as5011_platform_data *plat_dat = dev_id;
>> +
>> +	mutex_lock(&plat_dat->update_lock);
>> +	as5011_update_axes(plat_dat);
>> +	mutex_unlock(&plat_dat->update_lock);
> 
> Please explain this lock. Sorry if I have missed out your explanation in the earlier threads.

If a second interruption occurs the first update must be finished before update again.

> 
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static int __devinit as5011_probe(struct i2c_client *client,
>> +			const struct i2c_device_id *id)
>> +{
>> +	struct as5011_platform_data *plat_dat = client->dev.platform_data;
> 
> const please. 

ok

>> +
>> +	retval = request_threaded_irq(plat_dat->button_irq,
>> +					NULL, button_interrupt,
>> +					0, "as5011_button",
>> +					plat_dat);
>> +	if (retval < 0) {
>> +		dev_err(&client->dev, "Can't allocate irq %d\n",
>> +			plat_dat->button_irq);
>> +		retval = -EBUSY;
> 
> Why don't we return same error code instead of overwriting it here?

Copy/paste error.


>> +
>> +	/* to free irq gpio in chip*/
>> +	as5011_i2c_read(plat_dat->i2c_client, AS5011_X_RES_INT);
> 
> Would you prefer to move some of the initialization of the chip except
> reset of controller to open() call, so that if there is no user of this
> device than we don't need to leave this device left configured?

I it could be a good idea. I didn't know that I can catch the open() call under the driver.

>> +struct as5011_platform_data {
>> +	/* public */
>> +	int button_gpio;
>> +	int button_irq;
>> +	int int_gpio;
>> +	int int_irq;
>> +	char xp, xn; /* threshold for x axis */
>> +	char yp, yn; /* threshold for y axis */
>> +
>> +	int (*init_gpio)(void); /* init interrupts gpios */
>> +	void (*exit_gpio)(void);/* exit gpios */
>> +
>> +	/* private */
>> +	struct input_dev *input_dev;
>> +	struct i2c_client *i2c_client;
>> +	char name[AS5011_MAX_NAME_LENGTH];
>> +	struct mutex update_lock;
> 
> These private stuff should not be part of your platform data structure. When we say
> platform data meaning that it will be all public with "const". Please allocate
> local data structure in the probe itself with these private members. You can refer
> other drivers.

Ok done.

> 
> 
> ---Trilok Soni
> 

-- Fabien Marteau

