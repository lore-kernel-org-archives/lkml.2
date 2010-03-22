Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0CVJLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 05:11:45 -0400
Received: from mga05.intel.com ([192.55.52.89]:24518 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752459Ab0CVJLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 05:11:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,286,1267430400"; 
   d="scan'208";a="782781513"
Message-ID: <4BA7344C.6030108@linux.intel.com>
Date: Mon, 22 Mar 2010 17:11:40 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: ak@linux.intel.com, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, "Li, Haicheng" <haicheng.li@intel.com>,
       linux-kernel@vger.kernel.org
Subject: [BUGFIX] [PATCH] x86: update all PGDs for direct mapping changes
 on 64bit.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In our recent CPU/MEM hotplug testing, a kernel BUG() was found:

[ 1139.243192] BUG: soft lockup - CPU#0 stuck for 61s! [bash:6534]
[ 1139.243195] Modules linked in: ipv6 autofs4 rfcomm l2cap crc16 bluetooth rfkill binfmt_misc 
dm_mirror dm_region_hash dm_log dm_multipath dm_mod video output sbs sbshc fan battery ac parport_pc 
lp parport joydev usbhid processor thermal thermal_sys container button rtc_cmos rtc_core rtc_lib 
i2c_i801 i2c_core pcspkr uhci_hcd ohci_hcd ehci_hcd usbcore
[ 1139.243229] irq event stamp: 8538759
[ 1139.243230] hardirqs last  enabled at (8538759): [<ffffffff8100c3fc>] restore_args+0x0/0x30
[ 1139.243236] hardirqs last disabled at (8538757): [<ffffffff810422df>] __do_softirq+0x106/0x146
[ 1139.243240] softirqs last  enabled at (8538758): [<ffffffff81042310>] __do_softirq+0x137/0x146
[ 1139.243245] softirqs last disabled at (8538743): [<ffffffff8100cb5c>] call_softirq+0x1c/0x34
[ 1139.243249] CPU 0:
[ 1139.243250] Modules linked in: ipv6 autofs4 rfcomm l2cap crc16 bluetooth rfkill binfmt_misc 
dm_mirror dm_region_hash dm_log dm_multipath dm_mod video output sbs sbshc fan battery ac parport_pc 
lp parport joydev usbhid processor thermal thermal_sys container button rtc_cmos rtc_core rtc_lib 
i2c_i801 i2c_core pcspkr uhci_hcd ohci_hcd ehci_hcd usbcore
[ 1139.243284] Pid: 6534, comm: bash Tainted: G   M       2.6.32-haicheng-cpuhp #7 QSSC-S4R
[ 1139.243287] RIP: 0010:[<ffffffff810ace35>]  [<ffffffff810ace35>] alloc_arraycache+0x35/0x69
[ 1139.243292] RSP: 0018:ffff8802799f9d78  EFLAGS: 00010286
[ 1139.243295] RAX: ffff8884ffc00000 RBX: ffff8802799f9d98 RCX: 0000000000000000
[ 1139.243297] RDX: 0000000000190018 RSI: 0000000000000001 RDI: ffff8884ffc00010
[ 1139.243300] RBP: ffffffff8100c34e R08: 0000000000000002 R09: 0000000000000000
[ 1139.243303] R10: ffffffff8246dda0 R11: 000000d08246dda0 R12: ffff8802599bfff0
[ 1139.243305] R13: ffff88027904c040 R14: ffff8802799f8000 R15: 0000000000000001
[ 1139.243308] FS:  00007fe81bfe86e0(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 1139.243311] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1139.243313] CR2: ffff8884ffc00000 CR3: 000000026cf2d000 CR4: 00000000000006f0
[ 1139.243316] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1139.243318] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1139.243321] Call Trace:
[ 1139.243324]  [<ffffffff810ace29>] ? alloc_arraycache+0x29/0x69
[ 1139.243328]  [<ffffffff8135004e>] ? cpuup_callback+0x1b0/0x32a
[ 1139.243333]  [<ffffffff8105385d>] ? notifier_call_chain+0x33/0x5b
[ 1139.243337]  [<ffffffff810538a4>] ? __raw_notifier_call_chain+0x9/0xb
[ 1139.243340]  [<ffffffff8134ecfc>] ? cpu_up+0xb3/0x152
[ 1139.243344]  [<ffffffff813388ce>] ? store_online+0x4d/0x75
[ 1139.243348]  [<ffffffff811e53f3>] ? sysdev_store+0x1b/0x1d
[ 1139.243351]  [<ffffffff8110589f>] ? sysfs_write_file+0xe5/0x121
[ 1139.243355]  [<ffffffff810b539d>] ? vfs_write+0xae/0x14a
[ 1139.243358]  [<ffffffff810b587f>] ? sys_write+0x47/0x6f
[ 1139.243362]  [<ffffffff8100b9ab>] ? system_call_fastpath+0x16/0x1b

