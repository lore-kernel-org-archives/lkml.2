Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0JSWiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:38:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab0JSWiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:38:12 -0400
Date: Tue, 19 Oct 2010 15:37:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bruno Randolf <br1@einfach.org>
Cc: randy.dunlap@oracle.com, kevin.granade@gmail.com, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] Add generic exponentially weighted moving average
 function
Message-Id: <20101019153756.a89ed362.akpm@linux-foundation.org>
In-Reply-To: <20101019083635.32294.67087.stgit@localhost6.localdomain6>
References: <20101019083635.32294.67087.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 17:36:35 +0900
Bruno Randolf <br1@einfach.org> wrote:

> This adds a generic exponentially weighted moving average function. This
> implementation makes use of a structure which keeps a scaled up internal
> representation to reduce rounding errors.
> 
> The idea for this implementation comes from the rt2x00 driver (rt2x00link.c)
> and I would like to use it in several places in the mac80211 and ath5k code.
> 
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> 

hm, interesting.  I suspect there are a few places in MM/VFS/writeback
which could/should be using something like this.  Of course, if we do
this then your nice little function will end up 250 lines long, utterly
incomprehensible and full of subtle bugs.  We like things to be that way.

Thanks for proposing it as generic code, btw.  Let's merge it and see
what happens.

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
