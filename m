Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291Ab0FUUPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:15:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945Ab0FUUPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:15:18 -0400
Date: Mon, 21 Jun 2010 13:14:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hughd@google.com>, yanmin.zhang@intel.com
Subject: Re: [PATCH v3 1/2] tmpfs: Add accurate compare function to
 percpu_counter library
Message-Id: <20100621131438.a17b818d.akpm@linux-foundation.org>
In-Reply-To: <1276818992.9661.81.camel@schen9-DESK>
References: <1276818992.9661.81.camel@schen9-DESK>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 16:56:32 -0700
Tim Chen <tim.c.chen@linux.intel.com> wrote:

> Add percpu_counter_compare that allows for a quick but accurate
> comparison of percpu_counter with a given value.  
> 
> A rough count is provided by the count field in percpu_counter structure, 
> without accounting for the other values stored in individual cpu counters.
> The actual count is a sum of count and the cpu counters.  However, count field is
> never different from the actual value by a factor of batch*num_online_cpu.
> We do not need to get actual count for comparison if count
> is different from the given value by this factor and allows for
> quick comparison without summing up all the per cpu counters.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
>  include/linux/percpu_counter.h |   11 +++++++++++
>  lib/percpu_counter.c           |   27 +++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> index c88d67b..8a7d510 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -40,6 +40,7 @@ void percpu_counter_destroy(struct percpu_counter *fbc);
>  void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
>  void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
>  s64 __percpu_counter_sum(struct percpu_counter *fbc);
> +int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
>  
>  static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
>  {
> @@ -98,6 +99,16 @@ static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
>  	fbc->count = amount;
>  }
>  
> +static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
> +{
> +	if (fbc->count > rhs)
> +		return 1;
> +	else if (fbc->count < rhs)
> +		return -1;
> +	else
> +		return 0;
> +}

It'd be nice if this interface were defined as returning a number
less-than, greater-than or equal to zero.  Like the qsort() callback. 
It's a pretty common idiom.  That way, the above code becomes just

	return fbc->count - rhs;

However that does require that percpu_counter_compare() return an s64,
which might make the code generated at callers a little less efficient.

I guess it doesn't matter much.

>  static inline void
>  percpu_counter_add(struct percpu_counter *fbc, s64 amount)
>  {
> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index aeaa6d7..ec9048e 100644
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -137,6 +137,33 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
>  	return NOTIFY_OK;
>  }
>  
> +/*
> + * Compare counter against given value.
> + * Return 1 if greater, 0 if equal and -1 if less
> + */
> +int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
> +{
> +	s64	count;
> +
> +	count = percpu_counter_read(fbc);
> +	/* Check to see if rough count will be sufficient for comparison */
> +	if (abs(count - rhs) > (percpu_counter_batch*num_online_cpus())) {
> +		if (count > rhs)
> +			return 1;
> +		else
> +			return -1;
> +	}
> +	/* Need to use precise count */
> +	count = percpu_counter_sum(fbc);
> +	if (count > rhs)
> +		return 1;
> +	else if (count < rhs)
> +		return -1;
> +	else
> +		return 0;
> +}
> +EXPORT_SYMBOL(percpu_counter_compare);

Looks OK.  For API uniformity we should have a

__percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, int batch)

but that can be added later if needed I guess.

