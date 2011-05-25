Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1EYUfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:35:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34013 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab1EYUfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w2Tg4n7LpQ2j04RGUK0npO44H0Fj1YBGu8mK7aVtEzSUP0chyDpiCxAbIVXy2+21t1
         gZEiUauobesnqGn0aYK/dt72Knv6AthHykR6x8QzUrHe11iKWjY88IjFKot2pKPhq4/k
         pHt0n75gommCNpYTBxlNYztUy9V9YtH+F69w4=
Message-ID: <4DDD6801.4010100@lwfinger.net>
Date: Wed, 25 May 2011 15:35:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>
Subject: Re: [RFC V1] lib: cordic: add library module for cordic angle calculation
References: <1306352426-1899-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1306352426-1899-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 02:40 PM, Arend van Spriel wrote:
> The brcm80211 driver in the staging tree has a cordic function to
> determine cosine and sine for a given angle. Feedback received from
> John Linville suggested that these kind of functions should be made
> available to others as a library function in the kernel tree.
>
> V1:
> - code taken from brcm80211 driver and added kernel-doc comments.
> - code compiled and tested for x86 architecture using brcm80211 driver.
> - code compiled for x86_64, ARM, and MIPS architectures.
>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: "John W. Linville"<linville@tuxdriver.com>
> Cc: Greg Kroah-Hartman<gregkh@suse.de>
> Cc: Dan Carpenter<error27@gmail.com>
> Reviewed-by: Roland Vossen<rvossen@broadcom.com>
> Reviewed-by: Henry Ptasinski<henryp@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin<frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel<arend@broadcom.com>
> ---
>   include/linux/cordic.h |   48 +++++++++++++++++++++++
>   lib/Kconfig            |    7 +++
>   lib/Makefile           |    2 +
>   lib/cordic.c           |   99 ++++++++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 156 insertions(+), 0 deletions(-)
>   create mode 100644 include/linux/cordic.h
>   create mode 100644 lib/cordic.c

There is a similar routine in b43, thus this library function will likely have 
at least 2 users.

