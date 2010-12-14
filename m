Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab0LNDGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 22:06:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64154 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab0LNDGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 22:06:10 -0500
Message-ID: <4D06DF32.2050604@cn.fujitsu.com>
Date: Tue, 14 Dec 2010 11:06:26 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8 v2] Introduce CFQ group hierarchical scheduling and
 "use_hierarchy" interface
References: <4CDF7BC5.9080803@cn.fujitsu.com> <4CDF9CC6.2040106@cn.fujitsu.com> <20101115165319.GI30792@redhat.com> <4CE2718C.6010406@kernel.dk> <4D057A6A.8060000@cn.fujitsu.com> <20101213142957.GA20454@redhat.com>
In-Reply-To: <20101213142957.GA20454@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 11:06:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 11:06:07,
	Serialize complete at 2010-12-14 11:06:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Mon, Dec 13, 2010 at 09:44:10AM +0800, Gui Jianfeng wrote:
>> Hi
>>
>> Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
>> in the way that it puts all CFQ queues in a hidden group and schedules with other 
>> CFQ group under their parent. The patchset is available here,
>> http://lkml.org/lkml/2010/8/30/30
>>
>> Vivek think this approach isn't so instinct that we should treat CFQ queues
>> and groups at the same level. Here is the new approach for hierarchical 
>> scheduling based on Vivek's suggestion. The most big change of CFQ is that
>> it gets rid of cfq_slice_offset logic, and makes use of vdisktime for CFQ
>> queue scheduling just like CFQ group does. But I still give cfqq some jump 
>> in vdisktime based on ioprio, thanks for Vivek to point out this. Now CFQ 
>> queue and CFQ group uses the same scheduling algorithm. 
> 
> Hi Gui,
> 
> Thanks for the patches. Few thoughts.
> 
> - I think we can implement vdisktime jump logic for both cfq queue and
>   cfq groups. So any entity (queue/group) which is being backlogged fresh
>   will get the vdisktime jump but anything which has been using its slice
>   will get queued at the end of tree.

Vivek,

vdisktime jump for both CFQ queue and CFQ group is ok to me.
what do you mean "anything which has been using its slice will get queued at the 
end of tree."
Currently, if a CFQ entity uses up its time slice, we'll update its vdisktime,
why should we put it at the end of tree.


> 
> - Have you done testing in true hierarchical mode. In the sense that
>   create atleast two level of hierarchy and see if bandwidth division
>   is happening properly. Something like as follows.
> 
> 			root
> 		       /    \ 
> 		    test1  test2
> 	           /    \   /  \
> 		  G1    G2  G3  G4

yes, I tested with two level, and works fine.

> 
> - On what kind of storage you have been doing your testing? I have noticed
>   that IO controllers works well only with idling on and with idling on
>   performance is bad on high end storage. The simple reason being that
>   an storage array can support multiple IOs at the same time and if we
>   are idling on queue or group in an attempt to provide fairness it hurts.
>   It hurts especially more if we are doing random IO (I am assuming this
>   is more typical of workloads).
>  
>   So we need to come up with a proper logic so that we can provide some
>   kind of fairness even with idle disabled. I think that's where this
>   vdisktime jump logic comes into picture and is important to get it
>   right.
> 
>   So can you also do some testing with idle disabled (both queue 
>   and group) and see if the vdisktime logic is helping with providing
>   some kind of service differentation. I think results will vary 
>   based on what is the storage and what queue depth are you driving. You
>   can even try to do this testing on an SSD.

I tested on sata. will do more tests when idle disabled.

Thanks
Gui

