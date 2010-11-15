Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0KOJdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:33:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34533 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0KOJdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:33:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MqT9YWIwcW/l6ufPJ3WkMJgKm/tKGUBskz2S4KRX96lKgCd2U+Isd7zh3OCR/2vfLA
         pjHqUIa9gzWDlITB2ujZufNMLfNwu4Mex5Xg0oFTdCFyZgAOl9QcVqxqXYBSqFS2YlIN
         UljmMDLYnzuLGqARdD20H6BWvyjQmUJFWsifk=
Message-ID: <4CE0FE71.6000303@suse.cz>
Date: Mon, 15 Nov 2010 10:33:37 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Alex Gershgorin <agersh@rambler.ru>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
In-Reply-To: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 09:23 AM, Baruch Siach wrote:
> --- /dev/null
> +++ b/drivers/misc/altera_as.c
> @@ -0,0 +1,349 @@
...
> +struct altera_as_device {
> +	unsigned id;
> +	struct device *dev;
> +	struct miscdevice miscdev;
> +	struct mutex open_lock;
> +	struct gpio gpios[AS_GPIO_NUM];
> +};
> +
> +/*
> + * The only functions updating this array are .probe/.remove, which are
> + * serialized. Hence, no locking is needed here.
> + */
> +static struct {
> +	int minor;

Why you need minor here? It's in drvdata->miscdev.minor.

> +	struct altera_as_device *drvdata;
> +} altera_as_devs[AS_MAX_DEVS];

You don't need the struct at all.
static struct altera_as_device *drvdata[AS_MAX_DEVS];
should be enough.

> +static int altera_as_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +	struct altera_as_device *drvdata = get_as_dev(iminor(inode));
> +
> +	if (drvdata == NULL)
> +		return -ENODEV;
> +	file->private_data = drvdata;
> +
> +	ret = mutex_trylock(&drvdata->open_lock);
> +	if (ret == 0)
> +		return -EBUSY;
> +
> +	ret = gpio_request_array(drvdata->gpios, ARRAY_SIZE(drvdata->gpios));
> +	if (ret < 0) {
> +		mutex_unlock(&drvdata->open_lock);
> +		return ret;
> +	}

So leaving to userspace with mutex held. This is *wrong*. use
test_and_set_bit or alike instead.

> +	return 0;
> +}
> +
> +static ssize_t altera_as_write(struct file *file, const char __user *buf,
> +		size_t count, loff_t *ppos)
> +{
...
> +	while ((count - written) > 0) {
> +		err = copy_from_user(page_buf, buf+written, AS_PAGE_SIZE);
> +		if (err < 0) {
> +			err = -EFAULT;
> +			goto out;
> +		}
> +
> +		xmit_cmd(drvdata->gpios, AS_WRITE_ENABLE);
> +
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 0);
> +		/* op code */
> +		xmit_byte(drvdata->gpios, AS_PAGE_PROGRAM);
> +		/* address */
> +		xmit_byte(drvdata->gpios, (*ppos >> 16) & 0xff);
> +		xmit_byte(drvdata->gpios, (*ppos >> 8) & 0xff);
> +		xmit_byte(drvdata->gpios, *ppos & 0xff);
> +		/* page data (LSB first) */
> +		for (i = 0; i < AS_PAGE_SIZE; i++)
> +			xmit_byte(drvdata->gpios, bitrev8(page_buf[i]));
> +		gpio_set_value(drvdata->gpios[ASIO_NCS].gpio, 1);
> +		mdelay(7);

So if I write 100 pages, I will _spin_ for 700 ms. You should rather
(m)sleep here.

> +
> +		*ppos += AS_PAGE_SIZE;
> +		written += AS_PAGE_SIZE;
> +	}
> +
> +out:
> +	kfree(page_buf);
> +	return err ?: written;
> +}
...
> +static int __init altera_as_probe(struct platform_device *pdev)
> +{
...
> +	drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
> +	drvdata->miscdev.name = kasprintf(GFP_KERNEL, "altera_as%d",
> +			pdata->id);
> +	if (drvdata->miscdev.name == NULL)
> +		return -ENOMEM;
> +	drvdata->miscdev.fops = &altera_as_fops;
> +	if (misc_register(&drvdata->miscdev) < 0) {

Hmm, how many devices can be in the system? This doesn't look like the
right way.

> +		kfree(drvdata->miscdev.name);
> +		return -ENODEV;
> +	}
> +	altera_as_devs[pdata->id].minor = drvdata->miscdev.minor;
> +	altera_as_devs[pdata->id].drvdata = drvdata;

So now the device is usable without the mutex and gpios inited?

> +	mutex_init(&drvdata->open_lock);
> +
> +	drvdata->id = pdata->id;
> +
> +	drvdata->gpios[ASIO_DATA].gpio		= pdata->data;
> +	drvdata->gpios[ASIO_DATA].flags		= GPIOF_IN;
> +	drvdata->gpios[ASIO_DATA].label		= "as_data";
...
> +	drvdata->gpios[ASIO_NCE].gpio		= pdata->nce;
> +	drvdata->gpios[ASIO_NCE].flags		= GPIOF_OUT_INIT_HIGH;
> +	drvdata->gpios[ASIO_NCE].label		= "as_nce";
> +
> +	dev_info(drvdata->dev, "Altera Cyclone Active Serial driver\n");
> +
> +	return 0;
> +}

regards,
-- 
js
suse labs
