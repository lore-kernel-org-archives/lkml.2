Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab1FQKvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 06:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab1FQKvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 06:51:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110616102209.GC5262@opensource.wolfsonmicro.com>
References: <20110616102209.GC5262@opensource.wolfsonmicro.com> <20110615144823.GA2806@opensource.wolfsonmicro.com> <1306921767-31115-1-git-send-email-broonie@opensource.wolfsonmicro.com> <5194.1308074912@redhat.com> <19624.1308206191@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, grant@secretlab.ca,
        ralf@linux-mips.org
Subject: Re: [PATCH] FRV: Hook up gpiolib support
Date: Fri, 17 Jun 2011 11:50:59 +0100
Message-ID: <28714.1308307859@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> And to repeat what I said: the generic header prototypes everything it
> needs before it uses it so there should be no problem here, it's not
> been a problem on the other architectures using this code verbatim.
> Please be more specific.

Okay:

  CC      drivers/mtd/maps/gpio-addr-flash.o
In file included from /data/frv/linux-2.6-frv/arch/frv/include/asm/gpio.h:21,
                 from include/linux/gpio.h:8,
                 from drivers/mtd/maps/gpio-addr-flash.c:17:
include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
include/asm-generic/gpio.h:233: error: implicit declaration of function 'gpio_get_value'
include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
include/asm-generic/gpio.h:239: error: implicit declaration of function 'gpio_set_value'
drivers/mtd/maps/gpio-addr-flash.c: In function 'gpio_flash_probe':
drivers/mtd/maps/gpio-addr-flash.c:234: error: implicit declaration of function 'gpio_request'
drivers/mtd/maps/gpio-addr-flash.c:238: error: implicit declaration of function 'gpio_free'
drivers/mtd/maps/gpio-addr-flash.c:242: error: implicit declaration of function 'gpio_direction_output'


Let me expand on my explanation earlier:

 (1) asm-generic/gpio.h has an _inline_ function:

	static inline int gpio_get_value_cansleep(unsigned gpio)
	{
		might_sleep();
		return gpio_get_value(gpio);
	}

 (2) gpio_get_value() is implemented in asm/gpio.h.  It is not declared in
     asm-generic/gpio.h.

 (3) Therefore, the #inclusion of asm-generic/gpio.h must come _after_ the
     implementation of gpio_get_value() in asm/gpio.h.

 (4) asm/gpio.h implements the aforementioned inline function:

	static inline int gpio_get_value(unsigned int gpio)
	{
		return __gpio_get_value(gpio);
	}

 (5) __gpio_get_value() is declared in asm-generic/gpio.h.  It is not declared
     in asm/gpio.h.

 (6) Therefore, the #inclusion of asm/gpio.h must come _before_ the
     implementation of gpio_get_value() in asm/gpio.h.

Thus (3) and (6) contradict.

David
