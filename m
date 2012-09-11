Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2IKFDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 01:03:33 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56451 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2IKFDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 01:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120911014025.GA22077@localhost>
References: <1346083274-3510-1-git-send-email-linkinjeon@gmail.com>
	<20120911014025.GA22077@localhost>
Date: Tue, 11 Sep 2012 14:03:30 +0900
Message-ID: <CAKYAXd_VucTrf=TeezrU28+Ja+41TAFCY3zfuBGvoMO9FXNB1A@mail.gmail.com>
Subject: Re: [PATCH 1/2] writeback: add dirty_background_time per bdi variable
From: Namjae Jeon <linkinjeon@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/11, Fengguang Wu <fengguang.wu@intel.com>:
> Hi Namjae,
Hi. Wu.
>
> On Mon, Aug 27, 2012 at 12:01:14PM -0400, Namjae Jeon wrote:
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>>
>> This patch is based on suggestion by Wu Fengguang:
>> https://lkml.org/lkml/2011/8/19/19
>>
>> kernel has mechanism to do writeback as per dirty_ratio and
>> dirty_background
>> ratio. It also maintains per task dirty rate limit to keep balance of
>> dirty pages at any given instance by doing bdi bandwidth estimation.
>>
>> Kernel also has max_ratio/min_ratio tunables to specify percentage of
>> writecache
>> to control per bdi dirty limits and task throttling.
>>
>> However, there might be a usecase where user wants a writeback tuning
>> parameter to flush dirty data at desired/tuned time interval especially
>> at NFS server.
>
> The dirty_background_time introduced by this patch is not an
> 'interval' thing, but a threshold to start background writeback.
Agreed. I will update the description.

>
>> dirty_background_time provides an interface where user can tune
>> background
>> writeback start time using /sys/block/sda/bdi/dirty_background_time
>
> It's me that come up with the name "dirty_background_time". However
> it may confuse users what's the exact unit for "time". In this regard,
> it looks better to follow the established examples of
> "dirty_expire_centisecs"/"dirty_writeback_centisecs"?
Ok. I will change dirty_background_time -> dirty_background_centisecs
and change variable logic to work in centisecs.

