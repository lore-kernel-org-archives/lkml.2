Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab0JSVSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:18:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52052 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0JSVSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:18:23 -0400
Date: Tue, 19 Oct 2010 14:16:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bruno Randolf <br1@einfach.org>
Cc: akpm@linux-foundation.org, kevin.granade@gmail.com, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add generic exponentially weighted moving average
 function
Message-Id: <20101019141627.3bac9593.randy.dunlap@oracle.com>
In-Reply-To: <20101019083635.32294.67087.stgit@localhost6.localdomain6>
References: <20101019083635.32294.67087.stgit@localhost6.localdomain6>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 17:36:35 +0900 Bruno Randolf wrote:

> This adds a generic exponentially weighted moving average function. This
> implementation makes use of a structure which keeps a scaled up internal
> representation to reduce rounding errors.
> 
> The idea for this implementation comes from the rt2x00 driver (rt2x00link.c)
> and I would like to use it in several places in the mac80211 and ath5k code.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>

Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>


> --
> v2: Renamed 'samples' to 'weight'. Added more documentation. Use avg_val
>     pointer. Add a WARN_ON_ONCE for invalid values of 'weight'. Divide
>     and round up/down.
> ---
>  include/linux/average.h |   37 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 37 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/average.h
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
> +#define AVG_FACTOR	1000
> +
> +struct avg_val {
> +	int value;
> +	int internal;
> +};
> +
> +/**
> + * moving_average() -  Exponentially weighted moving average (EWMA)
> + * @avg: Average structure
> + * @val: Current value
> + * @weight: This defines how fast the influence of older values decreases.
> + *	Has to be higher than 1. Use the same number every time you call this
> + *	function for a single struct avg_val!
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
> +	if (WARN_ON_ONCE(weight <= 1))
> +		return;
> +	avg->internal = avg->internal  ?
> +		(((avg->internal * (weight - 1)) +
> +			(val * AVG_FACTOR)) / weight) :
> +		(val * AVG_FACTOR);
> +	avg->value = DIV_ROUND_CLOSEST(avg->internal, AVG_FACTOR);
> +}
> +
> +#endif /* _LINUX_AVERAGE_H */
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
