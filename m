Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab0ITJoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:44:39 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:52352 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751509Ab0ITJoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:44:38 -0400
Date: Mon, 20 Sep 2010 05:44:29 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: graff yang <graff.yang@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        sonic adi <sonic.adi@gmail.com>,
        Chris Lalancette <clalance@redhat.com>, Avi Kivity <avi@redhat.com>
Message-ID: <1033143831.1348811284975869188.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C97256A.7020208@kernel.org>
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
> I was slightly confused with the debug patch but it looks like
> someone
> is feeding non-percpu address to the function.  Hmm... or it could be
> that the first chunk test is returning false incorrectly for an
> address which is inside static percpu area.  Can you please try the
> following patch instead?  This should make the problem go away and
> give us enough information about which address is causing the
> problem.
> Please attach logs from both the original kernel before triggering
> crash and from the crash kernel.
Tejun, which version should I apply this patch for?
# patch -Np1 <tejun2.patch
patching file mm/percpu-vm.c
Hunk #1 FAILED at 415.
Hunk #2 FAILED at 429.
2 out of 2 hunks FAILED -- saving rejects to file mm/percpu-vm.c.rej
patching file mm/percpu.c
Hunk #1 FAILED at 96.
Hunk #2 succeeded at 182 with fuzz 1.
Hunk #3 FAILED at 1051.
Hunk #4 FAILED at 1317.
Hunk #5 FAILED at 1326.
Hunk #6 FAILED at 1345.
Hunk #7 FAILED at 1374.
Hunk #8 FAILED at 1657.
Hunk #9 FAILED at 1673.
8 out of 9 hunks FAILED -- saving rejects to file mm/percpu.c.rej
> 
> Thank you.
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
> index 77e3f5a..14c836b 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -96,7 +96,10 @@
>  #define __pcpu_ptr_to_addr(ptr)		(void __force *)(ptr)
>  #endif	/* CONFIG_SMP */
> 
> +static int chunkno;
> +
>  struct pcpu_chunk {
> +	int			chunkno;
>  	struct list_head	list;		/* linked to pcpu_slot lists */
>  	int			free_size;	/* free bytes in the chunk */
>  	int			contig_hint;	/* max contiguous size hint */
> @@ -182,6 +185,40 @@ static struct list_head *pcpu_slot __read_mostly;
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
> @@ -1017,8 +1054,20 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
>  			return __pa(addr);
>  		else
>  			return page_to_phys(vmalloc_to_page(addr));
> -	} else
> +	} else {
> +		if ((unsigned long)addr < VMALLOC_START ||
> +		    (unsigned long)addr >= VMALLOC_END) {
> +			static bool first = true;
> +			if (first) {
> +				WARN_ON(1);
> +				printk("XXX addr=%p out of vmalloc area and not in first
> chunk\n", addr);
> +				pcpu_dump_chunk_slots();
> +				first = false;
> +			}
> +			return __pa(addr);
> +		}
>  		return page_to_phys(pcpu_addr_to_page(addr));
> +	}
>  }
> 
>  /**
> @@ -1283,6 +1332,11 @@ int __init pcpu_setup_first_chunk(const struct
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
> @@ -1292,6 +1346,10 @@ int __init pcpu_setup_first_chunk(const struct
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
> @@ -1311,6 +1369,7 @@ int __init pcpu_setup_first_chunk(const struct
> pcpu_alloc_info *ai,
>  		schunk->free_size = ai->reserved_size;
>  		pcpu_reserved_chunk = schunk;
>  		pcpu_reserved_chunk_limit = ai->static_size + ai->reserved_size;
> +		schunk->chunkno = -1;
>  	} else {
>  		schunk->free_size = dyn_size;
>  		dyn_size = 0;			/* dynamic area covered */
> @@ -1340,6 +1399,12 @@ int __init pcpu_setup_first_chunk(const struct
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
> @@ -1623,6 +1688,7 @@ int __init pcpu_embed_first_chunk(size_t
> reserved_size, size_t dyn_size,
>  			goto out_free_areas;
>  		}
>  		areas[group] = ptr;
> +		printk("XXX areas[%d]=%p\n", group, areas[group]);
> 
>  		base = min(ptr, base);
> 
> @@ -1639,12 +1705,15 @@ int __init pcpu_embed_first_chunk(size_t
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
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