>
>> dirty_background_time is used alongwith average bdi write bandwidth
>> estimation
>> to start background writeback.
>>
>> One of the use case to demonstrate the patch functionality can be
>> on NFS setup:-
>> We have a NFS setup with ethernet line of 100Mbps, while the USB
>> disk is attached to server, which has a local speed of 25MBps. Server
>> and client both are arm target boards.
>>
>> Now if we perform a write operation over NFS (client to server), as
>> per the network speed, data can travel at max speed of 100Mbps. But
>> if we check the default write speed of USB hdd over NFS it comes
>> around to 8MB/sec, far below the speed of network.
>>
>> Reason being is as per the NFS logic, during write operation, initially
>> pages are dirtied on NFS client side, then after reaching the dirty
>> threshold/writeback limit (or in case of sync) data is actually sent
>> to NFS server (so now again pages are dirtied on server side). This
>> will be done in COMMIT call from client to server i.e if 100MB of data
>> is dirtied and sent then it will take minimum 100MB/10Mbps ~ 8-9 seconds.
>
> To be exact, there are two steps:
>
> - WRITE to send data from client to server
> - COMMIT to sync data from server memory to disk
>
> The nfs clients have logics to optimize away too frequent COMMITs.
> However in the case of continuous writing, the data are effectively
> COMMITed pretty soon after being WRITE to server memory. So
> "threshold" can keep the flusher more reliably busy than "interval".
>
> It's better for the flusher to do the background writes because they
> are ASYNC IO, which generally performs better than SYNC COMMIT IO.
>
> As for latency, there will be IO competitions between the flusher and
> nfsd which may impact some COMMITs' latency and improve some other
> COMMITs (because they'll do less SYNC IO).
Right! I will update this description also.
>
>> After the data is received, now it will take approx 100/25 ~4 Seconds to
>> write the data to USB Hdd on server side. Hence making the overall time
>> to write this much of data ~12 seconds, which in practically comes out to
>> be near 7 to 8MB/second. After this a COMMIT response will be sent to NFS
>> client.
>>
>> However we may improve this write performace by making the use of NFS
>> server idle time i.e while data is being received from the client,
>> simultaneously initiate the writeback thread on server side. So instead
>> of waiting for the complete data to come and then start the writeback,
>> we can work in parallel while the network is still busy in receiving the
>> data. Hence in this way overall performace will be improved.
>
> To be frank, no realistic NFS servers will use USB disk as backing
> storage. So that rational for reducing "initial" delays is weak.
> Continuous write performance to HDD is much more important. Do you
> have numbers for that?

Actually, we use USB HDD and USB Flash devices at NFS server.
There can be other similar users as well. So it might be useful to
provide this tuning feature other.
As default value is zero, it is disabled by default and it should not
impact normal writeback.

I will share large file writes test result on NFS client on USB HDD
with/without tuning with patch.

>
>> If we tune dirty_background_time, we can see there
>> is increase in the performace and it comes out to be ~ 11MB/seconds.
>> Results are:-
>> ==========================================================
>> Case:1 - Normal setup without any changes
>> ./performancetest_arm ./100MB write
>>
>>  RecSize  WriteSpeed   RanWriteSpeed
>>
>>  10485760  7.93MB/sec   8.11MB/sec
>>   1048576  8.21MB/sec   7.80MB/sec
>>    524288  8.71MB/sec   8.39MB/sec
>>    262144  8.91MB/sec   7.83MB/sec
>>    131072  8.91MB/sec   8.95MB/sec
>>     65536  8.95MB/sec   8.90MB/sec
>>     32768  8.76MB/sec   8.93MB/sec
>>     16384  8.78MB/sec   8.67MB/sec
>>      8192  8.90MB/sec   8.52MB/sec
>>      4096  8.89MB/sec   8.28MB/sec
>>
>> Average speed is near 8MB/seconds.
>>
>> Case:2 - Modified /sys/block/sda/bdi/dirty_background_time
>
> What's the exact threshold used? 1s?
Yes. We recommend to use it as 1 sec i.e. start writeback once dirty
threashold reach bdi bandwidth at NFS Server.
As you know initial bandwidth is incorrect(default value 100 MB/sec),
we have taken this result after some I/O work load on NFS Server.

>
>>          on *** NFS Server only - not on NFS Client****
>> ./performancetest_arm ./100MB write
>>
>>  RecSize  WriteSpeed   RanWriteSpeed
>>
>>  10485760  10.56MB/sec  10.37MB/sec
>>   1048576  10.43MB/sec  10.33MB/sec
>>    524288  10.32MB/sec  10.02MB/sec
>>    262144  10.52MB/sec  10.19MB/sec
>>    131072  10.34MB/sec  10.07MB/sec
>>     65536  10.31MB/sec  10.06MB/sec
>>     32768  10.27MB/sec  10.24MB/sec
>>     16384  10.54MB/sec  10.03MB/sec
>>      8192  10.41MB/sec  10.38MB/sec
>>      4096  10.34MB/sec  10.12MB/sec
>>
>> we can see, average write speed is increased to ~10-11MB/sec.
>> ============================================================
>>
>> This patch provides the changes per block devices. So that we may modify
>> the
>> dirty_background_time as per the device and overall system is not
>> impacted
>> by the changes and we get improved perforamace in certain use cases.
>>
>> NOTE: dirty_background_time is used alongwith average bdi write bandwidth
>> estimation to start background writeback. But, bdi write bandwidth
>> estimation
>> is an _estimation_ and may become wildly wrong. So the
>> dirty_background_time
>> tuning may not always work to the user expectations.
>> dirty_background_time
>> will require careful tuning by users on NFS Server.
>>
>> Changes since v1:
>> * make default value of 'dirty_background_time = 0' so that there is no
>> change
>>   in default writeback behaviour.
>> * Add description of dirty_background_time in documentation
>>
>> Original-patch-by: Wu Fengguang <fengguang.wu@intel.com>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
>> ---
>>  fs/fs-writeback.c           |   21 +++++++++++++++++++--
>>  include/linux/backing-dev.h |    1 +
>>  include/linux/writeback.h   |    1 +
>>  mm/backing-dev.c            |   21 +++++++++++++++++++++
>>  mm/page-writeback.c         |    3 ++-
>>  5 files changed, 44 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
>> index be3efc4..dc2a43d 100644
>> --- a/fs/fs-writeback.c
>> +++ b/fs/fs-writeback.c
>> @@ -769,6 +769,22 @@ static bool over_bground_thresh(struct
>> backing_dev_info *bdi)
>>  	return false;
>>  }
>>
>> +bool over_dirty_bground_time(struct backing_dev_info *bdi)
>> +{
>> +	unsigned long background_thresh;
>> +
>> +	if (!bdi->dirty_background_time)
>> +		return false;
>> +
>> +	background_thresh = bdi->avg_write_bandwidth *
>> +				bdi->dirty_background_time / 1000;
>> +
>> +	if (bdi_stat(bdi, BDI_RECLAIMABLE) > background_thresh)
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>>  /*
>>   * Called under wb->list_lock. If there are multiple wb per bdi,
>>   * only the flusher working on the first wb should do it.
>> @@ -828,7 +844,8 @@ static long wb_writeback(struct bdi_writeback *wb,
>>  		 * For background writeout, stop when we are below the
>>  		 * background dirty threshold
>>  		 */
>> -		if (work->for_background && !over_bground_thresh(wb->bdi))
>> +		if (work->for_background && !over_bground_thresh(wb->bdi) &&
>> +			!over_dirty_bground_time(wb->bdi))
>>  			break;
>>
>>  		/*
>> @@ -920,7 +937,7 @@ static unsigned long get_nr_dirty_pages(void)
>>
>>  static long wb_check_background_flush(struct bdi_writeback *wb)
>>  {
>> -	if (over_bground_thresh(wb->bdi)) {
>> +	if (over_bground_thresh(wb->bdi) || over_dirty_bground_time(wb->bdi)) {
>>
>>  		struct wb_writeback_work work = {
>>  			.nr_pages	= LONG_MAX,
>> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
>> index 2a9a9ab..ad83783 100644
>> --- a/include/linux/backing-dev.h
>> +++ b/include/linux/backing-dev.h
>> @@ -95,6 +95,7 @@ struct backing_dev_info {
>>
>>  	unsigned int min_ratio;
>>  	unsigned int max_ratio, max_prop_frac;
>> +	unsigned int dirty_background_time;
>>
>>  	struct bdi_writeback wb;  /* default writeback info for this bdi */
>>  	spinlock_t wb_lock;	  /* protects work_list */
>> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
>> index 50c3e8f..6dc2abe 100644
>> --- a/include/linux/writeback.h
>> +++ b/include/linux/writeback.h
>> @@ -96,6 +96,7 @@ long writeback_inodes_wb(struct bdi_writeback *wb, long
>> nr_pages,
>>  long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
>>  void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
>>  void inode_wait_for_writeback(struct inode *inode);
>> +bool over_dirty_bground_time(struct backing_dev_info *bdi);
>>
>>  /* writeback.h requires fs.h; it, too, is not included from here. */
>>  static inline void wait_on_inode(struct inode *inode)
>> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
>> index d3ca2b3..71f88d4 100644
>> --- a/mm/backing-dev.c
>> +++ b/mm/backing-dev.c
>> @@ -221,12 +221,32 @@ static ssize_t max_ratio_store(struct device *dev,
>>  }
>>  BDI_SHOW(max_ratio, bdi->max_ratio)
>>
>> +static ssize_t dirty_background_time_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t count)
>> +{
>> +	struct backing_dev_info *bdi = dev_get_drvdata(dev);
>> +	unsigned int msec;
>> +	ssize_t ret;
>> +
>> +	ret = kstrtouint(buf, 10, &msec);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	bdi->dirty_background_time = msec;
>
> As commented above, please change to 1/100 seconds unit and change
> variables/logics accordingly.
Ok. We will make changes as per suggestion.

>
>> +	if (over_dirty_bground_time(bdi))
>> +		bdi_start_background_writeback(bdi);
>> +
>> +	return count;
>> +}
>> +BDI_SHOW(dirty_background_time, bdi->dirty_background_time)
>> +
>>  #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
>>
>>  static struct device_attribute bdi_dev_attrs[] = {
>>  	__ATTR_RW(read_ahead_kb),
>>  	__ATTR_RW(min_ratio),
>>  	__ATTR_RW(max_ratio),
>> +	__ATTR_RW(dirty_background_time),
>>  	__ATTR_NULL,
>>  };
>>
>> @@ -628,6 +648,7 @@ int bdi_init(struct backing_dev_info *bdi)
>>  	bdi->min_ratio = 0;
>>  	bdi->max_ratio = 100;
>>  	bdi->max_prop_frac = FPROP_FRAC_BASE;
>> +	bdi->dirty_background_time = 0;
>>  	spin_lock_init(&bdi->wb_lock);
>>  	INIT_LIST_HEAD(&bdi->bdi_list);
>>  	INIT_LIST_HEAD(&bdi->work_list);
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 5ad5ce2..bfbd85c 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -1403,7 +1403,8 @@ pause:
>>  	if (laptop_mode)
>>  		return;
>>
>> -	if (nr_reclaimable > background_thresh)
>> +	if ((nr_reclaimable > background_thresh) ||
>
> No need to add () here.
I will remove it.

Thanks.
>
>> +			over_dirty_bground_time(bdi))
>>  		bdi_start_background_writeback(bdi);
>>  }
>>
>> --
>> 1.7.9.5
>
