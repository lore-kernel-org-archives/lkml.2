Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab1BCQ4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:56:12 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40799 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab1BCQ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:56:11 -0500
Date: Thu, 3 Feb 2011 09:56:07 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Bernhard Walle <walle@corscience.de>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de
Subject: Re: [PATCH] spi: spidev: Add 32 bit compat ioctl()
Message-ID: <20110203165607.GB6180@angua.secretlab.ca>
References: <1296722238-4308-1-git-send-email-walle@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296722238-4308-1-git-send-email-walle@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 09:37:18AM +0100, Bernhard Walle wrote:
> Add the compat_ioctl for operations on /dev/spi* so that 32 bit
> userspace applications can access SPI. As far as I can see all data
> structure are already prepared for that, so no additional conversion has
> to be done.
> 
> My use case is MIPS with N32 userspace ABI and toolchain, and that was
> also the platform where I tested it successfully (Cavium Octeon).
> 
> Signed-off-by: Bernhard Walle <walle@corscience.de>

Applied, thanks.

g.

> ---
>  drivers/spi/spidev.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
> index 4e6245e..833e238 100644
> --- a/drivers/spi/spidev.c
> +++ b/drivers/spi/spidev.c
> @@ -30,6 +30,7 @@
>  #include <linux/errno.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/compat.h>
>  
>  #include <linux/spi/spi.h>
>  #include <linux/spi/spidev.h>
> @@ -471,6 +472,16 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	return retval;
>  }
>  
> +#ifdef CONFIG_COMPAT
> +static long
> +spidev_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +	return spidev_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
> +}
> +#else
> +#define spidev_compat_ioctl NULL
> +#endif /* CONFIG_COMPAT */
> +
>  static int spidev_open(struct inode *inode, struct file *filp)
>  {
>  	struct spidev_data	*spidev;
> @@ -543,6 +554,7 @@ static const struct file_operations spidev_fops = {
>  	.write =	spidev_write,
>  	.read =		spidev_read,
>  	.unlocked_ioctl = spidev_ioctl,
> +	.compat_ioctl = spidev_compat_ioctl,
>  	.open =		spidev_open,
>  	.release =	spidev_release,
>  	.llseek =	no_llseek,
> -- 
> 1.7.1
> 
