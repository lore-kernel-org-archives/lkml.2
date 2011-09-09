Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab1IIFkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 01:40:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356Ab1IIFkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 01:40:19 -0400
Date: Thu, 8 Sep 2011 22:44:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trent Piepho <tpiepho@gmail.com>
Cc: David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] leds/of: leds-gpio.c: Use gpio_get_value_cansleep()
 when initializing.
Message-Id: <20110908224427.6685a152.akpm@linux-foundation.org>
In-Reply-To: <CA+7tXih+4A_JDCHcN1VOVeKjapEfY9aYwCG4cBiHX1iWXb_ECw@mail.gmail.com>
References: <1314747592-20975-1-git-send-email-david.daney@cavium.com>
	<20110908183544.414f3add.akpm@linux-foundation.org>
	<CA+7tXiiHBsFYwSY5VRY=HQ40+TkBhHm0K5uT_=0-UW2Mx=r6vg@mail.gmail.com>
	<20110908210732.2a85c0f7.akpm@linux-foundation.org>
	<CA+7tXih+4A_JDCHcN1VOVeKjapEfY9aYwCG4cBiHX1iWXb_ECw@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011 22:30:58 -0700 Trent Piepho <tpiepho@gmail.com> wrote:

> >
> > They're very different. __Why is it OK to replace one with the other??
> 
> What's supposed to happen is chip->get() will be a method that does
> "readl(GPIO_GPLR) & GPIO_GPIO(gpio);" or whatever the inlined bit in
> gpio_get_value() is.  So calling gpio_get_value_cansleep() should
> still get the correct value for the gpio.  It just won't be an inlined
> register read anymore.
> 
> For instance, all the arch versions that use builtin_constant_p() will
> not take the inline path, since the gpio number if obviously not a
> constant when gpio_get_value() is called in this leds function.  So
> they inline into a call to __gpio_get_value().  Which as you've
> pointed out is nearly exactly the same as gpio_get_value_cansleep().
> The only change is debugging related, that of the might_sleep_if() to
> a WARN_ON().
> 
> One could have:
> static inline int __gpio_get_value(gpio) { return
> _gpio_get_value(gpio, GFP_ATOMIC); }
> static inline int gpio_get_value_cansleep(gpio) { return
> _gpio_get_value(gpio, GFP_KERNEL); }
> 
> Then _gpio_get_value(gpio, context) would be the current code that's
> common to both __gpio_get_value() and gpio_get_value_cansleep(),
> except it uses context solely to spit a warning if the gpio can't be
> done from the requested context or if the context isn't allowable from
> whence the call was made.

Well, that may be the case with the current in-tree implementations (I
didn't check), but from a design point of view the core code shouldn't
"know" how the architecture is implementing gpio_get_value().

> And then one would ask if all this complexity in the interface is
> really the best way to throw warnings about sleeping in atomic
> context?  Because if there was a better way to do that, we could just
> s/(gpio_get_value)_cansleep/\1/g and not worry about these someone
> did/didn't call cansleep() when they should done the opposite patches.

Yes, it sounds like the interface around there needs a rethink.

I don't actually know why gpio_get_value_cansleep() exists.  I looked
at the silly comment and for some reason didn't feel like working this
out.

> >> > Asides:
> >> >
> >> > The duplication of code between __gpio_get_value() and
> >> > gpio_get_value_cansleep() is daft.
> >> >
> >> > The comment over gpio_get_value_cansleep() sucks mud rocks.
> >
> > Preserving this...
> 
> Well, inlining code that sits on a waitq doesn't make a lot of sense.

No need for inlining - just a function call.  One which the compiler
might turn into a tailcall for us.

