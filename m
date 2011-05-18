Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1ERPet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:34:49 -0400
Received: from relay2.sgi.com ([192.48.179.30]:35272 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756547Ab1ERPes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:34:48 -0400
Date: Wed, 18 May 2011 10:34:45 -0500
From: Russ Anderson <rja@sgi.com>
To: Andrea Arcangeli <aarcange@redhat.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Russ Anderson <rja@sgi.com>
Subject: [PATCH] [BUGFIX] mm: hugepages can cause negative commitlimit
Message-ID: <20110518153445.GA18127@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the total size of hugepages allocated on a system is
over half of the total memory size, commitlimit becomes
a negative number.

What happens in fs/proc/meminfo.c is this calculation:

        allowed = ((totalram_pages - hugetlb_total_pages())
                * sysctl_overcommit_ratio / 100) + total_swap_pages;

The problem is that hugetlb_total_pages() is larger than
totalram_pages resulting in a negative number.  Since
allowed is an unsigned long the negative shows up as a
big number.  

A similar calculation occurs in __vm_enough_memory() in mm/mmap.c.

A symptom of this problem is that /proc/meminfo prints a
very large CommitLimit number.

CommitLimit:    737869762947802600 kB

To reproduce the problem reserve over half of memory as hugepages.
For example "default_hugepagesz=1G hugepagesz=1G hugepages=64
Then look at /proc/meminfo "CommitLimit:" to see if it is too big.

The fix is to not subtract hugetlb_total_pages().  When hugepages
are allocated totalram_pages is decremented so there is no need to
subtract out hugetlb_total_pages() a second time.

Reported-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Russ Anderson <rja@sgi.com>

---

Example of "CommitLimit:" being too big.

uv1-sys:~ # cat /proc/meminfo
MemTotal:       32395508 kB
MemFree:        32029276 kB
Buffers:            8656 kB
Cached:            89548 kB
SwapCached:            0 kB
Active:            55336 kB
Inactive:          73916 kB
Active(anon):      31220 kB
Inactive(anon):       36 kB
Active(file):      24116 kB
Inactive(file):    73880 kB
Unevictable:           0 kB
Mlocked:               0 kB                                                                                  
SwapTotal:             0 kB
SwapFree:              0 kB
Dirty:              1692 kB
Writeback:             0 kB
AnonPages:         31132 kB
Mapped:            15668 kB
Shmem:               152 kB
Slab:              70256 kB
SReclaimable:      17148 kB
SUnreclaim:        53108 kB
KernelStack:        6536 kB
PageTables:         3704 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    737869762947802600 kB
Committed_AS:     394044 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      713960 kB
VmallocChunk:   34325764204 kB
HardwareCorrupted:     0 kB
HugePages_Total:      32
HugePages_Free:       32
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:    1048576 kB
DirectMap4k:       16384 kB
DirectMap2M:     2064384 kB
DirectMap1G:    65011712 kB

 fs/proc/meminfo.c |    2 +-
 mm/mmap.c         |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

Index: linux/fs/proc/meminfo.c
===================================================================
--- linux.orig/fs/proc/meminfo.c	2011-05-17 16:03:50.935658801 -0500
+++ linux/fs/proc/meminfo.c	2011-05-18 08:53:00.568784147 -0500
@@ -36,7 +36,7 @@ static int meminfo_proc_show(struct seq_
 	si_meminfo(&i);
 	si_swapinfo(&i);
 	committed = percpu_counter_read_positive(&vm_committed_as);
-	allowed = ((totalram_pages - hugetlb_total_pages())
+	allowed = (totalram_pages
 		* sysctl_overcommit_ratio / 100) + total_swap_pages;
 
 	cached = global_page_state(NR_FILE_PAGES) -
Index: linux/mm/mmap.c
===================================================================
--- linux.orig/mm/mmap.c	2011-05-17 16:03:51.727658828 -0500
+++ linux/mm/mmap.c	2011-05-18 08:54:34.912222405 -0500
@@ -167,8 +167,7 @@ int __vm_enough_memory(struct mm_struct
 		goto error;
 	}
 
-	allowed = (totalram_pages - hugetlb_total_pages())
-	       	* sysctl_overcommit_ratio / 100;
+	allowed = totalram_pages * sysctl_overcommit_ratio / 100;
 	/*
 	 * Leave the last 3% for root
 	 */
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
