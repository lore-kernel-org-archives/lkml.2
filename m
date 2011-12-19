Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1LSIcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 03:32:46 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:47957 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1LSIcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 03:32:45 -0500
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Subject: [RFC PATCH 0/4] Gang scheduling in CFS
To: peterz@infradead.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Date: Mon, 19 Dec 2011 14:03:55 +0530
Message-ID: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11121908-9574-0000-0000-00000094C367
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    The following patches implements gang scheduling. These patches
    are *highly* experimental in nature and are not proposed for
    inclusion at this time.

    Gang scheduling is an approach where we make an effort to run
    related tasks (the gang) at the same time on a number of CPUs.

    Gang scheduling can be helpful in virtualization scenario. It will
    help in avoiding the lock-holder-preemption[1] problem and other
    benefits include improved lock-acquisition times. This feature
    will help address some limitations of KVM on Power

    On Power, we have an interesting hardware restriction on guests
    running across SMT theads: on any single core, we can only run one
    mm context at any given time.  That means that we can run 4
    threads from one guest, but we can not mix and match threads from
    different guests or host.  In KVM's case, QEMU also counts as
    another mm context, so any VM exits or hypercalls that trap in to
    QEMU will stop all the other threads on the core except the one
    making the call.

    The gang scheduling problem can be broken into two parts:
    a) Placement of the tasks to be gang scheduled 
    b) Synchronized scheduling of the tasks across a set of cpu.
   
    This patch takes care of point "b" and the placement part(pinning)
    is handled manually in user space currently.

