Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab1J1MPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:15:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33637 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab1J1MPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:15:21 -0400
MIME-Version: 1.0
In-Reply-To: <20111027131124.GK19187@n2100.arm.linux.org.uk>
References: <1319528012-19006-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1319720503-3183-1-git-send-email-vapier@gentoo.org> <20111027131124.GK19187@n2100.arm.linux.org.uk>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 28 Oct 2011 14:15:00 +0200
X-Google-Sender-Auth: WyTDOdtviFSWLZS9IjjvztfbLOM
Message-ID: <CAJaTeTp71t0BYsEpDu07BE5ox2FBAiH7xEQqjhb=6QadrsQGAQ@mail.gmail.com>
Subject: Re: [PATCH] asm-generic/gpio.h: merge basic gpiolib wrappers
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 15:11, Russell King - ARM Linux wrote:
> This is extremely dangerous.  Consider for example this code
> (see ARM mach-davinci's gpio.h):

it's interesting you highlight davinci.  if i'm reading things
correctly, the current davinci code is broken today and my v2 proposed
patch actually fixes it.

let's see if i have this right:
arch/arm/include/asm/gpio.h:
...
#include <mach/gpio.h>
#ifndef __ARM_GPIOLIB_COMPLEX
/* The trivial gpiolib dispatchers */
#define gpio_get_value  __gpio_get_value
#define gpio_set_value  __gpio_set_value
#define gpio_cansleep   __gpio_cansleep
#endif
...

arch/arm/mach-davinci/include/mach/gpio.h:
...
#include <asm-generic/gpio.h>
...
static inline void gpio_set_value(unsigned gpio, int value)
{
    if (__builtin_constant_p(value) && gpio < davinci_soc_info.gpio_num) {
           ... do some SoC checking ...
    }
    __gpio_set_value(gpio, value);
}
... same thing for gpio_get_value and gpio_cansleep ...
...

since the davinci code doesn't define __ARM_GPIOLIB_COMPLEX, the
common arm gpio.h will rewrite these few gpio calls to the gpiolib
code all the time, and so all the inline funcs in the davinci header
always get ignored.

i noticed because when comparing the compiled
-mike
