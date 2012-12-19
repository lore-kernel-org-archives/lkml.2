Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab2LSXBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:01:44 -0500
Received: from mail.active-venture.com ([67.228.131.205]:58772 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2LSXBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:01:36 -0500
X-Originating-IP: 108.223.40.66
Date: Wed, 19 Dec 2012 15:01:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        lm-sensors@lm-sensors.org, Juergen Beisert <jbe@pengutronix.de>
Subject: Re: [PATCH v2] linux/kernel.h: Fix DIV_ROUND_CLOSEST with unsigned
 divisors
Message-ID: <20121219230144.GB26863@roeck-us.net>
References: <1355928015-26212-1-git-send-email-linux@roeck-us.net>
 <20121219232115.727a2e91@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219232115.727a2e91@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 11:21:15PM +0100, Jean Delvare wrote:
> Hi Guenter,
> 
> On Wed, 19 Dec 2012 06:40:15 -0800, Guenter Roeck wrote:
> > Commit 263a523 fixes a warning seen with W=1 due to change in
> > DIV_ROUND_CLOSEST. Unfortunately, the C compiler converts divide operations
> > with unsigned divisors to unsigned, even if the dividend is signed and
> > negative (for example, -10 / 5U = 858993457). The C standard says "If one
> > operand has unsigned int type, the other operand is converted to unsigned
> > int", so the compiler is not to blame.
> 
> This is surprising to say the least. But if the C standard says so...
> 
Agreed, but it is how it is.

> I wouldn't be surprised if there are bugs because of this in the kernel
> and in other projects.
> 
Might easily be. This might make a good interview question - I suspect many
if not most engineers would fail it. At least I would have until yesterday :).

> > As a result, DIV_ROUND_CLOSEST(0, 2U) and similar operations now return
> > bad values, since the automatic conversion of expressions such as "0 - 2U/2"
> > to unsigned was not taken into account.
> > 
> > Fix by checking for the divisor variable type when deciding which operation
> > to perform. This fixes DIV_ROUND_CLOSEST(0, 2U), but still returns bad values
> > for negative dividends divided by unsigned divisors. Mark the latter case as
> > unsupported.
> 
> True but this last issue isn't specific to the DIV_ROUND_CLOSEST
> implementation, it would also happen with a simple division.
> 
Correct, which is why I did not try to fix it. Still worth mentioning, though,
in my opinion.

> > Reported-by: Juergen Beisert <jbe@pengutronix.de>
> > Tested-by: Juergen Beisert <jbe@pengutronix.de>
> > Cc: Jean Delvare <khali@linux-fr.org>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > v2: Description update (v1 wasn't supposed to make it to lkml)
> > 
> >  include/linux/kernel.h |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index d97ed58..45726dc 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -77,13 +77,15 @@
> >  
> >  /*
> >   * Divide positive or negative dividend by positive divisor and round
> > - * to closest integer. Result is undefined for negative divisors.
> > + * to closest integer. Result is undefined for negative divisors and
> > + * for negative dividends if the divisor variable type is unsigned.
> 
> Thinking a bit more about this... Documenting the non-working cases is
> great, however I don't really expect all developers to pay attention. I
> can also imagine variable types changing from signed to unsigned later,
> and never thinking this can introduce a bug.
> 
> So, is there nothing we can do to spot at least the second issue at
> build time? For regular division there's nothing we can do (although I
> don't understand why gcc doesn't warn...) but here we get the
> opportunity to report the issue, let's take it.
> 
> And given that the divisor is almost always a constant,
> maybe we can check for negative divisors too, this would be safer and
> the code size increase would probably be very small in practice.
> Opinions?
> 
Agreed, though we should fix the problem now and think about reporting
afterwards.

Guenter

> >   */
> >  #define DIV_ROUND_CLOSEST(x, divisor)(			\
> >  {							\
> >  	typeof(x) __x = x;				\
> >  	typeof(divisor) __d = divisor;			\
> > -	(((typeof(x))-1) > 0 || (__x) > 0) ?		\
> > +	(((typeof(x))-1) > 0 ||				\
> > +	 ((typeof(divisor))-1) > 0 || (__x) > 0) ?	\
> >  		(((__x) + ((__d) / 2)) / (__d)) :	\
> >  		(((__x) - ((__d) / 2)) / (__d));	\
> >  }							\
> 
> Looks good.
> 
> -- 
> Jean Delvare
> 
