Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0I1Mkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:40:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38834 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0I1Mks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fl1U9kAhfLnw6UBLbdRjN29ufuyO4p+OWF1dG9zsh7lNycbaRDyWPDT3kUR4DXxmTC
         9iKoF3axonpoxdnwqx4PVO2Q9LThPoGDBEGLZEMW8P7HbWElqKLmxE9Z7Fn/5jLvAXaI
         0X+CQ1umMGtFc4fP/xLJYluOB+zxDjIMfmIXw=
Date: Tue, 28 Sep 2010 16:40:41 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v7-fix] gpio: Add driver for basic memory-mapped GPIO
 controllers (fix)
Message-ID: <20100928124041.GA27783@oksana.dev.rtsoft.ru>
References: <20100831175839.GA32468@oksana.dev.rtsoft.ru>
 <755774.85376.qm@web180301.mail.gq1.yahoo.com>
 <20100907140132.GA31782@oksana.dev.rtsoft.ru>
 <20100924144535.3714beab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100924144535.3714beab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 02:45:35PM -0700, Andrew Morton wrote:
> It would be good to document `bits' and `big_endian_bits', and to
> describe what `lock' locks.

Done.

> > +static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
> > +{
> > +	return 0;
> > +}
> 
> hm, what does this mean.  The hardware cannot set pin directions to
> "in"?

Nope, 0 is the success. The hardware cannot set pin directions
at all (well, some hw can, but we don't support these yet).

> > +	return gpiochip_add(&bgc->gc);
> > +}
> 
> If this function returns -EINVAL then much head-scratching will ensue. 
> It might make your life easier to emit a diagnostic just before the
> failure so you can work out why it failed.

OK.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

Thanks!

 drivers/gpio/basic_mmio_gpio.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index c2c11e7..3addea6 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -66,12 +66,23 @@ struct bgpio_chip {
 	void __iomem *reg_dat;
 	void __iomem *reg_set;
 	void __iomem *reg_clr;
-	spinlock_t lock;
 
+	/* Number of bits (GPIOs): <register width> * 8. */
 	int bits;
+
+	/*
+	 * Some GPIO controllers work with the big-endian bits notation,
+	 * e.g. in a 8-bits register, GPIO7 is the least significant bit.
+	 */
 	int big_endian_bits;
 
-	/* shadowed data register to clear/set bits safely */
+	/*
+	 * Used to lock bgpio_chip->data. Also, this is needed to keep
+	 * shadowed and real data registers writes together.
+	 */
+	spinlock_t lock;
+
+	/* Shadowed data register to clear/set bits safely. */
 	unsigned long data;
 };
 
@@ -181,6 +192,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	struct resource *res_clr;
 	resource_size_t dat_sz;
 	int bits;
+	int ret;
 
 	res_dat = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
 	if (!res_dat)
@@ -238,7 +250,11 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, bgc);
 
-	return gpiochip_add(&bgc->gc);
+	ret = gpiochip_add(&bgc->gc);
+	if (ret)
+		dev_err(dev, "gpiochip_add() failed: %d\n", ret);
+
+	return ret;
 }
 
 static int __devexit bgpio_remove(struct platform_device *pdev)
-- 
1.7.0.5

