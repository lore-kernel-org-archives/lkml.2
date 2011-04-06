Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1DFMNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:13:06 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33842 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab1DFMNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=XNxqn/l2TQTye+GyI+W8CuyIHaBr9iUfphDrVDE/KR8/KPMJZ/HOm/pXWWs2UVMuTU
         Ix46UrB8OW/YAJjb9ZYNCr5+HuPzQeY2pd0qW2+NsIKxdcVTrvktWxPi5T6veGEZSstR
         T+oH87sY01MMAkz/PzI2EuYYLV6w7hDzjqigo=
Date: Wed, 6 Apr 2011 16:12:58 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [RFC PATCH 1/7] basic_mmio_gpio: remove runtime
 width/endianness evaluation
Message-ID: <20110406121258.GA9530@oksana.dev.rtsoft.ru>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
 <1302088263-12714-2-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302088263-12714-2-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 12:10:57PM +0100, Jamie Iles wrote:
> Remove endianness/width calculations at runtime by installing function
> pointers for bit-to-mask conversion and register accessors.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

I guess there should be Suggested-by: Thomas Gleixner <tglx@linutronix.de>

:-)

[...]
> @@ -74,7 +78,8 @@ struct bgpio_chip {
>        * Some GPIO controllers work with the big-endian bits notation,
>        * e.g. in a 8-bits register, GPIO7 is the least significant bit.
>        */
> -     int big_endian_bits;
> +     unsigned long (*pin2mask)(struct bgpio_chip *bgc, unsigned int pin);
> +
>
>       /*

No need for this new empty line, I think.

[...]
> +static unsigned long bgpio_write64(void __iomem *reg, unsigned long data)
> +{
> +	return __raw_writeq(data, reg);
> +}

I was getting this on a 64 bit machine:

  CHECK   drivers/gpio/basic_mmio_gpio.c
drivers/gpio/basic_mmio_gpio.c:138:16: warning: incorrect type in return expression (different base types)
drivers/gpio/basic_mmio_gpio.c:138:16:    expected unsigned long
drivers/gpio/basic_mmio_gpio.c:138:16:    got void
drivers/gpio/basic_mmio_gpio.c:302:33: warning: incorrect type in assignment (different base types)
drivers/gpio/basic_mmio_gpio.c:302:33:    expected void ( *write_reg )( ... )
drivers/gpio/basic_mmio_gpio.c:302:33:    got unsigned long ( static [toplevel] *<noident> )( ... )
  CC      drivers/gpio/basic_mmio_gpio.o
drivers/gpio/basic_mmio_gpio.c: In function ‘bgpio_write64’:
drivers/gpio/basic_mmio_gpio.c:138: error: void value not ignored as it ought to be
drivers/gpio/basic_mmio_gpio.c: In function ‘bgpio_setup_accessors’:
drivers/gpio/basic_mmio_gpio.c:302: warning: assignment from incompatible pointer type
make[1]: *** [drivers/gpio/basic_mmio_gpio.o] Error 1

And I fixed it with this:

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 9dad485..3ddc4b2 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -133,9 +133,9 @@ static unsigned long bgpio_read32(void __iomem *reg)
 }
 
 #if BITS_PER_LONG >= 64
-static unsigned long bgpio_write64(void __iomem *reg, unsigned long data)
+static void bgpio_write64(void __iomem *reg, unsigned long data)
 {
-	return __raw_writeq(data, reg);
+	__raw_writeq(data, reg);
 }
 
 static unsigned long bgpio_read64(void __iomem *reg)


Otherwise, the patch looks perfect.

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com

