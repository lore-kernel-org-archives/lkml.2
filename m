Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2C2JUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:20:36 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:58696 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2C2JU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:20:29 -0400
Message-ID: <4F742951.7080003@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:20:17 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 00/13] KVM: MMU: fast page fault
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12032909-2674-0000-0000-000003DF68DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Idea
The present bit of page fault error code (EFEC.P) indicates whether the
page table is populated on all levels, if this bit is set, we can know
the page fault is caused by the page-protection bits (e.g. W/R bit) or
the reserved bits.

In KVM, in most cases, all this kind of page fault (EFEC.P = 1) can be
simply fixed: the page fault caused by reserved bit
(EFFC.P = 1 && EFEC.RSV = 1) has already been filtered out in fast mmio
path. What we need do to fix the rest page fault (EFEC.P = 1 && RSV != 1)
is just increasing the corresponding access on the spte.

This pachset introduces a fast path to fix this kind of page fault: it
is out of mmu-lock and need not walk host page table to get the mapping
from gfn to pfn.


* Advantage
- it is really fast
  it fixes page fault out of mmu-lock, and uses a very light way to avoid
  the race with other pathes. Also, it fixes page fault in the front of
  gfn_to_pfn, it means no host page table walking.

- we can get lots of page fault with PFEC.P = 1 in KVM:
  - in the case of ept/npt
  　after shadow page become stable (all gfn is mapped in shadow page table,
  　it is a short stage since only one shadow page table is used and only a
  　few of page is needed), almost all page fault is caused by write-protect
  　(frame-buffer under Xwindow, migration), the other small part is caused
  　by page merge/COW under KSM/THP.

  We do not hope it can fix the page fault caused by the read-only host
  page of KSM, since after COW, all the spte pointing to the gfn will be
  unmapped.

- in the case of soft mmu
  - many spurious page fault due to tlb lazily flushed
  - lots of write-protect page fault (dirty bit track for guest pte, shadow
    page table write-protected, frame-buffer under Xwindow, migration, ...)


* Implementation
We can freely walk the page between walk_shadow_page_lockless_begin and
walk_shadow_page_lockless_end, it can ensure all the shadow page is valid.

In the most case, cmpxchg is fair enough to change the access bit of spte,
but the write-protect path on softmmu/nested mmu is a especial case: it is
a read-check-modify path: read spte, check W bit, then clear W bit. In order
to avoid marking spte writable after/during page write-protect, we do the
trick like below:

      fast page fault path:
            lock RCU
            set identification in the spte
            smp_mb()
            if (!rmap.PTE_LIST_WRITE_PROTECT)
                 cmpxchg + w - vcpu-id
            unlock RCU

      write protect path:
            lock mmu-lock
            set rmap.PTE_LIST_WRITE_PROTECT
                 smp_mb()
            if (spte.w || spte has identification)
                 clear w bit and identification
            unlock mmu-lock

Setting identification in the spte is used to notify page-protect path to
modify the spte, then we can see the change in the cmpxchg.

Setting identification is also a trick: it only set the last bit of spte
that does not change the mapping and lose cpu status bits.

The identification should be unique to avoid the below race:

     VCPU 0                VCPU 1            VCPU 2
      lock RCU
   spte + identification
   check conditions
                       do write-protect, clear
                          identification
                                              lock RCU
                                        set identification
     cmpxchg + w - identification
        OOPS!!!

We choose the vcpu id as the unique value, currently, 254 vcpus on VMX
and 127 vcpus on softmmu can be fast. Keep it simply firtsly. :)


* Performance
It introduces a full memory barrier on the page write-protect path, i
have done the test of kernbench in the text mode which does not generate
write-protect page fault by frame-buffer avoiding the optimization
introduced by this patch, it shows no regression.

And there is the result tested by x11perf and migration on autotest:

x11perf (x11perf -repeat 10 -comppixwin500):
(Host: Intel(R) Core(TM) i5-2540M CPU @ 2.60GHz * 4 + 4G
 Guest: 4 vcpus + 1G)

- For ept:
$ x11perfcomp baseline-hard optimaze-hard
1: baseline-hard
2: optimaze-hard

     1         2    Operation
--------  --------  ---------
  7060.0    7150.0  Composite 500x500 from pixmap to window

- For shadow mmu:
$ x11perfcomp baseline-soft optimaze-soft
1: baseline-soft
2: optimaze-soft

     1         2    Operation
--------  --------  ---------
  6980.0    7490.0  Composite 500x500 from pixmap to window

( It is interesting that after this patch, the performance of x11perf on
  softmmu is better than it on hardmmu, i have tested it for many times,
  it is really true. :) )

autotest migration:
(Host: Intel(R) Xeon(R) CPU           X5690  @ 3.47GHz * 12 + 32G)

- For ept:

Before:
                    smp2.Fedora.16.64.migrate
Times   .unix      .with_autotest.dbench.unix     total
 1       102           204                         309
 2       68            203                         275
 3       67            218                         289

After:
                    smp2.Fedora.16.64.migrate
Times   .unix      .with_autotest.dbench.unix     total
 1       103           189                         295
 2       67            188                         259
 3       64            202                         271


- For shadow mmu:

Before:
                    smp2.Fedora.16.64.migrate
Times   .unix      .with_autotest.dbench.unix     total
 1       102           262                         368
 2       68            220                         292
 3       68            234                         307

After:
                    smp2.Fedora.16.64.migrate
Times   .unix      .with_autotest.dbench.unix     total
 1       104           231                         341
 2       68            218                         289
 3       66            205                         275


Any comments are welcome. :)

