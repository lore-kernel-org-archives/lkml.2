Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1CJTz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:55:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab1CJTz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:55:58 -0500
Date: Thu, 10 Mar 2011 14:55:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Lina Lu <lulina_nuaa@foxmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Re: blk-throttle.c : When limit is changed, must start a new
 slice
Message-ID: <20110310195520.GJ29464@redhat.com>
References: <tencent_6A5F95FF2112DFE963C44E4E@qq.com>
 <201103110038174067110@foxmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103110038174067110@foxmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 12:38:18AM +0800, Lina Lu wrote:
> On 2011-03-09 04:54:43, Vivek Goyal wrote:
> >
> >On Tue, Mar 08, 2011 at 11:03:59PM +0800, lina wrote:
> 
> >[..]
> >> >>  Unfortunately, the following patch still has 5~10 seconds latency. I have no
> >> >>  idea to resolve this problem, it seens hard to find a more suitable func to
> >> >>  call throtl_start_new_slice().
> >> >
> >> >So are you saying that following patch did not solve the latnecy issue?
> >> >Resetting slice upon limit change did not work for you?
> >> >
> >>   
> >>  Yes, the following patch did not solve the latency issue. There is still 5~10
> >>  seconds latency when I change the limit from a very high value to low. From
> >>  blktrace, I find that the throtl_process_limit_change() is called after work 
> >>  queue delay.
> >>   
> >>  Thanks
> >>  Lina
> >
> >Ok,
> >
> >Can you try the attached patch. I think what was happening that after
> >changing limits, work was not being scheduled as there were no queued
> >bios hence no slice reset was taking place immediately.
> >
> >[..]
> >
> >Thanks
> >Vivek
> >
> 
> Hi Vivek,
> I have test the following patch, but the latency still there.
> 
> I try to find why there are 5~10 seconds latency today. After collect the blktrace, I 
> think the reason is that throtl_trim_slice() don't aways update the tg->slice_start[rw], 
> although we call it once dispatch a bio.

lina,

Trim slice should not even matter now. Upon limit change, this patch
should reset the slice and start a new one irrespective of the fact
where are.

In your traces, do you see limit change message and do you see a new
slice starting.

I did similar test yesterday on my box and this patch worked. Can you
capture some block traces and I can have a look at those. Key thing
to look for is limit change message and whether it started a new
slice or not.

Thanks
Vivek

> 
> Suppose that if the limits change now from 102400000000 to 1024000, the 
> tg->slice_start[rw] and tg->slice_end[rw] just like in the following chart. There is two 
> throtl_slice in the chart. Here my HZ is 250, so the throtl_slice is 25.
> 
>                   jiffies
>                   |
>    |------------------|------------------|
>    |                         |
> start                    end
> 
> As the jiffies - start < 25(throtl_slice), throtl_trim_slice() will not update the 
> tg->slice_start[rw] and tg->bytes_disp[rw]. If the tg->bytes_disp[rw] now is 8M, then
> there will be about 7 seconds from jiffies 0 bps as I have set the limits at 1M/s, in 
> these seconds no bio can be dispatched.
> 
> As the tg->slice_start[rw] must less than or equal to jiffies, and we can not know the 
> reason of tg->bytes_disp[rw] > the theoretical value with limits 1M/s, So can not just 
> set the tg->slice_start[rw] to jiffies here. If set the start to jiffies, throtl will not work.
> 
> I think if we can start a new slice in the next throtl_slice when the limits changed from 
> high to low and the tg->bytes_disp[rw] is critical greater than the theoretical value with
> now limits, this problem can be solved.
> 
> Thanks
> Lina
> 
> >---
> > block/blk-throttle.c |   24 +++++++++++++++++++++++-
> > 1 file changed, 23 insertions(+), 1 deletion(-)
> >
> >Index: linux-2.6/block/blk-throttle.c
> >===================================================================
> >--- linux-2.6.orig/block/blk-throttle.c	2011-03-04 13:59:45.000000000 -0500
> >+++ linux-2.6/block/blk-throttle.c	2011-03-08 15:41:19.384654732 -0500
> >@@ -757,6 +757,14 @@ static void throtl_process_limit_change(
> > 				" riops=%u wiops=%u", tg->bps[READ],
> > 				tg->bps[WRITE], tg->iops[READ],
> > 				tg->iops[WRITE]);
> >+			/*
> >+			 * Restart the slices for both READ and WRITES. It
> >+			 * might happen that a group's limit are dropped
> >+			 * suddenly and we don't want to account recently
> >+			 * dispatched IO with new low rate
> >+			 */
> >+			throtl_start_new_slice(td, tg, 0);
> >+			throtl_start_new_slice(td, tg, 1);
> > 			tg_update_disptime(td, tg);
> > 			tg->limits_changed = false;
> > 		}
> >@@ -825,7 +833,8 @@ throtl_schedule_delayed_work(struct thro
> > 
> > 	struct delayed_work *dwork = &td->throtl_work;
> > 
> >-	if (total_nr_queued(td) > 0) {
> >+	/* schedule work if limits changed even if no bio is queued */
> >+	if (total_nr_queued(td) > 0 || atomic_read(&td->limits_changed)) {
> > 		/*
> > 		 * We might have a work scheduled to be executed in future.
> > 		 * Cancel that and schedule a new one.
> >@@ -1023,6 +1032,19 @@ int blk_throtl_bio(struct request_queue 
> > 	/* Bio is with-in rate limit of group */
> > 	if (tg_may_dispatch(td, tg, bio, NULL)) {
> > 		throtl_charge_bio(tg, bio);
> >+
> >+		/*
> >+		 * We need to trim slice even when bios are not being queued
> >+		 * otherwise it might happen that a bio is not queued for
> >+		 * a long time and slice keeps on extending and trim is not
> >+		 * called for a long time. Now if limits are reduced suddenly
> >+		 * we take into account all the IO dispatched so far at new
> >+		 * low rate and * newly queued IO gets a really long dispatch
> >+		 * time.
> >+		 *
> >+		 * So keep on trimming slice even if bio is not queued.
> >+		 */
> >+		throtl_trim_slice(td, tg, rw);
> > 		goto out;
> > 	}
>  
> 
