Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774Ab0GSRPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:15:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760703Ab0GSROh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:14:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        jmoyer@redhat.com, czoccolo@gmail.com, vgoyal@redhat.com
Subject: [RFC PATCH] cfq-iosched: Implement group idle V2
Date: Mon, 19 Jul 2010 13:14:09 -0400
Message-Id: <1279559652-2775-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This is V2 of the group_idle implementation patchset. I have done some more
testing since V1 and fixed couple of bugs since V1.

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

Kernel=2.6.35-rc5-gi-sl-accounting+
GROUPMODE=1          NRGRP=8             
DIR=/mnt/iostestmnt/fio        DEV=/dev/dm-4                 
Workload=bsr      iosched=cfq     Filesz=512M bs=4K   
group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
=========================================================================
AVERAGE[bsr]    [bw in KB/s]    
------- 
job     Set NR  test1  test2  test3  test4  test5  test6  test7  test8  total  
---     --- --  ---------------------------------------------------------------
bsr     1   1   6245   12776  16591  23471  28746  36799  43031  49778  217437 
bsr     1   2   5100   11063  17216  23136  23738  30391  35910  40874  187428 
bsr     1   4   4623   9718   14746  18356  22875  30407  33215  38073  172013 
bsr     1   8   4720   10143  13499  19115  22157  29126  31688  30784  161232 

Notice that overall throughput is just around 160MB/s with 8 sequential reader
in each group.

With this patch set, I have set slice_idle=0 and re-ran same test.

Kernel=2.6.35-rc5-gi-sl-accounting+
GROUPMODE=1          NRGRP=8             
DIR=/mnt/iostestmnt/fio        DEV=/dev/dm-4                 
Workload=bsr      iosched=cfq     Filesz=512M bs=4K   
group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
=========================================================================
AVERAGE[bsr]    [bw in KB/s]    
------- 
job     Set NR  test1  test2  test3  test4  test5  test6  test7  test8  total  
---     --- --  ---------------------------------------------------------------
bsr     1   1   6789   12764  17174  23111  28528  36807  42753  48826  216752 
bsr     1   2   9845   20617  30521  39061  45514  51607  63683  63770  324618 
bsr     1   4   14835  24241  42444  55207  45914  51318  54661  60318  348938 
bsr     1   8   12022  24478  36732  48651  54333  60974  64856  72930  374976 

Notice how overall throughput has shot upto 374MB/s while retaining the ability
to do the IO control.

So this is not the default mode. This new tunable group_idle, allows one to
set slice_idle=0 to disable some of the CFQ features and and use primarily
group service differentation feature.

If you have thoughts on other ways of solving the problem, I am all ears
to it.

Thanks
Vivek
