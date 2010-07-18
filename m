Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab0GRScL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 14:32:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50187 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab0GRScI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 14:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=knTntw3NNQ8oBHMxzqItsfdt2aMUZEkoqcXBjx/pFQOLRIi/SwuGT/UcDicw9ZZJbE
         qEsZWoglI7/cySoc0jgIoaQJmPcN1Q6qz6olRN6HyMlJBvqNhuMfH2HL1sIocqEfQxO4
         NJXwyqeN18O9yTUhqVzVq5Tn4cmAQViI71YzE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1006131208470.18415@ayla.of.borg>
References: <alpine.DEB.2.00.1006131208470.18415@ayla.of.borg>
Date: Sun, 18 Jul 2010 20:32:06 +0200
X-Google-Sender-Auth: hfCpbuaa65n_491gfXsXEhhyUC0
Message-ID: <AANLkTilzH61NsPF5maM77chbuQA8ptUiV5iaXtOShYOB@mail.gmail.com>
Subject: Re: [PATCH] rtc: rp5c01 - Add NVRAM support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, rtc-linux@googlegroups.com,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 12:12, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> The Ricoh RP5C01 RTC contains 26 x 4 bits of NVRAM.
> Provide access to it via a sysfs "nvram" attribute file.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Alessandro: Ping?

