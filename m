Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab0JSNX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:23:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63970 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab0JSNXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=iwpOukyqa2NInDRcxwisitqFVE3GHUvG5DpMtx3E1vCWoWidux4uKu6azrpRt3YySx
         /kU+nDt6YRNTZmZduYkWGaaNOQNYxFSoB9vDPF75rNBsJKmTPfmCESz3iYDk3nohRDTT
         jGZw3FL1IbhZFyeVl9V6/8PJ94u1cE41sdAZ4=
MIME-Version: 1.0
In-Reply-To: <20101019083635.32294.67087.stgit@localhost6.localdomain6>
References: <20101019083635.32294.67087.stgit@localhost6.localdomain6>
From: kevin granade <kevin.granade@gmail.com>
Date: Tue, 19 Oct 2010 08:22:54 -0500
Message-ID: <AANLkTimeUUxxJWFbpNa4Z=aVAJ1QRvEX3qkVw8K_c=19@mail.gmail.com>
Subject: Re: [PATCH v2] Add generic exponentially weighted moving average function
To: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, akpm@linux-foundation.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 3:36 AM, Bruno Randolf <br1@einfach.org> wrote:
>
> This adds a generic exponentially weighted moving average function. This
> implementation makes use of a structure which keeps a scaled up internal
> representation to reduce rounding errors.
>
> The idea for this implementation comes from the rt2x00 driver (rt2x00link.c)
> and I would like to use it in several places in the mac80211 and ath5k code.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>

Sorry for the resend, gmail auto-switched to html.

Probably not worth the paper it's written on, but fwiw:
Reviewed-by: Kevin Granade <kevin.granade@gmail.com>

>
> --
> v2: Renamed 'samples' to 'weight'. Added more documentation. Use avg_val
>    pointer. Add a WARN_ON_ONCE for invalid values of 'weight'. Divide
>    and round up/down.
> ---
>  include/linux/average.h |   37 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 37 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/average.h
>
> diff --git a/include/linux/average.h b/include/linux/average.h
> new file mode 100644
> index 0000000..55e4317
> --- /dev/null
> +++ b/include/linux/average.h
> @@ -0,0 +1,37 @@
> +#ifndef _LINUX_AVERAGE_H
> +#define _LINUX_AVERAGE_H
> +
> +#define AVG_FACTOR     1000
> +
> +struct avg_val {
> +       int value;
> +       int internal;
> +};
> +
> +/**
> + * moving_average() -  Exponentially weighted moving average (EWMA)
> + * @avg: Average structure
> + * @val: Current value
> + * @weight: This defines how fast the influence of older values decreases.
> + *     Has to be higher than 1. Use the same number every time you call this
> + *     function for a single struct avg_val!
> + *
> + * This implementation make use of a struct avg_val which keeps a scaled up
> + * internal representation to prevent rounding errors. Due to this, the maximum
> + * range of values is MAX_INT/(AVG_FACTOR*weight).
> + *
> + * The current average value can be accessed by using avg_val.value.
> + */
> +static inline void
> +moving_average(struct avg_val *avg, const int val, const int weight)
> +{
> +       if (WARN_ON_ONCE(weight <= 1))
> +               return;
> +       avg->internal = avg->internal  ?
> +               (((avg->internal * (weight - 1)) +
> +                       (val * AVG_FACTOR)) / weight) :
> +               (val * AVG_FACTOR);
> +       avg->value = DIV_ROUND_CLOSEST(avg->internal, AVG_FACTOR);
> +}
> +
> +#endif /* _LINUX_AVERAGE_H */
>