Below is the patch to fix this bug.

---
x86: update all PGDs for direct mapping changes on 64bit.

When memory hotadd/removal happens for a large enough area
that a new PGD entry is needed for the direct mapping, the PGDs
of other processes would not get updated. This leads to some CPUs
oopsing when they have to access the unmapped areas.

This patch makes sure to always replicate new direct mapping PGD entries
to the PGDs of all processes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
  arch/x86/mm/init_64.c |   82 ++++++++++++++++++++++++++++++++++++++++---------
  1 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e9b040e..384ca43 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -96,6 +96,37 @@ static int __init nonx32_setup(char *str)
  }
  __setup("noexec32=", nonx32_setup);

+
+/*
+ * When memory was added/removed make sure all the processes MM have
+ * suitable PGD entries in the local PGD level page.
+ * Caller must flush global TLBs if needed (old mapping changed)
+ */
+static void sync_global_pgds(unsigned long start, unsigned long end)
+{
+	unsigned long flags;
+	struct page *page;
+	unsigned long addr;
+
+	spin_lock_irqsave(&pgd_lock, flags);
+	for (addr = start; addr < end; addr += PGDIR_SIZE) {
+		pgd_t *ref_pgd = pgd_offset_k(addr);
+		list_for_each_entry(page, &pgd_list, lru) {
+			pgd_t *pgd_base = page_address(page);
+			pgd_t *pgd = pgd_base + pgd_index(addr);
+
+			/*
+			 * When the state is the same in one other,
+			 * assume it's the same everywhere.
+			 */
+			if (pgd_base != init_mm.pgd &&
+			    !!pgd_none(*pgd) != !!pgd_none(*ref_pgd))
+				set_pgd(pgd, *ref_pgd);
+		}
+	}
+	spin_unlock_irqrestore(&pgd_lock, flags);
+}
+
  /*
   * NOTE: This function is marked __ref because it calls __init function
   * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
@@ -217,6 +248,8 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
  	pgd_t *pgd;
  	pud_t *pud;
  	pmd_t *pmd;
+	int pgd_changed = 0;
+	unsigned long addr = phys;

  	BUG_ON((phys & ~PMD_MASK) || (size & ~PMD_MASK));
  	for (; size; phys += PMD_SIZE, size -= PMD_SIZE) {
@@ -225,6 +258,7 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
  			pud = (pud_t *) spp_getpage();
  			set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE |
  						_PAGE_USER));
+			pgd_changed = 1;
  		}
  		pud = pud_offset(pgd, (unsigned long)__va(phys));
  		if (pud_none(*pud)) {
@@ -236,6 +270,11 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
  		BUG_ON(!pmd_none(*pmd));
  		set_pmd(pmd, __pmd(phys | pgprot_val(prot)));
  	}
+	if (pgd_changed) {
+		sync_global_pgds(addr, addr + size);
+		/* Might not be needed if the previous mapping was always zero*/
+		__flush_tlb_all();
+	}
  }

  void __init init_extra_mapping_wb(unsigned long phys, unsigned long size)