> diff --git a/include/linux/cordic.h b/include/linux/cordic.h
> new file mode 100644
> index 0000000..28443a6
> --- /dev/null
> +++ b/include/linux/cordic.h
> @@ -0,0 +1,48 @@
> +/*
> + * Copyright (c) 2011 Broadcom Corporation
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +#ifndef __CORDIC_H_
> +#define __CORDIC_H_
> +
> +#include<linux/types.h>
> +
> +/**
> + * struct - i/q coordinate.
> + *
> + * @i: real part of coordinate (in phase).
> + * @q: imaginary part of coordinate (quadrature).
> + */
> +struct cordic_iq {
> +	s32 i;
> +	s32 q;
> +};
> +
> +/**
> + * cordic_calc_iq() - calculates the i/q coordinate for given angle.
> + *
> + * @theta: angle in degrees for which i/q coordinate is to be calculated.
> + * @coord: function output parameter holding the i/q coordinate.
> + *
> + * The function calculates the i/q coordinate for a given angle using
> + * cordic algorithm. The coordinate consists of a real (i) and an
> + * imaginary (q) part. The real part is essentially the cosine of the
> + * angle and the imaginary part is the sine of the angle. The returned
> + * values are scaled by 2^16 for precision. The range for theta is
> + * for -180 degrees to +180 degrees. Passed values outside this range are
> + * converted before doing the actual calculation.
> + */
> +void cordic_calc_iq(s32 theta, struct cordic_iq *coord);
> +
> +#endif /* __CORDIC_H_ */
> diff --git a/lib/Kconfig b/lib/Kconfig
> index ff9e5a3..5c70204 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -279,4 +279,11 @@ config AVERAGE
>
>   	  If unsure, say N.
>
> +config CORDIC
> +	tristate "Cordic function"
> +	help
> +	  The option provides arithmetic function using cordic algorithm
> +	  so its calculations are in fixed point. Modules can select this
> +	  when they require this function. Module will be called cordic.
> +
>   endmenu
> diff --git a/lib/Makefile b/lib/Makefile
> index 704959d..9e3c1b0 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -117,6 +117,8 @@ obj-$(CONFIG_AVERAGE) += average.o
>
>   obj-$(CONFIG_CPU_RMAP) += cpu_rmap.o
>
> +obj-$(CONFIG_CORDIC) += cordic.o
> +
>   hostprogs-y	:= gen_crc32table
>   clean-files	:= crc32table.h
>
> diff --git a/lib/cordic.c b/lib/cordic.c
> new file mode 100644
> index 0000000..3952258
> --- /dev/null
> +++ b/lib/cordic.c
> @@ -0,0 +1,99 @@
> +/*
> + * Copyright (c) 2011 Broadcom Corporation
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
> + * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
> + * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> + * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +#include<linux/module.h>
> +#include<linux/cordic.h>
> +
> +#define CORDIC_ANGLE_GEN	39797
> +#define CORDIC_PRECISION_SHIFT	16
> +#define	CORDIC_NUM_ITER		(CORDIC_PRECISION_SHIFT + 2)
> +
> +#define	FIXED(X)	((s32)((X)<<  CORDIC_PRECISION_SHIFT))
> +#define	FLOAT(X)	(((X)>= 0) \
> +		? ((((X)>>  (CORDIC_PRECISION_SHIFT - 1)) + 1)>>  1) \
> +		: -((((-(X))>>  (CORDIC_PRECISION_SHIFT - 1)) + 1)>>  1))
> +
> +static const s32 AtanTbl[] = {

In Documentation/CodingStyle, variables with mixed-case names are frownid upon.

> +	2949120,
> +	1740967,
> +	919879,
> +	466945,
> +	234379,
> +	117304,
> +	58666,
> +	29335,
> +	14668,
> +	7334,
> +	3667,
> +	1833,
> +	917,
> +	458,
> +	229,
> +	115,
> +	57,
> +	29
> +};
> +
> +/*
> + * cordic_calc_iq() - calculates the i/q coordinate for given angle
> + *
> + * theta: angle in degrees for which i/q coordinate is to be calculated
> + * coord: function output parameter holding the i/q coordinate
> + */
> +void cordic_calc_iq(s32 theta, struct cordic_iq *coord)

As "coord" is only for output, why not have this be a function returning a 
struct cordic_iq?

> +{
> +	s32 angle, valtmp;
> +	unsigned iter;
> +	int signx = 1;
> +	int signtheta;
> +
> +	coord->i = CORDIC_ANGLE_GEN;
> +	coord->q = 0;
> +	angle = 0;
> +
> +	theta = FIXED(theta);
> +	signtheta = (theta<  0) ? -1 : 1;
> +	theta = ((theta + FIXED(180) * signtheta) % FIXED(360)) -
> +		FIXED(180) * signtheta;
> +
> +	if (FLOAT(theta)>  90) {
> +		theta -= FIXED(180);
> +		signx = -1;
> +	} else if (FLOAT(theta)<  -90) {
> +		theta += FIXED(180);
> +		signx = -1;
> +	}
> +
> +	for (iter = 0; iter<  CORDIC_NUM_ITER; iter++) {
> +		if (theta>  angle) {
> +			valtmp = coord->i - (coord->q>>  iter);

I think the whitespace should be the same on both sides of the >> operator. 
Either "coord->q>>iter" or "coord->q >> iter" would be OK. I know checkpatch.pl 
does not complain, but it does for other binary operators.

> +			coord->q += (coord->i>>  iter);
> +			angle += AtanTbl[iter];
> +		} else {
> +			valtmp = coord->i + (coord->q>>  iter);
> +			coord->q -= (coord->i>>  iter);
> +			angle -= AtanTbl[iter];
> +		}
> +		coord->i = valtmp;
> +	}
> +
> +	coord->i *= signx;
> +	coord->q *= signx;
> +}
> +EXPORT_SYMBOL(cordic_calc_iq);
> +
> +MODULE_DESCRIPTION("Cordic functions");
> +MODULE_AUTHOR("Broadcom Corporation");
> +MODULE_LICENSE("Dual BSD/GPL");

Larry
