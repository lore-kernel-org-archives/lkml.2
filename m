Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1LIPJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:09:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1LIPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:09:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sjur =?utf-8?q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: Re: [PATCHv2 07/10] xshm: XSHM Configuration data handling
Date: Fri, 9 Dec 2011 15:09:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com> <1323439648-22697-8-git-send-email-sjur.brandeland@stericsson.com>
In-Reply-To: <1323439648-22697-8-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201112091509.41123.arnd@arndb.de>
X-Provags-ID: V02:K0:LsqAWA0b1PyKe0z4zbISQf21nB+0m2WtaqelZ1eowgc
 QeC5oFOCvv9N8x8mQc/D1a9c4L1nA+0mIem7EU+L8vWwnuAdWn
 oiXSQqrcRzFTjP6S8iGMnWwVBy5FMkUntEqwMFmuuuaEvb9AlY
 xCwCWJB9gKeQCmg8nEfD1CGeZrXSCzXX7FicLITNkA1AM7/R8F
 9feR8U1aT2a1mNNFr24Rs3HvjoU5XHf9mRX9ZDtzZFgse4gdeS
 qxIO7hKVuqrjLA1oXHYpF0MiGWaabVTu2C34+z7Ux4yD75wqM3
 JxfGSuqSqMTJasKObfAxANExo5/i7mA/tyJpkuYHZ1/aItZIbc
 F4FFAGA1SScfEjiWosVM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 December 2011, Sjur Brændeland wrote:
> This patch implements the configuration handling:
> - reception of gen-netlink requests from user-space.
> - calculating address of where to put information in shared memory, i.e
>   the offset of: IPC-TOC, channel-descriptors, read/write indexes for each
>   directional channel, and data area of each channel.
> - formatting of the shared memory area, so modem can read out configuration
>   data.
> - Creation of configuration data given to the XSHM drivers: xshm_chr and
>   caif_xshm.

Hmm, from what I read here, you rely on the user to create the channels
that correspond to the ones that the modem side has configured.

Why is that? Can't you query from the modem what channels it needs and
then automatically create those?

> +static bool config_error;
> +static bool commited;
> +static bool registered;
> +static bool addr_set;
> +static u32 modem_bootimg_size;
> +static void *shm_start;
> +static u32 xshm_channels;
> +static struct xshm_dev *xshmdevs[XSHM_MAX_CHANNELS + 1];
> +static struct xshm_ipctoc *ipctoc;

Global variables like this are a bit problematic. What would happen if
you ever get a system that has access to two devices? I think you
can remove most of these easily. Anything that is specific to the xshm
modem should just go into the device private data of the modem.

Do not hold your own list of devices, that's what the generic device
handling is for. You can e.g. use device_for_each_child on the
modem device to iterate the channels.

> +static unsigned long xshm_start;
> +module_param(xshm_start, ulong, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(xshm_start, "Address for memory shared by host/modem.");
> +
> +static unsigned long xshm_c2c_bootaddr;
> +module_param(xshm_c2c_bootaddr, ulong, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(xshm_c2c_bootaddr, "Address given to modem (through GENI register)");
> +
> +static long xshm_size;
> +module_param(xshm_size, long, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(xshm_size, "Size of SHM area");

That looks fragile, you should never have addresses as module arguments.
Either the kernel should be free to pick a reasonable address and tell
it to the modem, or the modem should pick an address and then the kernel
needs a reliable way to find out what it is.

> +/* sysfs: Write the modem firmware including TOC */
> +static ssize_t modemfw_write(struct file *f, struct kobject *kobj,
> +			struct bin_attribute *attr,
> +			char *buf, loff_t off, size_t count)
> +{
> +	if (commited)
> +		return -EBUSY;
> +
> +	if (off + count > xshm_size)
> +		return -ENOSPC;
> +	memcpy(shm_start + off, buf, count);
> +	modem_bootimg_size = off + count;
> +	return count;
> +}
> +
> +/* sysfs: Modem firmware attribute */
> +static struct bin_attribute modemfw_attr = {
> +	.attr = {
> +		 .name = "bootimg",
> +		 .mode = S_IRUGO | S_IWUSR,
> +		 },
> +	.size = IMG_MAX_SZ,
> +	.read = modemfw_read,
> +	.write = modemfw_write
> +};

Why don't you use the regular request_firmware() function here?

	Arnd
