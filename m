Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341Ab0J2S5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:57:15 -0400
Received: from claw.goop.org ([74.207.240.146]:45734 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758461Ab0J2S5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:57:12 -0400
Message-ID: <4CCB1906.4000608@goop.org>
Date: Fri, 29 Oct 2010 11:57:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Vasiliy G Tolstov <v.tolstov@selfip.ru>
Subject: [GIT PULL] Small Xen bugfixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Linus,

Here are some small Xen bugfixes:

    * fix dom0 boot on systems whose E820 doesn't completely cover the
      ISA address space.  This fixes a crash on a Dell R310.
    * fix misallocation of initial pagetables on 32-bit systems
      (sizeof(pmd_t) != sizeof(pmd_t *)).  In practice this didn't cause
      a problem because the following allocation was page-aligned so the
      padding was big enough to make up the difference.
    * in xenfs, properly report put_user failures to write back error status

The changes are on two branches:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/core

Ian Campbell (2):
      xen: do not release any memory under 1M in domain 0
      xen: correct size of level2_kernel_pgt

 arch/x86/xen/mmu.c   |    2 +-
 arch/x86/xen/setup.c |   31 ++++++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 6 deletions(-)

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/xenfs

Vasiliy Kulikov (1):
      xen: xenfs: privcmd: check put_user() return code

 drivers/xen/xenfs/privcmd.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

Thanks,
	J


diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index e41683c..13cd4eb 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2104,7 +2104,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 {
 	pmd_t *kernel_pmd;
 
-	level2_kernel_pgt = extend_brk(sizeof(pmd_t *) * PTRS_PER_PMD, PAGE_SIZE);
+	level2_kernel_pgt = extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
 
 	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
 				  xen_start_info->nr_pt_frames * PAGE_SIZE +
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 8e2c9f21..1f49951 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -84,6 +84,22 @@ static unsigned long __init xen_release_chunk(phys_addr_t start_addr,
 	start = PFN_UP(start_addr);
 	end = PFN_DOWN(end_addr);
 
+	/*
+	 * Domain 0 maintains a 1-1 P2M mapping for the first megabyte
+	 * so do not return such memory to the hypervisor.
+	 *
+	 * This region can contain various firmware tables and the
+	 * like which are often assumed to be always mapped and
+	 * available via phys_to_virt.
+	 */
+	if (xen_initial_domain()) {
+		if (end < PFN_DOWN(ISA_END_ADDRESS))
+			return 0;
+
+		if (start < PFN_DOWN(ISA_END_ADDRESS))
+			start = PFN_DOWN(ISA_END_ADDRESS);
+	}
+
 	if (end <= start)
 		return 0;
 
@@ -163,6 +179,7 @@ char * __init xen_memory_setup(void)
 		XENMEM_memory_map;
 	rc = HYPERVISOR_memory_op(op, &memmap);
 	if (rc == -ENOSYS) {
+		BUG_ON(xen_initial_domain());
 		memmap.nr_entries = 1;
 		map[0].addr = 0ULL;
 		map[0].size = mem_end;
@@ -200,12 +217,16 @@ char * __init xen_memory_setup(void)
 	}
 
 	/*
-	 * Even though this is normal, usable memory under Xen, reserve
-	 * ISA memory anyway because too many things think they can poke
-	 * about in there.
+	 * Even though this is normal, usable memory in a Xen domU,
+	 * reserve ISA memory anyway because too many things think
+	 * they can poke about in there.
+	 *
+	 * In dom0 we use the host e820 and therefore do not need to
+	 * specially reserved anything.
 	 */
-	e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
-			E820_RESERVED);
+	if (!xen_initial_domain())
+		e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
+				E820_RESERVED);
 
 	/*
 	 * Reserve Xen bits:
diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/xenfs/privcmd.c
index f80be7f..2eb04c8 100644
--- a/drivers/xen/xenfs/privcmd.c
+++ b/drivers/xen/xenfs/privcmd.c
@@ -266,9 +266,7 @@ static int mmap_return_errors(void *data, void *state)
 	xen_pfn_t *mfnp = data;
 	struct mmap_batch_state *st = state;
 
-	put_user(*mfnp, st->user++);
-
-	return 0;
+	return put_user(*mfnp, st->user++);
 }
 
 static struct vm_operations_struct privcmd_vm_ops;
@@ -323,10 +321,8 @@ static long privcmd_ioctl_mmap_batch(void __user *udata)
 	up_write(&mm->mmap_sem);
 
 	if (state.err > 0) {
-		ret = 0;
-
 		state.user = m.arr;
-		traverse_pages(m.num, sizeof(xen_pfn_t),
+		ret = traverse_pages(m.num, sizeof(xen_pfn_t),
 			       &pagelist,
 			       mmap_return_errors, &state);
 	}


