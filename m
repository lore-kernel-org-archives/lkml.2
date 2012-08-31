Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2HaAcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 20:32:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2HaAcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 20:32:01 -0400
Date: Thu, 30 Aug 2012 17:35:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3] linux/kernel.h: Fix DIV_ROUND_CLOSEST to support
 negative operands
Message-Id: <20120830173531.291e7b6d.akpm@linux-foundation.org>
In-Reply-To: <1346371847-21384-1-git-send-email-linux@roeck-us.net>
References: <1346371847-21384-1-git-send-email-linux@roeck-us.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2012 17:10:47 -0700 Guenter Roeck <linux@roeck-us.net> wrote:

> DIV_ROUND_CLOSEST returns a bad result for dividends with different sign:
> 	DIV_ROUND_CLOSEST(-2, 2) = 0
> 
> Most of the time this does not matter. However, in the hardware monitoring
> subsystem, DIV_ROUND_CLOSEST is sometimes used on integers which can be
> negative (such as temperatures).
> 
> ...
>
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -84,8 +84,11 @@
>  )
>  #define DIV_ROUND_CLOSEST(x, divisor)(			\
>  {							\
> -	typeof(divisor) __divisor = divisor;		\
> -	(((x) + ((__divisor) / 2)) / (__divisor));	\
> +	typeof(x) __x = x;				\
> +	typeof(divisor) __d = divisor;			\
> +	((__x) < 0) == ((__d) < 0) ?			\
> +		(((__x) + ((__d) / 2)) / (__d)) :	\
> +		(((__x) - ((__d) / 2)) / (__d));	\
>  }							\
>  )

Your v2 had that sneaky little "(typeof(x))-1 >= 0" trick in it, so
half the code gets elided at compile time if `x' (why isn't this called
"dividend") has an unsigned type.

Would retaining that be of any benefit?  We do want to avoid doing the
compare-and-branch in as many cases as possible.

Also, this would be a great opportunity to document the macro's beahviour
(I do go on).  That would be a useful thing to do, given that we're now
handling the four +/+, +/-, -/+, -/- cases and the behaviour for each
case isn't terribly obvious.
