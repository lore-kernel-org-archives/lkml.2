Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab1C2GVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 02:21:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33768 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1C2GVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 02:21:23 -0400
Date: Tue, 29 Mar 2011 08:21:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/6] x86-64: vclock_gettime(CLOCK_MONOTONIC) can't ever
 see nsec < 0
Message-ID: <20110329062112.GC27398@elte.hu>
References: <cover.1301324270.git.luto@mit.edu>
 <75824c7636ab74a71598080867c927d313c8ab66.1301324270.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75824c7636ab74a71598080867c927d313c8ab66.1301324270.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@MIT.EDU> wrote:

> vclock_gettime's do_monotonic helper can't ever generate a negative
> nsec value, so it doesn't need to check whether it's negative.  This
> saves a single easily-predicted branch.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/vdso/vclock_gettime.c |   40 ++++++++++++++++++++++------------------
>  1 files changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index ee55754..67d54bb 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -56,22 +56,6 @@ notrace static noinline int do_realtime(struct timespec *ts)
>  	return 0;
>  }
>  
> -/* Copy of the version in kernel/time.c which we cannot directly access */
> -notrace static void
> -vset_normalized_timespec(struct timespec *ts, long sec, long nsec)
> -{
> -	while (nsec >= NSEC_PER_SEC) {
> -		nsec -= NSEC_PER_SEC;
> -		++sec;
> -	}
> -	while (nsec < 0) {
> -		nsec += NSEC_PER_SEC;
> -		--sec;
> -	}
> -	ts->tv_sec = sec;
> -	ts->tv_nsec = nsec;
> -}
> -
>  notrace static noinline int do_monotonic(struct timespec *ts)
>  {
>  	unsigned long seq, ns, secs;
> @@ -82,7 +66,17 @@ notrace static noinline int do_monotonic(struct timespec *ts)
>  		secs += gtod->wall_to_monotonic.tv_sec;
>  		ns += gtod->wall_to_monotonic.tv_nsec;
>  	} while (unlikely(read_seqretry(&gtod->lock, seq)));
> -	vset_normalized_timespec(ts, secs, ns);
> +
> +	/* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
> +	 * are all guaranteed to be nonnegative.
> +	 */
> +	while (ns >= NSEC_PER_SEC) {
> +		ns -= NSEC_PER_SEC;
> +		++secs;
> +	}
> +	ts->tv_sec = secs;
> +	ts->tv_nsec = ns;
> +
>  	return 0;
>  }
>  
> @@ -107,7 +101,17 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
>  		secs += gtod->wall_to_monotonic.tv_sec;
>  		ns += gtod->wall_to_monotonic.tv_nsec;
>  	} while (unlikely(read_seqretry(&gtod->lock, seq)));
> -	vset_normalized_timespec(ts, secs, ns);
> +
> +	/* wall_time_nsec and wall_to_monotonic.tv_nsec are
> +	 * guaranteed to be between 0 and NSEC_PER_SEC.
> +	 */
> +	if (ns >= NSEC_PER_SEC) {
> +		ns -= NSEC_PER_SEC;
> +		++secs;
> +	}
> +	ts->tv_sec = secs;
> +	ts->tv_nsec = ns;
> +
>  	return 0;

Beyond the change you describe in the changelog, you also uninlined the helper 
function.

You can use __always_inline instead and still keep the code maintainable.

Thanks,

	Ingo
