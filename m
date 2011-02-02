Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1BBOPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 09:15:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48931 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1BBOPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:15:33 -0500
MIME-Version: 1.0
In-Reply-To: <1296646296-31843-1-git-send-email-walle@corscience.de>
References: <1296646296-31843-1-git-send-email-walle@corscience.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 2 Feb 2011 07:15:12 -0700
X-Google-Sender-Auth: RSr1s5YdMimCkd-Hj55r_0Qijks
Message-ID: <AANLkTikbXYxyUmBsPNO6mxB2x_4Qr49BQZTKrqvsiK8a@mail.gmail.com>
Subject: Re: [PATCH] spi: spidev: Add 32 bit compat ioctl()
To: Bernhard Walle <walle@corscience.de>
Cc: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 4:31 AM, Bernhard Walle <walle@corscience.de> wrote:
> Add the compat_ioctl for operations on /dev/spi* so that 32 bit
> userspace applications can access SPI. As far as I can see all data
> structure are already prepared for that, so no additional conversion has
> to be done.
>
> My use case is MIPS with N32 userspace ABI and toolchain, and that was
> also the platform where I tested it successfully (Cavium Octeon).
>
> Signed-off-by: Bernhard Walle <walle@corscience.de>
> ---
>  drivers/spi/spidev.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
> index 4e6245e..f80503b 100644
> --- a/drivers/spi/spidev.c
> +++ b/drivers/spi/spidev.c
> @@ -30,6 +30,7 @@
>  #include <linux/errno.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/compat.h>
>
>  #include <linux/spi/spi.h>
>  #include <linux/spi/spidev.h>
> @@ -471,6 +472,14 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>        return retval;
>  }
>
> +#ifdef CONFIG_COMPAT
> +static long
> +spidev_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +       return spidev_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
> +}
> +#endif /* CONFIG_COMPAT */

If you do the following...
+#else /* CONFIG_COMPAT */
+#define spidev_compat_ioctl NULL
+#endif /* CONFIG_COMPAT */

> +
>  static int spidev_open(struct inode *inode, struct file *filp)
>  {
>        struct spidev_data      *spidev;
> @@ -543,6 +552,9 @@ static const struct file_operations spidev_fops = {
>        .write =        spidev_write,
>        .read =         spidev_read,
>        .unlocked_ioctl = spidev_ioctl,
> +#ifdef CONFIG_COMPAT
> +       .compat_ioctl = spidev_compat_ioctl,
> +#endif

Then the #ifdef/#endif can be dropped here which is tidier.

g.

>        .open =         spidev_open,
>        .release =      spidev_release,
>        .llseek =       no_llseek,
> --
> 1.7.1
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
