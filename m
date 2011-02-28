Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1B1J26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:28:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab1B1J24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:28:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: james_p_freyensee@linux.intel.com
Subject: Re: [PATCH 03/10] Intel PTI implementaiton of MIPI 1149.7.
Date: Mon, 28 Feb 2011 10:28:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
References: <james_p_freyensee@linux.intel.com> <1298570824-26085-4-git-send-email-james_p_freyensee@linux.intel.com>
In-Reply-To: <1298570824-26085-4-git-send-email-james_p_freyensee@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281028.48314.arnd@arndb.de>
X-Provags-ID: V02:K0:ln56M8wLdNZOR6XZJ+sRDBG9uCDBvp9sfr2iPrWMu0N
 aT4htOD0RkDthpBLuxAJ3CKl9aHh/1FAMgsDwcIavZTz3V/R1m
 PjhB30MVI/qU+AKSsRIVpGXEB7pmN1Nffe4i/IxHUIZ0vJs45v
 H5/MjLSBAAGQ5Ff9D5r1Z5ZWCyPBFtVL3Mah1CCm1orxis3qw4
 PEMhVI7BEKQNIFDToUlsw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Thursday 24 February 2011, james_p_freyensee@linux.intel.com wrote:
> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This driver is the Intel Atom implementation of MIPI P1149.7,
> compact JTAG standard for mobile devices.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> ---
>  drivers/misc/pti.c |  890 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 890 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/pti.c

I have no idea what a "misc" driver really is, but this one clearly isn't
one. When you register a tty here, drivers/tty would be the right place.
> +
> +struct pti_tty {
> +	struct pti_masterchannel *mc;
> +};
> +
> +struct pti_dev {
> +	struct tty_port port;
> +	unsigned long pti_addr;
> +	unsigned long aperture_base;
> +	void __iomem *pti_ioaddr;
> +	unsigned long pti_iolen;

pti_adr, aperture_base and pti_iolen seem to be unused in the driver, you
only use them to get pti_ioaddr, so no need to store them.

> +	u8 IA_App[MAX_APP_IDS];
> +	u8 IA_OS[MAX_OS_IDS];
> +	u8 IA_Modem[MAX_MODEM_IDS];

Please use lowercase identifiers.

> +static DEFINE_MUTEX(alloclock);

It's not really clear what this protects. Please add some comment here.

> +static struct tty_driver *pti_tty_driver;
> +
> +static struct pti_dev *drv_data;

You use drv_data both for the global structure and for local variables,
which is rather confusing to the reader.

> +static unsigned int pti_console_channel;
> +static unsigned int pti_control_channel;

These don't need to be global, because they are only used in one function
each (besides a pointless initialization).

Are you sure that you need no locking for them?


> +static ssize_t pti_char_write(struct file *filp, const char __user *data,
> +			      size_t len, loff_t *ppose)
> +{
> +	struct pti_masterchannel *mc;
> +	void *kbuf;
> +	const char __user *tmp;
> +	size_t size = USER_COPY_SIZE, n = 0;
> +
> +	tmp = data;
> +	mc = filp->private_data;
> +
> +	kbuf = kmalloc(size, GFP_KERNEL);
> +	if (kbuf == NULL)  {
> +		pr_err("%s(%d): buf allocation failed\n",
> +			__func__, __LINE__);
> +		return 0;
> +	}
> +
> +	do {
> +		if (len - n > USER_COPY_SIZE)
> +			size = USER_COPY_SIZE;
> +		else
> +			size = len - n;
> +
> +		if (copy_from_user(kbuf, tmp, size)) {
> +			kfree(kbuf);
> +			return n ? n : -EFAULT;
> +		}
> +
> +		pti_write_to_aperture(mc, kbuf, size);
> +		n  += size;
> +		tmp += size;
> +
> +	} while (len > n);
> +
> +	kfree(kbuf);
> +	kbuf = NULL;
> +
> +	return len;
> +}

You write chunks of 8KB here, which sounds rather large for a serial port.
Is that intentional? What is the typical line rate? If you need more than
a milisecond for a single write, you should probably return a short write
to user space or at least call cond_resched() to be more friendly to
other tasks.

> +static const struct tty_operations pti_tty_driver_ops = {
> +	.open		= pti_tty_driver_open,
> +	.close		= pti_tty_driver_close,
> +	.write		= pti_tty_driver_write,
> +	.write_room	= pti_tty_write_room,
> +	.install	= pti_tty_install,
> +	.cleanup	= pti_tty_cleanup
> +};
> +
> +static const struct file_operations pti_char_driver_ops = {
> +	.owner		= THIS_MODULE,
> +	.write		= pti_char_write,
> +	.open		= pti_char_open,
> +	.release	= pti_char_release,
> +};
> +
> +static struct miscdevice pti_char_driver = {
> +	.minor		= MISC_DYNAMIC_MINOR,
> +	.name		= CHARNAME,
> +	.fops		= &pti_char_driver_ops
> +};
> +

It's really strange to have both a tty and a character device that have similar
operations. Why can't you have the pti_char_driver functionality in the tty driver?

	Arnd
