Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1CHUyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:54:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532Ab1CHUyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:54:44 -0500
Date: Tue, 8 Mar 2011 15:54:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: lina <lulina_nuaa@foxmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: blk-throttle.c : When limit is changed, must start a new slice
Message-ID: <20110308205422.GI27455@redhat.com>
References: <tencent_6A5F95FF2112DFE963C44E4E@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_6A5F95FF2112DFE963C44E4E@qq.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 11:03:59PM +0800, lina wrote:

[..]
> >>  Unfortunately, the following patch still has 5~10 seconds latency. I have no
> >>  idea to resolve this problem, it seens hard to find a more suitable func to
> >>  call throtl_start_new_slice().
> >
> >So are you saying that following patch did not solve the latnecy issue?
> >Resetting slice upon limit change did not work for you?
> ></:includetail>
>  </:includetail> 
>  Yes, the following patch did not solve the latency issue. There is still 5~10</:includetail>
>  seconds latency when I change the limit from a very high value to low. From </:includetail>
>  blktrace, I find that the throtl_process_limit_change() is called after work </:includetail>
>  queue </:includetail>delay.</:includetail>
>  </:includetail> 
>  Thanks</:includetail>
>  Lina</:includetail>
>  </:includetail></:includetail> 
>  </:includetail>>Thanks

Ok,

Can you try the attached patch. I think what was happening that after
changing limits, work was not being scheduled as there were no queued
bios hence no slice reset was taking place immediately.

Also I am not sure from where these "</:includetail>" strings are coming.
Looks like your mailer is inserting those. Trying sending mails in text
format.

Thanks
Vivek

---
 block/blk-throttle.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

Index: linux-2.6/block/blk-throttle.c
===================================================================
--- linux-2.6.orig/block/blk-throttle.c	2011-03-04 13:59:45.000000000 -0500
+++ linux-2.6/block/blk-throttle.c	2011-03-08 15:41:19.384654732 -0500
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
@@ -825,7 +833,8 @@ throtl_schedule_delayed_work(struct thro
 
 	struct delayed_work *dwork = &td->throtl_work;
 
-	if (total_nr_queued(td) > 0) {
+	/* schedule work if limits changed even if no bio is queued */
+	if (total_nr_queued(td) > 0 || atomic_read(&td->limits_changed)) {
 		/*
 		 * We might have a work scheduled to be executed in future.
 		 * Cancel that and schedule a new one.
@@ -1023,6 +1032,19 @@ int blk_throtl_bio(struct request_queue 
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
 
