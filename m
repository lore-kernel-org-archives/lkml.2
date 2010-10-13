Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0JMOBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:01:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50567 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0JMOBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=u3/HfK4fXtwtwVsiimU6diPFLqYCk0rkgA0B0kRPVbfHE/wm0pbH2dDNLEdVOIwmhI
         SAo+KpMiYCRwGw0R8M2Emk4ylfCNrfUcNb4SHep9S1sS79ykxfwK8qFR3efx/fst6h3F
         CYGbg/fz9anyabzRsRABVA1ALAAbEOeFVI8w8=
MIME-Version: 1.0
In-Reply-To: <20101006093225.8739.14012.stgit@tt-desk>
References: <20101006093225.8739.14012.stgit@tt-desk>
From: kevin granade <kevin.granade@gmail.com>
Date: Wed, 13 Oct 2010 09:01:16 -0500
Message-ID: <AANLkTikzq-d4s83kx-RWv5_D2TN4bEDHKUqyaLo8z=5+@mail.gmail.com>
Subject: Re: [PATCH] Add generic exponentially weighted moving average function
To: Bruno Randolf <br1@einfach.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 6, 2010 at 4:32 AM, Bruno Randolf <br1@einfach.org> wrote:
>
> This adds a generic exponentially weighted moving average function. This
> implementation makes use of a structure which keeps a scaled up internal
> representation to reduce rounding errors.
>
> The idea for this implementation comes from the rt2x00 driver (rt2x00link.c)
> and i would like to use it in several places in the mac80211 and ath5k code.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
>
> --
> Is this the right place to add it? Who to CC:?
> ---
>  include/linux/average.h |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/average.h
>
> diff --git a/include/linux/average.h b/include/linux/average.h
> new file mode 100644
> index 0000000..2a00d3d
> --- /dev/null
> +++ b/include/linux/average.h
> @@ -0,0 +1,32 @@
> +#ifndef _LINUX_AVERAGE_H
> +#define _LINUX_AVERAGE_H
> +
> +#define AVG_FACTOR     1000

If this is going to be general use, wouldn't it be a good feature to
make AVG_FACTOR adjustable?

>
> +
> +struct avg_val {
> +       int value;
> +       int internal;
> +};

This has a scaled up copy of the moving average, which reduces the
available range for the average to MAX_INT/(AVG_FACTOR*num_samples)
instead of +/- MAX_INT, is that acceptable?  Even if it is, shouldn't
it be documented?  For example, with num_samples = 10, it will roll
over to a negative value if the average exceeds 214,748.  This seems
like a potentially surprising outcome.

>
> +
> +/**
> + * moving_average -  Exponentially weighted moving average
> + * @avg: average structure
> + * @val: current value
> + * @samples: number of samples
> + *
> + * This implementation make use of a struct avg_val to prevent rounding
> + * errors.
> + */
> +static inline struct avg_val
> +moving_average(const struct avg_val avg, const int val, const int samples)
> +{
> +       struct avg_val ret;
> +       ret.internal = avg.internal  ?
> +               (((avg.internal * (samples - 1)) +
> +                       (val * AVG_FACTOR)) / samples) :

I'm not sure what the kernel standard is on this, but is it ok to have
this potential div/0 in a general purpose function?

Thanks,
Kevin Granade

>
> +               (val * AVG_FACTOR);
> +       ret.value = ret.internal / AVG_FACTOR;
> +       return ret;
> +}
>
> +
> +#endif /* _LINUX_AVERAGE_H */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
