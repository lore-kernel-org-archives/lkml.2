Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab2GLCwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:52:08 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:32148
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756762Ab2GLCwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:52:05 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz9371I542M1432Izz1202hzz8275bhz2dh2a8h668h839h93fhd25hf0ah107ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Peter Korsgaard <jacmet@sunsite.dk>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Vitaly Wool <vitalywool@gmail.com>, Colin Cross <ccross@android.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Date: Wed, 11 Jul 2012 22:51:45 -0400
Subject: RE: [PATCH 2/7] i2c-bfin-twi: Use struct dev_pm_ops for power
 management
Thread-Topic: [PATCH 2/7] i2c-bfin-twi: Use struct dev_pm_ops for power
 management
Thread-Index: Ac1fmoSxj4xUj5ggQ9mtW0T5g0zzeAAPpCag
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D171409B8860@NWD2CMBX1.ad.analog.com>
References: <201207112121.11046.rjw@sisk.pl> <201207112123.31502.rjw@sisk.pl>
In-Reply-To: <201207112123.31502.rjw@sisk.pl>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6C2qFkV003545

Acked-by: Sonic Zhang <sonic.zhang@analog.com>

>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>Sent: Thursday, July 12, 2012 3:24 AM
>To: LKML
>Cc: Linux PM list; Linus Walleij; linux-i2c@vger.kernel.org; Zhang, Sonic; Jean
>Delvare; Ben Dooks; Wolfram Sang; Peter Korsgaard; Guan Xuetao; Vitaly Wool;
>Colin Cross; Stephen Warren
>Subject: [PATCH 2/7] i2c-bfin-twi: Use struct dev_pm_ops for power management
>
>From: Rafael J. Wysocki <rjw@sisk.pl>
>
>Make the Blackfin On-Chip Two Wire Interface driver define its PM
>callbacks through a struct dev_pm_ops object rather than by using
>legacy PM hooks in struct platform_driver.
>
>Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>---
> drivers/i2c/busses/i2c-bfin-twi.c |   18 ++++++++++--------
> 1 file changed, 10 insertions(+), 8 deletions(-)
>
>Index: linux/drivers/i2c/busses/i2c-bfin-twi.c
>=============================================================
>======
>--- linux.orig/drivers/i2c/busses/i2c-bfin-twi.c
>+++ linux/drivers/i2c/busses/i2c-bfin-twi.c
>@@ -611,9 +611,9 @@ static struct i2c_algorithm bfin_twi_alg
>       .functionality = bfin_twi_functionality,
> };
>
>-static int i2c_bfin_twi_suspend(struct platform_device *pdev, pm_message_t
>state)
>+static int i2c_bfin_twi_suspend(struct device *dev)
> {
>-      struct bfin_twi_iface *iface = platform_get_drvdata(pdev);
>+      struct bfin_twi_iface *iface = dev_get_drvdata(dev);
>
>       iface->saved_clkdiv = read_CLKDIV(iface);
>       iface->saved_control = read_CONTROL(iface);
>@@ -626,14 +626,14 @@ static int i2c_bfin_twi_suspend(struct p
>       return 0;
> }
>
>-static int i2c_bfin_twi_resume(struct platform_device *pdev)
>+static int i2c_bfin_twi_resume(struct device *dev)
> {
>-      struct bfin_twi_iface *iface = platform_get_drvdata(pdev);
>+      struct bfin_twi_iface *iface = dev_get_drvdata(dev);
>
>       int rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
>-              0, pdev->name, iface);
>+              0, to_platform_device(dev)->name, iface);
>       if (rc) {
>-              dev_err(&pdev->dev, "Can't get IRQ %d !\n", iface->irq);
>+              dev_err(dev, "Can't get IRQ %d !\n", iface->irq);
>               return -ENODEV;
>       }
>
>@@ -646,6 +646,9 @@ static int i2c_bfin_twi_resume(struct pl
>       return 0;
> }
>
>+static SIMPLE_DEV_PM_OPS(i2c_bfin_twi_pm,
>+                       i2c_bfin_twi_suspend, i2c_bfin_twi_resume);
>+
> static int i2c_bfin_twi_probe(struct platform_device *pdev)
> {
>       struct bfin_twi_iface *iface;
>@@ -770,11 +773,10 @@ static int i2c_bfin_twi_remove(struct pl
> static struct platform_driver i2c_bfin_twi_driver = {
>       .probe          = i2c_bfin_twi_probe,
>       .remove         = i2c_bfin_twi_remove,
>-      .suspend        = i2c_bfin_twi_suspend,
>-      .resume         = i2c_bfin_twi_resume,
>       .driver         = {
>               .name   = "i2c-bfin-twi",
>               .owner  = THIS_MODULE,
>+              .pm     = &i2c_bfin_twi_pm,
>       },
> };
>
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
