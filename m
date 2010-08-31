Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0HaRIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 13:08:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41946 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab0HaRIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 13:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=dpC/25O65JWVhygg6TQ0EsM86H3w19lFgQ/U9CJ+qc80kgWamIURi5Q0enRrtbthE9
         YYc3VYl7BlT14TN5CWHvchmSeGCgTvRb/oR9OvhfBqhBtmQ6cRha9QvIU4N/OACj+Muu
         TyG7xfjFQGqx3qytYegIb0qn+yBHXG4PaBIEY=
Date: Tue, 31 Aug 2010 21:07:56 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] gpiolib: Add 'struct gpio_chip' forward declaration
 for !GPIOLIB case
Message-ID: <20100831170756.GA24887@oksana.dev.rtsoft.ru>
References: <1282631168.22370.517.camel@pasglop>
 <20100824092623.GA20334@oksana.dev.rtsoft.ru>
 <20100831080344.GA20515@angua.secretlab.ca>
 <20100831083716.GA28362@oksana.dev.rtsoft.ru>
 <AANLkTi=EaHxDgwVfh-bhGANcBYWjHW7-aZt4K5ZZ7WRi@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=EaHxDgwVfh-bhGANcBYWjHW7-aZt4K5ZZ7WRi@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 10:44:14AM -0600, Grant Likely wrote:
> On Tue, Aug 31, 2010 at 2:37 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > On Tue, Aug 31, 2010 at 02:03:44AM -0600, Grant Likely wrote:
> >> On Tue, Aug 24, 2010 at 01:26:23PM +0400, Anton Vorontsov wrote:
> >> > With CONFIG_GPIOLIB=n, the 'struct gpio_chip' is not declared,
> >> > so the following pops up on PowerPC:
> >> >
> >> >   cc1: warnings being treated as errors
> >> >   In file included from arch/powerpc/platforms/52xx/mpc52xx_common.c:19:
> >> >   include/linux/of_gpio.h:74: warning: 'struct gpio_chip' declared
> >> >                               inside parameter list
> >> >   include/linux/of_gpio.h:74: warning: its scope is only this definition
> >> >                               or declaration, which is probably not what
> >> >                           you want
> >> >   include/linux/of_gpio.h:75: warning: 'struct gpio_chip' declared
> >> >                               inside parameter list
> >> >   make[2]: *** [arch/powerpc/platforms/52xx/mpc52xx_common.o] Error 1
> >> >
> >> > This patch fixes the issue by providing the proper forward declaration.
> >> >
> >> > Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
> >>
> >> This doesn't actually solve the problem, and gpiochip should
> >> remain undefined when CONFIG_GPIOLIB=n to catch exactly these
> >> build failures.  The real problem is that I merged a change
> >> into the mpc5200 code that required CONFIG_GPIOLIB be enabled
> >> without reflecting that requirement in Kconfig.
> >
> > No, look closer. The error is in of_gpio.h, and it's perfectly
> > fine to include it w/o GPIOLIB=y.
> 
> Looking even closer, we're both wrong.  You're right I didn't look
> carefully enough, and the error is in of_gpio.h, not the .c file.
> 
> However, it is not okay to get the definitions from of_gpio.h when
> CONFIG_GPIOLIB=n.  If GPIOLIB, or more specifically OF_GPIO isn't set,
> then the of_gpio.h definitions should either not be defined, or should
> be defined as empty stubs (where appropriate).

Grrr. Grant, look again, even closer than you did.

They are stubs!

#else /* CONFIG_OF_GPIO */  <<<<<< !OF_GPIO (or !GPIOLIB) case.

/* Drivers may not strictly depend on the GPIO support, so let them link. */
static inline int of_get_gpio_flags(struct device_node *np, int index,
                                    enum of_gpio_flags *flags)
{
        return -ENOSYS;
}

static inline unsigned int of_gpio_count(struct device_node *np)
{
        return 0;
}

static inline void of_gpiochip_add(struct gpio_chip *gc) { }
static inline void of_gpiochip_remove(struct gpio_chip *gc) { }

#endif /* CONFIG_OF_GPIO */

The errors are triggered by the of_gpiochip_*() stubs, which
are needed by the drivers/gpio/gpiolib.c.

Do you want to add another #ifdef CONFIG_GPIOLIB around
of_gpiochip_*()? That would be ugly.

There's nothing wrong in providing the forward decls, you
can't dereference it anyway (so you would still catch the
bogus users). And at the same time it's will work great
for these stubs.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
