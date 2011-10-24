Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1JXMyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:54:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40263 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab1JXMyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:54:53 -0400
Date: Mon, 24 Oct 2011 14:54:49 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: Provide a definition of struct gpio for the
 stub gpiolib
Message-ID: <20111024125449.GT8708@ponder.secretlab.ca>
References: <1319455649-4916-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20111024120120.GO8708@ponder.secretlab.ca>
 <20111024120706.GD6148@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024120706.GD6148@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 02:07:06PM +0200, Mark Brown wrote:
> On Mon, Oct 24, 2011 at 02:01:20PM +0200, Grant Likely wrote:
> > On Mon, Oct 24, 2011 at 01:27:29PM +0200, Mark Brown wrote:
> > > This makes the stub gpio_request_array() much more usable as drivers can
> > > declare struct gpio variables.
> 
> > > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> > Shouldn't this patch remove the definition from
> > include/asm-generic/gpio.h at the same time?
> 
> Both the original forward declaration and the new definition are within
> the !GPIOLIB case of the #defines, it's just a minimal patch moving the
> undefined forward declaration to a defintion.  I didn't want to worry
> about reading the individual users to figure out if they had separate
> defintions separately to the work to get them all moved over to gpiolib.

I think it's good:

$ git grep asm/gpio.h | grep '\.h:'
arch/blackfin/include/asm/portmux.h:#include <asm/gpio.h>
arch/sh/include/mach-common/mach/magicpanelr2.h:#include <asm/gpio.h>
arch/unicore32/include/asm/gpio.h: * linux/arch/unicore32/include/asm/gpio.h
include/asm-generic/gpio.h:/* A platform's <asm/gpio.h> code may want to inline the I/O calls when
include/linux/gpio.h:#include <asm/gpio.h>

$ git grep -e $'struct[ \t]*gpio[^_a-z]' `git grep -l asm/gpio.h` `git grep -l mach/portmux.h` `git grep -l mach/magicpanelr2.h` 
Documentation/gpio.txt: int gpio_request_array(struct  gpio *array, size_t num);
Documentation/gpio.txt: void gpio_free_array(struct      gpio *array, size_t num);
Documentation/gpio.txt:Further more, to ease the claim/release of multiple GPIOs, 'struct gpio' is
Documentation/gpio.txt: struct gpio {
Documentation/gpio.txt: static struct gpio leds_gpios[] = {
include/asm-generic/gpio.h: * struct gpio - a structure describing a GPIO with configuration
include/asm-generic/gpio.h:struct gpio {
include/asm-generic/gpio.h:extern int gpio_request_array(const struct gpio *array, size_t num);
include/asm-generic/gpio.h:extern void gpio_free_array(const struct gpio *array, size_t num);
include/linux/gpio.h:struct gpio;
include/linux/gpio.h:static inline int gpio_request_array(const struct gpio *array, size_t num)
include/linux/gpio.h:static inline void gpio_free_array(const struct gpio *array, size_t num)

You'll still need a 'struct gpio;' forward decl in asm-generic/gpio.h,
but that's better than having two copies.  If you craft the patch,
I'll make sure some build coverage testing is performed before merging
it.

