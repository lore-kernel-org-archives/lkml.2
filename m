Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1CWB2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:28:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab1CWB2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:28:17 -0400
Date: Tue, 22 Mar 2011 21:27:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp,
        taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH v2 0/8] Provide cgroup isolation for buffered
 writes.
Message-ID: <20110323012755.GA10325@redhat.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300835335-2777-1-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 04:08:47PM -0700, Justin TerAvest wrote:

[..]
> ===================================== Isolation experiment results
> 
> For isolation testing, we run a test that's available at:
>   git://google3-2.osuosl.org/tests/blkcgroup.git
> 
> It creates containers, runs workloads, and checks to see how well we meet
> isolation targets. For the purposes of this patchset, I only ran
> tests among buffered writers.
> 
> Before patches
> ==============
> 10:32:06 INFO experiment 0 achieved DTFs: 666, 333
> 10:32:06 INFO experiment 0 FAILED: max observed error is 167, allowed is 150
> 10:32:51 INFO experiment 1 achieved DTFs: 647, 352
> 10:32:51 INFO experiment 1 FAILED: max observed error is 253, allowed is 150
> 10:33:35 INFO experiment 2 achieved DTFs: 298, 701
> 10:33:35 INFO experiment 2 FAILED: max observed error is 199, allowed is 150
> 10:34:19 INFO experiment 3 achieved DTFs: 445, 277, 277
> 10:34:19 INFO experiment 3 FAILED: max observed error is 155, allowed is 150
> 10:35:05 INFO experiment 4 achieved DTFs: 418, 104, 261, 215
> 10:35:05 INFO experiment 4 FAILED: max observed error is 232, allowed is 150
> 10:35:53 INFO experiment 5 achieved DTFs: 213, 136, 68, 102, 170, 136, 170
> 10:35:53 INFO experiment 5 PASSED: max observed error is 73, allowed is 150
> 10:36:04 INFO -----ran 6 experiments, 1 passed, 5 failed
> 
> After patches
> =============
> 11:05:22 INFO experiment 0 achieved DTFs: 501, 498
> 11:05:22 INFO experiment 0 PASSED: max observed error is 2, allowed is 150
> 11:06:07 INFO experiment 1 achieved DTFs: 874, 125
> 11:06:07 INFO experiment 1 PASSED: max observed error is 26, allowed is 150
> 11:06:53 INFO experiment 2 achieved DTFs: 121, 878
> 11:06:53 INFO experiment 2 PASSED: max observed error is 22, allowed is 150
> 11:07:46 INFO experiment 3 achieved DTFs: 589, 205, 204
> 11:07:46 INFO experiment 3 PASSED: max observed error is 11, allowed is 150
> 11:08:34 INFO experiment 4 achieved DTFs: 616, 109, 109, 163
> 11:08:34 INFO experiment 4 PASSED: max observed error is 34, allowed is 150
> 11:09:29 INFO experiment 5 achieved DTFs: 139, 139, 139, 139, 140, 141, 160
> 11:09:29 INFO experiment 5 PASSED: max observed error is 1, allowed is 150
> 11:09:46 INFO -----ran 6 experiments, 6 passed, 0 failed
> 
> Summary
> =======
> Isolation between buffered writers is clearly better with this patch.

Can you pleae explain what is this test doing. All I am seeing is passed
and failed and really don't understand what the test is doing.

Can you run say simple 4 dd buffered writers in 4 cgroups with weights
100, 200, 300 and 400 and see if you get better isolation.

Secondly can you also please explain that how does it work. Without
making writeback cgroup aware, there are no gurantees that higher
weight cgroup will get more IO done. 

