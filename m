Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab2HMOgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:36:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58689 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2HMOgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:36:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [GIT PULL] gpio fixes for v3.6-rc1
Date: Mon, 13 Aug 2012 14:36:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Shawn Guo <shawn.guo@linaro.org>, Daniel Mack <zonque@gmail.com>,
        Axel Lin <axel.lin@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>, Julia Lawall <Julia.Lawall@lip6.fr>
References: <CACRpkdaixT=Zn69x9_b9G2nQFm4cu2S5Uo23ww909MJFH2yWwQ@mail.gmail.com>
In-Reply-To: <CACRpkdaixT=Zn69x9_b9G2nQFm4cu2S5Uo23ww909MJFH2yWwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208131436.11122.arnd@arndb.de>
X-Provags-ID: V02:K0:wveRG/HjD8vOJutcMZGbylNeaw5Vrqx5f7z4WXqhGhl
 xca+cxhcy9HtWQDbCzmVYQeh+wOsGLEfhXK/tGnIq5QaSxYhTO
 4c07yqWuTktJ9m+U0ckKzhAUkscf/eXoCVLGzB70SZSizB0nyH
 kCtJLVvcfcLVcu8vLOHALlkY6rzSxbbCOU+FPxtWgSzsh02rHG
 L5SttMw+PJ9lxNpDcu6urRn3BPFDNn+b4RGxRDdt7mCTzLltQW
 TddWtexo13XQ7cbfvxNUY4Jj91TMiLTCzac7hyw4BSTUl4hD5P
 eVtio0AEpsq57Wuv253F5O7NBYARWao/Gxs1kRrRc3nNiO9Rv0
 jOGw6nnGVo1z2HcT6kp0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 August 2012, Linus Walleij wrote:
> Daniel Mack (1):
>       GPIO: gpio-pxa: fix devicetree functions
> 

Unfortunately, this one caused a build regression, see the fix below.
I also wonder why pxa_irq_domain_ops isn't static.

	Arnd

8<----
GPIO: gpio-pxa: fix building without CONFIG_OF

Patch 7212157267 "GPIO: gpio-pxa: fix devicetree functions" added an
"xlate" function pointer to the irq_domain_ops, but this function
is nor declared or defined anywhere when CONFIG_OF is disabled, causing
the build error:

drivers/gpio/gpio-pxa.c:532:11: error: 'irq_domain_xlate_twocell' undeclared here (not in a function)

Extending the DT-only code section to cover the irq_domain_ops
and the pxa_gpio_dt_ids solves this problem and makes it clearer
which code is actually used without DT.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index 793767b0..9cac88a 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -512,6 +512,7 @@ static int pxa_gpio_nums(void)
 	return count;
 }
 
+#ifdef CONFIG_OF
 static struct of_device_id pxa_gpio_dt_ids[] = {
 	{ .compatible = "mrvl,pxa-gpio" },
 	{ .compatible = "mrvl,mmp-gpio", .data = (void *)MMP_GPIO },
@@ -532,7 +533,6 @@ const struct irq_domain_ops pxa_irq_domain_ops = {
 	.xlate	= irq_domain_xlate_twocell,
 };
 
-#ifdef CONFIG_OF
 static int __devinit pxa_gpio_probe_dt(struct platform_device *pdev)
 {
 	int ret, nr_banks, nr_gpios, irq_base;
@@ -679,7 +679,7 @@ static struct platform_driver pxa_gpio_driver = {
 	.probe		= pxa_gpio_probe,
 	.driver		= {
 		.name	= "pxa-gpio",
-		.of_match_table = pxa_gpio_dt_ids,
+		.of_match_table = of_match_ptr(pxa_gpio_dt_ids),
 	},
 };
 
