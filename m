Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2BWL0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 06:26:44 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41660 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2BWL0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 06:26:42 -0500
Date: Thu, 23 Feb 2012 20:33:00 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 0/4] KVM: srcu-less dirty logging
Message-Id: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is the result of the integration of my dirty logging
optimization work, including preparation for the new GET_DIRTY_LOG API,
and the attempt to get rid of controversial synchronize_srcu_expedited().

1 - KVM: MMU: Split the main body of rmap_write_protect() off from others
2 - KVM: Avoid checking huge page mappings in get_dirty_log()
3 - KVM: Switch to srcu-less get_dirty_log()
4 - KVM: Remove unused dirty_bitmap_head and nr_dirty_pages

Although there are still some remaining tasks, the test result obtained
looks very promising.


Remaining tasks:

- Implement set_bit_le() for mark_page_dirty()

  Some drivers are using their own implementation of it and a bit of
  work is needed to make it generic.  I want to do this separately
  later because it cannot be done within kvm tree.

- Stop allocating extra dirty bitmap buffer area

  According to Peter, mmu_notifier has become preemptible.  If we can
  change mmu_lock from spin_lock to mutex_lock, as Avi said before, this
  would be staightforward because we can use __put_user() right after
  xchg() with the mmu_lock held.


Test results:

1. dirty-log-perf unit test (on Sandy Bridge core-i3 32-bit host)

With some changes added since the previous post, the performance was
much improved: now even when every page in the slot is dirty, the number
is reasonably close to the original one.  For others, needless to say,
we have achieved very nice improvement.

- kvm.git next
average(ns)    stdev     ns/page    pages

 147018.6    77604.9    147018.6        1
 158080.2    82211.9     79040.1        2
 127555.6    80619.8     31888.9        4
 108865.6    78499.3     13608.2        8
 114707.8    43508.6      7169.2       16
  76679.0    37659.8      2396.2       32
  59159.8    20417.1       924.3       64
  60418.2    19405.7       472.0      128
  76267.0    21450.5       297.9      256
 113182.0    22684.9       221.0      512
 930344.2   153766.5       908.5       1K
 939098.2   163800.3       458.5       2K
 996813.4    77921.0       243.3       4K
1113232.6   107782.6       135.8       8K
1241206.4    82282.5        75.7      16K
1529526.4   116388.2        46.6      32K
2147538.4   227375.9        32.7      64K
3309619.4    79356.8        25.2     128K
6016951.8   549873.4        22.9     256K

- kvm.git next + srcu-less series
average(ns)    stdev     ns/page    pages    improvement(%)

  14086.0     3532.3     14086.0        1     944
  13303.6     3317.7      6651.8        2    1088
  13455.6     3315.2      3363.9        4     848
  14125.8     3435.4      1765.7        8     671
  15322.4     3690.1       957.6       16     649
  17026.6     4037.2       532.0       32     350
  21258.6     4852.3       332.1       64     178
  33845.6    14115.8       264.4      128      79
  37893.0      681.8       148.0      256     101
  61707.4     1057.6       120.5      512      83
  88861.4     2131.0        86.7       1K     947
 151315.6     6490.5        73.8       2K     521
 290579.6     8523.0        70.9       4K     243
 518231.0    20412.6        63.2       8K     115
2271171.4    12064.9       138.6      16K     -45
3375866.2    14743.3       103.0      32K     -55
4408395.6    10720.0        67.2      64K     -51
5915336.2    26538.1        45.1     128K     -44
8497356.4    16441.0        32.4     256K     -29

Note that when the number of dirty pages was large, we spent less than
100ns for getting one dirty page information: see ns/page column.

As Avi noted before, this is much faster than the userspace send one
page to the destination node.

Furthermore, with the already proposed new GET_DIRTY_LOG API, we will
be able to restrict the area from which we get the log and will not need
to care about ms order of latency observed for very large number of dirty
pages.

2. real workloads (on Xeon W3520 64-bit host)

I traced kvm_vm_ioctl_get_dirty_log() during heavy VGA updates and
during live migration.

2.1. VGA: guest was doing "x11perf -rect1 -rect10 -rect100 -rect500"

As can be guessed from the result of dirty-log-perf, we observed very
nice improvement.

- kvm.git next
For heavy updates: 100us to 300us.
Worst: 300us

- kvm.git next + srcu-less series
For heavy updates: 3us to 10us.
Worst: 50us.

2.2. live migration: guest was doing "dd if=/path/to/a/file of=/dev/null"

The improvement was significant again.

- kvm.git next
For heavy updates: 1ms to 3ms

- kvm.git next + srcu-less series
For heavy updates: 50us to 300us

Probably we gained a lot from the locality of WWS.


	Takuya
