Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab1COOuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:50:54 -0400
Received: from smtpbg55.qq.com ([64.71.138.44]:55901 "HELO smtpbg55.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751412Ab1COOux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:50:53 -0400
X-QQ-mid: esmtp2t1300200570t446t05135
X-QQ-SSF: 00000000000000F0FF200F000000000
Date: Tue, 15 Mar 2011 23:00:25 +0800
From: "Lina Lu" <lulina_nuaa@foxmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <tencent_6A5F95FF2112DFE963C44E4E@qq.com>,
 <201103110038174067110@foxmail.com>,
 <201103121933025463003@foxmail.com>,
 <201103142352342813806@foxmail.com>
Subject: Re: Re: Re: blk-throttle.c : When limit is changed, must startanewslice
Message-ID: <201103152300242189340@foxmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-14 23:52:31, Vivek Goyal wrote:
>On Mon, Mar 14, 2011 at 11:52:36PM +0800, Lina Lu wrote:
>> On 2011-03-14 23:18:31, Vivek Goyal wrote:
>> >On Sat, Mar 12, 2011 at 07:33:07PM +0800, Lina Lu wrote:
>> >> On 2011-03-11 03:55:55, Vivek Goyal wrote:
>> >> >On Fri, Mar 11, 2011 at 12:38:18AM +0800, Lina Lu wrote:
>> >> >> [..]
>> >> >> Hi Vivek,
>> >> >> I have test the following patch, but the latency still there.
>> >> >> 
>> >> >> I try to find why there are 5~10 seconds latency today. After collect the blktrace, I 
>> >> >> think the reason is that throtl_trim_slice() don't aways update the tg->slice_start[rw], 
>> >> >> although we call it once dispatch a bio.
>> >> >
>> >> >lina,
>> >> >
>> >> >Trim slice should not even matter now. Upon limit change, this patch
>> >> >should reset the slice and start a new one irrespective of the fact
>> >> >where are.
>> >> >
>> >> >In your traces, do you see limit change message and do you see a new
>> >> >slice starting.
>> >> >
>> >> >I did similar test yesterday on my box and this patch worked. Can you
>> >> >capture some block traces and I can have a look at those. Key thing
>> >> >to look for is limit change message and whether it started a new
>> >> >slice or not.
>> >> >
>> >> >Thanks
>> >> >Vivek
>> >> >
>> >> 	
>> >> Hi Vivek,
>> >> 	
>> >> Here is the blktrace and iostat results when I change the limit from 1024000000000000
>> >> to 1024000. When the limit changed, there is about 3 seconds lantency.
>> >> 
>> >> blktrace:	
>> >> 253,1    0        0     4.177733270     0  m   N throtl / [R] trim slice nr=1 bytes=102400000000000 io=429496729 start=4297788991 end=4297789100 jiffies=4297788992
>> >> 253,1    0        0     4.187393582     0  m   N throtl / [R] extend slice start=4297788991 end=4297789200 jiffies=4297789002
>> >> 253,1    0        0     4.276120505     0  m   N throtl / [R] trim slice nr=1 bytes=102400000000000 io=429496729 start=4297789091 end=4297789200 jiffies=4297789091
>> >> 253,1    0        0     4.285934091     0  m   N throtl / [R] extend slice start=4297789091 end=4297789300 jiffies=4297789101
>> >> 253,1    1        0     4.348552814     0  m   N throtl schedule work. delay=0 jiffies=4297789163
>> >> 253,1    1        0     4.348571560     0  m   N throtl limit changed =1
>> >> 253,1    0        0     4.349839104     0  m   N throtl / [R] extend slice start=4297789091 end=4297793000 jiffies=4297789164
>> >> 253,1    0        0     4.349844118     0  m   N throtl / [R] bio. bdisp=3928064 sz=4096 bps=1024000 iodisp=959 iops=4294967295 queued=0/0
>> >
>> >Lina,
>> >
>> >Thanks for the traces.
>> >
>> >I think we did call process_limit_change() but we did not start the new
>> >slice. I guess this happened because, we seem to be starting slice only
>> >if group on run tree. Because before limit udpates, most likely group
>> >is not on run tree as limits are very high, hence we missed resetting
>> >the slice.
>> >
>> >        hlist_for_each_entry_safe(tg, pos, n, &td->tg_list, tg_node) {
>> >                if (throtl_tg_on_rr(tg) && tg->limits_changed) {
>> >                        throtl_log_tg(td, tg, "limit change rbps=%llu wbps=%llu"
>> >                                " riops=%u wiops=%u", tg->bps[READ],
>> >                                tg->bps[WRITE], tg->iops[READ],
>> >                                tg->iops[WRITE]);
>> >
>> 	
>> Do you mean that throtl_tg_on_rr() function returns 0 when the limits are very
>> high?
>
>Yes. When limits are very high, you will never enqueue a bio hence a 
>group will never be enqueued hence throtl_tg_on_rr=0.
>
>> 	
>> >Actually many races have been fixed in Jens's block tree. Is it possible to
>> >test origin/for-2.6.39/core branch of Jens's tree with following patch applied
>> >and see if it fixes the issue for you?
>> 
>> I only find 2.6.38 core in gitweb. Do you mean origin/for-2.6.38/core branch? 
>> I'll test it as soon as possible and keep you know the result.
>
>Here is Jens's block tree. It is separate from linus's tree.
>
>http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=summary
>
>Thanks
>Vivek
>
Hi Vivek,
I have test the following patch on 2.6.39 core branch of Jens's tree, the bug has
been fixed. 

Can you tell me which patch makes the throtl_tg_on_rr() return 1 even if the limits
are very high?

Thanks
Lina
	
>> 
>> >Thanks
>> >Vivek
>> >
>> >---
>> > block/blk-throttle.c |   25 ++++++++++++++++++++++++-
>> > 1 file changed, 24 insertions(+), 1 deletion(-)
>> >
>> >Index: linux-2.6-block/block/blk-throttle.c
>> >===================================================================
>> >--- linux-2.6-block.orig/block/blk-throttle.c	2011-03-14 10:27:57.000000000 -0400
>> >+++ linux-2.6-block/block/blk-throttle.c	2011-03-14 10:30:47.267170956 -0400
>> >@@ -756,6 +756,15 @@ static void throtl_process_limit_change(
>> > 			" riops=%u wiops=%u", tg->bps[READ], tg->bps[WRITE],
>> > 			tg->iops[READ], tg->iops[WRITE]);
>> > 
>> >+		/*
>> >+		 * Restart the slices for both READ and WRITES. It
>> >+		 * might happen that a group's limit are dropped
>> >+		 * suddenly and we don't want to account recently
>> >+		 * dispatched IO with new low rate
>> >+		 */
>> >+		throtl_start_new_slice(td, tg, 0);
>> >+		throtl_start_new_slice(td, tg, 1);
>> >+
>> > 		if (throtl_tg_on_rr(tg))
>> > 			tg_update_disptime(td, tg);
>> > 	}
>> >@@ -821,7 +830,8 @@ throtl_schedule_delayed_work(struct thro
>> > 
>> > 	struct delayed_work *dwork = &td->throtl_work;
>> > 
>> >-	if (total_nr_queued(td) > 0) {
>> >+	/* schedule work if limits changed even if no bio is queued */
>> >+	if (total_nr_queued(td) > 0 || td->limits_changed) {
>> > 		/*
>> > 		 * We might have a work scheduled to be executed in future.
>> > 		 * Cancel that and schedule a new one.
>> >@@ -1002,6 +1012,19 @@ int blk_throtl_bio(struct request_queue 
>> > 	/* Bio is with-in rate limit of group */
>> > 	if (tg_may_dispatch(td, tg, bio, NULL)) {
>> > 		throtl_charge_bio(tg, bio);
>> >+
>> >+		/*
>> >+		 * We need to trim slice even when bios are not being queued
>> >+		 * otherwise it might happen that a bio is not queued for
>> >+		 * a long time and slice keeps on extending and trim is not
>> >+		 * called for a long time. Now if limits are reduced suddenly
>> >+		 * we take into account all the IO dispatched so far at new
>> >+		 * low rate and * newly queued IO gets a really long dispatch
>> >+		 * time.
>> >+		 *
>> >+		 * So keep on trimming slice even if bio is not queued.
>> >+		 */
>> >+		throtl_trim_slice(td, tg, rw);
>> > 		goto out;
>> > 	}
0
