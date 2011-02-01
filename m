Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1BAOKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:10:12 -0500
Received: from www.tglx.de ([62.245.132.106]:33144 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab1BAOKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:10:10 -0500
Date: Tue, 1 Feb 2011 15:10:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 1/2] hrtimers: extend hrtimer base code to handle more
 then 2 clockids
In-Reply-To: <1296531837-12879-2-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.LFD.2.00.1102011505540.31804@localhost6.localdomain6>
References: <1296531837-12879-1-git-send-email-john.stultz@linaro.org> <1296531837-12879-2-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, John Stultz wrote:
> @@ -53,11 +53,10 @@
>  /*
>   * The timer bases:
>   *
> - * Note: If we want to add new timer bases, we have to skip the two
> - * clock ids captured by the cpu-timers. We do this by holding empty
> - * entries rather than doing math adjustment of the clock ids.
> - * This ensures that we capture erroneous accesses to these clock ids
> - * rather than moving them into the range of valid clock id's.
> + * There are more clockids then hrtimer bases. Thus, we index

s/then/than/

> + * into the timer bases by the hrtimer_base_type enum. When trying
> + * to reach a base using a clockid, hrtimer_clockid_to_base()
> + * is used to convert from clockid to the proper hrtimer_base_type.
>   */
>  DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
>  {
> @@ -77,6 +76,24 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
>  	}
>  };
>  
> +static int hrtimer_clock_to_base_table[MAX_CLOCKS];
> +
> +static inline int hrtimer_clockid_to_base(clockid_t clock_id)
> +{
> +	int ret = hrtimer_clock_to_base_table[clock_id];
> +
> +	if(ret == -1) {
> +		WARN_ON(1);
> +		/* We just hit an invalid clock base,
> +		 * but returning -1 isn't safe, so
> +		 * return the _REALTIME base
> +		 */

  How can this happen ?

> +		return HRTIMER_BASE_REALTIME; 
> +	}
> +	return ret;
> +}

Thanks,

	tglx
