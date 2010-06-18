Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0FRGQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:16:12 -0400
Received: from n3-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.156]:22928 "HELO
	n3-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753230Ab0FRGQL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:16:11 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 609296.70126.bm@omp121.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=TeZnP8tz+4WtYG2dnxrclP8UmruJa1AboaHqONUA/E3JWYbLxt/ZvQn6mpl34hRkXlWuVgU1l8on/cF2e+v+l9pQgIot5c7Zn9cwwP/Yn7a3vvcnJl7GmzlwACMdH7lJNZ8kNyKCM2WNqebTHG6wRvS2BkIeJ2X5Cfn6VflwTiI=;
Message-ID: <514259.95052.qm@web180315.mail.gq1.yahoo.com>
X-YMail-OSG: Js.PEsUVM1mgXhfoD1FqO6OZp4K84c84_5MKDfQmpg0iqaH
 t_2wCdgvCv3uR3hw.4cdUCUgUhTYc.ueeb8q408EMBnQUVW2wurNKwZVrkez
 7zlPW43bwXQERJ.PknEZev31by3PvhweDPLQk5uEx4xg4PY9a9FjDE2nCuOc
 bD.VydBT14B_peek54DAm64Z_ZJtrGu98lduZg5w06geY8X8izuxcfN9bZJD
 W51Onu76OmrBJgvluhLY4vublEueup8mdvV1BpGrAgiLOKC6wNGSQT6XyxGu
 WeqnZNw1C7eYmnXJKm_95otr_BXBEKZiSVd8qpBykds7lI1_FlhNvGGTOFQq
 _Q2Dseqf6E8._Nx0L.uG8MayAFhhn1Cf1GXs-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.103.269680
Date: Thu, 17 Jun 2010 23:16:10 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: gpiolib and sleeping gpios
To: linux kernel <linux-kernel@vger.kernel.org>,
       Ryan Mallon <ryan@bluewatersys.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       ext-jani.1.nikula@nokia.com
In-Reply-To: <4C1A980F.8080908@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 6/17/10, Ryan Mallon <ryan@bluewatersys.com> wrote:
> Currently implementors of gpiolib must provide
> implementations for
> gpio_get_value, gpio_set_value and gpio_cansleep. 

Not true.  There is ONE implementation of gpiolib.

I think you mean "implementors of the GPIO calls".
many of those implementors will use gpiolib, to
make their lives easier.  They are not, however,
re-implementing gpiolib itself...

Most of
> the
> implementations just #define these to the double underscore
> prefixed
> versions in drivers/gpio/gpiolib.c. A few implementations
> have a simple
> wrapper function which provides a fast path for the SoC
> gpios, and calls
> gpiolib for the any additional gpios, such as those added
> by an io expander.

Right...


> Although gpio_chips know whether or not they may sleep,
> gpios which can
> sleep need to call gpio_[set/get]_value_cansleep. 

GPIOsare hardware, or maybe software abstractions;
either way,  can't call those.
  Driver level code does
when it accesses a GPIO.
for example,peripheral setup logic might.


The only
> difference
> between __gpio_(set/get)_value and
> gpio_(set/get)_value_cansleep is that


only the cansleep() versions may be used for
GPIOs whose operation requires use of sleeping
calls.  Most SoC GPIOs are safe to access with
IRQs disabled, spinlocks, held and so on.

That's why only the non-cansleep() versions
are documented as being spinlock-safe.


> the cansleep versions calls might_sleep_if. Most drivers


That's an implemenation detail, internal to the
gpiolib code.

Note that "can" sleep means exactly that...  It
doesn't mean "must sleep".  A valid way to
implement a cansleep() variant is to 

just call the spinlock-safe routine, so that
it never sleeps.

THe converse is not true; the spinlock-safe
routine must never call a cansleep() version.


>  Most drivers call > gpio_(get/set)_value, rather than the cansleep variants. I
> haven't done
> a full audit of all of the drivers (which is a reasonably
> involved
> task), but I would hazard a guess that some of these could
> be replaced
> by the cansleep versions.


One hopes that the runtime warnings have gotten
folk to fix bugs where the cansleep() version
should have been used, but wasn't...


Better IMO not to make that change except as
part
of a bugfix:  e.g. remove a runtime warning
that boils down to not using the cansleep()
version when it should have been used.
> 
> Would it not be simpler to combine the calls and have
> something like this:
> 
> void __gpio_get_value(unsigned gpio, int value)
> {
>     struct gpio_chip *chip;
> 
>     chip = gpio_to_chip(gpio);
>     might_sleep_if(extra_checks &&
> chip->can_sleep);
>     chip->set(chip, gpio - chip->base,

> value);

calling chip->set() when  chip->can_sleep
and the call context can't be preempted,
would be a bug.  So that code is wrong ...
it should at least warn about the error
made by the caller.  If we had error returns from gpio get/set calls 9sigh), it'd be right to
fail that call.

> }
> 
> Then all drivers can just call gpio_(set/get)_value


Bad idea.  Those calls are only for
use in non-sleeping contexts; don't
train developers to misuse calls.

 and any
> attempts to
> use sleeping gpios from an non-sleeping context will be
> caught by the
> might_sleep_if check. Is there something I am missing about
> this?

The fact that such attempts are errors
in the calling code, and should not be
swept under therug...


> 
> I can prepare a patch which combines the non-sleeping and
> sleeping
> variants, but I wanted to check that I'm not missing
> something
> fundamental first.
> 
> Thanks,
> ~Ryan
> 
> -- 
> Bluewater Systems Ltd - ARM Technology Solution Centre
> 
> Ryan Mallon     
>            5
> Amuri Park, 404 Barbadoes St
> ryan@bluewatersys.com 
>            PO Box 13
> 889, Christchurch 8013
> http://www.bluewatersys.com    New
> Zealand
> Phone: +64 3 3779127       
> Freecall: Australia 1800 148 751
> Fax:   +64 3 3779135   
>           USA 1800 261
> 2934
> 

