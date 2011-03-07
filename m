Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1CGQH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 11:07:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab1CGQH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 11:07:26 -0500
Date: Mon, 7 Mar 2011 11:07:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: lina <lulina_nuaa@foxmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: blk-throttle.c : When limit is changed, must start a new slice
Message-ID: <20110307160704.GG9540@redhat.com>
References: <tencent_1FCD09C260CD8FFB3D3886AD@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_1FCD09C260CD8FFB3D3886AD@qq.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:05:49PM +0800, lina wrote:
> >On Sat, Mar 05, 2011 at 12:30:55AM +0800, lina wrote:
> >> Hi Vivek,    
> >>      Take you a litter time to read this letter, I think there seens  to 
> >>  be a small bug in blk-throttle.c.
> >>      This might happen that initially cgroup limit was greater than the 
> >>  device's physic ability, but later limit was under physic ability. In this
> >>  case, all of the bio in the device was throttled for serveral minutes. 
> >>   
> >>      I did some analysis as the following:
> >>      First, setting a very large bps on device lead all of the bio go
> >>  through. The slice is begin when test begin, and only extend but 
> >>  can not start new one. 
> >>      Second, change the limit under physic ability to make one bio 
> >>  queued. Once one bio queued, blk_throtl_bio func will call 
> >>  tg_update_disptime to estimate the delay time for the throtl_work.
> >>      As the slice is very old, there is a very large value in 
> >>  tg->bytes_disp[rw], and the tg->disptime is a long time after jiffies. 
> >>  During this time, all of the bio is queued. And the work_queue can 
> >>  not start, so tg->slice_start[rw] still can not be reset.
> >>   
> >>      Although after serveral minutes everything will be ok, but it still
> >>  seens no-good for users.
> >>      
> >>      I think it should start a new slice when the limit is changed. 
> >>      Here is my patch, please conrrect it if there is something wrong
> >>  follow.</:includetail>
>  >
> >
> >CCing to lkml. Lets keep all the testing and bug reports regarding
> >blkio throttling on mailing list.
> >
> >thanks for the bug report lina. I think this is a bug. I am not too keen
> >on restarting slice all the time upon limit change as somebody can exploit
> >that to get higher BW by doing it frequently. Can you try attached patch
> >and see if it solves your problem.
> </:includetail></:includetail>
>  Thank you for this patch, it can solve the problem. But there still has 5~10</:includetail>
>  seconds 0 bps in the test. I think this is because we first tirm the end of </:includetail>
>  slice, then new one, there is some latency. Do you have any idea to let </:includetail>the </:includetail>
>  limit change work immediately or make less latency(maybe 1 or 2 seconds)?</:includetail>
>  </:includetail> 

Ok, if you are concerned about those few seconds, can you please try
following patch. I think starting a new slice is better when processing
limit change instead of in blk_throtl_bio().

Thanks
Vivek


---
 block/blk-throttle.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6/block/blk-throttle.c
===================================================================
--- linux-2.6.orig/block/blk-throttle.c	2011-03-04 13:59:45.000000000 -0500
+++ linux-2.6/block/blk-throttle.c	2011-03-07 10:54:30.639467538 -0500
@@ -757,6 +757,14 @@ static void throtl_process_limit_change(
 				" riops=%u wiops=%u", tg->bps[READ],
 				tg->bps[WRITE], tg->iops[READ],
 				tg->iops[WRITE]);
+			/*
+			 * Restart the slices for both READ and WRITES. It
+			 * might happen that a group's limit are dropped
+			 * suddenly and we don't want to account recently
+			 * dispatched IO with new low rate
+			 */
+			throtl_start_new_slice(td, tg, 0);
+			throtl_start_new_slice(td, tg, 1);
 			tg_update_disptime(td, tg);
 			tg->limits_changed = false;
 		}
@@ -1023,6 +1031,19 @@ int blk_throtl_bio(struct request_queue 
 	/* Bio is with-in rate limit of group */
 	if (tg_may_dispatch(td, tg, bio, NULL)) {
 		throtl_charge_bio(tg, bio);
+
+		/*
+		 * We need to trim slice even when bios are not being queued
+		 * otherwise it might happen that a bio is not queued for
+		 * a long time and slice keeps on extending and trim is not
+		 * called for a long time. Now if limits are reduced suddenly
+		 * we take into account all the IO dispatched so far at new
+		 * low rate and * newly queued IO gets a really long dispatch
+		 * time.
+		 *
+		 * So keep on trimming slice even if bio is not queued.
+		 */
+		throtl_trim_slice(td, tg, rw);
 		goto out;
 	}
 
