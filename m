Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1KPVkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:40:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36995 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab1KPVkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:40:12 -0500
Date: Thu, 17 Nov 2011 01:40:07 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, grant.likely@secretlab.ca,
        jamie@jamieiles.com, akpm@linux-foundation.org,
        rmk+kernel@arm.linux.org.uk
Subject: Re: basic_mmio_gpio: Add hook for simple debounce register
Message-ID: <20111116214007.GA26380@oksana.dev.rtsoft.ru>
References: <201111161202.15485.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201111161202.15485.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 16, 2011 at 12:02:15PM -0700, H Hartley Sweeten wrote:
> Some platforms using the basic memory-mapped GPIO library have
> simple input debounce support that is enabled/disabled, per-input,
> by setting/clearing bits in a control register. Add a hook in the
> bgpio_chip structure to hold the void __iomem * for this register.
> 
> This register, and the gc.set_debounce callback should set by the
> platform after calling bgpio_init() and before calling gpiochip_add().

I think it is possible to add 'reg_db' into the device-specific
(private) structure, so no need to add it into the generic one
(the fact that the generic gpio code does not use it at all, is a
sign that you should place it into a private struct).

I.e. something like this:

struct foo_chip {
	struct bgpio_chip bgc;
	void __iomem *reg_db;
};

static struct foo_chip *to_foo_chip(struct bgpio_chip *bgc)
{
	return container_of(bgc, struct foo_chip, bgc);
}

static void foo_gpio_set_debounce(struct gpio_chip *gc, ...)
{
	struct bgpio_chip *bgc = to_bgpio_chip(gc);
	struct foo_chip *fgc = to_foo_chip(bgc);

	writel(..., fgc->reg_db);
}


Or, if the generic code will use that register, then please introduce
the code at the same time you introduce reg_db.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
