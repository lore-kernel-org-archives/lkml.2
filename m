Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab1KVMWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:22:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1KVMWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:22:00 -0500
Date: Tue, 22 Nov 2011 13:21:57 +0100
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: fix dirtied pages accounting on
 sub-page writes
Message-ID: <20111122122157.GB8058@quack.suse.cz>
References: <20111121130342.211953629@intel.com>
 <20111121131215.905222115@intel.com>
 <20111122001127.GG4017@quack.suse.cz>
 <20111122092110.GB12864@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122092110.GB12864@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-11-11 17:21:11, Wu Fengguang wrote:
> On Tue, Nov 22, 2011 at 08:11:27AM +0800, Jan Kara wrote:
> > On Mon 21-11-11 21:03:45, Wu Fengguang wrote:
> > > When dd in 512bytes, generic_perform_write() calls
> > > balance_dirty_pages_ratelimited() 8 times for the same page, but
> > > obviously the page is only dirtied once.
> > > 
> > > Fix it by accounting nr_dirtied at page dirty time.
> >   Well, but after this change, the interface balance_dirty_ratelimited_nr()
> > is strange because the argument is only used for per-CPU ratelimiting and
> > not for per-task ratelimiting...
> 
> Yeah I was vaguely aware of this... and still choose to ignore this
> since the patchset looked already forbiddingly large at the time ;)
> 
> > So if you do this switch then I'd also
> > switch bdp_ratelimits to get consistent results and a clean interface and
> > completely kill balance_dirty_pages_ratelimited_nr().
> 
> Following your suggestions to change ratelimiting as well :)
> 
> I'll do the interface change with a standalone patch.
  OK.

> ---
> Subject: writeback: fix dirtied pages accounting on sub-page writes
> Date: Thu Apr 14 07:52:37 CST 2011
> 
> When dd in 512bytes, generic_perform_write() calls
> balance_dirty_pages_ratelimited() 8 times for the same page, but
> obviously the page is only dirtied once.
> 
> Fix it by accounting tsk->nr_dirtied and bdp_ratelimits at page dirty time.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/page-writeback.c |   13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> --- linux-next.orig/mm/page-writeback.c	2011-11-22 16:59:48.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-11-22 17:12:20.000000000 +0800
> @@ -1231,8 +1231,6 @@ void balance_dirty_pages_ratelimited_nr(
>  	if (bdi->dirty_exceeded)
>  		ratelimit = min(ratelimit, 32 >> (PAGE_SHIFT - 10));
>  
> -	current->nr_dirtied += nr_pages_dirtied;
> -
>  	preempt_disable();
>  	/*
>  	 * This prevents one CPU to accumulate too many dirtied pages without
> @@ -1243,12 +1241,9 @@ void balance_dirty_pages_ratelimited_nr(
>  	p =  &__get_cpu_var(bdp_ratelimits);
>  	if (unlikely(current->nr_dirtied >= ratelimit))
>  		*p = 0;
> -	else {
> -		*p += nr_pages_dirtied;
> -		if (unlikely(*p >= ratelimit_pages)) {
> -			*p = 0;
> -			ratelimit = 0;
> -		}
> +	else if (unlikely(*p >= ratelimit_pages)) {
> +		*p = 0;
> +		ratelimit = 0;
>  	}
>  	/*
>  	 * Pick up the dirtied pages by the exited tasks. This avoids lots of
> @@ -1743,6 +1738,8 @@ void account_page_dirtied(struct page *p
>  		__inc_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
>  		task_dirty_inc(current);
>  		task_io_account_write(PAGE_CACHE_SIZE);
> +		current->nr_dirtied++;
> +		__get_cpu_var(bdp_ratelimits)++;
  I think you need preempt_disable() and preempt_enable() pair around
__get_cpu_var(). Otherwise a process could get rescheduled in the middle of
read-modify-write cycle...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
