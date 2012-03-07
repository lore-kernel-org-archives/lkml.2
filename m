Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2CGIBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:01:24 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60720 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2CGIBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:01:23 -0500
Date: Wed, 7 Mar 2012 17:07:45 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 changelog-v2] KVM: Switch to srcu-less
 get_dirty_log()
Message-Id: <20120307170745.3147f776.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120306152850.GB3353@amt.cnet>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
	<20120303142148.2689454b30dc86d84c4a19f5@gmail.com>
	<20120306111540.GA29914@amt.cnet>
	<20120306234317.2817d2071038d11ab3831c82@gmail.com>
	<20120306150104.GA3041@amt.cnet>
	<20120307002317.d8682de9c6ccd6af8ccac467@gmail.com>
	<20120306152850.GB3353@amt.cnet>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti <mtosatti@redhat.com> wrote:

> > Partly yes: my method mainly depends on the number of dirty pages,
> > not slot size.
> > 
> > But it is not a new problem: traversing all shadow pages for that
> > also takes linearly increasing time.
> 
> It was not necessary to read the bitmap under mmu_lock previously.

Let's check actual data!

Below I pasted a simple test result to show that reading bitmap is not
a problem at all compared to traversing shadow pages.

** During doing the same live migration test as:

  For real workloads, both VGA and live migration, we have observed pure
  improvements: when the guest was reading a file during live migration,
  we originally saw a few ms of latency, but with the new method the
  latency was less than 200us.

I measured how long the current method takes to just write protect sptes
with the mmu_lock held - kvm_mmu_slot_remove_write_access() time.


You can see many ms order of protection times from this result: for me this
is more problematic than downtime problem many people like to improve.

In contrast my method only took 200us in the worst case: actually what I
measured for that was the entire kvm_vm_ioctl_get_dirty_log() time which
contained more extra tasks, e.g. copy_to_user().

  FYI: changing the guest memory size from 4GB to 8GB did not show any
  siginificant change to my method, but, as you can guess, traversing
  shadow pages will need more time for increased shadow pages.


If we have 4K shadow pages in the slot, kvm_mmu_slot_remove_write_access()
have to traverse all of them, checking all 512 entries in them.

Compared to that, the bitmap size of 4GB memory slot is 1M bits = 128KB.
Reading this 8 pages is negligible.

My unit-test experiment has also showed that xchg overheads is not so much,
compared to others:

   493900.4   15911.9       60.2      125%     5%      8K
   760268.2    5929.6       46.4       63%   199%     16K
  1238709.6    7123.5       37.8       23%   173%     32K
  2359523.6    3121.7       36.0       -9%    87%     64K
  4540780.6   10155.6       34.6      -27%    30%    128K
  8747274.0   10973.3       33.3      -31%    -3%    256K

Note that these cases need to xchg the entire dirty bitmap because at least
one bit is set for each unsigned-long-word.

The big difference came from the number of sptes to protect alone.

	Takuya

===
funcgraph_entry:      + 25.123 us  |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      + 35.746 us  |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 922.886 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      + 20.153 us  |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      + 20.424 us  |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      + 17.595 us  |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      + 20.240 us  |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 9783.060 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1992.718 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1312.128 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2028.900 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1455.889 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1382.795 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2030.321 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1407.248 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2189.321 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1444.344 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2291.976 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1801.848 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1993.104 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1531.858 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2394.283 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1613.203 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1699.472 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2416.467 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1566.451 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1772.670 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1700.544 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1590.114 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2311.419 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1923.888 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2534.780 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2083.623 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1664.170 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2867.553 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2684.615 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1706.371 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2655.976 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1720.777 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2993.758 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1924.842 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 3091.190 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1776.427 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2808.984 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2669.008 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2359.525 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2703.617 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2623.198 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1942.833 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1906.551 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2981.093 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2168.301 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1949.932 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2992.925 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 3360.511 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1993.321 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 3187.857 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 1989.417 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2001.865 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2047.220 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 3107.808 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2039.732 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2057.575 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2417.748 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2076.445 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2308.323 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 3216.713 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2148.263 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2269.673 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 2133.566 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 3757.388 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 3372.302 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 3679.316 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 3516.200 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 630.067 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 3191.830 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      ! 658.717 us |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      + 66.683 us  |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:      + 31.027 us  |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:        0.274 us   |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:        0.568 us   |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:        0.460 us   |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:        0.358 us   |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:        0.197 us   |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:        0.306 us   |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:        0.259 us   |  kvm_mmu_slot_remove_write_access();
funcgraph_entry:        0.181 us   |  kvm_mmu_slot_remove_write_access();