@@ -533,36 +572,41 @@ kernel_physical_mapping_init(unsigned long start,
  			     unsigned long end,
  			     unsigned long page_size_mask)
  {
-
+	int pgd_changed = 0;
  	unsigned long next, last_map_addr = end;
+	unsigned long addr;

  	start = (unsigned long)__va(start);
  	end = (unsigned long)__va(end);

-	for (; start < end; start = next) {
-		pgd_t *pgd = pgd_offset_k(start);
+	for (addr = start; addr < end; addr = next) {
+		pgd_t *pgd = pgd_offset_k(addr);
  		unsigned long pud_phys;
  		pud_t *pud;

-		next = (start + PGDIR_SIZE) & PGDIR_MASK;
+		next = (addr + PGDIR_SIZE) & PGDIR_MASK;
  		if (next > end)
  			next = end;

  		if (pgd_val(*pgd)) {
-			last_map_addr = phys_pud_update(pgd, __pa(start),
+			last_map_addr = phys_pud_update(pgd, __pa(addr),
  						 __pa(end), page_size_mask);
  			continue;
  		}

  		pud = alloc_low_page(&pud_phys);
-		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
+		last_map_addr = phys_pud_init(pud, __pa(addr), __pa(next),
  						 page_size_mask);
  		unmap_low_page(pud);

  		spin_lock(&init_mm.page_table_lock);
  		pgd_populate(&init_mm, pgd, __va(pud_phys));
  		spin_unlock(&init_mm.page_table_lock);
+		pgd_changed = 1;
  	}
+
+	if (pgd_changed)
+		sync_global_pgds(start, end);
  	__flush_tlb_all();

  	return last_map_addr;
@@ -938,35 +982,37 @@ static int __meminitdata node_start;
  int __meminit
  vmemmap_populate(struct page *start_page, unsigned long size, int node)
  {
-	unsigned long addr = (unsigned long)start_page;
+	unsigned long start = (unsigned long)start_page;
  	unsigned long end = (unsigned long)(start_page + size);
-	unsigned long next;
+	unsigned long addr, next;
  	pgd_t *pgd;
  	pud_t *pud;
  	pmd_t *pmd;
+	int err = -ENOMEM;

-	for (; addr < end; addr = next) {
+	for (addr = start; addr < end; addr = next) {
  		void *p = NULL;

+		err = -ENOMEM;
  		pgd = vmemmap_pgd_populate(addr, node);
  		if (!pgd)
-			return -ENOMEM;
+			break;

  		pud = vmemmap_pud_populate(pgd, addr, node);
  		if (!pud)
-			return -ENOMEM;
+			break;

  		if (!cpu_has_pse) {
  			next = (addr + PAGE_SIZE) & PAGE_MASK;
  			pmd = vmemmap_pmd_populate(pud, addr, node);

  			if (!pmd)
-				return -ENOMEM;
+				break;

  			p = vmemmap_pte_populate(pmd, addr, node);

  			if (!p)
-				return -ENOMEM;
+				break;

  			addr_end = addr + PAGE_SIZE;
  			p_end = p + PAGE_SIZE;
@@ -979,7 +1025,7 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)

  				p = vmemmap_alloc_block_buf(PMD_SIZE, node);
  				if (!p)
-					return -ENOMEM;
+					break;

  				entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
  						PAGE_KERNEL_LARGE);
@@ -1000,9 +1046,15 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
  			} else
  				vmemmap_verify((pte_t *)pmd, node, addr, next);
  		}
+		err = 0;
+	}

+	if (!err) {
+		sync_global_pgds(start, end);
+		__flush_tlb_all();
  	}
-	return 0;
+
+	return err;
  }

  void __meminit vmemmap_populate_print_last(void)
-- 
1.5.6.1

-haicheng
