Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab0LPRtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:49:53 -0500
Received: from www.tglx.de ([62.245.132.106]:45459 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab0LPRtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:49:51 -0500
Date: Thu, 16 Dec 2010 18:48:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
In-Reply-To: <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
Message-ID: <alpine.LFD.2.00.1012161844140.12146@localhost6.localdomain6>
References: <cover.1292512461.git.richard.cochran@omicron.at> <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010, Richard Cochran wrote:
> +	if (txc->modes & ADJ_SETOFFSET) {
> +		/* Validate the delta value. */
> +		if (txc->time.tv_sec && txc->time.tv_usec < 0)
> +			return -EINVAL;
> +
> +		if (txc->modes & ADJ_NANO) {
> +			struct timespec tmp;
> +			tmp.tv_sec  = txc->time.tv_sec;
> +			tmp.tv_nsec = txc->time.tv_usec;
> +			delta = timespec_to_ktime(tmp);
> +		} else
> +			delta = timeval_to_ktime(txc->time);
> +
> +		/* Adding the delta should be an "atomic" operation. */
> +		local_irq_disable();

I really do not like that conditional irq_disable(), especially as we
disable them further down again and we only safe the getnstimeofday()
call in the non ADJSETOFFSET code path.

So we really better do that unconditionally before getnstimeofday()
with an appropriate comment and change the write_seqlock_irq() to
write_seqlock().

> +	}
> +
>  	getnstimeofday(&ts);
>  
> +	if (txc->modes & ADJ_SETOFFSET) {
> +		kt = timespec_to_ktime(ts);
> +		kt = ktime_add(kt, delta);
> +		ts = ktime_to_timespec(kt);
> +		do_settimeofday(&ts);
> +		local_irq_enable();
> +	}
> +
>  	write_seqlock_irq(&xtime_lock);

Thanks,

	tglx
> 
