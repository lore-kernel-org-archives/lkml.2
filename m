Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2H1QUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 12:20:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65211 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2H1QUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 12:20:11 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 28 Aug 2012 09:20:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] kernel.h: Introduce IDIV_ROUND_CLOSEST
Message-ID: <20120828162016.GA29145@roeck-us.net>
References: <1345855997-9408-1-git-send-email-linux@roeck-us.net>
 <20120828180926.4d64f99a@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828180926.4d64f99a@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 06:09:26PM +0200, Jean Delvare wrote:
> Hi Guenter,
> 
> On Fri, 24 Aug 2012 17:53:17 -0700, Guenter Roeck wrote:
> > DIV_ROUND_CLOSEST returns a bad result for negative dividends:
> > 	DIV_ROUND_CLOSEST(-2, 2) = 0
> > 
> > Most of the time this does not matter. However, in the hardware monitoring
> > subsystem, it is often used on integers which can be negative (such as
> > temperatures). Introduce new macro IDIV_ROUND_CLOSEST which also supports
> > negative dividends.
> 
> Good catch. It's been broken for years and I never noticed :(
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>
> 
> > 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > I can take this patch through my hwmon tree, but would like to get an Ack first.
> > Alternative would be to put it into include/linux/hwmon.h, but I would prefer
> > to avoid that.
> 
> I agree it should sit next to DIV_ROUND_CLOSEST in <linux/kernel.h>.
> 
> > 
> > Also, if someone has an idea for a simpler implementation, I would really like
> > to know about it.
> 
> I can't think of anything better.
> 
> Note that your implementation only supports negative dividend not
> divisor. While it won't be a problem for hwmon drivers, and most
> probably not a problem for other drivers either, it might be worth
> putting in a comment so as to prevent false expectations from the
> reader.
> 
I noticed. I am not concerned about negative divisors, though, but unsigned
divisor variables are a problem too. I have a new version which also supports
divisors which are declared as unsigned.

Thanks,
Guenter

> > 
> >  include/linux/kernel.h |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index 6043821..a89483c 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -89,6 +89,15 @@
> >  }							\
> >  )
> >  
> > +#define IDIV_ROUND_CLOSEST(x, divisor)(			\
> > +{							\
> > +	typeof(x) __x = x;				\
> > +	typeof(divisor) __d1 = divisor;			\
> > +	typeof(divisor) __d2 = (__x) < 0 ? -(__d1) : (__d1);\
> > +	(((__x) + ((__d2) / 2)) / (__d1));		\
> > +}							\
> > +)
> > +
> >  /*
> >   * Multiplies an integer by a fraction, while avoiding unnecessary
> >   * overflow or loss of precision.
> 
> 
> -- 
> Jean Delvare
> 
