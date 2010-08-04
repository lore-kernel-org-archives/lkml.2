Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab0HDWt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:49:57 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50542 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab0HDWtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:49:55 -0400
Subject: Re: [PATCHv3 12/16] ntp: add hardpps implementation
From: john stultz <johnstul@us.ibm.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <358275628c418f5f328adc4a4ea23fc902776566.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
	 <358275628c418f5f328adc4a4ea23fc902776566.1280952801.git.lasaine@lvk.cs.msu.su>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 15:49:47 -0700
Message-ID: <1280962187.2678.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 01:06 +0400, Alexander Gordeev wrote:
> This commit adds hardpps() implementation based upon the original one
> from the NTPv4 reference kernel code from David Mills. However, it is
> highly optimized towards very fast syncronization and maximum stickness
> to PPS signal. The typical error is less then a microsecond.
> To make it sync faster I had to throw away exponential phase filter so
> that the full phase offset is corrected immediately. Then I also had to
> throw away median phase filter because it gives a bigger error itself
> if used without exponential filter.
> Maybe we will find an appropriate filtering scheme in the future but
> it's not necessary if the signal quality is ok.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

[snip]

> +#ifdef	CONFIG_NTP_PPS
> +
> +struct pps_normtime {
> +	__kernel_time_t	sec;	/* seconds */
> +	long		nsec;	/* nanoseconds */
> +};

I don't quite remember the history here (it may be I suggested you use
this instead of overloading a timespec? I honestly don't recall), but
could you add some extra context in a comment here for what a
pps_normtime structure represents and why its used instead of a
timespec? The comment below sort of hints at it, but it would be useful
if it was more explicit.

> +/* normalize the timestamp so that nsec is in the
> +   ( -NSEC_PER_SEC / 2, NSEC_PER_SEC / 2 ] interval */
> +static inline struct pps_normtime pps_normalize_ts(struct timespec ts)
> +{
> +	struct pps_normtime norm = {
> +		.sec = ts.tv_sec,
> +		.nsec = ts.tv_nsec
> +	};
> +
> +	if (norm.nsec > (NSEC_PER_SEC >> 1)) {
> +		norm.nsec -= NSEC_PER_SEC;
> +		norm.sec++;
> +	}
> +
> +	return norm;
> +}

Otherwise the code looks pretty good to me.

Acked-by: John Stultz <johnstul@us.ibm.com>

thanks
-john


