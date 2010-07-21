Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0GUTHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758795Ab0GUTGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:06:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        jmoyer@redhat.com, czoccolo@gmail.com, vgoyal@redhat.com
Subject: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle tunable V3
Date: Wed, 21 Jul 2010 15:06:18 -0400
Message-Id: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This is V3 of the group_idle and CFQ IOPS mode implementation patchset. Since V2
I have cleaned up the code a bit to clarify the confusion lingering around in
what cases do we charge time slice and in what cases do we charge number of
requests.

What's the problem
------------------
On high end storage (I got on HP EVA storage array with 12 SATA disks in 
RAID 5), CFQ's model of dispatching requests from a single queue at a
time (sequential readers/write sync writers etc), becomes a bottleneck.
Often we don't drive enough request queue depth to keep all the disks busy
and suffer a lot in terms of overall throughput.

All these problems primarily originate from two things. Idling on per
cfq queue and quantum (dispatching limited number of requests from a
single queue) and till then not allowing dispatch from other queues. Once
you set the slice_idle=0 and quantum to higher value, most of the CFQ's
problem on higher end storage disappear.

This problem also becomes visible in IO controller where one creates
multiple groups and gets the fairness but overall throughput is less. In
the following table, I am running increasing number of sequential readers
(1,2,4,8) in 8 groups of weight 100 to 800.

Kernel=2.6.35-rc5-iops+
GROUPMODE=1          NRGRP=8
DIR=/mnt/iostestmnt/fio        DEV=/dev/dm-4
Workload=bsr      iosched=cfq     Filesz=512M bs=4K
group_isolation=1 slice_idle=8    group_idle=8    quantum=8
=========================================================================
AVERAGE[bsr]    [bw in KB/s]
-------
job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  cgrp5  cgrp6  cgrp7  cgrp8  total
---     --- --  ---------------------------------------------------------------
bsr     3   1   6186   12752  16568  23068  28608  35785  42322  48409  213701
bsr     3   2   5396   10902  16959  23471  25099  30643  37168  42820  192461
bsr     3   4   4655   9463   14042  20537  24074  28499  34679  37895  173847
bsr     3   8   4418   8783   12625  19015  21933  26354  29830  36290  159249

Notice that overall throughput is just around 160MB/s with 8 sequential reader
in each group.

With this patch set, I have set slice_idle=0 and re-ran same test.

Kernel=2.6.35-rc5-iops+
GROUPMODE=1          NRGRP=8
DIR=/mnt/iostestmnt/fio        DEV=/dev/dm-4
Workload=bsr      iosched=cfq     Filesz=512M bs=4K
group_isolation=1 slice_idle=0    group_idle=8    quantum=8
=========================================================================
AVERAGE[bsr]    [bw in KB/s]
-------
job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  cgrp5  cgrp6  cgrp7  cgrp8  total
---     --- --  ---------------------------------------------------------------
bsr     3   1   6523   12399  18116  24752  30481  36144  42185  48894  219496
bsr     3   2   10072  20078  29614  38378  46354  52513  58315  64833  320159
bsr     3   4   11045  22340  33013  44330  52663  58254  63883  70990  356520
bsr     3   8   12362  25860  37920  47486  61415  47292  45581  70828  348747

Notice how overall throughput has shot upto 348MB/s while retaining the ability
to do the IO control.

So this is not the default mode. This new tunable group_idle, allows one to
set slice_idle=0 to disable some of the CFQ features and and use primarily
group service differentation feature.

If you have thoughts on other ways of solving the problem, I am all ears
to it.

Thanks
Vivek
