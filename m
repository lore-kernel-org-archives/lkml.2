Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0KYKRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:17:47 -0500
Received: from 31.mail-out.ovh.net ([213.186.62.10]:39262 "HELO
	31.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751374Ab0KYKRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:17:45 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2010 05:17:44 EST
Message-ID: <4CEE3632.6020502@armadeus.com>
Date: Thu, 25 Nov 2010 11:10:58 +0100
From: Fabien Marteau <fabien.marteau@armadeus.com>
Reply-To: fabien.marteau@armadeus.com
Organization: ARMadeus Systems
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver
References: <4CEBED7E.7010101@armadeus.com> <20101124195523.GF27368@core.coreip.homeip.net>
In-Reply-To: <20101124195523.GF27368@core.coreip.homeip.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3905465302302810523
X-Ovh-Remote: 82.232.255.99 (arc68-6-82-232-255-99.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thank you for yours comments, it's my first kernel driver patch and your advices
are really helpful.

On 24/11/2010 20:55, Dmitry Torokhov wrote:
> Hi Fabien,
> 
> On Tue, Nov 23, 2010 at 05:36:14PM +0100, Fabien Marteau wrote:
>> Driver for EasyPoint AS5011 2 axis joystick chip. This chip is plugged
>> on an I2C bus. It as been tested on ARM processor (i.MX27).
>>
> 
> Thank you for the patch. In addiitoon to comments you got from the other
> reviewers I'd recommend switching to threaded IRQ instead of using a
> separate workqueue, it greatly simplifies the code.

Ok I will see it.

> 
>> +
>> +static irqreturn_t button_interrupt(int irq, void *dev_id)
>> +{
>> +	struct as5011_platform_data *plat_dat =
>> +		(struct as5011_platform_data *)dev_id;
>> +	int ret;
>> +
>> +	ret = gpio_get_value(plat_dat->button_gpio);
>> +	if (ret)
>> +		input_report_key(plat_dat->input_dev, BTN_JOYSTICK, 0);
>> +	else
>> +		input_report_key(plat_dat->input_dev, BTN_JOYSTICK, 1);
>> +	input_sync(plat_dat->input_dev);
>> +	return IRQ_HANDLED;
> 
> That appears to be a hard IRQ; are you sure that gpio_get_value will not
> sleep?

For my platform, yes I'm sure … but if somebody else use this driver with
gpio that can sleep, it can be a bad idea of course.
I did it because it's under an interrupt call, then we can't sleep.
I will see how to use  a threaded IRQ to avoid it.

> 
>> +
>> +	plat_dat->input_dev->name = "Austria Microsystem as5011 joystick";
>> +	plat_dat->input_dev->uniq = "Austria0";
>> +	plat_dat->input_dev->id.bustype = BUS_I2C;
>> +	plat_dat->input_dev->phys = "/dev/input/event0";
> 
> Phys is not the path in device tree but rather physical device
> connection path within the system. If there is not known connection path
> it is better just leave it as NULL.

Ok, done.

> 
>> +	plat_dat->input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
>> +	plat_dat->input_dev->keybit[BIT_WORD(BTN_JOYSTICK)] =
>> +					BIT_MASK(BTN_JOYSTICK);
>> +
>> +	input_set_abs_params(plat_dat->input_dev,
>> +			     ABS_X,
>> +			     AS5011_MIN_AXIS,
>> +			     AS5011_MAX_AXIS,
>> +			     AS5011_FUZZ,
>> +			     AS5011_FLAT);
>> +	input_set_abs_params(plat_dat->input_dev,
>> +			     ABS_Y,
>> +			     AS5011_MIN_AXIS,
>> +			     AS5011_MAX_AXIS,
>> +			     AS5011_FUZZ,
>> +			     AS5011_FLAT);
>> +
>> +	plat_dat->button_irq_name =
>> +		kmalloc(sizeof(unsigned char)*SIZE_NAME,
>> +					 GFP_KERNEL);
> 
> Just why does it have to be separately allocated? I'd even stick with
> "as5011" for all IRQ names.

I thought that irq name should be different for each IRQ used under device and
for each device used in system. I can use the same irq name if I've got several
as5011 joystick in the same system ?

> 
>> +
>> +	queue_work(plat_dat->workqueue, &plat_dat->update_axes_work);
>> +
> 
> The device is quite likely not opened here so why do you want to send
> events?
It was a mistake.

> 
> Thanks.
> 

Thanks too.
Fabien
