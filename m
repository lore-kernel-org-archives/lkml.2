Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751000Ab0FWEmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 00:42:38 -0400
Received: from n2b.bullet.mail.ac4.yahoo.com ([76.13.13.72]:42325 "HELO
	n2b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750829Ab0FWEmh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 00:42:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 287727.92202.bm@omp120.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=TGMWDrkCqBuvsK+gIG6eSlmWCZ3dAf66ufSRyx2Rkk667RjChKQmLxlIB2tTaR5pL8n2R8bLc9azxrCQ16VZBHrXOmnfgEtzDiRbS6qNmz7OKm9d2jcIRnEcLKQXe4Rf8wLu5iwImiboSnYJ9Y3saJiBPm1KsoDs56EwOHm5syI=;
Message-ID: <191168.5104.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: 1ewCgpoVM1lMVUXBzyvU.lJSn4iociIoo.ooK5qiOwepAY8
 36kxAfET4YdZOnzEJgY93I3IpYZh_IE9kNMXPpIVmH_uERyp2ZPg7dmDnGe1
 WJ5pifHPREfK62FGbmd.aLgvkUNU910Fxhssu9bXzvuMcX2rLWKPoqRESsPS
 iUKALgDTIlsTEaO8j0_Zw.782XeR1MGqa1BEgaK.X0lEKyYLl7.AQ3hmuNob
 X7kUTqHCm8Exz5OWo51AFcUQe21.PS3u8Zcan68b7IEMI7jTqGDkKg0nnGs.
 oY7q9fdE5X8.PSbJ3.cags9TCbJgIQty2DWvFTvmQMnGyUFZl3AlkzaAmhZI
 JPH_CSW_ybNw.cAfMF58ATndrejG0.zMocRU-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.103.269680
Date: Tue, 22 Jun 2010 21:37:47 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping gpios)
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4C216A79.7000305@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 6/22/10, Ryan Mallon <ryan@bluewatersys.com> wrote:


> gpiolib


Again, you're talking about "gpiolib" when
you seem to mean the GPIO framework itself
(for which gpiolib is only an implementation
option)...

> framework could be simplified for cansleep gpios.
> 
> 'Can sleep' for a gpio has two different meanings depending
> on context

NO; for the GPIO itself it's only ever had one
meaning, regardless of context.

You're trying to conflate the GPIO and one
of the contexts in which it's used.  That's
the problem you seem to be struggling with.

Please stop conflating/confusing
those two disparate concepts...

I hope you don't have such a hard time with
the distinction in other contexts.  Like,
the fact that some calls can't be made while
holding spinlocks.  That notion is everywhere
in Linux.


> example, if a driver calls gpio_get_value(gpio) from an
> interupt handler
> then the gpio must not be a sleeping gpio.

In a threaded IRQ handler it's OK to use
the get_value_cansleep() option..



> 
> This patch introduces a new flag, FLAG_CANSLEEP, internal
> to gpiolib

NAK; Superfluous; the gpio_chip already has
that information recorded.


> new request function, gpio_request_cansleep, requests a
> gpio which may
> only be used from sleep possible contexts

Also superfluous.


 The existing
> gpio_request
> function requests a gpio, but does not allow it to be used
> from a
> context where sleep is not possible.

Changing semantics of existing calls is a big
mess, and should be avoided even if it seems
appropriate.

Since the request is just reserving a resource
that's already been identified (and which has
known characteristics, like whether the GPIO
value must be accessed only from sleeping
contexts), this call would also be superfluous.

If you want to ensure the GPIO is a cansleep()
one, just check that before reserving it.  There
is no need for new calls to support that model;
it works today.

(NAK...)



> The benefits I see to this approach are:
>  ...
>  - The API is simplified by combining gpio_(set/get)_value
> and
> gpio_(set/get)_value_cansleep


You have a strange definition of "simplified"...

Recognize that you're also proposing to remove
an API characteristic which much simplifies
code review:  you can look at calls and see
that because they're the cansleep() version,
they are unsafe in IRQ context ...

That is, you're making code (and patch)
reviews much harder and more error-prone.
This isn't good, and doesn't simplify any
process I can think of...

So, NAK on these proposed changes.

- Dave