> --
> Question: Is a spinlock in priv the right kind of locking?
>          Should I use e.g. rtc-device.ops_lock instead?
>
> diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
> index a95f733..36eb661 100644
> --- a/drivers/rtc/rtc-rp5c01.c
> +++ b/drivers/rtc/rtc-rp5c01.c
> @@ -63,6 +63,8 @@ enum {
>  struct rp5c01_priv {
>        u32 __iomem *regs;
>        struct rtc_device *rtc;
> +       spinlock_t lock;        /* against concurrent RTC/NVRAM access */
> +       struct bin_attribute nvram_attr;
>  };
>
>  static inline unsigned int rp5c01_read(struct rp5c01_priv *priv,
> @@ -92,6 +94,7 @@ static int rp5c01_read_time(struct device *dev, struct rtc_time *tm)
>  {
>        struct rp5c01_priv *priv = dev_get_drvdata(dev);
>
> +       spin_lock_irq(&priv->lock);
>        rp5c01_lock(priv);
>
>        tm->tm_sec  = rp5c01_read(priv, RP5C01_10_SECOND) * 10 +
> @@ -111,6 +114,7 @@ static int rp5c01_read_time(struct device *dev, struct rtc_time *tm)
>                tm->tm_year += 100;
>
>        rp5c01_unlock(priv);
> +       spin_unlock_irq(&priv->lock);
>
>        return rtc_valid_tm(tm);
>  }
> @@ -119,6 +123,7 @@ static int rp5c01_set_time(struct device *dev, struct rtc_time *tm)
>  {
>        struct rp5c01_priv *priv = dev_get_drvdata(dev);
>
> +       spin_lock_irq(&priv->lock);
>        rp5c01_lock(priv);
>
>        rp5c01_write(priv, tm->tm_sec / 10, RP5C01_10_SECOND);
> @@ -139,6 +144,7 @@ static int rp5c01_set_time(struct device *dev, struct rtc_time *tm)
>        rp5c01_write(priv, tm->tm_year % 10, RP5C01_1_YEAR);
>
>        rp5c01_unlock(priv);
> +       spin_unlock_irq(&priv->lock);
>        return 0;
>  }
>
> @@ -147,6 +153,72 @@ static const struct rtc_class_ops rp5c01_rtc_ops = {
>        .set_time       = rp5c01_set_time,
>  };
>
> +
> +/*
> + * The NVRAM is organized as 2 blocks of 13 nibbles of 4 bits.
> + * We provide access to them like AmigaOS does: the high nibble of each 8-bit
> + * byte is stored in BLOCK10, the low nibble in BLOCK11.
> + */
> +
> +static ssize_t rp5c01_nvram_read(struct file *filp, struct kobject *kobj,
> +                                struct bin_attribute *bin_attr,
> +                                char *buf, loff_t pos, size_t size)
> +{
> +       struct device *dev = container_of(kobj, struct device, kobj);
> +       struct rp5c01_priv *priv = dev_get_drvdata(dev);
> +       ssize_t count;
> +
> +       spin_lock_irq(&priv->lock);
> +
> +       for (count = 0; size > 0 && pos < RP5C01_MODE; count++, size--) {
> +               u8 data;
> +
> +               rp5c01_write(priv,
> +                            RP5C01_MODE_TIMER_EN | RP5C01_MODE_RAM_BLOCK10,
> +                            RP5C01_MODE);
> +               data = rp5c01_read(priv, pos) << 4;
> +               rp5c01_write(priv,
> +                            RP5C01_MODE_TIMER_EN | RP5C01_MODE_RAM_BLOCK11,
> +                            RP5C01_MODE);
> +               data |= rp5c01_read(priv, pos++);
> +               rp5c01_write(priv, RP5C01_MODE_TIMER_EN | RP5C01_MODE_MODE01,
> +                            RP5C01_MODE);
> +               *buf++ = data;
> +       }
> +
> +       spin_unlock_irq(&priv->lock);
> +       return count;
> +}
> +
> +static ssize_t rp5c01_nvram_write(struct file *filp, struct kobject *kobj,
> +                                 struct bin_attribute *bin_attr,
> +                                 char *buf, loff_t pos, size_t size)
> +{
> +       struct device *dev = container_of(kobj, struct device, kobj);
> +       struct rp5c01_priv *priv = dev_get_drvdata(dev);
> +       ssize_t count;
> +
> +       spin_lock_irq(&priv->lock);
> +
> +       for (count = 0; size > 0 && pos < RP5C01_MODE; count++, size--) {
> +               u8 data = *buf++;
> +
> +               rp5c01_write(priv,
> +                            RP5C01_MODE_TIMER_EN | RP5C01_MODE_RAM_BLOCK10,
> +                            RP5C01_MODE);
> +               rp5c01_write(priv, data >> 4, pos);
> +               rp5c01_write(priv,
> +                            RP5C01_MODE_TIMER_EN | RP5C01_MODE_RAM_BLOCK11,
> +                            RP5C01_MODE);
> +               rp5c01_write(priv, data & 0xf, pos++);
> +               rp5c01_write(priv, RP5C01_MODE_TIMER_EN | RP5C01_MODE_MODE01,
> +                            RP5C01_MODE);
> +       }
> +
> +       spin_unlock_irq(&priv->lock);
> +       return count;
> +}
> +
>  static int __init rp5c01_rtc_probe(struct platform_device *dev)
>  {
>        struct resource *res;
> @@ -168,6 +240,15 @@ static int __init rp5c01_rtc_probe(struct platform_device *dev)
>                goto out_free_priv;
>        }
>
> +       sysfs_bin_attr_init(&priv->nvram_attr);
> +       priv->nvram_attr.attr.name = "nvram";
> +       priv->nvram_attr.attr.mode = S_IRUGO | S_IWUSR;
> +       priv->nvram_attr.read = rp5c01_nvram_read;
> +       priv->nvram_attr.write = rp5c01_nvram_write;
> +       priv->nvram_attr.size = RP5C01_MODE;
> +
> +       spin_lock_init(&priv->lock);
> +
>        rtc = rtc_device_register("rtc-rp5c01", &dev->dev, &rp5c01_rtc_ops,
>                                  THIS_MODULE);
>        if (IS_ERR(rtc)) {
> @@ -177,8 +258,15 @@ static int __init rp5c01_rtc_probe(struct platform_device *dev)
>
>        priv->rtc = rtc;
>        platform_set_drvdata(dev, priv);
> +
> +       error = sysfs_create_bin_file(&dev->dev.kobj, &priv->nvram_attr);
> +       if (error)
> +               goto out_unregister;
> +
>        return 0;
>
> +out_unregister:
> +       rtc_device_unregister(rtc);
>  out_unmap:
>        iounmap(priv->regs);
>  out_free_priv:
> @@ -190,6 +278,7 @@ static int __exit rp5c01_rtc_remove(struct platform_device *dev)
>  {
>        struct rp5c01_priv *priv = platform_get_drvdata(dev);
>
> +       sysfs_remove_bin_file(&dev->dev.kobj, &priv->nvram_attr);
>        rtc_device_unregister(priv->rtc);
>        iounmap(priv->regs);
>        kfree(priv);
> --
> 1.7.0.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