> 
> Thanks
> Vivek 
>   
> 
>> "use_hierarchy" interface is now added to switch between hierarchical mode
>> and flat mode. For this time being, this interface only appears in Root Cgroup.
>>
>> V1 -> V2 Changes:
>> - Raname "struct io_sched_entity" to "struct cfq_entity" and don't differentiate
>>   queue_entity and group_entity, just use cfqe instead. 
>> - Give newly added cfqq a small vdisktime jump accord to its ioprio.
>> - Make flat mode as default CFQ group scheduling mode.
>> - Introduce "use_hierarchy" interface.
>> - Update blkio cgroup documents
>>
>> [PATCH 1/8 v2] cfq-iosched: Introduce cfq_entity for CFQ queue
>> [PATCH 2/8 v2] cfq-iosched: Introduce cfq_entity for CFQ group
>> [PATCH 3/8 v2] cfq-iosched: Introduce vdisktime and io weight for CFQ queue
>> [PATCH 4/8 v2] cfq-iosched: Extract some common code of service tree handling for CFQ queue and CFQ group
>> [PATCH 5/8 v2] cfq-iosched: Introduce hierarchical scheduling with CFQ queue and group at the same level
>> [PATCH 6/8] blkio-cgroup: "use_hierarchy" interface without any functionality
>> [PATCH 7/8] cfq-iosched: Add flat mode and switch between two modes by "use_hierarchy"
>> [PATCH 8/8] blkio-cgroup: Document for blkio.use_hierarchy.
>>
>> Benchmarks:
>> I made use of Vivek's iostest to perform some benchmarks on my box. I tested different workloads, and
>> didn't see any performance drop comparing to vanilla kernel. The attached files are some performance
>> numbers on vanilla Kernel, patched kernel with flat mode and patched kernel with hierarchical mode.
>>
>>
>>
>>
> 
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=brr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[brr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> brr     1   1   294    692    1101   1526   3613   
>> brr     1   2   176    420    755    1281   2632   
>> brr     1   4   160    323    583    1253   2319   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=brr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[brr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> brr     1   1   380    738    1092   1439   3649   
>> brr     1   2   171    413    733    1242   2559   
>> brr     1   4   188    350    665    1193   2396   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=bsr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[bsr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> bsr     1   1   6856   11480  17644  22647  58627  
>> bsr     1   2   2592   5409   8464   13300  29765  
>> bsr     1   4   2502   4635   7640   12909  27686  
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=bsr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[bsr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> bsr     1   1   6913   11643  17843  22909  59308  
>> bsr     1   2   6682   11234  15527  19410  52853  
>> bsr     1   4   5209   10882  15002  18167  49260  
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drr     1   1   298    701    1117   1538   3654   
>> drr     1   2   190    372    731    1244   2537   
>> drr     1   4   147    322    563    1143   2175   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drr     1   1   370    713    1050   1416   3549   
>> drr     1   2   192    434    755    1265   2646   
>> drr     1   4   157    333    677    1159   2326   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drw      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drw]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drw     1   1   595    1272   2007   2737   6611   
>> drw     1   2   269    690    1407   1953   4319   
>> drw     1   4   145    396    978    1752   3271   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drw      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drw]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drw     1   1   604    1310   1827   2778   6519   
>> drw     1   2   287    723    1368   1887   4265   
>> drw     1   4   170    407    979    1575   3131   
>>
>>
> 
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=brr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[brr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> brr     1   1   287    690    1096   1506   3579   
>> brr     1   2   189    404    800    1283   2676   
>> brr     1   4   141    317    557    1106   2121   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=brr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[brr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> brr     1   1   386    715    1071   1437   3609   
>> brr     1   2   187    401    717    1258   2563   
>> brr     1   4   296    767    1553   32     2648   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=bsr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[bsr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> bsr     1   1   6971   11459  17789  23158  59377  
>> bsr     1   2   2592   5536   8679   13389  30196  
>> bsr     1   4   2194   4635   7820   13984  28633  
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=bsr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[bsr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> bsr     1   1   6851   11588  17459  22297  58195  
>> bsr     1   2   6814   11534  16141  20426  54915  
>> bsr     1   4   5118   10741  13994  17661  47514  
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drr     1   1   297    689    1097   1522   3605   
>> drr     1   2   175    426    757    1277   2635   
>> drr     1   4   150    330    604    1100   2184   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drr     1   1   379    735    1077   1436   3627   
>> drr     1   2   190    404    760    1247   2601   
>> drr     1   4   155    333    692    1044   2224   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drw      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drw]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drw     1   1   566    1293   2001   2686   6546   
>> drw     1   2   225    662    1233   1902   4022   
>> drw     1   4   147    379    922    1761   3209   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drw      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drw]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drw     1   1   579    1226   2020   2823   6648   
>> drw     1   2   276    689    1288   2068   4321   
>> drw     1   4   183    399    798    2113   3493   
>>
>>
> 
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=brr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[brr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> brr     1   1   289    684    1098   1508   3579   
>> brr     1   2   178    421    765    1228   2592   
>> brr     1   4   144    301    585    1094   2124   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=brr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[brr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> brr     1   1   375    734    1081   1434   3624   
>> brr     1   2   172    397    700    1201   2470   
>> brr     1   4   154    316    573    1087   2130   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=bsr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[bsr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> bsr     1   1   6818   11510  17820  23239  59387  
>> bsr     1   2   2643   5502   8728   13329  30202  
>> bsr     1   4   2166   4785   7344   12954  27249  
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=bsr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[bsr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> bsr     1   1   6979   11629  17782  23064  59454  
>> bsr     1   2   6803   11274  15865  20024  53966  
>> bsr     1   4   5292   10674  14504  17674  48144  
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drr     1   1   298    694    1116   1540   3648   
>> drr     1   2   183    405    721    1197   2506   
>> drr     1   4   151    296    553    1119   2119   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drr      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drr]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drr     1   1   367    724    1078   1433   3602   
>> drr     1   2   184    418    744    1245   2591   
>> drr     1   4   157    295    562    1122   2136   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drw      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=0    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drw]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drw     1   1   582    1271   1948   2754   6555   
>> drw     1   2   277    700    1294   1970   4241   
>> drw     1   4   172    345    928    1585   3030   
>>
>>
>> Host=localhost.localdomain     Kernel=2.6.37-rc2-Block-+     
>> GROUPMODE=1          NRGRP=4             
>> DIR=/mnt/iostestmnt/fio        DEV=/dev/sdb2                 
>> Workload=drw      iosched=cfq     Filesz=512M bs=32k  
>> group_isolation=1 slice_idle=8    group_idle=8    quantum=8    
>> =========================================================================
>> AVERAGE[drw]    [bw in KB/s]    
>> ------- 
>> job     Set NR  cgrp1  cgrp2  cgrp3  cgrp4  total  
>> ---     --- --  -----------------------------------
>> drw     1   1   586    1296   1888   2739   6509   
>> drw     1   2   294    749    1360   1931   4334   
>> drw     1   4   156    337    814    1806   3113   
>>
>>
> 
> 

-- 
Regards
Gui Jianfeng
