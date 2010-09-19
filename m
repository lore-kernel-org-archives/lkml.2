Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0ISPBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 11:01:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:53715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab0ISPBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 11:01:34 -0400
Message-ID: <4C962617.4020308@kernel.org>
Date: Sun, 19 Sep 2010 17:02:47 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, dhowells@redhat.com,
        graff yang <graff.yang@gmail.com>, sonic adi <sonic.adi@gmail.com>,
        kexec <kexec@lists.infradead.org>,
        Chris Lalancette <clalance@redhat.com>
Subject: Re: kvm kdump regression
References: <575271221.1298091284813406110.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <575271221.1298091284813406110.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 19 Sep 2010 15:01:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2010 02:36 PM, CAI Qian wrote:
>> Can you please apply the following patch, reproduce the problem and
>> report the kernel log?
> Tejun, which version this patch is against? Both 2.6.36-rc2-mm1 and 2.6.36-rc4-mm1 failed to apply it,

The patch was against percpu#for-next branch.  Below is a patch
regenerated against the current linux-next.

Thanks.

diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index bf43188..9510e7d 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -13,6 +13,7 @@
 /* Stores the physical address of elf header of crash image. */
 unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;

+void per_cpu_ptr_to_phys_failed(void *addr);
 /**
  * copy_oldmem_page - copy one page from "oldmem"
  * @pfn: page frame number to be copied
@@ -35,8 +36,10 @@ ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
 		return 0;

 	vaddr = ioremap_cache(pfn << PAGE_SHIFT, PAGE_SIZE);
-	if (!vaddr)
+	if (!vaddr) {
+		per_cpu_ptr_to_phys_failed(vaddr);
 		return -ENOMEM;
+	}

 	if (userbuf) {
 		if (copy_to_user(buf, vaddr + offset, csize)) {
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 7d9c1d0..357569a 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -415,6 +415,7 @@ static struct pcpu_chunk *pcpu_create_chunk(void)
 {
 	struct pcpu_chunk *chunk;
 	struct vm_struct **vms;
+	int i;

 	chunk = pcpu_alloc_chunk();
 	if (!chunk)
@@ -429,6 +430,13 @@ static struct pcpu_chunk *pcpu_create_chunk(void)

 	chunk->data = vms;
 	chunk->base_addr = vms[0]->addr - pcpu_group_offsets[0];
+	chunk->chunkno = ++chunkno;
+	printk("XXX chunk %d allocated base_addr=%p\n",
+	       chunk->chunkno, chunk->base_addr);
+	printk("XXX VMS:");
+	for (i = 0; i < pcpu_nr_groups; i++)
+		printk(" %zu@%p", vms[i]->size, vms[i]->addr);
+	printk("\n");
 	return chunk;
 }

diff --git a/mm/percpu.c b/mm/percpu.c
index 77e3f5a..f4b094b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -96,7 +96,10 @@
 #define __pcpu_ptr_to_addr(ptr)		(void __force *)(ptr)
 #endif	/* CONFIG_SMP */

