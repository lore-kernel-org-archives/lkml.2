Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab2EOMIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:08:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2EOMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:08:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio/exynos: Fix compiler warnings when non-exynos machines are selected
Date: Tue, 15 May 2012 12:08:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, patches@linaro.org
References: <1335768768-10231-1-git-send-email-sachin.kamat@linaro.org> <CACRpkdYHKR+oOD36RCUMobEwJj_Y9WDHTUY+UaHAx0YegMhXyg@mail.gmail.com> <20120512002912.8A0A23E0791@localhost>
In-Reply-To: <20120512002912.8A0A23E0791@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Message-Id: <201205151208.26551.arnd@arndb.de>
X-Provags-ID: V02:K0:x9FXTixr58HfP3U6TpBmWBt1h4xFnqh9b0A3Aicbqx5
 YCiF/3+BwlAyLeK8rB4HkxXXgSj2JL/M1J5ymD3uhAyO/Z5g/S
 eBWwJ1pqI/wgtx+13e2wifCYaKCF8CI6aCkdcuGP96i/w2yUaH
 9VYq51D0IYQh3CSXATI97q1J7HutTJ13cVJRgtXF+3jU/nM0KS
 2PvdycaMy9zu/fuhBjaT+96URaD/Nom0eeymiIFtblo2fuHsq5
 DEyXBU+a7y2XCT6AYLRyYSkZV2pcKnYaxIX7B4+eY75z7A2518
 3mUgN+YUm/G20B6pFkxuaApXjd3NxQ3Mdz4YrsveCndyIyAwK/
 z+9ffbIAKE9UnkITNpX0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2012, Grant Likely wrote:
> On Wed, 2 May 2012 01:26:12 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Mon, Apr 30, 2012 at 8:52 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> > 
> > > +#if defined(CONFIG_ARCH_EXYNOS4) || defined(CONFIG_ARCH_EXYNOS5)
> > > +#endif
> > > -static struct samsung_gpio_chip exynos4_gpios_1[] = {
> > > Â #ifdef CONFIG_ARCH_EXYNOS4
> > > +static struct samsung_gpio_chip exynos4_gpios_1[] = {
> > > -#endif
> > > +#endif
> > > -static struct samsung_gpio_chip exynos4_gpios_2[] = {
> > > Â #ifdef CONFIG_ARCH_EXYNOS4
> > > +static struct samsung_gpio_chip exynos4_gpios_2[] = {
> > > -#endif
> > > +#endif
> > > -static struct samsung_gpio_chip exynos4_gpios_3[] = {
> > > Â #ifdef CONFIG_ARCH_EXYNOS4
> > > +static struct samsung_gpio_chip exynos4_gpios_3[] = {
> > > -#endif
> > > +#endif
> > > Â #ifdef CONFIG_ARCH_EXYNOS5
> > > +#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
> > > +#endif
> > > +#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
> > > +#endif
> > 
> > We really want to get rid of this kind of stuff from all drivers, #ifdefs are
> > declared ugly already in Documentation/CodingStyle.
> > 
> > Any chance you could solve this problem by reworking the driver to
> > pass some flag in platform data tell which exynos it's for
> > and jist adapt at runtime instead of the compile-time quirkiness?
> > 
> > Besides looking better, it helps us to get to a single zImage for the
> > exynoses too..
> 
> I don't see any single-zImage issues here.  There are no #else clauses
> in the #ifdef blocks so all it does it compile out unused code when
> exynos4 & 5 is not enabled. I'm going to apply it.


I needed another fixup on top of this to build exynos4_defconfig without
warnings.

8<---
gpio/samsung: define gpio_base4 variable only for exynos5

Avoids this warning:
drivers/gpio/gpio-samsung.c: In function 'samsung_gpiolib_init':
drivers/gpio/gpio-samsung.c:2979:1: warning: label 'err_ioremap4' defined but not used [-Wunused-label]
drivers/gpio/gpio-samsung.c:2725:47: warning: unused variable 'gpio_base4' [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index e991d91..c80356d 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -2722,7 +2722,10 @@ static __init int samsung_gpiolib_init(void)
 	struct samsung_gpio_chip *chip;
 	int i, nr_chips;
 #if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
-	void __iomem *gpio_base1, *gpio_base2, *gpio_base3, *gpio_base4;
+	void __iomem *gpio_base1, *gpio_base2, *gpio_base3;
+#endif
+#if defined(CONFIG_SOC_EXYNOS5250)
+	void __iomem *gpio_base4;
 #endif
 	int group = 0;
 
@@ -2975,9 +2978,11 @@ static __init int samsung_gpiolib_init(void)
 
 	return 0;
 
-#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
+#if defined(CONFIG_SOC_EXYNOS5250)
 err_ioremap4:
 	iounmap(gpio_base3);
+#endif
+#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
 err_ioremap3:
 	iounmap(gpio_base2);
 err_ioremap2:
