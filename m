Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2LTWgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:36:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57758 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2LTWg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:36:26 -0500
Date: Thu, 20 Dec 2012 23:36:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH v3] mm: limit mmu_gather batching to fix soft lockups on
 !CONFIG_PREEMPT
Message-ID: <20121220223623.GA9012@dhcp22.suse.cz>
References: <1355847088-1207-1-git-send-email-mhocko@suse.cz>
 <20121218140219.45867ddd.akpm@linux-foundation.org>
 <20121218235042.GA10350@dhcp22.suse.cz>
 <20121218160030.baf723aa.akpm@linux-foundation.org>
 <20121219150423.GA12888@dhcp22.suse.cz>
 <20121219131316.7d13fcb1.akpm@linux-foundation.org>
 <20121220124710.GA31912@dhcp22.suse.cz>
 <20121220122746.72d889fd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121220122746.72d889fd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-12-12 12:27:46, Andrew Morton wrote:
> On Thu, 20 Dec 2012 13:47:10 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > > > + */
> > > > +#if defined(CONFIG_PREEMPT_COUNT)
> > > > +#define MAX_GATHER_BATCH_COUNT	(UINT_MAX)
> > > > +#else
> > > > +#define MAX_GATHER_BATCH_COUNT	(((1UL<<(30-PAGE_SHIFT))/MAX_GATHER_BATCH))
> > > 
> > > Geeze.  I spent waaaaay too long staring at that expression trying to
> > > work out "how many pages is in a batch" and gave up.
> > > 
> > > Realistically, I don't think we need to worry about CONFIG_PREEMPT here
> > > - if we just limit the thing to, say, 64k pages per batch then that
> > > will be OK for preemptible and non-preemptible kernels. 
> > 
> > I wanted the fix to be as non-intrusive as possible so I didn't want to
> > touch PREEMPT (which is default in many configs) at all. I am OK to a
> > single limit of course.
> 
> non-intrusive is nice, but best-implementation is nicer.
> 
> > > The performance difference between "64k" and "infinite" will be
> > > miniscule and unmeasurable.
> > > 
> > > Also, the batch count should be independent of PAGE_SIZE.  Because
> > > PAGE_SIZE can vary by a factor of 16 and you don't want to fix the
> > > problem on 4k page size but leave it broken on 64k page size.
> > 
> > MAX_GATHER_BATCH depends on the page size so I didn't want to differ
> > without a good reason.
> 
> There's a good reason!  PAGE_SIZE can vary by a factor of 16, and if
> this results in the unpreemptible-CPU-effort varying by a factor of 16
> then that's bad, and we should change things so the
> unpreemptible-CPU-effort is independent of PAGE_SIZE.

Yes you are right. Let's make the number of entries (pages) fixed instead
(in the end we are just freeing pages which have more or less constant
cost). Then something like the following should work:
---
>From 839736c13064008a41fabf5de69c2f23d685a1fd Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 20 Dec 2012 23:25:24 +0100
Subject: [PATCH] mm: limit mmu_gather batching to fix soft lockups on
 !CONFIG_PREEMPT

Since e303297 (mm: extended batches for generic mmu_gather) we are batching
pages to be freed until either tlb_next_batch cannot allocate a new batch or we
are done.

This works just fine most of the time but we can get in troubles with
non-preemptible kernel (CONFIG_PREEMPT_NONE or CONFIG_PREEMPT_VOLUNTARY)
on large machines where too aggressive batching might lead to soft
lockups during process exit path (exit_mmap) because there are no
scheduling points down the free_pages_and_swap_cache path and so the
freeing can take long enough to trigger the soft lockup.

The lockup is harmless except when the system is setup to panic on
softlockup which is not that unusual.

The simplest way to work around this issue is to limit the maximum
number of batches in a single mmu_gather. 10k of collected pages should
be safe to prevent from soft lockups (we would have 2ms for one) even if
they are all freed without an explicit scheduling point.

This patch doesn't add any new explicit scheduling points because
it relies on zap_pmd_range during page tables zapping which calls
cond_resched per PMD.

The following lockup has been reported for 3.0 kernel with a huge process
(in order of hundreds gigs but I do know any more details).

