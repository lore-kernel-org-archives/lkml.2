Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab1IIRnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:43:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758672Ab1IIRny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:43:54 -0400
Date: Fri, 9 Sep 2011 10:48:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Daney <david.daney@cavium.com>
Cc: Trent Piepho <tpiepho@gmail.com>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] leds/of: leds-gpio.c: Use gpio_get_value_cansleep()
 when initializing.
Message-Id: <20110909104806.b4c541c5.akpm@linux-foundation.org>
In-Reply-To: <4E6A3BBE.1000409@cavium.com>
References: <1314747592-20975-1-git-send-email-david.daney@cavium.com>
	<20110908183544.414f3add.akpm@linux-foundation.org>
	<CA+7tXiiHBsFYwSY5VRY=HQ40+TkBhHm0K5uT_=0-UW2Mx=r6vg@mail.gmail.com>
	<20110908210732.2a85c0f7.akpm@linux-foundation.org>
	<CA+7tXih+4A_JDCHcN1VOVeKjapEfY9aYwCG4cBiHX1iWXb_ECw@mail.gmail.com>
	<20110908224427.6685a152.akpm@linux-foundation.org>
	<4E6A3BBE.1000409@cavium.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Sep 2011 09:15:58 -0700 David Daney <david.daney@cavium.com> wrote:

> On 09/08/2011 10:44 PM, Andrew Morton wrote:
> > On Thu, 8 Sep 2011 22:30:58 -0700 Trent Piepho<tpiepho@gmail.com>  wrote:
> >
> >>>
> >>> They're very different. __Why is it OK to replace one with the other??
> >>
> >> What's supposed to happen is chip->get() will be a method that does
> >> "readl(GPIO_GPLR)&  GPIO_GPIO(gpio);" or whatever the inlined bit in
> >> gpio_get_value() is.  So calling gpio_get_value_cansleep() should
> >> still get the correct value for the gpio.  It just won't be an inlined
> >> register read anymore.
> >>
> >> For instance, all the arch versions that use builtin_constant_p() will
> >> not take the inline path, since the gpio number if obviously not a
> >> constant when gpio_get_value() is called in this leds function.  So
> >> they inline into a call to __gpio_get_value().  Which as you've
> >> pointed out is nearly exactly the same as gpio_get_value_cansleep().
> >> The only change is debugging related, that of the might_sleep_if() to
> >> a WARN_ON().
> >>
> >> One could have:
> >> static inline int __gpio_get_value(gpio) { return
> >> _gpio_get_value(gpio, GFP_ATOMIC); }
> >> static inline int gpio_get_value_cansleep(gpio) { return
> >> _gpio_get_value(gpio, GFP_KERNEL); }
> >>
> >> Then _gpio_get_value(gpio, context) would be the current code that's
> >> common to both __gpio_get_value() and gpio_get_value_cansleep(),
> >> except it uses context solely to spit a warning if the gpio can't be
> >> done from the requested context or if the context isn't allowable from
> >> whence the call was made.
> >
> > Well, that may be the case with the current in-tree implementations (I
> > didn't check), but from a design point of view the core code shouldn't
> > "know" how the architecture is implementing gpio_get_value().
> 
> Really there are two separate issues here:
> 
> 1) Should the patch be applied?
> 
> 2) Is there room to improve the libgpio API?
> 
> It is unclear to me if these are currently being conflated.
> 
> In any event, from a purely selfish point of view, I would like to see 
> the patch applied as I cannot boot my boards with out it.  As for 
> improving the GPIO APIs, it seems slightly less urgent, but also a good 
> idea.

Yeah.  One option is to apply it as a stopgap and promise ourselves
that we'll fix things for real later.  I'm waiting for Grant to pop up
and tell us when he'll be fixing his junk ;)

