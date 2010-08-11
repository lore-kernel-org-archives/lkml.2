Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab0HKWom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:44:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab0HKWoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:44:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com
Subject: [PATCH] cfq-iosched: cfq-iosched: Implement group idling and IOPS accounting for groups V4 
Date: Wed, 11 Aug 2010 18:44:22 -0400
Message-Id: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This is V4 of the patches for group_idle and CFQ group charge accounting in
terms of IOPS implementation. Since V3 not much has changed. Just more testing
and rebase on top of for-2.6.36 branch of block tree.

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

Kernel=2.6.35-blktree-group_idle+
GROUPMODE=1          NRGRP=8      DEV=/dev/dm-3                 
Workload=bsr      iosched=cfq     Filesz=512M bs=4K   
gi=1  slice_idle=8    group_idle=8    quantum=8
=========================================================================
AVERAGE[bsr]    [bw in KB/s]    
------- 
job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  cgrp5  cgrp6  cgrp7  cgrp8  total  
---     --- --  ---------------------------------------------------------------
bsr     1   1   6519   12742  16801  23109  28694  35988  43175  49272  216300 
bsr     1   2   5522   10922  17174  22554  24151  30488  36572  42021  189404 
bsr     1   4   4593   9620   13120  21405  25827  28097  33029  37335  173026 
bsr     1   8   3622   8277   12557  18296  21775  26022  30760  35713  157022 


Notice that overall throughput is just around 160MB/s with 8 sequential reader
in each group.

With this patch set, I have set slice_idle=0 and re-ran same test.

Kernel=2.6.35-blktree-group_idle+
GROUPMODE=1          NRGRP=8         DEV=/dev/dm-3                 
Workload=bsr      iosched=cfq     Filesz=512M bs=4K   
gi=1  slice_idle=0    group_idle=8    quantum=8
=========================================================================
AVERAGE[bsr]    [bw in KB/s]    
------- 
job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  cgrp5  cgrp6  cgrp7  cgrp8  total  
---     --- --  ---------------------------------------------------------------
bsr     1   1   6652   12341  17335  23856  28740  36059  42833  48487  216303 
bsr     1   2   10168  20292  29827  38363  45746  52842  60071  63957  321266 
bsr     1   4   11176  21763  32713  42970  53222  58613  63598  69296  353351 
bsr     1   8   11750  23718  34102  47144  56975  63613  69000  69666  375968 

Notice how overall throughput has shot upto 350-370MB/s while retaining the
ability to do the IO control.

So this is not the default mode. This new tunable group_idle, allows one to
set slice_idle=0 to disable some of the CFQ features and and use primarily
group service differentation feature.

By default nothing should change for CFQ and this change should be fairly
low risk.

Thanks
Vivek
