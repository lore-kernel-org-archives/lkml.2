Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1CLLX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 06:23:56 -0500
Received: from smtpbg52.qq.com ([64.71.138.43]:34363 "HELO smtpbg52.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753384Ab1CLLXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 06:23:52 -0500
X-QQ-mid: esmtp4t1299928941t527t23920
X-QQ-SSF: 00000000000000F0F8200F000000000
Date: Sat, 12 Mar 2011 19:33:07 +0800
From: "Lina Lu" <lulina_nuaa@foxmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <tencent_6A5F95FF2112DFE963C44E4E@qq.com>,
 <201103110038174067110@foxmail.com>
Subject: Re: Re: Re: blk-throttle.c : When limit is changed, must start a newslice
Message-ID: <201103121933025463003@foxmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-11 03:55:55, Vivek Goyal wrote:
>On Fri, Mar 11, 2011 at 12:38:18AM +0800, Lina Lu wrote:
>> [..]
>> Hi Vivek,
>> I have test the following patch, but the latency still there.
>> 
>> I try to find why there are 5~10 seconds latency today. After collect the blktrace, I 
>> think the reason is that throtl_trim_slice() don't aways update the tg->slice_start[rw], 
>> although we call it once dispatch a bio.
>
>lina,
>
>Trim slice should not even matter now. Upon limit change, this patch
>should reset the slice and start a new one irrespective of the fact
>where are.
>
>In your traces, do you see limit change message and do you see a new
>slice starting.
>
>I did similar test yesterday on my box and this patch worked. Can you
>capture some block traces and I can have a look at those. Key thing
>to look for is limit change message and whether it started a new
>slice or not.
>
>Thanks
>Vivek
>
	
Hi Vivek,
	
Here is the blktrace and iostat results when I change the limit from 1024000000000000
to 1024000. When the limit changed, there is about 3 seconds lantency.

blktrace:	
253,1    0        0     4.177733270     0  m   N throtl / [R] trim slice nr=1 bytes=102400000000000 io=429496729 start=4297788991 end=4297789100 jiffies=4297788992
253,1    0        0     4.187393582     0  m   N throtl / [R] extend slice start=4297788991 end=4297789200 jiffies=4297789002
253,1    0        0     4.276120505     0  m   N throtl / [R] trim slice nr=1 bytes=102400000000000 io=429496729 start=4297789091 end=4297789200 jiffies=4297789091
253,1    0        0     4.285934091     0  m   N throtl / [R] extend slice start=4297789091 end=4297789300 jiffies=4297789101
253,1    1        0     4.348552814     0  m   N throtl schedule work. delay=0 jiffies=4297789163
253,1    1        0     4.348571560     0  m   N throtl limit changed =1
253,1    0        0     4.349839104     0  m   N throtl / [R] extend slice start=4297789091 end=4297793000 jiffies=4297789164
253,1    0        0     4.349844118     0  m   N throtl / [R] bio. bdisp=3928064 sz=4096 bps=1024000 iodisp=959 iops=4294967295 queued=0/0
253,1    0        0     4.349850121     0  m   N throtl schedule work. delay=3767 jiffies=4297789164
253,1    0        0     4.349912607     0  m   N throtl / [R] bio. bdisp=3928064 sz=4096 bps=1024000 iodisp=959 iops=4294967295 queued=1/0
253,1    0        0     4.349915880     0  m   N throtl schedule work. delay=3766 jiffies=4297789165
253,1    0        0     4.349921567     0  m   N throtl / [R] bio. bdisp=3928064 sz=4096 bps=1024000 iodisp=959 iops=4294967295 queued=2/0
...            #queued 63 read bios with no new slice.
253,1    0        0     4.353728869     0  m   N throtl / [R] bio. bdisp=3928064 sz=4096 bps=1024000 iodisp=959 iops=4294967295 queued=61/0
253,1    0        0     4.353731799     0  m   N throtl / [R] bio. bdisp=3928064 sz=4096 bps=1024000 iodisp=959 iops=4294967295 queued=62/0
253,1    0        0     4.353735427     0  m   N throtl / [R] bio. bdisp=3928064 sz=4096 bps=1024000 iodisp=959 iops=4294967295 queued=63/0
253,1    0        0     8.129092326     0  m   N throtl dispatch nr_queued=64 read=64 write=0
253,1    0        0     8.129096924     0  m   N throtl / [R] extend slice start=4297789091 end=4297793100 jiffies=4297792944
253,1    0        0     8.129100584     0  m   N throtl / [R] trim slice nr=38 bytes=3891200 io=16320875721 start=4297792891 end=4297793100 jiffies=4297792944
253,1    0        0     8.129108331     0  m   N throtl bios disp=16
253,1    0        0     8.129111864     0  m   N throtl schedule work. delay=51 jiffies=4297792944
253,1    0        0     8.180899035     0  m   N throtl dispatch nr_queued=48 read=48 write=0
253,1    0        0     8.180905222     0  m   N throtl / [R] trim slice nr=1 bytes=102400 io=429496729 start=4297792991 end=4297793100 jiffies=4297792996
253,1    0        0     8.180915206     0  m   N throtl bios disp=25
253,1    0        0     8.180919011     0  m   N throtl schedule work. delay=99 jiffies=4297792996
253,1    0        0     8.182058927     0  m   N throtl / [R] bio. bdisp=102400 sz=4096 bps=1024000 iodisp=24 iops=4294967295 queued=23/0

iostat:
Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
dm-1              0.00     0.00 12992.00    0.00    50.75     0.00     8.00    59.47    4.57   0.08  99.70
dm-1              0.00     0.00 12598.00    0.00    49.21     0.00     8.00    59.03    4.70   0.08  99.70
dm-1              0.00     0.00 12923.00    0.00    50.48     0.00     8.00    54.43    4.22   0.08  98.50
dm-1              0.00     0.00 13103.00    0.00    51.18     0.00     8.00    57.54    4.38   0.08  99.70
dm-1              0.00     0.00 13024.00    0.00    50.88     0.00     8.00    58.67    4.51   0.08  99.70
dm-1              0.00     0.00 12928.00    0.00    50.50     0.00     8.00    58.50    4.53   0.08  99.60
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00   66.00    0.00     0.26     0.00     8.00     0.05    0.76   0.03   0.20
dm-1              0.00     0.00  250.00    0.00     0.98     0.00     8.00     0.24    0.98   0.04   1.00

>From the trace we can find 3766 delay(3766/HZ~3.7 seconds), the greater delay value, the
longer latency. Sometimes, the delay is low, so the latency does not appear everytime when I
change limit from high to low.
	
And the latency seens relate to the device's physic capacity.
Here my device has only 50MB/s physic capacity, so there is about 3~5 seconds latency.
If the device has 100MB/s physic capacity, the lantcy will be 5~10 seconds latency. 

There is no new slice trace because the throtl_process_limit_change() is not been called. 
throtl_process_limit_change() function is called only in throtl_dispatch(), and throtl_dispatch()
is called only in blk_throtl_work(). When the limit change from high to low, there is no work
queue, so blk_throtl_work() is never called.

When the limit change from low to high, I find the new slice trace like following. So it only new
slice when there is work queue.

253,1    0        0    60.250888001     0  m   N throtl / [R] bio. bdisp=102400 sz=4096 bps=1024000 iodisp=24 iops=4294967295 queued=49/0
253,1    0        0    60.250890858     0  m   N throtl / [R] bio. bdisp=102400 sz=4096 bps=1024000 iodisp=24 iops=4294967295 queued=50/0
253,1    0        0    60.349455559     0  m   N throtl dispatch nr_queued=51 read=51 write=0
253,1    0        0    60.349460882     0  m   N throtl / [R] extend slice start=4297998658 end=4297998900 jiffies=4297998762
253,1    0        0    60.349464810     0  m   N throtl / [R] trim slice nr=1 bytes=102400 io=429496729 start=4297998758 end=4297998900 jiffies=4297998762
253,1    0        0    60.349473330     0  m   N throtl bios disp=25
253,1    0        0    60.349476631     0  m   N throtl schedule work. delay=100 jiffies=4297998762
253,1    1        0    60.375043834     0  m   N throtl schedule work. delay=0 jiffies=4297998787
253,1    1        0    60.375062998     0  m   N throtl limit changed =1
253,1    1        0    60.375066704     0  m   N throtl / limit change rbps=1024000000000000 wbps=18446744073709551615 riops=4294967295 wiops=4294967295
253,1    1        0    60.375069747     0  m   N throtl / [R] new slice start=4297998787 end=4297998887 jiffies=4297998787
253,1    1        0    60.375070919     0  m   N throtl / [W] new slice start=4297998787 end=4297998887 jiffies=4297998787
253,1    1        0    60.375073946     0  m   N throtl dispatch nr_queued=26 read=26 write=0
253,1    1        0    60.375083440     0  m   N throtl bios disp=26
253,1    1        0    60.430614460     0  m   N throtl / [R] extend slice start=4297998787 end=4297999000 jiffies=4297998843
253,1    1        0    60.476022578     0  m   N throtl / [R] trim slice nr=1 bytes=102400000000000 io=429496729 start=4297998887 end=4297999000 jiffies=4297998888

Thanks
Lina                            
  	
>> 
>> Suppose that if the limits change now from 102400000000 to 1024000, the 
>> tg->slice_start[rw] and tg->slice_end[rw] just like in the following chart. There is two 
>> throtl_slice in the chart. Here my HZ is 250, so the throtl_slice is 25.
>> 
>>                   jiffies
>>                   |
>>    |------------------|------------------|
>>    |                         |
>> start                    end
>> 
>> As the jiffies - start < 25(throtl_slice), throtl_trim_slice() will not update the 
>> tg->slice_start[rw] and tg->bytes_disp[rw]. If the tg->bytes_disp[rw] now is 8M, then
>> there will be about 7 seconds from jiffies 0 bps as I have set the limits at 1M/s, in 
>> these seconds no bio can be dispatched.
>> 
>> As the tg->slice_start[rw] must less than or equal to jiffies, and we can not know the 
>> reason of tg->bytes_disp[rw] > the theoretical value with limits 1M/s, So can not just 
>> set the tg->slice_start[rw] to jiffies here. If set the start to jiffies, throtl will not work.
>> 
>> I think if we can start a new slice in the next throtl_slice when the limits changed from 
>> high to low and the tg->bytes_disp[rw] is critical greater than the theoretical value with
>> now limits, this problem can be solved.
>> 
>> Thanks
>> Lina
>> 
>> >---
>> > block/blk-throttle.c |   24 +++++++++++++++++++++++-
>> > 1 file changed, 23 insertions(+), 1 deletion(-)
>> >
>> >Index: linux-2.6/block/blk-throttle.c
>> >===================================================================
>> >--- linux-2.6.orig/block/blk-throttle.c	2011-03-04 13:59:45.000000000 -0500
>> >+++ linux-2.6/block/blk-throttle.c	2011-03-08 15:41:19.384654732 -0500
>> >@@ -757,6 +757,14 @@ static void throtl_process_limit_change(
>> > 				" riops=%u wiops=%u", tg->bps[READ],
>> > 				tg->bps[WRITE], tg->iops[READ],
>> > 				tg->iops[WRITE]);
>> >+			/*
>> >+			 * Restart the slices for both READ and WRITES. It
>> >+			 * might happen that a group's limit are dropped
>> >+			 * suddenly and we don't want to account recently
>> >+			 * dispatched IO with new low rate
>> >+			 */
>> >+			throtl_start_new_slice(td, tg, 0);
>> >+			throtl_start_new_slice(td, tg, 1);
>> > 			tg_update_disptime(td, tg);
>> > 			tg->limits_changed = false;
>> > 		}
>> >@@ -825,7 +833,8 @@ throtl_schedule_delayed_work(struct thro
>> > 
>> > 	struct delayed_work *dwork = &td->throtl_work;
>> > 
>> >-	if (total_nr_queued(td) > 0) {
>> >+	/* schedule work if limits changed even if no bio is queued */
>> >+	if (total_nr_queued(td) > 0 || atomic_read(&td->limits_changed)) {
>> > 		/*
>> > 		 * We might have a work scheduled to be executed in future.
>> > 		 * Cancel that and schedule a new one.
>> >@@ -1023,6 +1032,19 @@ int blk_throtl_bio(struct request_queue 
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
>>  
>> 
 
