Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0GZHAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:00:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59310 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0GZHAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:00:49 -0400
Message-ID: <4C4D3208.7090703@cn.fujitsu.com>
Date: Mon, 26 Jul 2010 14:58:16 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, jmoyer@redhat.com, czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle tunable
 V3
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Hi,
> 
> This is V3 of the group_idle and CFQ IOPS mode implementation patchset. Since V2
> I have cleaned up the code a bit to clarify the confusion lingering around in
> what cases do we charge time slice and in what cases do we charge number of
> requests.
> 
> What's the problem
> ------------------
> On high end storage (I got on HP EVA storage array with 12 SATA disks in 
> RAID 5), CFQ's model of dispatching requests from a single queue at a
> time (sequential readers/write sync writers etc), becomes a bottleneck.
> Often we don't drive enough request queue depth to keep all the disks busy
> and suffer a lot in terms of overall throughput.
> 
> All these problems primarily originate from two things. Idling on per
> cfq queue and quantum (dispatching limited number of requests from a
> single queue) and till then not allowing dispatch from other queues. Once
> you set the slice_idle=0 and quantum to higher value, most of the CFQ's
> problem on higher end storage disappear.
> 
> This problem also becomes visible in IO controller where one creates
> multiple groups and gets the fairness but overall throughput is less. In
> the following table, I am running increasing number of sequential readers
> (1,2,4,8) in 8 groups of weight 100 to 800.
> 
> Kernel=2.6.35-rc5-iops+
> GROUPMODE=1          NRGRP=8
> DIR=/mnt/iostestmnt/fio        DEV=/dev/dm-4
> Workload=bsr      iosched=cfq     Filesz=512M bs=4K
> group_isolation=1 slice_idle=8    group_idle=8    quantum=8
> =========================================================================
> AVERAGE[bsr]    [bw in KB/s]
> -------
> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  cgrp5  cgrp6  cgrp7  cgrp8  total
> ---     --- --  ---------------------------------------------------------------
> bsr     3   1   6186   12752  16568  23068  28608  35785  42322  48409  213701
> bsr     3   2   5396   10902  16959  23471  25099  30643  37168  42820  192461
> bsr     3   4   4655   9463   14042  20537  24074  28499  34679  37895  173847
> bsr     3   8   4418   8783   12625  19015  21933  26354  29830  36290  159249
> 
> Notice that overall throughput is just around 160MB/s with 8 sequential reader
> in each group.
> 
> With this patch set, I have set slice_idle=0 and re-ran same test.
> 
> Kernel=2.6.35-rc5-iops+
> GROUPMODE=1          NRGRP=8
> DIR=/mnt/iostestmnt/fio        DEV=/dev/dm-4
> Workload=bsr      iosched=cfq     Filesz=512M bs=4K
> group_isolation=1 slice_idle=0    group_idle=8    quantum=8
> =========================================================================
> AVERAGE[bsr]    [bw in KB/s]
> -------
> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  cgrp5  cgrp6  cgrp7  cgrp8  total
> ---     --- --  ---------------------------------------------------------------
> bsr     3   1   6523   12399  18116  24752  30481  36144  42185  48894  219496
> bsr     3   2   10072  20078  29614  38378  46354  52513  58315  64833  320159
> bsr     3   4   11045  22340  33013  44330  52663  58254  63883  70990  356520
> bsr     3   8   12362  25860  37920  47486  61415  47292  45581  70828  348747
> 
> Notice how overall throughput has shot upto 348MB/s while retaining the ability
> to do the IO control.
> 
> So this is not the default mode. This new tunable group_idle, allows one to
> set slice_idle=0 to disable some of the CFQ features and and use primarily
> group service differentation feature.
> 
> If you have thoughts on other ways of solving the problem, I am all ears
> to it.

Hi Vivek,

I did some tests on single SATA disk on my desktop. With patches applied, seems no
regression occurs till now, and have some performance improvement in case of 
"Direct Random Reader" mode. Here're some numbers on my box.

Vallina kernel:

Blkio is already mounted at /cgroup/blkio. Unmounting it
DIR=/mnt/iostestmnt/fio                 DEV=/dev/sdb2
GROUPMODE=1                             NRGRP=4
Will run workloads for increasing number of threads upto a max of 4
Starting test for [drr] with set=1 numjobs=1 filesz=512M bs=32k runtime=30
Starting test for [drr] with set=1 numjobs=2 filesz=512M bs=32k runtime=30
Starting test for [drr] with set=1 numjobs=4 filesz=512M bs=32k runtime=30
Finished test for workload [drr]
Host=localhost.localdomain     Kernel=2.6.35-rc4-Vivek-+
GROUPMODE=1          NRGRP=4
DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2
Workload=drr      iosched=cfq     Filesz=512M bs=32k
group_isolation=1 slice_idle=0    group_idle=8    quantum=8
=========================================================================
AVERAGE[drr]    [bw in KB/s]
-------
job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total
---     --- --  -----------------------------------
drr     1   1   761    761    762    760    3044
drr     1   2   185    420    727    1256   2588
drr     1   4   180    371    588    863    2002


Patched kernel:

Blkio is already mounted at /cgroup/blkio. Unmounting it
DIR=/mnt/iostestmnt/fio                 DEV=/dev/sdb2
GROUPMODE=1                             NRGRP=4
Will run workloads for increasing number of threads upto a max of 4
Starting test for [drr] with set=1 numjobs=1 filesz=512M bs=32k runtime=30
Starting test for [drr] with set=1 numjobs=2 filesz=512M bs=32k runtime=30
Starting test for [drr] with set=1 numjobs=4 filesz=512M bs=32k runtime=30
Finished test for workload [drr]
Host=localhost.localdomain     Kernel=2.6.35-rc4-Vivek-+
GROUPMODE=1          NRGRP=4
DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2
Workload=drr      iosched=cfq     Filesz=512M bs=32k
group_isolation=1 slice_idle=0    group_idle=8    quantum=8
=========================================================================
AVERAGE[drr]    [bw in KB/s]
-------
job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total
---     --- --  -----------------------------------
drr     1   1   323    671    1030   1378   3402
drr     1   2   165    391    686    1144   2386
drr     1   4   185    373    612    873    2043

Thanks
Gui

> 
> Thanks
> Vivek
> 
