Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3AINYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:24:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39059 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab3AINYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:24:51 -0500
Date: Wed, 9 Jan 2013 08:24:09 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
Message-ID: <20130109132409.GB18395@phenom.dumpdata.com>
References: <CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
 <8762382z2c.fsf@xmission.com>
 <CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
 <87y5g4z7rp.fsf@xmission.com>
 <CAE9FiQVVtfxZs7E9Q=VbNHNbYJg_9TGCTetkZMYT0tgt0JLNZw@mail.gmail.com>
 <CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
 <20130109004340.GA12234@konrad-lan.dumpdata.com>
 <87txqruq8p.fsf@xmission.com>
 <CAE9FiQVgMK=CK5BvfOkGF3Pp4kOqBEg2mxX2zDuhW8zZXSVXzg@mail.gmail.com>
 <CAE9FiQVomDtc0P9B7aTDBrm7kC+i=GYokBmT54w-VBwZsafb5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVomDtc0P9B7aTDBrm7kC+i=GYokBmT54w-VBwZsafb5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 05:12:02PM -0800, Yinghai Lu wrote:
> On Tue, Jan 8, 2013 at 5:07 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Tue, Jan 8, 2013 at 4:58 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> >>
> >> So instead we need to say?
> >>
> >> +       if (no_iotlb_memory)
> >> +               panic("Cannot allocate SWIOTLB buffer");
> >> +
> >>
> >> Which is just making the panic a little later than it used to be and
> >> seems completely reasonable.
> >
> > yes, looks some driver just use map_single without checking results.
> 
> update one.

Please make it inline.

Anyhow, comments:

> Subject: [PATCH] x86: Don't panic if can not alloc buffer for swiotlb
> 
> Normal boot path on system with iommu support:
> swiotlb buffer will be allocated early at first and then try to initialize
> iommu, if iommu for intel or amd could setup properly, swiotlb buffer

Intel or AMD
> will be freed.
> 
> The early allocating is with bootmem, and could panic when we try to use
> kdump with buffer above 4G only, or with memmap to limit mem under 4G.

Can you provide the memmap example in here, please.

> 
> According to Eric, add _nopanic version and no_iotlb_memory to fail
> map single later if swiotlb is still needed.
> 
> -v2: don't pass nopanic, and use -ENOMEM return value according to Eric.
>      panic early instead of using swiotlb_full to panic...according to Eric/Konrad.
> 
> Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> 
> ---
>  arch/x86/kernel/pci-swiotlb.c |    2 -
>  include/linux/swiotlb.h       |    1 
>  lib/swiotlb.c                 |   54 +++++++++++++++++++++++++++++++++++-------
>  3 files changed, 47 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/include/linux/swiotlb.h
> ===================================================================
> --- linux-2.6.orig/include/linux/swiotlb.h
> +++ linux-2.6/include/linux/swiotlb.h
> @@ -22,6 +22,7 @@ extern int swiotlb_force;
>   */
>  #define IO_TLB_SHIFT 11
>  
> +void swiotlb_init_nopanic(int verbose);

No need for that, lets just use the swiotlb_init version.

>  extern void swiotlb_init(int verbose);
>  extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
>  extern unsigned long swiotlb_nr_tbl(void);
> Index: linux-2.6/lib/swiotlb.c
> ===================================================================
> --- linux-2.6.orig/lib/swiotlb.c
> +++ linux-2.6/lib/swiotlb.c
> @@ -122,11 +122,18 @@ static dma_addr_t swiotlb_virt_to_bus(st
>  	return phys_to_dma(hwdev, virt_to_phys(address));
>  }
>  
> +static bool no_iotlb_memory;
> +
>  void swiotlb_print_info(void)
>  {
>  	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
>  	unsigned char *vstart, *vend;
>  
> +	if (no_iotlb_memory) {
> +		printk(KERN_INFO "software IO TLB: No low mem\n");

KERN_ERROR or KERN_WARN

> +		return;
> +	}
> +
>  	vstart = phys_to_virt(io_tlb_start);
>  	vend = phys_to_virt(io_tlb_end);
>  
> @@ -136,7 +143,8 @@ void swiotlb_print_info(void)
>  	       bytes >> 20, vstart, vend - 1);
>  }
>  
> -void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
> +static int __init __swiotlb_init_with_tbl(char *tlb, unsigned long nslabs,
> +				 int verbose)

