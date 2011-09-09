Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab1IIRmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 13:42:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57205 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab1IIRmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 13:42:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110908224427.6685a152.akpm@linux-foundation.org>
References: <1314747592-20975-1-git-send-email-david.daney@cavium.com>
	<20110908183544.414f3add.akpm@linux-foundation.org>
	<CA+7tXiiHBsFYwSY5VRY=HQ40+TkBhHm0K5uT_=0-UW2Mx=r6vg@mail.gmail.com>
	<20110908210732.2a85c0f7.akpm@linux-foundation.org>
	<CA+7tXih+4A_JDCHcN1VOVeKjapEfY9aYwCG4cBiHX1iWXb_ECw@mail.gmail.com>
	<20110908224427.6685a152.akpm@linux-foundation.org>
Date: Fri, 9 Sep 2011 13:41:59 -0400
Message-ID: <CA+7tXighLUHoZO0_wg5A+eTFA_ekpsbFvF97Wx97HLdzjZrf4g@mail.gmail.com>
Subject: Re: [PATCH] leds/of: leds-gpio.c: Use gpio_get_value_cansleep() when initializing.
From: Trent Piepho <tpiepho@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 1:44 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 8 Sep 2011 22:30:58 -0700 Trent Piepho <tpiepho@gmail.com> wrote:
>> >
>> > They're very different. __Why is it OK to replace one with the other??
>>
>> What's supposed to happen is chip->get() will be a method that does
>> "readl(GPIO_GPLR) & GPIO_GPIO(gpio);" or whatever the inlined bit in
>> gpio_get_value() is.  So calling gpio_get_value_cansleep() should
>> still get the correct value for the gpio.  It just won't be an inlined
>> register read anymore.
>
> Well, that may be the case with the current in-tree implementations (I
> didn't check), but from a design point of view the core code shouldn't
> "know" how the architecture is implementing gpio_get_value().

The architectures aren't free to make gpio_get_value() do whatever
they want.  They're supposed to provide one that follows certain
semantics.  And those semantics mean we can replace any
gpio_get_value() call with __gpio_get_value() or
gpio_get_value_cansleep(), depending on the context the call is made
from.  If we can't, then the architecture's gpio_get_value() is
broken.

>> And then one would ask if all this complexity in the interface is
>> really the best way to throw warnings about sleeping in atomic
>> context?  Because if there was a better way to do that, we could just
>> s/(gpio_get_value)_cansleep/\1/g and not worry about these someone
>> did/didn't call cansleep() when they should done the opposite patches.
>
> Yes, it sounds like the interface around there needs a rethink.

The idea was that someone would write code that used a gpio from an
irq handler or while holding a spinlock.  Which is fine.  And their
gpio would be one that doesn't need to sleep so there isn't a problem.
 But then someone else uses that code with a different gpio driver and
this gpio sleeps, because it's on an I2C chip for instance.  So now
you get a hang.  Sure would be nice if the kernel would tell us, "Hey,
you can't use that gpio with this code!" instead of just randomly
hanging.  Which is the warning David got.  Except the warning was
false, since we weren't in atomic context.

So there is probably a better way to do that than have two different
functions for getting a gpio value.  Maybe one that doesn't generate
false warnings like this.

So I'd purpose getting rid of gpio_get_value_cansleep().  Instead put
a check in __gpio_get_value() to pop up a warning if it's called from
atomic context on a gpio that can sleep.

> I don't actually know why gpio_get_value_cansleep() exists.  I looked
> at the silly comment and for some reason didn't feel like working this
> out.

I think the logic for gpio_get_value_cansleep()'s comment is flawed.
We have, "It makes sense to inline gpio code that's a single register
read, but doesn't make sense to inline code that will sit on a waitq."
That's true.  Then we have, "The former gpio code can be called from
atomic context while the latter can't."  That's true too.  But then
the comment for gpio_get_value_cansleep() seems to have combined those
two into, "It doesn't make sense to inline code that is called from
non-atomic context."  Which doesn't follow.  What it should be is, "It
doesn't make sense to inline code that can't be called from atomic
context."

But the rule seems to be that one should use gpio_get_value_cansleep()
if you are in non-atomic context, which is following the flawed logic
that in non-atomic context you don't care about making sure fast gpios
stay fast.
