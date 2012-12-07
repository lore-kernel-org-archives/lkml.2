Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab2LGPHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 10:07:30 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57535 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab2LGPH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 10:07:26 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Fri, 07 Dec 2012 09:07:23 -0600
X-Originating-IP: 108.223.40.66
Date: Fri, 7 Dec 2012 07:07:44 -0800
From: Guenter Roeck <groeck-dsl@sbcglobal.net>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [RFC] gpiolib: introduce descriptor-based GPIO interface
Message-ID: <20121207150744.GB28704@roeck-us.net>
References: <1354779918-4028-1-git-send-email-acourbot@nvidia.com>
 <1354779918-4028-2-git-send-email-acourbot@nvidia.com>
 <20121207024947.GA25121@roeck-us.net>
 <2562815.JQOcF2Dmj3@percival>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2562815.JQOcF2Dmj3@percival>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 04:02:02PM +0900, Alex Courbot wrote:
> Hi Guenter,
> 
> On Friday 07 December 2012 10:49:47 Guenter Roeck wrote:
> > My own idea for a solution was to keep integer based handles, but replace
> > gpio_desc[] with a hash table. But ultimately I don't really care how
> > it is done.
> > 
> > Do you have a solution for gpiochip_find_base() in mind, and how to handle
> > reservations ? I had thought about using bit maps, but maybe there is
> > a better solution.
> 
> My plan so far is to use a sorted linked list of gpio_chips. Each chip 
> contains its base address and size, so this will make it possible to find 
> usable areas through a single parse. Current gpiochip_find_base() start from 

Excellent idea.

> ARCH_NR_GPIOS and look backwards in the integer space to find a free range, a 
> similar behavior can also be done if this is deemed better (GPIO numbers might 
> become high, but since we want to hide them this should not matter).
> 
You can not completely hide them, I would guess - you'd still want to export
them. Anyway, a simpler method would be to keep the list sorted in increasing
order and simply search for a large enough gap. If there is none, add the new
chip to the end of the list.

> The counterpart of the list is that fetching the descriptor corresponding to a 
> GPIO number is going to be linear instead of constant, but (1) the number of 
> gpio_chips on the system should never grow very high and (2) this is a good 
> incentive to use the descriptor-based API instead. :) Existing code could 
> easily be converted - once a GPIO is acquired, its number should be converted 
> immediatly to a descriptor and the gpiod_* functions used from them on. We can 
> probably write a sed or Coccinelle rule to do that through the whole kernel.
> 
Since the current approach loops through all gpio pins, it is still much better
than that - the complexity would be O(chips), not O(ngpios). As you said, there
won't be many chips, so that should scale for a long time.

> gpiochip_reserve() will require some more thinking using this model, but 
> something like a dummy chip can probably be introduced in the list. It will 
> need to be statically allocated however since memory allocation cannot be used 
> there.
> 
Introducing a dummy chip sounds like a good idea, and would have very low overhead.

Thanks,
Guenter
