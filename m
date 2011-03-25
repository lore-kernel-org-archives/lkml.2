Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab1CYUM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:12:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1CYUMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:12:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Fri, 25 Mar 2011 21:12:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, vapier@gentoo.org
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
In-Reply-To: <1300980071-24645-2-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103252112.22520.arnd@arndb.de>
X-Provags-ID: V02:K0:jvtgi++zV4mZ9fehEyBJQpcd7E9WKxRq7zlcUBSVcKr
 Z+Yx9qt1G3kb7cfwPhbctfqQjQ5FvD40xl31OIonYcv7S1RfSC
 98HudQ66s1J2amCTTgoL0lzKO6Y0++FPvkw96C4J91Nin4i/pz
 RhfkOz1umgDnbcngZt2GNn/KqXlg6ywOaYLqlxvSg5Yhf6COYx
 2amE9bhjxGKuhZL+N+OEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 March 2011 16:21:08 Jamie Iles wrote:
> OTP memory is typically found in some embedded devices and can be
> used for storing boot code, cryptographic keys and other persistent
> information onchip.  This patch adds a generic layer that devices can
> register OTP with and allows access through a set of character
> device nodes.

Looks very nice overall, but I have a few minor comments.

> diff --git a/Documentation/ABI/testing/sysfs-bus-otp b/Documentation/ABI/testing/sysfs-bus-otp
> new file mode 100644
> index 0000000..4dbc652
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-otp
> @@ -0,0 +1,68 @@
> +What:           /sys/bus/otp/
> +Date:           March 2011
> +KernelVersion:  2.6.40+
> +Contact:        Jamie Iles <jamie@jamieiles.com>
> +Description:
> +                The otp bus presents a number of devices where each
> +		device represents a region or device in the SoC. Each region
> +		will create a device node which allows the region to be
> +		written with read()/write() calls and the device on the bus
> +		has attributes for controlling the redundancy format and
> +		getting the region size.

Why is this a bus? You don't have any device matching code or similar,
and the devices typically are on an existing bus_type (e.g. platform_bus).
I think it would make more sense to do this as a class.

> +
> +menuconfig OTP
> +	bool "OTP memory support"
> +	help
> +	  Say y here to support OTP memory found in some embedded devices.
> +	  This memory can commonly be used to store boot code, cryptographic
> +	  keys and other persistent data.

Please spell out OTP at least once here, a lot of people might not
know the TLA.

> +
> +static int otp_open(struct inode *inode, struct file *filp);
> +static int otp_release(struct inode *inode, struct file *filp);
> +static ssize_t otp_write(struct file *filp, const char __user *buf,
> +			 size_t len, loff_t *offs);
> +static ssize_t otp_read(struct file *filp, char __user *buf, size_t len,
> +			loff_t *offs);
> +static loff_t otp_llseek(struct file *filp, loff_t offs, int origin);
> +
> +static const struct file_operations otp_fops = {
> +	.owner	    = THIS_MODULE,
> +	.open	    = otp_open,
> +	.release    = otp_release,
> +	.write	    = otp_write,
> +	.read	    = otp_read,
> +	.llseek	    = otp_llseek,
> +};

The common way to organize source files is to put all definitions in an
order that requires no forward declarations.

Just define the operations first, then the struct file_operations, and
then the rest.

> +
> +static DEFINE_SEMAPHORE(otp_sem);

Semaphores are basically deprecated. Use a mutex instead.

> +static int otp_we, otp_strict_programming;
> +static struct otp_device *otp;
> +static dev_t otp_devno;

Making these global variables limits you to a single device. I think
you can put everything here into struct otp_device and find that from
the device or chardev you get passed when entering the otp code.

> +static void otp_dev_release(struct device *dev)
> +{
> +	struct otp_device *otp = to_otp_device(dev);
> +
> +	kfree(otp);
> +	otp = NULL;
> +}

The final assignment is not needed.

	Arnd