Collapse it in. Meaning make swiotlb_init_with_tbl return an int. This will
require altering the Xen version of Xen-SWIOTLB but that should be fairly easy.


>  {
>  	void *v_overflow_buffer;
>  	unsigned long i, bytes;
> @@ -150,9 +158,10 @@ void __init swiotlb_init_with_tbl(char *
>  	/*
>  	 * Get the overflow emergency buffer
>  	 */
> -	v_overflow_buffer = alloc_bootmem_low_pages(PAGE_ALIGN(io_tlb_overflow));
> +	v_overflow_buffer = alloc_bootmem_low_pages_nopanic(
> +						PAGE_ALIGN(io_tlb_overflow));
>  	if (!v_overflow_buffer)
> -		panic("Cannot allocate SWIOTLB overflow buffer!\n");
> +		return -ENOMEM;
>  
>  	io_tlb_overflow_buffer = __pa(v_overflow_buffer);
>  
> @@ -169,14 +178,22 @@ void __init swiotlb_init_with_tbl(char *
>  
>  	if (verbose)
>  		swiotlb_print_info();
> +
> +	return 0;
> +}
> +
> +void __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
> +{
> +	if (__swiotlb_init_with_tbl(tlb, nslabs, verbose) == -ENOMEM)
> +		panic("Cannot allocate SWIOTLB buffer");

And that way we can get rid of this.

>  }
>  
>  /*
>   * Statically reserve bounce buffer space and initialize bounce buffer data
>   * structures for the software IO TLB used to implement the DMA API.
>   */
> -static void __init
> -swiotlb_init_with_default_size(size_t default_size, int verbose)
> +static  __init
> +int swiotlb_init_with_default_size(size_t default_size, int verbose)
>  {
>  	unsigned char *vstart;
>  	unsigned long bytes;
> @@ -191,17 +208,33 @@ swiotlb_init_with_default_size(size_t de
>  	/*
>  	 * Get IO TLB memory from the low pages
>  	 */
> -	vstart = alloc_bootmem_low_pages(PAGE_ALIGN(bytes));
> +	vstart = alloc_bootmem_low_pages_nopanic(PAGE_ALIGN(bytes));
>  	if (!vstart)
> -		panic("Cannot allocate SWIOTLB buffer");
> +		return -ENOMEM;
>  
> -	swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose);
> +	if (__swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose) == -ENOMEM) {
> +		free_bootmem(io_tlb_start,
> +				     PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +void __init
> +swiotlb_init_nopanic(int verbose)
> +{
> +	/* default to 64MB */
> +	if (swiotlb_init_with_default_size(64 * (1<<20), verbose) == -ENOMEM)
> +		pr_warn("Cannot allocate SWIOTLB buffer");
>  }

And this
>  
>  void __init
>  swiotlb_init(int verbose)
>  {
> -	swiotlb_init_with_default_size(64 * (1<<20), verbose);	/* default to 64MB */
> +	/* default to 64MB */
> +	if (swiotlb_init_with_default_size(64 * (1<<20), verbose) == -ENOMEM)
> +		panic("Cannot allocate SWIOTLB buffer");
>  }

And just make this function return 'int'
>  
>  /*
> @@ -405,6 +438,9 @@ phys_addr_t swiotlb_tbl_map_single(struc
>  	unsigned long offset_slots;
>  	unsigned long max_slots;
>  
> +	if (no_iotlb_memory)
> +		panic("Cannot allocate SWIOTLB buffer");
> +
>  	mask = dma_get_seg_boundary(hwdev);
>  
>  	tbl_dma_addr &= mask;
> Index: linux-2.6/arch/x86/kernel/pci-swiotlb.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/pci-swiotlb.c
> +++ linux-2.6/arch/x86/kernel/pci-swiotlb.c
> @@ -91,7 +91,7 @@ IOMMU_INIT(pci_swiotlb_detect_4gb,
>  void __init pci_swiotlb_init(void)
>  {
>  	if (swiotlb) {
> -		swiotlb_init(0);
> +		swiotlb_init_nopanic(0);
>  		dma_ops = &swiotlb_dma_ops;
>  	}
>  }
