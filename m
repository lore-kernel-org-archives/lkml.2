Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0KKXff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:35:35 -0500
Received: from claw.goop.org ([74.207.240.146]:41048 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0KKXfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:35:34 -0500
Message-ID: <4CDC7DC4.5070406@goop.org>
Date: Thu, 11 Nov 2010 15:35:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [GIT PULL] Xen bug fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some Xen bugfixes against -rc1.  This is another spin of the
"don't free memory below 1M" patch the last time around.  I played
around with it a bit and slightly improved it, but I couldn't find
anything substantially prettier.

The other significant fix here is from Stefano which allows domain
creation to work - it seems that one or both of aaead25b9 and
c9d0bf24145 exposed the fact that we should have been setting VM_PFNMAP
on these cross-domain mappings.

There's also a fix for save/restore - we have IPI interrupts which
should not be disabled by a suspend, but they still need some specific
setup on resume.

There are two branches:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/core

Ian Campbell (3):
      xen: correct size of level2_kernel_pgt
      xen: events: do not unmask event channels on resume
      xen: do not release any memory under 1M in domain 0

 arch/x86/xen/mmu.c   |    2 +-
 arch/x86/xen/setup.c |   18 +++++++++++-------
 drivers/xen/events.c |   25 ++++++++++++++++++-------
 3 files changed, 30 insertions(+), 15 deletions(-)

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/xenfs

Stefano Stabellini (1):
      xen: set vma flag VM_PFNMAP in the privcmd mmap file_op

Vasiliy Kulikov (1):
      xen: xenfs: privcmd: check put_user() return code

 arch/x86/xen/mmu.c          |    3 ++-
 drivers/xen/xenfs/privcmd.c |   13 +++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

Thanks,
	J

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index c237b81..21ed8d7 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2126,7 +2126,7 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 {
 	pmd_t *kernel_pmd;
 
-	level2_kernel_pgt = extend_brk(sizeof(pmd_t *) * PTRS_PER_PMD, PAGE_SIZE);
+	level2_kernel_pgt = extend_brk(sizeof(pmd_t) * PTRS_PER_PMD, PAGE_SIZE);
 
 	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
 				  xen_start_info->nr_pt_frames * PAGE_SIZE +
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index b1dbdaa..769c4b0 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -118,16 +118,18 @@ static unsigned long __init xen_return_unused_memory(unsigned long max_pfn,
 						     const struct e820map *e820)
 {
 	phys_addr_t max_addr = PFN_PHYS(max_pfn);
-	phys_addr_t last_end = 0;
+	phys_addr_t last_end = ISA_END_ADDRESS;
 	unsigned long released = 0;
 	int i;
 
+	/* Free any unused memory above the low 1Mbyte. */
 	for (i = 0; i < e820->nr_map && last_end < max_addr; i++) {
 		phys_addr_t end = e820->map[i].addr;
 		end = min(max_addr, end);
 
-		released += xen_release_chunk(last_end, end);
-		last_end = e820->map[i].addr + e820->map[i].size;
+		if (last_end < end)
+			released += xen_release_chunk(last_end, end);
+		last_end = max(last_end, e820->map[i].addr + e820->map[i].size);
 	}
 
 	if (last_end < max_addr)
@@ -164,6 +166,7 @@ char * __init xen_memory_setup(void)
 		XENMEM_memory_map;
 	rc = HYPERVISOR_memory_op(op, &memmap);
 	if (rc == -ENOSYS) {
+		BUG_ON(xen_initial_domain());
 		memmap.nr_entries = 1;
 		map[0].addr = 0ULL;
 		map[0].size = mem_end;
@@ -201,12 +204,13 @@ char * __init xen_memory_setup(void)
 	}
 
 	/*
-	 * Even though this is normal, usable memory under Xen, reserve
-	 * ISA memory anyway because too many things think they can poke
+	 * In domU, the ISA region is normal, usable memory, but we
+	 * reserve ISA memory anyway because too many things poke
 	 * about in there.
 	 *
-	 * In a dom0 kernel, this region is identity mapped with the
-	 * hardware ISA area, so it really is out of bounds.
+	 * In Dom0, the host E820 information can leave gaps in the
+	 * ISA range, which would cause us to release those pages.  To
+	 * avoid this, we unconditionally reserve them here.
 	 */
 	e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
 			E820_RESERVED);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 97612f5..321a0c8 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -1299,9 +1299,6 @@ static void restore_cpu_virqs(unsigned int cpu)
 		evtchn_to_irq[evtchn] = irq;
 		irq_info[irq] = mk_virq_info(evtchn, virq);
 		bind_evtchn_to_cpu(evtchn, cpu);
-
-		/* Ready for use. */
-		unmask_evtchn(evtchn);
 	}
 }
 
@@ -1327,10 +1324,6 @@ static void restore_cpu_ipis(unsigned int cpu)
 		evtchn_to_irq[evtchn] = irq;
 		irq_info[irq] = mk_ipi_info(evtchn, ipi);
 		bind_evtchn_to_cpu(evtchn, cpu);
-
-		/* Ready for use. */
-		unmask_evtchn(evtchn);
-
 	}
 }
 
@@ -1390,6 +1383,7 @@ void xen_poll_irq(int irq)
 void xen_irq_resume(void)
 {
 	unsigned int cpu, irq, evtchn;
+	struct irq_desc *desc;
 
 	init_evtchn_cpu_bindings();
 
@@ -1408,6 +1402,23 @@ void xen_irq_resume(void)
 		restore_cpu_virqs(cpu);
 		restore_cpu_ipis(cpu);
 	}
+
+	/*
+	 * Unmask any IRQF_NO_SUSPEND IRQs which are enabled. These
+	 * are not handled by the IRQ core.
+	 */
+	for_each_irq_desc(irq, desc) {
+		if (!desc->action || !(desc->action->flags & IRQF_NO_SUSPEND))
+			continue;
+		if (desc->status & IRQ_DISABLED)
+			continue;
+
+		evtchn = evtchn_from_irq(irq);
+		if (evtchn == -1)
+			continue;
+
+		unmask_evtchn(evtchn);
+	}
 }
 
 static struct irq_chip xen_dynamic_chip __read_mostly = {
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index f08ea04..792de43 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2299,7 +2299,8 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 
 	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
 
-	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
+	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_RESERVED | VM_IO)) ==
+				(VM_PFNMAP | VM_RESERVED | VM_IO)));
 
 	rmd.mfn = mfn;
 	rmd.prot = prot;
diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/xenfs/privcmd.c
index f80be7f..88474d4 100644
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
@@ -384,8 +380,9 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return -ENOSYS;
 
-	/* DONTCOPY is essential for Xen as copy_page_range is broken. */
-	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY;
+	/* DONTCOPY is essential for Xen because copy_page_range doesn't know
+	 * how to recreate these mappings */
+	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY | VM_PFNMAP;
 	vma->vm_ops = &privcmd_vm_ops;
 	vma->vm_private_data = NULL;
 