[65674.040540] BUG: soft lockup - CPU#56 stuck for 22s! [kernel:31053]
[65674.040544] Modules linked in: af_packet nfs lockd fscache auth_rpcgss nfs_acl sunrpc mptctl mptbase autofs4 binfmt_misc dm_round_robin dm_multipath bonding cpufreq_conservative cpufreq_userspace cpufreq_powersave pcc_cpufreq mperf microcode fuse loop osst sg sd_mod crc_t10dif st qla2xxx scsi_transport_fc scsi_tgt netxen_nic i7core_edac iTCO_wdt joydev e1000e serio_raw pcspkr edac_core iTCO_vendor_support acpi_power_meter rtc_cmos hpwdt hpilo button container usbhid hid dm_mirror dm_region_hash dm_log linear uhci_hcd ehci_hcd usbcore usb_common scsi_dh_emc scsi_dh_alua scsi_dh_hp_sw scsi_dh_rdac scsi_dh dm_snapshot pcnet32 mii edd dm_mod raid1 ext3 mbcache jbd fan thermal processor thermal_sys hwmon cciss scsi_mod
[65674.040602] Supported: Yes
[65674.040604] CPU 56
[65674.040639] Pid: 31053, comm: kernel Not tainted 3.0.31-0.9-default #1 HP ProLiant DL580 G7
[65674.040643] RIP: 0010:[<ffffffff81443a88>]  [<ffffffff81443a88>] _raw_spin_unlock_irqrestore+0x8/0x10
[65674.040656] RSP: 0018:ffff883ec1037af0  EFLAGS: 00000206
[65674.040657] RAX: 0000000000000e00 RBX: ffffea01a0817e28 RCX: ffff88803ffd9e80
[65674.040659] RDX: 0000000000000200 RSI: 0000000000000206 RDI: 0000000000000206
[65674.040661] RBP: 0000000000000002 R08: 0000000000000001 R09: ffff887ec724a400
[65674.040663] R10: 0000000000000000 R11: dead000000200200 R12: ffffffff8144c26e
[65674.040665] R13: 0000000000000030 R14: 0000000000000297 R15: 000000000000000e
[65674.040667] FS:  00007ed834282700(0000) GS:ffff88c03f200000(0000) knlGS:0000000000000000
[65674.040669] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[65674.040671] CR2: 000000000068b240 CR3: 0000003ec13c5000 CR4: 00000000000006e0
[65674.040673] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[65674.040675] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[65674.040678] Process kernel (pid: 31053, threadinfo ffff883ec1036000, task ffff883ebd5d4100)
[65674.040680] Stack:
[65674.042972]  ffffffff810fc935 ffff88a9f1e182b0 0000000000000206 0000000000000009
[65674.042978]  0000000000000000 ffffea01a0817e60 ffffea0211d3a808 ffffea0211d3a840
[65674.042983]  ffffea01a0827a28 ffffea01a0827a60 ffffea0288a598c0 ffffea0288a598f8
[65674.042989] Call Trace:
[65674.045765]  [<ffffffff810fc935>] release_pages+0xc5/0x260
[65674.045779]  [<ffffffff811289dd>] free_pages_and_swap_cache+0x9d/0xc0
[65674.045786]  [<ffffffff81115d6c>] tlb_flush_mmu+0x5c/0x80
[65674.045791]  [<ffffffff8111628e>] tlb_finish_mmu+0xe/0x50
[65674.045796]  [<ffffffff8111c65d>] exit_mmap+0xbd/0x120
[65674.045805]  [<ffffffff810582d9>] mmput+0x49/0x120
[65674.045813]  [<ffffffff8105cbb2>] exit_mm+0x122/0x160
[65674.045818]  [<ffffffff8105e95a>] do_exit+0x17a/0x430
[65674.045824]  [<ffffffff8105ec4d>] do_group_exit+0x3d/0xb0
[65674.045831]  [<ffffffff8106f7c7>] get_signal_to_deliver+0x247/0x480
[65674.045840]  [<ffffffff81002931>] do_signal+0x71/0x1b0
[65674.045845]  [<ffffffff81002b08>] do_notify_resume+0x98/0xb0
[65674.045853]  [<ffffffff8144bb60>] int_signal+0x12/0x17
[65674.046737] DWARF2 unwinder stuck at int_signal+0x12/0x17

Changes since v2
- make the baches count limit depend on the number of entries rather
  than size of the freed memory

Changes since v1
- do not cond_resched in tlb_flush_mmu as we do not want to limit this
  interface for non atomic contexts and limit batching instead.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: stable@vger.kernel.org # 3.0 and higher
---
 include/asm-generic/tlb.h |    9 +++++++++
 mm/memory.c               |    4 ++++
 2 files changed, 13 insertions(+)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index ed6642a..25f01d0 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -78,6 +78,14 @@ struct mmu_gather_batch {
 #define MAX_GATHER_BATCH	\
 	((PAGE_SIZE - sizeof(struct mmu_gather_batch)) / sizeof(void *))
 
+/*
+ * Limit the maximum number of mmu_gather batches to reduce a risk of soft
+ * lockups for non-preemptible kernels on huge machines when a lot of memory
+ * is zapped during unmapping.
+ * 10K pages freed at once should be safe even without a preemption point.
+ */
+#define MAX_GATHER_BATCH_COUNT	(10000UL/MAX_GATHER_BATCH)
+
 /* struct mmu_gather is an opaque type used by the mm code for passing around
  * any data needed by arch specific code for tlb_remove_page.
  */
@@ -96,6 +104,7 @@ struct mmu_gather {
 	struct mmu_gather_batch *active;
 	struct mmu_gather_batch	local;
 	struct page		*__pages[MMU_GATHER_BUNDLE];
+	unsigned int		batch_count;
 };
 
 #define HAVE_GENERIC_MMU_GATHER
diff --git a/mm/memory.c b/mm/memory.c
index 1f6cae4..d4aebd9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -183,10 +183,14 @@ static int tlb_next_batch(struct mmu_gather *tlb)
 		return 1;
 	}
 
+	if (tlb->batch_count == MAX_GATHER_BATCH_COUNT)
+		return 0;
+
 	batch = (void *)__get_free_pages(GFP_NOWAIT | __GFP_NOWARN, 0);
 	if (!batch)
 		return 0;
 
+	tlb->batch_count++;
 	batch->next = NULL;
 	batch->nr   = 0;
 	batch->max  = MAX_GATHER_BATCH;
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
