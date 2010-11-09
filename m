Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0KIUPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:15:16 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:48687 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab0KIUPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:15:12 -0500
Message-ID: <dbd33aac54791d5b5f33f03325b6b4bc.squirrel@webmail.greenhost.nl>
In-Reply-To: <20101109153550.GD29441@jasper.tkos.co.il>
References: <f04cbe31c7e03a9d798b30526a5fed1cd8ee4c7a.1289297142.git.baruch@tkos.co.il>
    <0d1a323315dcf505e64fb5165ea41e95.squirrel@webmail.greenhost.nl>
    <20101109153550.GD29441@jasper.tkos.co.il>
Date: Tue, 9 Nov 2010 21:15:09 +0100 (CET)
Subject: Re: [PATCHv2] drivers/misc: Altera Cyclone active serial 
     implementation
From: "Indan Zupancic" <indan@nul.nu>
To: "Baruch Siach" <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>,
        "Alex Gershgorin" <agersh@rambler.ru>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: fcb7c697ec3ef2fbe58fd922c339dcbb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Baruch,

On Tue, November 9, 2010 16:35, Baruch Siach wrote:
>> > --- /dev/null
>> > +++ b/drivers/misc/cyclone_as.c
>> > @@ -0,0 +1,343 @@
>> > +/*
>> > + * Copyright 2010 Alex Gershgorin, Orex Computed Radiography
>> > + *
>> > + * The code contained herein is licensed under the GNU General Public
>> > + * License. You may obtain a copy of the GNU General Public License
>> > + * Version 2 or later at the following locations:
>> > + *
>> > + * http://www.opensource.org/licenses/gpl-license.html
>> > + * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
>> > + */
>>
>> GPLv2 is included with the kernel source, no need to give external links.
>
> This copyright notice (or a similar one) is common in almost all kernel
> source files. I guess it meant to cover the case of this file being
> distributed separate from the kernel.

