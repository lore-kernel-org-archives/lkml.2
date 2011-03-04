Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978Ab1CDTaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:30:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab1CDTa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:30:28 -0500
Date: Fri, 4 Mar 2011 14:30:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: lina <lulina_nuaa@foxmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: blk-throttle.c : When limit is changed, must start a new slice
Message-ID: <20110304193006.GF5466@redhat.com>
References: <tencent_323C67E7636EA7895ACB367F@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_323C67E7636EA7895ACB367F@qq.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 05, 2011 at 12:30:55AM +0800, lina wrote:
> Hi Vivek,    
>      Take you a litter time to read this letter, I think there seens  to 
>  be a small bug in blk-throttle.c.
>      This might happen that initially cgroup limit was greater than the 
>  device's physic ability, but later limit was under physic ability. In this
>  case, all of the bio in the device was throttled for serveral minutes. 
>   
>      I did some analysis as the following:
>      First, setting a very large bps on device lead all of the bio go
>  through. The slice is begin when test begin, and only extend but 
>  can not start new one. 
>      Second, change the limit under physic ability to make one bio 
>  queued. Once one bio queued, blk_throtl_bio func will call 
>  tg_update_disptime to estimate the delay time for the throtl_work.
>      As the slice is very old, there is a very large value in 
>  tg->bytes_disp[rw], and the tg->disptime is a long time after jiffies. 
>  During this time, all of the bio is queued. And the work_queue can 
>  not start, so tg->slice_start[rw] still can not be reset.
>   
>      Although after serveral minutes everything will be ok, but it still
>  seens no-good for users.
>      
>      I think it should start a new slice when the limit is changed. 
>      Here is my patch, please conrrect it if there is something wrong
>  follow.

CCing to lkml. Lets keep all the testing and bug reports regarding
blkio throttling on mailing list.

thanks for the bug report lina. I think this is a bug. I am not too keen
on restarting slice all the time upon limit change as somebody can exploit
that to get higher BW by doing it frequently. Can you try attached patch
and see if it solves your problem.

>   
>  --- block/blk-throttle.c
>  +++ block/blk-throttle.c
>  @@ -1027,6 +1027,9 @@
>           *biop = NULL;  
>           if (update_disptime) {
>  +                 if (tg->limits_changed)
>  +                 {
>  +                         throtl_start_new_slice(td, tg, rw);
>  +                 }
>                   tg_update_disptime(td, tg);
>                   throtl_schedule_next_dispatch(td);
>           }
>   
>   
>       There is two other problems, can you explain them to me? 
>   
>  First：
>       The blkio dir always like 
>   
>       blkio //patent dir
>         ---blkio.weight
>         ---blkio.throtl_write_bps_device
>         ...
>         ---tst1  //child dir
>               ---blkio.weight              ---blkio.throtl_write_bps_device
>               ...
>   
>       The child dir's throtl files like tst1/blkio.throttl_write_bps_device 
>  seens never be use. It maybe better that do not create these files.
>  If they are useful, please tell me. Thank you!

Throttle creates a flag hierarchy of groups internally. So even if you
create child of a child group, child will be treated as if children 
of root and will be throttled as per throttling rules.
>   
>  Second:
>       When apply weight policy to some pid, I must mkdir tst1 like 
>  above. If all of pid in tst1 is end, the pid in tasks will disappear, but
>  the tst1 dir is still here. I think here will be better if tst1 can be 
>  removed automatically. 
>       Throttle policy has no auto-clean capacity. If I create many 
>  linear dm devices, and apply throttle policy on them, then use 
>  'dmsetup remove--all'. Now I must clean the entries one by one in blkio.throtl_write_bps_device manually. If the throttle policy can 
>  clean the entry automatically when the device is no longger in the 
>  system, It seens to be perfect!

i think it is hard to remove rules also when devie is going away. One
easy way is to remove whole cgroup. Other would be that provide a 
simple command to delete all the rules from a file. 

say echo "0" > blkio.throttle.read_bps_device will remove all the rules
from the file. If that helps you, you can write one patch for that.

Thanks
Vivek

---
 block/blk-throttle.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6/block/blk-throttle.c
===================================================================
--- linux-2.6.orig/block/blk-throttle.c	2011-03-04 13:59:45.000000000 -0500
+++ linux-2.6/block/blk-throttle.c	2011-03-04 14:05:31.542332242 -0500
@@ -1023,6 +1023,19 @@ int blk_throtl_bio(struct request_queue 
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
 

