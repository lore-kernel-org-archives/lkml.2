Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab0GVVax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:30:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab0GVV34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:29:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        jmoyer@redhat.com, czoccolo@gmail.com, vgoyal@redhat.com
Subject: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new group_idle tunable
Date: Thu, 22 Jul 2010 17:29:27 -0400
Message-Id: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This is V4 of the patchset which implements a new tunable group_idle and also
implements IOPS mode for group fairness. Following are changes since V3.

- Cleaned up the code a bit to make clear that IOPS mode is effective only
  for group scheduling and cfqq queue scheduling should not be affected. Note
  that currently cfqq uses slightly different algorithms for cfq queue and
  cfq group scheduling.

- Updated the documentation as per Christoph's comments.

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

Kernel=2.6.35-rc6-iops+       
GROUPMODE=1          NRGRP=8             
DIR=/mnt/iostestmnt/fio        DEV=/dev/dm-4                 
Workload=bsr      iosched=cfq     Filesz=512M bs=4K   
group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
=========================================================================
AVERAGE[bsr]    [bw in KB/s]    
------- 
job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  cgrp5  cgrp6  cgrp7  cgrp8  total  
---     --- --  ---------------------------------------------------------------
bsr     1   1   6120   12596  16530  23408  28984  35579  42061  47335  212613 
bsr     1   2   5250   10545  16604  23717  24677  29997  36753  42571  190114 
bsr     1   4   4437   10372  12546  17231  26100  32241  38208  35419  176554 
bsr     1   8   4636   9367   11902  18948  24589  27472  30341  37262  164517 

Notice that overall throughput is just around 164MB/s with 8 sequential reader
in each group.

With this patch set, I have set slice_idle=0 and re-ran same test.

Kernel=2.6.35-rc6-iops+       
GROUPMODE=1          NRGRP=8             
DIR=/mnt/iostestmnt/fio        DEV=/dev/dm-4                 
Workload=bsr      iosched=cfq     Filesz=512M bs=4K   
group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
=========================================================================
AVERAGE[bsr]    [bw in KB/s]    
------- 
job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  cgrp5  cgrp6  cgrp7  cgrp8  total  
---     --- --  ---------------------------------------------------------------
bsr     1   1   6548   12174  17870  24063  29992  35695  41439  47034  214815 
bsr     1   2   10299  20487  30460  39375  46812  52783  59455  64351  324022 
bsr     1   4   10648  21735  32565  43442  52756  59513  64425  70324  355408 
bsr     1   8   11818  24483  36779  48144  55623  62583  65478  72279  377187 


Notice how overall throughput has shot upto 377MB/s while retaining the ability
to do the IO control.

This patchset implements a CFQ group IOPS fairness mode where if slice_idle=0
and if storage supports NCQ, CFQ starts doing accounting in terms of number
of requests dispatched and not in terms of time for groups.

This patchset also implements a new tunable group_idle, which allows one to set
slice_idle=0 to disable slice idling on cfqq and service tree but still idle on
group to make sure we can achieve better throughput for certain workloads
(read sequential) and also be able to achive service differentation among groups.

If you have thoughts on other ways of solving the problem, I am all ears
to it.

Thanks
Vivek