+static int chunkno;
+
 struct pcpu_chunk {
+	int			chunkno;
 	struct list_head	list;		/* linked to pcpu_slot lists */
 	int			free_size;	/* free bytes in the chunk */
 	int			contig_hint;	/* max contiguous size hint */
@@ -182,6 +185,40 @@ static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
 static void pcpu_reclaim(struct work_struct *work);
 static DECLARE_WORK(pcpu_reclaim_work, pcpu_reclaim);

+void pcpu_dump_chunk(struct pcpu_chunk *chunk)
+{
+	int i, contig = 0, free = 0;
+
+	printk("XXX   %d(f=%d,c=%d,u=%d,a=%d)", chunk->chunkno,
+	       chunk->free_size, chunk->contig_hint,
+	       chunk->map_used, chunk->map_alloc);
+	for (i = 0; i < chunk->map_used; i++) {
+		if (chunk->map[i] > 0) {
+			free += chunk->map[i];
+			contig = max(contig, chunk->map[i]);
+		}
+		printk(" %d", chunk->map[i]);
+	}
+	printk(" free=%d contig=%d%s\n", free, contig,
+	       (free != chunk->free_size || contig != chunk->contig_hint) ?
+	       " MISMATCH!" : "");
+}
+
+void pcpu_dump_chunk_slots(void)
+{
+	struct pcpu_chunk *chunk;
+	int i;
+
+	printk("XXX percpu allocator dump\n");
+	for (i = 0; i < pcpu_nr_slots; i++) {
+		if (list_empty(&pcpu_slot[i]))
+			continue;
+		printk("XXX  SLOT[%02d]\n", i);
+		list_for_each_entry(chunk, &pcpu_slot[i], list)
+			pcpu_dump_chunk(chunk);
+	}
+}
+
 static bool pcpu_addr_in_first_chunk(void *addr)
 {
 	void *first_start = pcpu_first_chunk->base_addr;
@@ -1021,6 +1058,19 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
 		return page_to_phys(pcpu_addr_to_page(addr));
 }

+void per_cpu_ptr_to_phys_failed(void *addr)
+{
+	phys_addr_t phys;
+	unsigned long flags;
+
+	phys = per_cpu_ptr_to_phys(addr);
+	printk("XXX per_cpu_ptry_to_phys(%p) returned invalid address 0x%llx\n",
+	       addr, (unsigned long long)phys);
+	spin_lock_irqsave(&pcpu_lock, flags);
+	pcpu_dump_chunk_slots();
+	spin_unlock_irqrestore(&pcpu_lock, flags);
+}
+
 /**
  * pcpu_alloc_alloc_info - allocate percpu allocation info
  * @nr_groups: the number of groups
@@ -1283,6 +1333,11 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
 		BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long);

+	printk("XXX CPU->UNIT M/O");
+	for_each_possible_cpu(cpu)
+		printk(" %d:%lx", unit_map[cpu], unit_off[cpu]);
+	printk("\n");
+
 	/*
 	 * Allocate chunk slots.  The additional last slot is for
 	 * empty chunks.
@@ -1292,6 +1347,10 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	for (i = 0; i < pcpu_nr_slots; i++)
 		INIT_LIST_HEAD(&pcpu_slot[i]);

+	printk("XXX ss=%zu up=%d us=%d ns=%d rs=%zd ds=%zd\n",
+	       ai->static_size, pcpu_unit_pages, pcpu_unit_size,
+	       pcpu_nr_slots, ai->reserved_size, dyn_size);
+
 	/*
 	 * Initialize static chunk.  If reserved_size is zero, the
 	 * static chunk covers static area + dynamic allocation area
@@ -1311,6 +1370,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 		schunk->free_size = ai->reserved_size;
 		pcpu_reserved_chunk = schunk;
 		pcpu_reserved_chunk_limit = ai->static_size + ai->reserved_size;
+		schunk->chunkno = -1;
 	} else {
 		schunk->free_size = dyn_size;
 		dyn_size = 0;			/* dynamic area covered */
@@ -1340,6 +1400,12 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	pcpu_first_chunk = dchunk ?: schunk;
 	pcpu_chunk_relocate(pcpu_first_chunk, -1);

+	if (pcpu_reserved_chunk) {
+		printk("XXX reserved chunk\n");
+		pcpu_dump_chunk(pcpu_reserved_chunk);
+	}
+	pcpu_dump_chunk_slots();
+
 	/* we're done */
 	pcpu_base_addr = base_addr;
 	return 0;
@@ -1623,6 +1689,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 			goto out_free_areas;
 		}
 		areas[group] = ptr;
+		printk("XXX areas[%d]=%p\n", group, areas[group]);

 		base = min(ptr, base);

@@ -1639,12 +1706,15 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 	}

 	/* base address is now known, determine group base offsets */
+	printk("XXX base_addr=%p", base);
 	max_distance = 0;
 	for (group = 0; group < ai->nr_groups; group++) {
 		ai->groups[group].base_offset = areas[group] - base;
 		max_distance = max_t(size_t, max_distance,
 				     ai->groups[group].base_offset);
+		printk(" %lx", ai->groups[group].base_offset);
 	}
+	printk("\n");
 	max_distance += ai->unit_size;

 	/* warn if maximum distance is further than 75% of vmalloc space */
