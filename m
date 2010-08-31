Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0HaQon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 12:44:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39043 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab0HaQol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 12:44:41 -0400
MIME-Version: 1.0
In-Reply-To: <20100831083716.GA28362@oksana.dev.rtsoft.ru>
References: <1282631168.22370.517.camel@pasglop> <20100824092623.GA20334@oksana.dev.rtsoft.ru>
 <20100831080344.GA20515@angua.secretlab.ca> <20100831083716.GA28362@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 31 Aug 2010 10:44:14 -0600
X-Google-Sender-Auth: 81ot-fq43VOjpHwDMMBqc9ASPhg
Message-ID: <AANLkTi=EaHxDgwVfh-bhGANcBYWjHW7-aZt4K5ZZ7WRi@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: Add 'struct gpio_chip' forward declaration for
 !GPIOLIB case
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Benjamin Herrenschmidt <benh@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 2:37 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Tue, Aug 31, 2010 at 02:03:44AM -0600, Grant Likely wrote:
>> On Tue, Aug 24, 2010 at 01:26:23PM +0400, Anton Vorontsov wrote:
>> > With CONFIG_GPIOLIB=n, the 'struct gpio_chip' is not declared,
>> > so the following pops up on PowerPC:
>> >
>> >   cc1: warnings being treated as errors
>> >   In file included from arch/powerpc/platforms/52xx/mpc52xx_common.c:19:
>> >   include/linux/of_gpio.h:74: warning: 'struct gpio_chip' declared
>> >                               inside parameter list
>> >   include/linux/of_gpio.h:74: warning: its scope is only this definition
>> >                               or declaration, which is probably not what
>> >                           you want
>> >   include/linux/of_gpio.h:75: warning: 'struct gpio_chip' declared
>> >                               inside parameter list
>> >   make[2]: *** [arch/powerpc/platforms/52xx/mpc52xx_common.o] Error 1
>> >
>> > This patch fixes the issue by providing the proper forward declaration.
>> >
>> > Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
>>
>> This doesn't actually solve the problem, and gpiochip should
>> remain undefined when CONFIG_GPIOLIB=n to catch exactly these
>> build failures.  The real problem is that I merged a change
>> into the mpc5200 code that required CONFIG_GPIOLIB be enabled
>> without reflecting that requirement in Kconfig.
>
> No, look closer. The error is in of_gpio.h, and it's perfectly
> fine to include it w/o GPIOLIB=y.

Looking even closer, we're both wrong.  You're right I didn't look
carefully enough, and the error is in of_gpio.h, not the .c file.

However, it is not okay to get the definitions from of_gpio.h when
CONFIG_GPIOLIB=n.  If GPIOLIB, or more specifically OF_GPIO isn't set,
then the of_gpio.h definitions should either not be defined, or should
be defined as empty stubs (where appropriate).

So, instead of adding a forward declarations of the struct, the
correct thing I think to do is to #ifdef out the contents of of_gpio.h
when GPIOLIB isn't selected so that extra #includes are completely
benign.  I've been doing the same thing on the other linux/of*.h
headers.  I've got a patch in my tree that I'm testing right now and
I'll post later today.

g.

>
>> > ---
>> >
>> > On Tue, Aug 24, 2010 at 04:26:08PM +1000, Benjamin Herrenschmidt wrote:
>> > > I get that with my current stuff:
>> > >
>> > > cc1: warnings being treated as errors
>> > > In file included from [..]/mpc52xx_common.c:19:
>> > > of_gpio.h:74: error: ‘struct gpio_chip’ declared inside parameter list
>> > [...]
>> > > make[3]: *** Waiting for unfinished jobs....
>> >
>> > That's because with GPIOCHIP=n no one declares struct gpio_chip.
>> >
>> > It should be either of_gpio.h or gpio.h. Let's make it gpio.h, as
>> > this feels more generic, and we already have some !GPIOLIB handling
>> > in there.
>> >
>> >  include/linux/gpio.h |    6 ++++++
>> >  1 files changed, 6 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/include/linux/gpio.h b/include/linux/gpio.h
>> > index 03f616b..85207d2 100644
>> > --- a/include/linux/gpio.h
>> > +++ b/include/linux/gpio.h
>> > @@ -15,6 +15,12 @@
>> >  struct device;
>> >
>> >  /*
>> > + * Some code might rely on the declaration. Still, it is illegal
>> > + * to dereference it for !GPIOLIB case.
>> > + */
>> > +struct gpio_chip;
>> > +
>> > +/*
>> >   * Some platforms don't support the GPIO programming interface.
>> >   *
>> >   * In case some driver uses it anyway (it should normally have
>> > --
>> > 1.7.0.5
>> >
>
> --
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