I know, but having that in every file is a bit pointless. Mentioning the
copyright and license version (mostly if it's different than the default)
should be sufficient. If nothing is mentioned it's the same as the rest of
the kernel (GPLv2). So I'd either leave it away altogether, or if you want
GPLv2 or later, mention just that.

> On page 3-30, the third paragraph from the page end mentions both nCONFIG
> and nCE.

Ah, okay.

>> > +#define AS_GPIO_NUM		6
>> > +
>> > +#define AS_ALIGNED(x)	IS_ALIGNED(x, AS_PAGE_SIZE)
>> > +
>> > +struct cyclone_as_device {
>> > +	unsigned id;
>> > +	struct device *dev;
>> > +	struct miscdevice miscdev;
>> > +	struct mutex open_lock;
>> > +	struct gpio gpios[AS_GPIO_NUM];
>>
>> I wonder whether it would be nicer to have them as proper struct members
>> instead of an array.
>
> This way I can use gpio_request_array/gpio_free_array directly.

That is the upside, and it could be the better approach. It's just
used that often that I wonder if it won't look nicer if it's changed
to separate members. No need to bother though. The emulating a struct
with an array and defines just irks me.

>
>> > +};
>> > +
>> > +static struct {
>> > +	int minor;
>> > +	struct cyclone_as_device *drvdata;
>> > +} cyclone_as_devs[AS_MAX_DEVS];
>> > +
>> > +static struct cyclone_as_device *get_as_dev(int minor)
>> > +{
>> > +	int i;
>> > +
>> > +	for (i = 0; i < ARRAY_SIZE(cyclone_as_devs); i++)
>>
>> To me AS_MAX_DEVS looks clearer than ARRAY_SIZE(cyclone_as_devs).
>
> Not to me. The fact that AS_MAX_DEVS happens to be equal to
> ARRAY_SIZE(cyclone_as_devs) is not relevant to the understanding of this
> procedure. It just forces the reader to lookup the AS_MAX_DEVS value, and
> distracts the reader's attention.

Then just leave the AS_MAX_DEVS define away, it doesn't add anything.
Also change the:

+	if (pdata->id >= AS_MAX_DEVS)
+		return -ENODEV;

to

+	if (pdata->id >= ARRAY_SIZE(cyclone_as_devs))
+		return -ENODEV;

After all, what you're really checking is if the id falls within the
array.

>> > +		if (cyclone_as_devs[i].minor == minor)
>> > +			return cyclone_as_devs[i].drvdata;
>> > +
>> > +	return NULL;
>> > +}
>> > +
>> > +static void as_clk_tick(struct gpio *gpios)
>> > +{
>> > +	gpio_set_value(gpios[ASIO_DCLK].gpio, 0);
>> > +	ndelay(40);
>> > +	gpio_set_value(gpios[ASIO_DCLK].gpio, 1);
>> > +	ndelay(20);
>>
>> Shouldn't the first ndelay(40) be a ndelay(20) too? That way the total
>> is 40 and you get a 25MHz clock.
>
> OK. I'll look into this.
>
>> > +}
>> > +
>> > +static void xmit_byte(struct gpio *gpios, u8 c)
>> > +{
>> > +	int i;
>> > +
>> > +	for (i = 0; i < 8; i++) {
>> > +		gpio_set_value(gpios[ASIO_ASDI].gpio, (c << i) & 0x80);
>> > +		as_clk_tick(gpios);
>> > +	}
>> > +}
>> > +
>> > +static void xmit_cmd(struct gpio *gpios, u8 cmd)
>> > +{
>> > +	gpio_set_value(gpios[ASIO_NCS].gpio, 0);
>> > +	xmit_byte(gpios, cmd);
>> > +	gpio_set_value(gpios[ASIO_NCS].gpio, 1);
>> > +	ndelay(300);
>>
>> That ndelay looks redundant, just leave it away?
>>
>> I can't find any requirement for it in the doc. Is it the 8 cycles
>> thing for NCS? If so, that seems to be handled automatically because
>> only whole bytes are sent at a time.
>
> Table 3-16 mandates 100ns for tCSH (Chip select high time). So this can be
> reduced to 100ns, but not eliminated.

You're right. When I saw that I misread it as the Chip select low time.

>> > +}
>> > +
>> > +static u8 recv_byte(struct gpio *gpios)
>> > +{
>> > +	int i;
>> > +	u8 val = 0;
>> > +
>> > +	for (i = 0; i < 8; i++) {
>> > +		as_clk_tick(gpios);
>> > +		val |= (!!gpio_get_value(gpios[ASIO_DATA].gpio) << (7 - i));
>>
>> The !! is a bit redundant. If it changes the reslult, val is invalid anyway?
>
> According to Documentation/gpio.txt, gpio_get_value returns nonzero for high.
> The !! prefix makes this 1.

Great. They should have specified 0 and 1. *grumbles*

>> > +	}
>> > +
>> > +	return val;
>> > +}
>> > +
>> > +static int cyclone_as_open(struct inode *inode, struct file *file)
>> > +{
>> > +	int ret;
>> > +	struct cyclone_as_device *drvdata = get_as_dev(iminor(inode));
>> > +
>> > +	if (drvdata == NULL)
>> > +		return -ENODEV;
>> > +	file->private_data = drvdata;
>> > +
>> > +	ret = mutex_trylock(&drvdata->open_lock);
>> > +	if (ret == 0)
>> > +		return -EBUSY;
>> > +
>> > +	ret = gpio_request_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));
>>
>> AS_GPIO_NUM?
>
> See above.

If you're not really using the define, you can as well leave it away then.