Approach:

    Whenever a task is picked, and the task is supposed to be gang
    scheduled we will do some post_schedule magic. post_schedule magic
    for once will decide whether this cpu is the gang_leader or not.

    So what is this gang_leader?  

    We need one of the cpu to start the gang on behalf of the set of
    cpus, IOW the gang granularity. The gang_leader will be sending
    IPIs to fellow cpus, as per the gang granularity. This granularity
    can be decided depending upon the architecture as well.

    All the fellow cpus on receiving an IPI will do the following: If
    the cpu's runqueue has a task belonging to the gang which was
    initiated by the gang_leader, favour the task to be picked up and
    set need_resched.

    The favouring of task can be done in different ways. I have tried
    two options here(patch3 and patch4) and have results from them.

    Interface to invoke a gang for a task group: 
    echo 1 > /cgroup/test/cpu.gang
    
    patch 1: Implements the interface of enabling/disabling gang using
    	     cpu cgroup.
    
    patch 2: Infrastructure to invoke gang scheduling. A gang leader
             would be electected once depending on the gang scheduling
             granularity, IOW, gang across how many cpus(gang_cpus).
             And then on, gang leader will be sending gang initiations
             to gang_cpus.
    
    patch 3: Uses set_next_buddy to favour gang tasks to be picked up
    
    patch 4: Introduces set_gang_buddy to favour gang task
    	     unconditionally.
    
    I have rebased patches for latest scheduler changes
    (3.2-rc4-tip_93e44306).

    PLE - Test Setup:
    - x3850x5 machine - PLE enabled
    - 8 CPUs (HT disabled)
    - 264GB memory
    - VM details:
       - Guest kernel: 2.6.32 based enterprise kernel
       - 4096MB memory
       - 8 VCPUs
    - During gang runs, vcpus are pinned
    
    Results:
     * Below numbers are average across 2runs
     * GangVsBase - Gang vs Baseline kernel
     * GangVsPin  - Gang vs Baseline kernel + vcpus pinned
     * V1 - patch 1, 2 and 3
     * V2 - v1 + patch4
     * Results are % improvement/degradation

    +-------------+---------------------------+-------------------------+
    |             |            V1 (%)         |             V2 (%)      |
    + Benchmarks  +-------------+-------------+-------------------------+
    |             | GangVsBase  |   GangVsPin |  GangVsBase | GangVsPin |
    +-------------+-------------+-------------+-------------------------+
    | kbench  2vm |       -1    |        1    |        1    |        3  |
    | kbench  4vm |      -10    |      -14    |       11    |        7  |
    | kbench  8vm |      -10    |      -13    |        8    |        6  |
    +-------------+-------------+-------------+-------------------------+
    | ebizzy  2vm |        0    |        3    |        2    |        5  |
    | ebizzy  4vm |        1    |        0    |        4    |        3  |
    | ebizzy  8vm |        0    |        1    |       23    |       26  |
    +-------------+-------------+-------------+-------------------------+
    | specjbb 2vm |       -3    |       -3    |      -17    |      -18  |
    | specjbb 4vm |       -9    |      -10    |      -33    |      -34  |
    | specjbb 8vm |      -19    |       -2    |       28    |       55  |
    +-------------+-------------+-------------+-------------------------+
    | hbench  2vm |        3    |      -14    |       28    |       15  |
    | hbench  4vm |      -66    |      -55    |      -20    |      -12  |
    | hbench  8vm |     -239    |      -92    |     -189    |      -64  |
    +-------------+-------------+-------------+-------------------------+
    | dbench  2vm |       -3    |       -3    |       -3    |       -3  |
    | dbench  4vm |      -11    |        3    |      -13    |        0  |
    | dbench  8vm |       25    |       -1    |       12    |      -12  |
    +-------------+-------------+-------------+-------------------------+

    Here are some additional data for the best and worst case in
    V2(GangVsBase). I am not able to figure out one/two data point
    that stands out always, that will say the gang sched
    improved/degraded for this reason.

    specjbb 8VM (improved 28%)
    +------------+--------------------+--------------------+----------+
    |                              SPECJBB                            |
    +------------+--------------------+--------------------+----------+
    | Parameter  |       Baseline     |         gang:V2    | % imprv  |
    +------------+--------------------+--------------------+----------+
    |       Score|            4173.19 |            5343.69 |       28 |
    |     BwUsage|   5745105989024.00 |   6566955369442.00 |       14 |
    |    HostIdle|              63.00 |              79.00 |      -25 |
    |     kvmExit|        31611242.00 |        52477831.00 |      -66 |
    |     UsrTime|              13.00 |              20.00 |       53 |
    |     SysTime|              16.00 |              12.00 |       25 |
    |      IOWait|               7.00 |               4.00 |       42 |
    |    IdleTime|              63.00 |              61.00 |       -3 |
    |         TPS|               7.00 |               6.00 |      -14 |
    | CacheMisses|     14272997833.00 |     14800182895.00 |       -3 |
    |   CacheRefs|     58143057220.00 |     69914413043.00 |       20 |
    |Instructions|   4397381980479.00 |   4572303159016.00 |       -3 |
    |      Cycles|   5884437898653.00 |   6489379310428.00 |      -10 |
    |   ContextSW|        10008378.00 |        14705944.00 |      -46 |
    |   CPUMigrat|           10501.00 |           21705.00 |     -106 |
    +-----------------------------------------------------------------+

    hbench 8VM (degraded 189%)
    +------------+--------------------+--------------------+----------+
    |                            Hackbench                            |
    +------------+--------------------+--------------------+----------+
    | Parameter  |        Baseline    |         gang:V2    | % imprv  |
    +------------+--------------------+--------------------+----------+
    |   HbenchAvg|              28.27 |              81.75 |     -189 |
    |     BwUsage|   1278656649466.00 |   2352504202657.00 |       83 |
    |    HostIdle|              82.00 |              80.00 |        2 |
    |     kvmExit|         6859301.00 |        31853895.00 |     -364 |
    |     UsrTime|              11.00 |              17.00 |       54 |
    |     SysTime|              17.00 |              13.00 |       23 |
    |      IOWait|               7.00 |               5.00 |       28 |
    |    IdleTime|              63.00 |              62.00 |       -1 |
    |         TPS|               8.00 |               7.00 |      -12 |
    | CacheMisses|       194565014.00 |       140098020.00 |       27 |
    |   CacheRefs|      4793875790.00 |     15942118793.00 |      232 |
    |Instructions|    430356490646.00 |   1006560006432.00 |     -133 |
    |      Cycles|    559463222878.00 |   1578421826236.00 |     -182 |
    |   ContextSW|         2587635.00 |         8110060.00 |     -213 |
    |   CPUMigrat|             967.00 |            3844.00 |     -297 |
    +-----------------------------------------------------------------+

    non-PLE - Test Setup:
    - x3650 M2 machine
    - 8 CPUs (HT disabled)
    - 64GB memory
    - VM details:
       - Guest kernel: 2.6.32 based enterprise kernel
       - 1024MB memory
       - 8 VCPUs
    - During gang runs, vcpus are pinned
    
    Results:
     * GangVsBase - Gang vs Baseline kernel
     * GangVsPin  - Gang vs Baseline kernel + vcpus pinned
     * V1 - patch 1, 2 and 3
     * V2 - V1 + patch4
     * Results are % improvement/degradation
    +-------------+---------------------------+-------------------------+
    |             |            V1             |             V2          |
    +-------------+-------------+-------------+-------------------------+
    |             | GangVsBase  |   GangVsPin |  GangVsBase | GangVsPin |
    +-------------+-------------+-------------+-------------------------+
    | kbench  2vm |       -3    |      -42    |       22    |     -6    |
    | kbench  4vm |        4    |      -11    |      -11    |    -29    |
    | kbench  8vm |       -4    |      -11    |       12    |      6    |
    +-------------+-------------+-------------+-------------------------+
    | ebizzy  2vm |     1333    |      772    |     1520    |    885    |
    | ebizzy  4vm |      525    |      423    |      930    |    761    |
    | ebizzy  8vm |      373    |      281    |      771    |    602    |
    +-------------+-------------+-------------+-------------------------+
    | specjbb 2vm |       -2    |       -1    |        0    |      0    |
    | specjbb 4vm |       -4    |       -7    |        2    |      0    |
    | specjbb 8vm |      -14    |      -17    |       -8    |    -11    |
    +-------------+-------------+-------------+-------------------------+
    | hbench  2vm |       12    |        0    |      -32    |    -49    |
    | hbench  4vm |     -234    |      -95    |       12    |     48    |
    | hbench  8vm |     -364    |      -69    |       -7    |     60    |
    +-------------+-------------+-------------+-------------------------+
    | dbench  2vm |      -13    |        3    |      -17    |     -1    |
    | dbench  4vm |       38    |       45    |       -2    |      1    |
    | dbench  8vm |      -36    |      -10    |       44    |    102    |
    +-------------+-------------+-------------+-------------------------+

    Similar data for the best and worst case in V2(GangVsBase). 

    ebizzy 2vm (improved 15 times, i.e. 1520%)
    +------------+--------------------+--------------------+----------+
    |                               Ebizzy                            |
    +------------+--------------------+--------------------+----------+
    | Parameter  |        Basline     |         gang:V2    | % imprv  |
    +------------+--------------------+--------------------+----------+
    | EbzyRecords|            1709.50 |           27701.00 |     1520 |
    |    EbzyUser|              20.48 |             376.64 |     1739 |
    |     EbzySys|            1384.65 |            1071.40 |       22 |
    |    EbzyReal|             300.00 |             300.00 |        0 |
    |     BwUsage|   2456114173416.00 |   2483447784640.00 |        1 |
    |    HostIdle|              34.00 |              35.00 |       -2 |
    |     UsrTime|               6.00 |              14.00 |      133 |
    |     SysTime|              30.00 |              24.00 |       20 |
    |      IOWait|              10.00 |               9.00 |       10 |
    |    IdleTime|              51.00 |              51.00 |        0 |
    |         TPS|              25.00 |              24.00 |       -4 |
    | CacheMisses|       766543805.00 |      8113721819.00 |     -958 |
    |   CacheRefs|      9420204706.00 |    136290854100.00 |     1346 |
    |BranchMisses|      1191336154.00 |     11336436452.00 |     -851 |
    |    Branches|    618882621656.00 |    459161727370.00 |      -25 |
    |Instructions|   2517045997661.00 |   2325227247092.00 |        7 |
    |      Cycles|   7642374654922.00 |   7657626973214.00 |        0 |
    |     PageFlt|           23779.00 |           22195.00 |        6 |
    |   ContextSW|         1517241.00 |         1786319.00 |      -17 |
    |   CPUMigrat|             537.00 |             241.00 |       55 |
    +-----------------------------------------------------------------+

    hbench 2vm (degraded 44%)
    +------------+--------------------+--------------------+----------+
    |                            Hackbench                            |
    +------------+--------------------+--------------------+----------+
    | Parameter  |     Non-Gang       |          gang:V2   | % imprv  |
    +------------+--------------------+--------------------+----------+
    |   HbenchAvg|               8.95 |              11.84 |      -32 |
    |     BwUsage|    140751454716.00 |    188528508986.00 |       33 |
    |    HostIdle|              46.00 |              41.00 |       10 |
    |     UsrTime|               6.00 |              13.00 |      116 |
    |     SysTime|              30.00 |              24.00 |       20 |
    |      IOWait|              10.00 |               9.00 |       10 |
    |    IdleTime|              52.00 |              52.00 |        0 |
    |         TPS|              24.00 |              23.00 |       -4 |
    | CacheMisses|       536001007.00 |       555837077.00 |       -3 |
    |   CacheRefs|      1388722056.00 |      1737837668.00 |       25 |
    |BranchMisses|       260102092.00 |       580784727.00 |     -123 |
    |    Branches|     25083812102.00 |     34960032641.00 |       39 |
    |Instructions|    136018192623.00 |    190522959512.00 |      -40 |
    |      Cycles|    232524382438.00 |    320669938332.00 |      -37 |
    |     PageFlt|            9562.00 |           10461.00 |       -9 |
    |   ContextSW|           78095.00 |          103097.00 |      -32 |
    |   CPUMigrat|             237.00 |             155.00 |       34 |
    +-----------------------------------------------------------------+

    For reference here are the benchmark parameters
    Kernbench: kernbench -f -M -H -o 16
    ebizzy: ebizzy -S 300 -t 16
    hbench: hackbench 8 (10000 loops)
    dbench: dbench 8 -t 120
    specjbb: 8 & 16 warehouses, 512MB heap, 120secs run

Thanks,
Nikunj

1. http://xen.org/files/xensummitboston08/LHP.pdf

---

Nikunj A. Dadhania (4):
      sched:Implement set_gang_buddy
      sched: Gang using set_next_buddy
      sched: Adding gang scheduling infrastrucure
      sched: Adding cpu.gang file to cpu cgroup


 kernel/sched/core.c  |   28 ++++++++++
 kernel/sched/fair.c  |  143 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h |    8 ++-
 3 files changed, 178 insertions(+), 1 deletions(-)

