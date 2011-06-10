Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab1FJIwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:52:08 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:35959 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227Ab1FJIwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:52:04 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Kyungmin Park <kmpark@infradead.org>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Ben Nizette <bn@niasdigital.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Stijn Devriendt <highguy@gmail.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH 0/2] RFC: gpio: driver-local pin configuration
Date: Fri, 10 Jun 2011 10:48:51 +0200
Message-ID: <1307695731-28018-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This is a modification of the previous generic GPIO configuration
patch series.

I'm Cc:ing everyone involved in earlier discussions so we can
move forward on this consolidation work, lest I cannot convert
my drivers to use struct gpio_chip / gpiolib.

Background: Grant didn't like the idea of an ioctl() like
configuration function in the struct gpio_chip vtable, so we
decided to see if it was wiser to go back to the initial suggestion
of making it possible for drivers to dereference the struct
gpio_chip and perform driver-local operations via regular
function calls instead.

So in this patch set I expose gpio_to_chip(), then alter the
previous rewrite of the U300 GPIO driver to instead use a local
configuration function by wrapping the previously defined config
function into this:

/* External function to configure pins */
int u300_gpio_set_config(unsigned gpio, u16 param, unsigned long *data)
{
        struct gpio_chip *chip = gpio_to_chip(gpio);
        unsigned offset = gpio - chip->base;

        return u300_gpio_config(chip, offset, param, data);
}

This one is then exposed in the chip-specific header  in
<linux/gpio/u300.h>, and all the configuration defines that
were previously globally generic in <linux/gpio.h> are also
moved there and made driver-specific without any attempt of
generalizing this.

So for anything that is not currently in struct gpio_chip you
will have to implement something like this, per driver.

I'm open for keeping the generic config defines in <linux/gpio.h>
if Grant accepts that, it certainly will avoid some define
duplication in driver headers. Right now I stay away from the
gpiolib as much as I can.

Comments welcome!

Thanks,
Linus Walleij


Linus Walleij (2):
  gpio: expose gpio_to_chip()
  gpio/u300: rewrite gpio driver

 arch/arm/Kconfig                       |    2 +-
 arch/arm/mach-u300/Kconfig             |    1 +
 arch/arm/mach-u300/core.c              |   31 +-
 arch/arm/mach-u300/include/mach/gpio.h |  163 +-----
 arch/arm/mach-u300/include/mach/irqs.h |   25 +-
 drivers/gpio/Kconfig                   |    9 +
 drivers/gpio/gpio-u300.c               | 1176 +++++++++++++++++++-------------
 drivers/gpio/gpiolib.c                 |    2 +-
 include/asm-generic/gpio.h             |    1 +
 include/linux/gpio/u300.h              |   82 +++
 10 files changed, 833 insertions(+), 659 deletions(-)
 create mode 100644 include/linux/gpio/u300.h

-- 
1.7.3.2