>> > +	if (ret < 0) {
>> > +		mutex_unlock(&drvdata->open_lock);
>> > +		return ret;
>> > +	}
>> > +
>> > +	return 0;
>> > +}
>> > +
>> > +static ssize_t cyclone_as_write(struct file *file, const char __user *buf,
>> > +		size_t count, loff_t *ppos)
>> > +{
>> > +	int	i, err = 0;
>> > +	u8	*page_buf;
>> > +	ssize_t written = 0;
>> > +	struct cyclone_as_device *drvdata = file->private_data;
>> > +	unsigned page_count;
>> > +
>> > +	if (count == 0)
>> > +		return 0;
>> > +
>> > +	/* writes must be page aligned */
>> > +	if (!AS_ALIGNED(*ppos) || !AS_ALIGNED(count))
>> > +		return -EINVAL;

As you're only incrementing ppos with the page size, is that first check
really needed? I don't think anything else can change ppos.

>> > +	page_count = *ppos / AS_PAGE_SIZE;
>> > +
>> > +	page_buf = kmalloc(AS_PAGE_SIZE, GFP_KERNEL);
>> > +	if (page_buf == NULL)
>> > +		return -ENOMEM;
>> > +
>> > +	if (*ppos == 0) {
>> > +		u8 as_status;
>> > +
>> > +		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
>> > +		xmit_cmd(drvdata->gpios, AS_ERASE_BULK);
>> > +
>> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
>> > +		xmit_byte(drvdata->gpios, AS_READ_STATUS);
>> > +		for (i = 0; i < AS_ERASE_TIMEOUT; i++) {
>> > +			as_status = recv_byte(drvdata->gpios);
>> > +			if ((as_status & AS_STATUS_WIP) == 0)
>> > +				break; /* erase done */
>> > +			if (msleep_interruptible(1000) > 0) {
>> > +				err = -EINTR;
>> > +				break;
>> > +			}
>> > +		}
>> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
>> > +		if ((as_status & AS_STATUS_WIP) && err == 0)
>> > +			err = -EIO; /* erase timeout */
>> > +		if (err)
>> > +			goto out;
>> > +		ndelay(300);
>> > +	}
>>
>> I'd move this into its own function, erase_device() or something.
>
> OK.
>
>> (And drop the ndelay.)
>
> See above.

In that case I'd move it to just after the gpio_set*.

>
>> > +	while (count) {
>> > +		dev_dbg(drvdata->dev, "offset = 0x%p\n", buf+written);
>>
>> If you tested this code and it works, then this dev_dbg() shouldn't be
>> needed anymore.
>
> OK.
>
>> > +		err = copy_from_user(page_buf, buf+written, AS_PAGE_SIZE);
>> > +		if (err < 0) {
>> > +			err = -EFAULT;
>> > +			goto out;
>> > +		}
>> > +
>> > +		*ppos += AS_PAGE_SIZE;
>> > +		count -= AS_PAGE_SIZE;
>> > +		written += AS_PAGE_SIZE;
>> > +
>> > +		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
>> > +
>> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
>> > +		/* op code */
>> > +		xmit_byte(drvdata->gpios, AS_PAGE_PROGRAM);
>> > +		/* address */
>> > +		xmit_byte(drvdata->gpios, (page_count >> 8) & 0xff);
>> > +		xmit_byte(drvdata->gpios, page_count & 0xff);
>> > +		xmit_byte(drvdata->gpios, 0);
>> > +		/* page data (LSB first) */
>> > +		for (i = 0; i < AS_PAGE_SIZE; i++)
>> > +			xmit_byte(drvdata->gpios, bitrev8(page_buf[i]));
>> > +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
>> > +		page_count++;
>> > +		mdelay(7);
>> > +	}
>> > +
>> > +out:
>> > +	kfree(page_buf);
>> > +	return err ?: written;
>>
>> Maybe use one variable to combine err and written.
>
> OK.
>
>> > +}
>
> [snip]
>
>> Reviewed-by: Indan Zupancic <indan@nul.nu>
>
> Thanks,
>
> baruch
>

You're welcome.

Greetings,

Indan


