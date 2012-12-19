Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2LSWVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:21:32 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:32077 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2LSWVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:21:24 -0500
Date: Wed, 19 Dec 2012 23:21:15 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        lm-sensors@lm-sensors.org, Juergen Beisert <jbe@pengutronix.de>
Subject: Re: [PATCH v2] linux/kernel.h: Fix DIV_ROUND_CLOSEST with unsigned
 divisors
Message-ID: <20121219232115.727a2e91@endymion.delvare>
In-Reply-To: <1355928015-26212-1-git-send-email-linux@roeck-us.net>
References: <1355928015-26212-1-git-send-email-linux@roeck-us.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Wed, 19 Dec 2012 06:40:15 -0800, Guenter Roeck wrote:
> Commit 263a523 fixes a warning seen with W=1 due to change in
> DIV_ROUND_CLOSEST. Unfortunately, the C compiler converts divide operations
> with unsigned divisors to unsigned, even if the dividend is signed and
> negative (for example, -10 / 5U = 858993457). The C standard says "If one
> operand has unsigned int type, the other operand is converted to unsigned
> int", so the compiler is not to blame.

This is surprising to say the least. But if the C standard says so...

I wouldn't be surprised if there are bugs because of this in the kernel
and in other projects.

> As a result, DIV_ROUND_CLOSEST(0, 2U) and similar operations now return
> bad values, since the automatic conversion of expressions such as "0 - 2U/2"
> to unsigned was not taken into account.
> 
> Fix by checking for the divisor variable type when deciding which operation
> to perform. This fixes DIV_ROUND_CLOSEST(0, 2U), but still returns bad values
> for negative dividends divided by unsigned divisors. Mark the latter case as
> unsupported.

True but this last issue isn't specific to the DIV_ROUND_CLOSEST
implementation, it would also happen with a simple division.

> Reported-by: Juergen Beisert <jbe@pengutronix.de>
> Tested-by: Juergen Beisert <jbe@pengutronix.de>
> Cc: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Description update (v1 wasn't supposed to make it to lkml)
> 
>  include/linux/kernel.h |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d97ed58..45726dc 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -77,13 +77,15 @@
>  
>  /*
>   * Divide positive or negative dividend by positive divisor and round
> - * to closest integer. Result is undefined for negative divisors.
> + * to closest integer. Result is undefined for negative divisors and
> + * for negative dividends if the divisor variable type is unsigned.

Thinking a bit more about this... Documenting the non-working cases is
great, however I don't really expect all developers to pay attention. I
can also imagine variable types changing from signed to unsigned later,
and never thinking this can introduce a bug.

So, is there nothing we can do to spot at least the second issue at
build time? For regular division there's nothing we can do (although I
don't understand why gcc doesn't warn...) but here we get the
opportunity to report the issue, let's take it.

And given that the divisor is almost always a constant,
maybe we can check for negative divisors too, this would be safer and
the code size increase would probably be very small in practice.
Opinions?

>   */
>  #define DIV_ROUND_CLOSEST(x, divisor)(			\
>  {							\
>  	typeof(x) __x = x;				\
>  	typeof(divisor) __d = divisor;			\
> -	(((typeof(x))-1) > 0 || (__x) > 0) ?		\
> +	(((typeof(x))-1) > 0 ||				\
> +	 ((typeof(divisor))-1) > 0 || (__x) > 0) ?	\
>  		(((__x) + ((__d) / 2)) / (__d)) :	\
>  		(((__x) - ((__d) / 2)) / (__d));	\
>  }							\

Looks good.

-- 
Jean Delvare
