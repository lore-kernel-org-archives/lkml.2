Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2LSPE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:04:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab2LSPEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:04:41 -0500
Date: Wed, 19 Dec 2012 16:04:37 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH v2] mm: limit mmu_gather batching to fix soft lockups on
 !CONFIG_PREEMPT
Message-ID: <20121219150423.GA12888@dhcp22.suse.cz>
References: <1355847088-1207-1-git-send-email-mhocko@suse.cz>
 <20121218140219.45867ddd.akpm@linux-foundation.org>
 <20121218235042.GA10350@dhcp22.suse.cz>
 <20121218160030.baf723aa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218160030.baf723aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 18-12-12 16:00:30, Andrew Morton wrote:
> On Wed, 19 Dec 2012 00:50:42 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Tue 18-12-12 14:02:19, Andrew Morton wrote:
> > > On Tue, 18 Dec 2012 17:11:28 +0100
> > > Michal Hocko <mhocko@suse.cz> wrote:
> > > 
> > > > Since e303297 (mm: extended batches for generic mmu_gather) we are batching
> > > > pages to be freed until either tlb_next_batch cannot allocate a new batch or we
> > > > are done.
> > > > 
> > > > This works just fine most of the time but we can get in troubles with
> > > > non-preemptible kernel (CONFIG_PREEMPT_NONE or CONFIG_PREEMPT_VOLUNTARY) on
> > > > large machines where too aggressive batching might lead to soft lockups during
> > > > process exit path (exit_mmap) because there are no scheduling points down the
> > > > free_pages_and_swap_cache path and so the freeing can take long enough to
> > > > trigger the soft lockup.
> > > > 
> > > > The lockup is harmless except when the system is setup to panic on
> > > > softlockup which is not that unusual.
> > > > 
> > > > The simplest way to work around this issue is to explicitly cond_resched per
> > > > batch in tlb_flush_mmu (1020 pages on x86_64).
> > > > 
> > > > ...
> > > >
> > > > --- a/mm/memory.c
> > > > +++ b/mm/memory.c
> > > > @@ -239,6 +239,7 @@ void tlb_flush_mmu(struct mmu_gather *tlb)
> > > >  	for (batch = &tlb->local; batch; batch = batch->next) {
> > > >  		free_pages_and_swap_cache(batch->pages, batch->nr);
> > > >  		batch->nr = 0;
> > > > +		cond_resched();
> > > >  	}
> > > >  	tlb->active = &tlb->local;
> > > >  }
> > > 
> > > tlb_flush_mmu() has a large number of callsites (or callsites which
> > > call callers, etc), many in arch code.  It's not at all obvious that
> > > tlb_flush_mmu() is never called from under spinlock?
> > 
> > free_pages_and_swap_cache calls lru_add_drain which in turn calls
> > put_cpu (aka preempt_enable) which is a scheduling point for
> > CONFIG_PREEMPT.
> 
> No, that inference doesn't work.  Because preempt_enable() inside
> spinlock is OK - it will not call schedule() because
> current->preempt_count is still elevated (by spin_lock).

Bahh, you are right. I was checking the callsites when patching our
internal kernel and it was really tedious so I thought this would be
easier to show.
Now when thinking about it some more it would be much safer to not
cond_resched unconditionally because this has a potential to blow up at
random places/archs. It sounds much more appropriate to kill the problem
where it started - an unbounded amount of batches. What do you think
about the following?
---
>From 658db334f7bef87168c3e8bc9b4a486e0055eabd Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 18 Dec 2012 17:02:20 +0100
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
number of batches in a single mmu_gather for !CONFIG_PREEMPT kernels.
Let's use 1G of resident memory for the limit for now. This shouldn't
make the batching less effective and it shouldn't trigger lockups as
well because freeing 262144 should be OK.

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

Changes since v1
- do not cond_resched in tlb_flush_mmu as we do not want to limit this
  interface for non atomic contexts and limit batching instead.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: stable@vger.kernel.org # 3.0 and higher
---
 include/asm-generic/tlb.h |   14 ++++++++++++++
 mm/memory.c               |    4 ++++
 2 files changed, 18 insertions(+)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index ed6642a..5843f59 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -78,6 +78,19 @@ struct mmu_gather_batch {
 #define MAX_GATHER_BATCH	\
 	((PAGE_SIZE - sizeof(struct mmu_gather_batch)) / sizeof(void *))
 
+/*
+ * Limit the maximum number of mmu_gather batches for non-preemptible kernels
+ * to reduce a risk of soft lockups on huge machines when a lot of memory is
+ * zapped during unmapping.
+ * 1GB of resident memory should be safe to free up at once even without
+ * explicit preemption point.
+ */
+#if defined(CONFIG_PREEMPT_COUNT)
+#define MAX_GATHER_BATCH_COUNT	(UINT_MAX)
+#else
+#define MAX_GATHER_BATCH_COUNT	(((1UL<<(30-PAGE_SHIFT))/MAX_GATHER_BATCH))
+#endif
+
 /* struct mmu_gather is an opaque type used by the mm code for passing around
  * any data needed by arch specific code for tlb_remove_page.
  */
@@ -96,6 +109,7 @@ struct mmu_gather {
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
