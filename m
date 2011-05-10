Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1EJXXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:23:10 -0400
Received: from mail.perches.com ([173.55.12.10]:1454 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab1EJXXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:23:09 -0400
Subject: [PATCH] gpio: Convert gpio_is_valid to return bool
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <BANLkTi=zDJLHUa2ogTeEkmdsbkhvGJCsEw@mail.gmail.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
	 <1304365077.7792.40.camel@Joe-Laptop>
	 <BANLkTi=XSevO72NqCYOYuketjE8XjeQU+A@mail.gmail.com>
	 <1305067020.19586.130.camel@Joe-Laptop>
	 <BANLkTi=zDJLHUa2ogTeEkmdsbkhvGJCsEw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 16:23:07 -0700
Message-ID: <1305069787.19586.141.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the code a bit more readable.

Instead of casting an int to an unsigned then comparing to
MAX_NR_GPIOS, add a >= 0 test and let the compiler optimizer
do the conversion to unsigned.

The generated code should be the same.

Signed-off-by: Joe Perches <joe@perches.com>

---

This came up because of a new pinmux subsystem that used
a style copied from gpio and a request from Linus Walleij.

On Wed, 2011-05-11 at 00:52 +0200, Linus Walleij wrote:
> 2011/5/11 Joe Perches <joe@perches.com>:
> > On Wed, 2011-05-11 at 00:18 +0200, Linus Walleij wrote:
> >> 2011/5/2 Joe Perches <joe@perches.com>:
> >> > On Mon, 2011-05-02 at 21:16 +0200, Linus Walleij wrote:
> >> >> From: Linus Walleij <linus.walleij@linaro.org>
> >> >> diff --git a/drivers/pinmux/core.c b/drivers/pinmux/core.c
> >> > Trivial comments follow
> >> >> +static inline int pin_is_valid(int pin)
> >> >> +{
> >> >> +     return ((unsigned)pin) < MACH_NR_PINS;
> >> >> +}
> >> > Couldn't pin just be declared unsigned or maybe u32?
> >> No, because like in the GPIO subsystem you *may* want to send in invalid
> >> pins, and those are identified by negative numbers.
> > Then I think this is clearer and the compiler
> > should produce the same code.
> > static inline bool pin_is_valid(int pin)
> > {
> >        return pin >= 0 && pin < MACH_NR_PINS;
> > }
> Yes indeed, I'll fix. Can you propose a patch to the same pattern
> found in include/asm-generic/gpio.h? It would bring equal
> clarity there I believe. 

 include/asm-generic/gpio.h |    6 +++---
 include/linux/gpio.h       |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index ce16e70..315ecb7 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -35,9 +35,9 @@
  * platform data and other tables.
  */
 
-static inline int gpio_is_valid(int number)
+static inline bool gpio_is_valid(int number)
 {
-	return ((unsigned)number) < ARCH_NR_GPIOS;
+	return number >= 0 && number < ARCH_NR_GPIOS;
 }
 
 struct device;
@@ -216,7 +216,7 @@ extern void gpio_unexport(unsigned gpio);
 
 #else	/* !CONFIG_GPIOLIB */
 
-static inline int gpio_is_valid(int number)
+static inline bool gpio_is_valid(int number)
 {
 	/* only non-negative numbers are valid */
 	return number >= 0;
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index fa92e50..0af3bca 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -79,9 +79,9 @@ struct gpio_chip;
  * warning when something is wrongly called.
  */
 
-static inline int gpio_is_valid(int number)
+static inline bool gpio_is_valid(int number)
 {
-	return 0;
+	return false;
 }
 
 static inline int gpio_request(unsigned gpio, const char *label)


