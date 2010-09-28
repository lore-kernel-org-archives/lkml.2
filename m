Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab0I1UQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:16:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45033 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab0I1UQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:16:29 -0400
Message-ID: <4CA24CD9.8090202@oracle.com>
Date: Tue, 28 Sep 2010 13:15:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blkio-throttle: Fix linux-next compilation failure on
 i386
References: <20100928193446.GE8950@redhat.com>
In-Reply-To: <20100928193446.GE8950@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/10 12:34, Vivek Goyal wrote:
> Hi Jens,
> 
> One more fix for throttling logic. After this fix I realized that there is
> potential for integer overflow in my calculations. I need to figure out
> how to take care of these overflow situations and will post a patch for
> that later.
> 
> Thanks
> Vivek
> 
> o Randy Dunlap reported following linux-next failure. This patch fixes it.
> 
> on i386:
> 
> blk-throttle.c:(.text+0x1abb8): undefined reference to `__udivdi3'
> blk-throttle.c:(.text+0x1b1dc): undefined reference to `__udivdi3'
> 
> o bytes_per_second interface is 64bit and I was continuing to do 64 bit
>   division even on 32bit platform without help of special macros/functions
>   hence the failure.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  block/blk-throttle.c |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6-block/block/blk-throttle.c
> ===================================================================
> --- linux-2.6-block.orig/block/blk-throttle.c	2010-09-28 12:42:51.000000000 -0400
> +++ linux-2.6-block/block/blk-throttle.c	2010-09-28 14:16:05.000000000 -0400
> @@ -378,7 +378,8 @@ throtl_slice_used(struct throtl_data *td
>  static inline void
>  throtl_trim_slice(struct throtl_data *td, struct throtl_grp *tg, bool rw)
>  {
> -	unsigned long nr_slices, bytes_trim, time_elapsed, io_trim;
> +	unsigned long nr_slices, time_elapsed, io_trim;
> +	u64 bytes_trim, tmp;
>  
>  	BUG_ON(time_before(tg->slice_end[rw], tg->slice_start[rw]));
>  
> @@ -396,8 +397,10 @@ throtl_trim_slice(struct throtl_data *td
>  
>  	if (!nr_slices)
>  		return;
> +	tmp = tg->bps[rw] * throtl_slice * nr_slices;
> +	do_div(tmp, HZ);
> +	bytes_trim = tmp;
>  
> -	bytes_trim = (tg->bps[rw] * throtl_slice * nr_slices)/HZ;
>  	io_trim = (tg->iops[rw] * throtl_slice * nr_slices)/HZ;
>  
>  	if (!bytes_trim && !io_trim)
> @@ -415,7 +418,7 @@ throtl_trim_slice(struct throtl_data *td
>  
>  	tg->slice_start[rw] += nr_slices * throtl_slice;
>  
> -	throtl_log_tg(td, tg, "[%c] trim slice nr=%lu bytes=%lu io=%lu"
> +	throtl_log_tg(td, tg, "[%c] trim slice nr=%lu bytes=%llu io=%lu"
>  			" start=%lu end=%lu jiffies=%lu",
>  			rw == READ ? 'R' : 'W', nr_slices, bytes_trim, io_trim,
>  			tg->slice_start[rw], tg->slice_end[rw], jiffies);
> @@ -462,7 +465,7 @@ static bool tg_with_in_bps_limit(struct 
>  		struct bio *bio, unsigned long *wait)
>  {
>  	bool rw = bio_data_dir(bio);
> -	u64 bytes_allowed, extra_bytes;
> +	u64 bytes_allowed, extra_bytes, tmp;
>  	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
>  
>  	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
> @@ -473,8 +476,9 @@ static bool tg_with_in_bps_limit(struct 
>  
>  	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
>  
> -	bytes_allowed = (tg->bps[rw] * jiffies_to_msecs(jiffy_elapsed_rnd))
> -				/ MSEC_PER_SEC;
> +	tmp = tg->bps[rw] * jiffies_to_msecs(jiffy_elapsed_rnd);
> +	do_div(tmp, MSEC_PER_SEC);
> +	bytes_allowed = tmp;
>  
>  	if (tg->bytes_disp[rw] + bio->bi_size <= bytes_allowed) {
>  		if (wait)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
