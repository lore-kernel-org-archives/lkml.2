Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1KHRzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:55:39 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:60762 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751501Ab1KHRzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:55:38 -0500
Date: Tue, 8 Nov 2011 17:55:32 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Al Cooper <alcooperx@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Kernel hangs occasionally during boot.
Message-ID: <20111108175532.GA15493@linux-mips.org>
References: <y>
 <1320764341-4275-1-git-send-email-alcooperx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320764341-4275-1-git-send-email-alcooperx@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 09:59:01AM -0500, Al Cooper wrote:

>  arch/mips/kernel/cevt-r4k.c |   38 +++++++++++++++++++-------------------
>  1 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
> index 98c5a97..e2d8e19 100644
> --- a/arch/mips/kernel/cevt-r4k.c
> +++ b/arch/mips/kernel/cevt-r4k.c
> @@ -103,19 +103,10 @@ static int c0_compare_int_pending(void)
>  
>  /*
>   * Compare interrupt can be routed and latched outside the core,
> - * so a single execution hazard barrier may not be enough to give
> - * it time to clear as seen in the Cause register.  4 time the
> - * pipeline depth seems reasonably conservative, and empirically
> - * works better in configurations with high CPU/bus clock ratios.
> + * so wait up to worst case number of cycle counter ticks for timer interrupt
> + * changes to propagate to the cause register.
>   */
> -
> -#define compare_change_hazard() \
> -	do { \
> -		irq_disable_hazard(); \
> -		irq_disable_hazard(); \
> -		irq_disable_hazard(); \
> -		irq_disable_hazard(); \
> -	} while (0)
> +#define COMPARE_INT_SEEN_TICKS 50
>  
>  int c0_compare_int_usable(void)
>  {
> @@ -126,8 +117,12 @@ int c0_compare_int_usable(void)
>  	 * IP7 already pending?  Try to clear it by acking the timer.
>  	 */
>  	if (c0_compare_int_pending()) {
> -		write_c0_compare(read_c0_count());
> -		compare_change_hazard();
> +		cnt = read_c0_count();
> +		write_c0_compare(cnt);
> +		back_to_back_c0_hazard();

back_to_back_c0_hazard is to separate cp0 writes from subsequent reads from
the same cp0 register.  So I think no back_to_back_c0_hazard() is needed
here.

> +		while (read_c0_count() < (cnt  + COMPARE_INT_SEEN_TICKS))
> +			if (!c0_compare_int_pending())
> +				break;
>  		if (c0_compare_int_pending())
>  			return 0;
>  	}
> @@ -136,7 +131,7 @@ int c0_compare_int_usable(void)
>  		cnt = read_c0_count();
>  		cnt += delta;
>  		write_c0_compare(cnt);
> -		compare_change_hazard();
> +		back_to_back_c0_hazard();

Same comment as above.

>  		if ((int)(read_c0_count() - cnt) < 0)
>  		    break;
>  		/* increase delta if the timer was already expired */
> @@ -145,12 +140,17 @@ int c0_compare_int_usable(void)
>  	while ((int)(read_c0_count() - cnt) <= 0)
>  		;	/* Wait for expiry  */
>  
> -	compare_change_hazard();
> +	while (read_c0_count() < (cnt + COMPARE_INT_SEEN_TICKS))
> +		if (c0_compare_int_pending())
> +			break;
>  	if (!c0_compare_int_pending())
>  		return 0;
> -
> -	write_c0_compare(read_c0_count());
> -	compare_change_hazard();
> +	cnt = read_c0_count();
> +	write_c0_compare(cnt);
> +	back_to_back_c0_hazard();
> +	while (read_c0_count() < (cnt + COMPARE_INT_SEEN_TICKS))
> +		if (!c0_compare_int_pending())
> +			break;
>  	if (c0_compare_int_pending())
>  		return 0;

I've applied your patch but we may need another hazard barrier to
replace back_to_back_c0_hazard().

  Ralf
