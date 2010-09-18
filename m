Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0IRMgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 08:36:53 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38507 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753827Ab0IRMgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 08:36:52 -0400
Date: Sat, 18 Sep 2010 08:36:46 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, dhowells@redhat.com,
        graff yang <graff.yang@gmail.com>, sonic adi <sonic.adi@gmail.com>,
        kexec <kexec@lists.infradead.org>,
        Chris Lalancette <clalance@redhat.com>
Message-ID: <575271221.1298091284813406110.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C93879F.6000201@kernel.org>
Subject: Re: kvm kdump regression
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Tejun Heo" <tj@kernel.org> wrote:

> Hello,
> 
> Can you please apply the following patch, reproduce the problem and
> report the kernel log?
Tejun, which version this patch is against? Both 2.6.36-rc2-mm1 and 2.6.36-rc4-mm1 failed to apply it,
patching file arch/x86/kernel/crash_dump_64.c
Hunk #2 FAILED at 36.
1 out of 2 hunks FAILED -- saving rejects to file arch/x86/kernel/crash_dump_64.c.rej
patching file drivers/ata/libata-core.c
Hunk #1 succeeded at 6578 with fuzz 1 (offset 38 lines).
Hunk #2 FAILED at 6555.
1 out of 2 hunks FAILED -- saving rejects to file drivers/ata/libata-core.c.rej
patching file mm/percpu-vm.c
Hunk #1 FAILED at 415.
Hunk #2 FAILED at 429.
2 out of 2 hunks FAILED -- saving rejects to file mm/percpu-vm.c.rej
patching file mm/percpu.c
Hunk #1 FAILED at 90.
Hunk #2 succeeded at 176 with fuzz 1.
Hunk #3 succeeded at 1045 with fuzz 1.
Hunk #4 FAILED at 1473.
Hunk #5 FAILED at 1482.
Hunk #6 FAILED at 1501.
Hunk #7 FAILED at 1530.
Hunk #8 FAILED at 1639.
Hunk #9 FAILED at 1655.
7 out of 9 hunks FAILED -- saving rejects to file mm/percpu.c.rej
> 
> Thanks.
> 
> diff --git a/arch/x86/kernel/crash_dump_64.c
> b/arch/x86/kernel/crash_dump_64.c
> index 045b36c..8ac45a4 100644
> --- a/arch/x86/kernel/crash_dump_64.c
> +++ b/arch/x86/kernel/crash_dump_64.c
> @@ -13,6 +13,7 @@
>  /* Stores the physical address of elf header of crash image. */
>  unsigned long long elfcorehdr_addr = ELFCORE_ADDR_MAX;
> 
> +void per_cpu_ptr_to_phys_failed(void *addr);
>  /**
>   * copy_oldmem_page - copy one page from "oldmem"
>   * @pfn: page frame number to be copied
> @@ -35,8 +36,10 @@ ssize_t copy_oldmem_page(unsigned long pfn, char
> *buf,
>  		return 0;
> 
>  	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
> -	if (!vaddr)
> +	if (!vaddr) {
> +		per_cpu_ptr_to_phys_failed(vaddr);
>  		return -ENOMEM;
> +	}
> 
>  	if (userbuf) {
>  		if (copy_to_user(buf, vaddr + offset, csize)) {
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 932eaee..3bbffb0 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -6540,6 +6540,8 @@ static void __init ata_parse_force_param(void)
>  	ata_force_tbl_size = idx;
>  }
> 
> +void per_cpu_ptr_to_phys_failed(void *addr);
> +
>  static int __init ata_init(void)
>  {
>  	int rc = -ENOMEM;
> @@ -6553,6 +6555,7 @@ static int __init ata_init(void)
>  	}
> 
>  	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
> +	per_cpu_ptr_to_phys_failed(0x1234);
>  	return 0;
>  }
> 
> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 7d9c1d0..357569a 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -415,6 +415,7 @@ static struct pcpu_chunk *pcpu_create_chunk(void)
>  {
>  	struct pcpu_chunk *chunk;
>  	struct vm_struct **vms;
> +	int i;
> 
>  	chunk = pcpu_alloc_chunk();
>  	if (!chunk)
> @@ -429,6 +430,13 @@ static struct pcpu_chunk
> *pcpu_create_chunk(void)
> 
>  	chunk->data = vms;
>  	chunk->base_addr = vms[0]->addr - pcpu_group_offsets[0];
> +	chunk->chunkno = ++chunkno;
> +	printk("XXX chunk %d allocated base_addr=%p\n",
> +	       chunk->chunkno, chunk->base_addr);
> +	printk("XXX VMS:");
> +	for (i = 0; i < pcpu_nr_groups; i++)
> +		printk(" %zu@%p", vms[i]->size, vms[i]->addr);
> +	printk("\n");
>  	return chunk;
>  }
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 58c572b..8ef744d 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -90,7 +90,10 @@
>  			 (unsigned long)__per_cpu_start)
>  #endif
> 
> +static int chunkno;
> +
>  struct pcpu_chunk {
> +	int			chunkno;
>  	struct list_head	list;		/* linked to pcpu_slot lists */
>  	int			free_size;	/* free bytes in the chunk */
>  	int			contig_hint;	/* max contiguous size hint */
> @@ -176,6 +179,40 @@ static struct list_head *pcpu_slot __read_mostly;
> /* chunk list slots */
>  static void pcpu_reclaim(struct work_struct *work);
>  static DECLARE_WORK(pcpu_reclaim_work, pcpu_reclaim);
> 
> +void pcpu_dump_chunk(struct pcpu_chunk *chunk)
> +{
> +	int i, contig = 0, free = 0;
> +
> +	printk("XXX   %d(f=%d,c=%d,u=%d,a=%d)", chunk->chunkno,
> +	       chunk->free_size, chunk->contig_hint,
> +	       chunk->map_used, chunk->map_alloc);
> +	for (i = 0; i < chunk->map_used; i++) {
> +		if (chunk->map[i] > 0) {
> +			free += chunk->map[i];
> +			contig = max(contig, chunk->map[i]);
> +		}
> +		printk(" %d", chunk->map[i]);
> +	}
> +	printk(" free=%d contig=%d%s\n", free, contig,
> +	       (free != chunk->free_size || contig != chunk->contig_hint) ?
> +	       " MISMATCH!" : "");
> +}
> +
> +void pcpu_dump_chunk_slots(void)
> +{
> +	struct pcpu_chunk *chunk;
> +	int i;
> +
> +	printk("XXX percpu allocator dump\n");
> +	for (i = 0; i < pcpu_nr_slots; i++) {
> +		if (list_empty(&pcpu_slot[i]))
> +			continue;
> +		printk("XXX  SLOT[%02d]\n", i);
> +		list_for_each_entry(chunk, &pcpu_slot[i], list)
> +			pcpu_dump_chunk(chunk);
> +	}
> +}
> +
>  static bool pcpu_addr_in_first_chunk(void *addr)
>  {
>  	void *first_start = pcpu_first_chunk->base_addr;
> @@ -1011,6 +1048,19 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
>  		return page_to_phys(pcpu_addr_to_page(addr));
>  }
> 
> +void per_cpu_ptr_to_phys_failed(void *addr)
> +{
> +	phys_addr_t phys;
> +	unsigned long flags;
> +
> +	phys = per_cpu_ptr_to_phys(addr);
> +	printk("XXX per_cpu_ptry_to_phys(%p) returned invalid address
> 0x%llx\n",
> +	       addr, (unsigned long long)phys);
> +	spin_lock_irqsave(&pcpu_lock, flags);
> +	pcpu_dump_chunk_slots();
> +	spin_unlock_irqrestore(&pcpu_lock, flags);
> +}
> +
>  /**
>   * pcpu_alloc_alloc_info - allocate percpu allocation info
>   * @nr_groups: the number of groups
> @@ -1426,6 +1476,11 @@ int __init pcpu_setup_first_chunk(const struct
> pcpu_alloc_info *ai,
>  	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
>  		BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long);
> 
> +	printk("XXX CPU->UNIT M/O");
> +	for_each_possible_cpu(cpu)
> +		printk(" %d:%lx", unit_map[cpu], unit_off[cpu]);
> +	printk("\n");
> +
>  	/*
>  	 * Allocate chunk slots.  The additional last slot is for
>  	 * empty chunks.
> @@ -1435,6 +1490,10 @@ int __init pcpu_setup_first_chunk(const struct
> pcpu_alloc_info *ai,
>  	for (i = 0; i < pcpu_nr_slots; i++)
>  		INIT_LIST_HEAD(&pcpu_slot[i]);
> 
> +	printk("XXX ss=%zu up=%d us=%d ns=%d rs=%zd ds=%zd\n",
> +	       ai->static_size, pcpu_unit_pages, pcpu_unit_size,
> +	       pcpu_nr_slots, ai->reserved_size, dyn_size);
> +
>  	/*
>  	 * Initialize static chunk.  If reserved_size is zero, the
>  	 * static chunk covers static area + dynamic allocation area
> @@ -1454,6 +1513,7 @@ int __init pcpu_setup_first_chunk(const struct
> pcpu_alloc_info *ai,
>  		schunk->free_size = ai->reserved_size;
>  		pcpu_reserved_chunk = schunk;
>  		pcpu_reserved_chunk_limit = ai->static_size + ai->reserved_size;
> +		schunk->chunkno = -1;
>  	} else {
>  		schunk->free_size = dyn_size;
>  		dyn_size = 0;			/* dynamic area covered */
> @@ -1483,6 +1543,12 @@ int __init pcpu_setup_first_chunk(const struct
> pcpu_alloc_info *ai,
>  	pcpu_first_chunk = dchunk ?: schunk;
>  	pcpu_chunk_relocate(pcpu_first_chunk, -1);
> 
> +	if (pcpu_reserved_chunk) {
> +		printk("XXX reserved chunk\n");
> +		pcpu_dump_chunk(pcpu_reserved_chunk);
> +	}
> +	pcpu_dump_chunk_slots();
> +
>  	/* we're done */
>  	pcpu_base_addr = base_addr;
>  	return 0;
> @@ -1592,6 +1658,7 @@ int __init pcpu_embed_first_chunk(size_t
> reserved_size, size_t dyn_size,
>  			goto out_free_areas;
>  		}
>  		areas[group] = ptr;
> +		printk("XXX areas[%d]=%p\n", group, areas[group]);
> 
>  		base = min(ptr, base);
> 
> @@ -1608,12 +1675,15 @@ int __init pcpu_embed_first_chunk(size_t
> reserved_size, size_t dyn_size,
>  	}
> 
>  	/* base address is now known, determine group base offsets */
> +	printk("XXX base_addr=%p", base);
>  	max_distance = 0;
>  	for (group = 0; group < ai->nr_groups; group++) {
>  		ai->groups[group].base_offset = areas[group] - base;
>  		max_distance = max_t(size_t, max_distance,
>  				     ai->groups[group].base_offset);
> +		printk(" %lx", ai->groups[group].base_offset);
>  	}
> +	printk("\n");
>  	max_distance += ai->unit_size;
> 
>  	/* warn if maximum distance is further than 75% of vmalloc space */
