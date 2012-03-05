Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab2CEPHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:07:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529Ab2CEPG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:06:59 -0500
Date: Mon, 5 Mar 2012 16:06:57 +0100
From: Jan Kara <jack@suse.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ilya Tumaykin <librarian_rus@yahoo.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [ 03/34] lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit
 kernel
Message-ID: <20120305150657.GB11238@quack.suse.cz>
References: <20120301214654.GA13231@kroah.com>
 <20120301213922.703908387@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301213922.703908387@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-03-12 13:39:25, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
  Not that I'd see anything wrong with this patch for 2.6.32. But it is
also unnecessary since the code which was triggering the overflow does not
exist in 2.6.32. So maybe just on the grounds of not applying unneeded
patchs I'd skip this one.

								Honza

> 
> ------------------
> 
> From: Wu Fengguang <fengguang.wu@intel.com>
> 
> commit 3310225dfc71a35a2cc9340c15c0e08b14b3c754 upstream.
> 
> PROP_MAX_SHIFT should be set to <=32 on 64-bit box. This fixes two bugs
> in the below lines of bdi_dirty_limit():
> 
> 	bdi_dirty *= numerator;
> 	do_div(bdi_dirty, denominator);
> 
> 1) divide error: do_div() only uses the lower 32 bit of the denominator,
>    which may trimmed to be 0 when PROP_MAX_SHIFT > 32.
> 
> 2) overflow: (bdi_dirty * numerator) could easily overflow if numerator
>    used up to 48 bits, leaving only 16 bits to bdi_dirty
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Reported-by: Ilya Tumaykin <librarian_rus@yahoo.com>
> Tested-by: Ilya Tumaykin <librarian_rus@yahoo.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  include/linux/proportions.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/include/linux/proportions.h
> +++ b/include/linux/proportions.h
> @@ -81,7 +81,11 @@ void prop_inc_percpu(struct prop_descrip
>   * Limit the time part in order to ensure there are some bits left for the
>   * cycle counter and fraction multiply.
>   */
> +#if BITS_PER_LONG == 32
>  #define PROP_MAX_SHIFT (3*BITS_PER_LONG/4)
> +#else
> +#define PROP_MAX_SHIFT (BITS_PER_LONG/2)
> +#endif
>  
>  #define PROP_FRAC_SHIFT		(BITS_PER_LONG - PROP_MAX_SHIFT - 1)
>  #define PROP_FRAC_BASE		(1UL << PROP_FRAC_SHIFT)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
