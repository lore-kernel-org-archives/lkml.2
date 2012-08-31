Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2HaBMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 21:12:05 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63818 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2HaBME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 21:12:04 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 30 Aug 2012 18:12:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3] linux/kernel.h: Fix DIV_ROUND_CLOSEST to support
 negative operands
Message-ID: <20120831011216.GA22010@roeck-us.net>
References: <1346371847-21384-1-git-send-email-linux@roeck-us.net>
 <20120830173531.291e7b6d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830173531.291e7b6d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 05:35:31PM -0700, Andrew Morton wrote:
> On Thu, 30 Aug 2012 17:10:47 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > DIV_ROUND_CLOSEST returns a bad result for dividends with different sign:
> > 	DIV_ROUND_CLOSEST(-2, 2) = 0
> > 
> > Most of the time this does not matter. However, in the hardware monitoring
> > subsystem, DIV_ROUND_CLOSEST is sometimes used on integers which can be
> > negative (such as temperatures).
> > 
> > ...
> >
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -84,8 +84,11 @@
> >  )
> >  #define DIV_ROUND_CLOSEST(x, divisor)(			\
> >  {							\
> > -	typeof(divisor) __divisor = divisor;		\
> > -	(((x) + ((__divisor) / 2)) / (__divisor));	\
> > +	typeof(x) __x = x;				\
> > +	typeof(divisor) __d = divisor;			\
> > +	((__x) < 0) == ((__d) < 0) ?			\
> > +		(((__x) + ((__d) / 2)) / (__d)) :	\
> > +		(((__x) - ((__d) / 2)) / (__d));	\
> >  }							\
> >  )
> 
> Your v2 had that sneaky little "(typeof(x))-1 >= 0" trick in it, so
> half the code gets elided at compile time if `x' (why isn't this called
> "dividend") has an unsigned type.
> 
> Would retaining that be of any benefit?  We do want to avoid doing the
> compare-and-branch in as many cases as possible.
> 
DIV_ROUND_CLOSEST(0,-2)=1

This also happens if I keep the sneaky code. The v3 code does not have this
problem. I know it is a bit theoretic, but still there. Of course, I could
simply ignore the divisor's sign entirely, assuming (and documenting) that
negative divisors are just too odd to deal with. Commentss welcome ...

> Also, this would be a great opportunity to document the macro's beahviour
> (I do go on).  That would be a useful thing to do, given that we're now
> handling the four +/+, +/-, -/+, -/- cases and the behaviour for each
> case isn't terribly obvious.
> 
Ok.

Guenter