> 
> 
> =============================== Read latency results
> To test read latency, I created two containers:
>   - One called "readers", with weight 900
>   - One called "writers", with weight 100
> 
> I ran this fio workload in "readers":
> [global]
> directory=/mnt/iostestmnt/fio
> runtime=30
> time_based=1
> group_reporting=1
> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
> cgroup_nodelete=1
> bs=4K
> size=512M
> 
> [iostest-read]
> description="reader"
> numjobs=16
> rw=randread
> new_group=1
> 
> 
> ....and this fio workload in "writers"
> [global]
> directory=/mnt/iostestmnt/fio
> runtime=30
> time_based=1
> group_reporting=1
> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
> cgroup_nodelete=1
> bs=4K
> size=512M
> 
> [iostest-write]
> description="writer"
> cgroup=writers
> numjobs=3
> rw=write
> new_group=1
> 
> 
> 
> I've pasted the results from the "read" workload inline.
> 
> Before patches
> ==============
> Starting 16 processes
> 
> Jobs: 14 (f=14): [_rrrrrr_rrrrrrrr] [36.2% done] [352K/0K /s] [86 /0  iops] [eta 01m:00s]·············
> iostest-read: (groupid=0, jobs=16): err= 0: pid=20606
>   Description  : ["reader"]
>   read : io=13532KB, bw=455814 B/s, iops=111 , runt= 30400msec
>     clat (usec): min=2190 , max=30399K, avg=30395175.13, stdev= 0.20
>      lat (usec): min=2190 , max=30399K, avg=30395177.07, stdev= 0.20
>     bw (KB/s) : min=    0, max=  260, per=0.00%, avg= 0.00, stdev= 0.00
>   cpu          : usr=0.00%, sys=0.03%, ctx=3691, majf=2, minf=468
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=3383/0/0, short=0/0/0
> 
>      lat (msec): 4=0.03%, 10=2.66%, 20=74.84%, 50=21.90%, 100=0.09%
>      lat (msec): 250=0.06%, >=2000=0.41%
> 
> Run status group 0 (all jobs):
>    READ: io=13532KB, aggrb=445KB/s, minb=455KB/s, maxb=455KB/s, mint=30400msec, maxt=30400msec
> 
> Disk stats (read/write):
>   sdb: ios=3744/18, merge=0/16, ticks=542713/1675, in_queue=550714, util=99.15%
> 
> 
> 
> After patches
> =============
> tarting 16 processes
> Jobs: 16 (f=16): [rrrrrrrrrrrrrrrr] [100.0% done] [557K/0K /s] [136 /0  iops] [eta 00m:00s]
> iostest-read: (groupid=0, jobs=16): err= 0: pid=14183
>   Description  : ["reader"]
>   read : io=14940KB, bw=506105 B/s, iops=123 , runt= 30228msec
>     clat (msec): min=2 , max=29866 , avg=463.42, stdev=101.84
>      lat (msec): min=2 , max=29866 , avg=463.42, stdev=101.84
>     bw (KB/s) : min=    0, max=  198, per=31.69%, avg=156.52, stdev=17.83
>   cpu          : usr=0.01%, sys=0.03%, ctx=4274, majf=2, minf=464
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued r/w/d: total=3735/0/0, short=0/0/0
> 
>      lat (msec): 4=0.05%, 10=0.32%, 20=32.99%, 50=64.61%, 100=1.26%
>      lat (msec): 250=0.11%, 500=0.11%, 750=0.16%, 1000=0.05%, >=2000=0.35%
> 
> Run status group 0 (all jobs):
>    READ: io=14940KB, aggrb=494KB/s, minb=506KB/s, maxb=506KB/s, mint=30228msec, maxt=30228msec
> 
> Disk stats (read/write):
>   sdb: ios=4189/0, merge=0/0, ticks=96428/0, in_queue=478798, util=100.00%
> 
> 
> 
> Summary
> =======
> Read latencies are a bit worse, but this overhead is only imposed when users
> ask for this feature by turning on CONFIG_BLKIOTRACK. We expect there to be =
> a something of a latency vs isolation tradeoff.

- What number you are looking at to say READ latencies are worse.
- Who got isolated here? If READS latencies are worse and you are saying
  that's the cost of isolation, that means you are looking for isolation
  for WRITES? This is the first time time I am hearing that READS starved
  WRITES and I want better isolation for WRITES.

Also CONFIG_BLKIOTRACK=n is not the solution. This will most likely be
set and we need to figure out which makes sense.

To me WRITE isolation comes handy only if we want to create speed
difference between multiple WRITE streams. And that can not reliably be
done till we make writeback logic cgroup aware.

If we try to put WRITES in a separate group, most likely WRITES will end
up getting bigger share of disk then what they are getting by default and
I seriously doubt that who is looking for that. So far all the complaints
I have heard is that in presence of WRITES, my READ latencies suffer and
not vice a versa.

Thanks
Vivek
