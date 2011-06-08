Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1FHQtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:49:13 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4643 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1FHQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:49:11 -0400
Message-ID: <4DEFA6E3.6090809@xs4all.nl>
Date: Wed, 08 Jun 2011 18:44:19 +0200
From: Jim Bos <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110429 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com> <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com> <4CE1968D.3050706@xs4all.nl> <4DE8DC16.6030308@xs4all.nl> <20110603133351.GA25130@srcf.ucam.org> <4DE8EF13.9030609@xs4all.nl> <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com> <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <4DEE17F9.6020503@gmail.com> <4DEEA548.5020405@kernel.org>
In-Reply-To: <4DEEA548.5020405@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------050207060609090108050504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050207060609090108050504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/08/2011 12:25 AM, Yinghai Lu wrote:
> On 06/07/2011 05:22 AM, Maarten Lankhorst wrote:
>> It seems the error still occurs when calling free_bootmem_late
>> even if I only reserve blocks that haven't been reserved yet.
> 
> please check this one.
> 
> ---
>  arch/x86/platform/efi/efi.c |    2 +-
>  include/linux/mm.h          |    2 ++
>  mm/page_alloc.c             |   32 ++++++++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/platform/efi/efi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
> +++ linux-2.6/arch/x86/platform/efi/efi.c
> @@ -368,7 +368,7 @@ static void __init efi_free_boot_service
>  		    md->type != EFI_BOOT_SERVICES_DATA)
>  			continue;
>  
> -		free_bootmem_late(start, size);
> +		free_bootmem_late_with_active_regions(start, size);
>  	}
>  }
>  
> Index: linux-2.6/include/linux/mm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/mm.h
> +++ linux-2.6/include/linux/mm.h
> @@ -1322,6 +1322,8 @@ extern void get_pfn_range_for_nid(unsign
>  extern unsigned long find_min_pfn_with_active_regions(void);
>  extern void free_bootmem_with_active_regions(int nid,
>  						unsigned long max_low_pfn);
> +void free_bootmem_late_with_active_regions(unsigned long addr,
> +						unsigned long size);
>  int add_from_early_node_map(struct range *range, int az,
>  				   int nr_range, int nid);
>  u64 __init find_memory_core_early(int nid, u64 size, u64 align,
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -3828,6 +3828,38 @@ void __init free_bootmem_with_active_reg
>  	}
>  }
>  
> +/**
> + * free_bootmem_late_with_active_regions - Call free_bootmem_late for each active range
> + * @addr: starting address of the range
> + * @size: size of the range in bytes
> + *
> + * this function make sure on active regions only
> + */
> +void __init free_bootmem_late_with_active_regions(unsigned long addr,
> +						unsigned long size)
> +{
> +	int i;
> +	int nid = MAX_NUMNODES;
> +	unsigned long start_pfn = PFN_UP(addr);
> +	unsigned long end_pfn = PFN_DOWN(addr + size);
> +
> +	if (start_pfn >= end_pfn)
> +		return;
> +
> +	for_each_active_range_index_in_nid(i, nid) {
> +		unsigned long common_start, common_end;
> +
> +		common_start = max(start_pfn, early_node_map[i].start_pfn);
> +		common_end = min(end_pfn, early_node_map[i].end_pfn);
> +
> +		if (common_start >= common_end)
> +			continue;
> +
> +		free_bootmem_late(common_start << PAGE_SHIFT,
> +				  (common_end - common_start) << PAGE_SHIFT);
> +	}
> +}
> +
>  #ifdef CONFIG_HAVE_MEMBLOCK
>  /*
>   * Basic iterator support. Return the last range of PFNs for a node
> 

I applied this on top of 3.0-rc1 (with offsets), kernels boots but see
now in dmesg output a new 'BUG: Bad page state in process swapper
pfn:01800' see attached dmesg output.

Jim




--------------050207060609090108050504
Content-Type: text/plain;
 name="bug.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bug.txt"

[    2.630101] BUG: Bad page state in process swapper  pfn:01800
[    2.631771] page:ffffea0000054000 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.633472] page flags: 0x4000000000000000()
[    2.635172] Pid: 1, comm: swapper Not tainted 3.0.0-rc1 #3
[    2.636856] Call Trace:
[    2.638515]  [<ffffffff8107e50d>] ? bad_page+0xd0/0xe2
[    2.640176]  [<ffffffff8107ea4c>] ? free_pages_prepare+0x67/0xa3
[    2.641846]  [<ffffffff8107db1e>] ? get_pageblock_flags_group+0x3f/0x76
[    2.643511]  [<ffffffff8107ebbf>] ? free_hot_cold_page+0x25/0x193
[    2.645177]  [<ffffffff81021ac9>] ? change_page_attr_set+0x23/0x28
[    2.646858]  [<ffffffff8101ee85>] ? free_init_pages+0xfb/0x110
[    2.648550]  [<ffffffff810001d8>] ? init_post+0xe/0xb6
[    2.650237]  [<ffffffff817b9bfc>] ? kernel_init+0x122/0x126
[    2.651926]  [<ffffffff81444564>] ? kernel_thread_helper+0x4/0x10
[    2.653602]  [<ffffffff817b9ada>] ? start_kernel+0x34f/0x34f
[    2.655268]  [<ffffffff81444560>] ? gs_change+0x13/0x13
[    2.656920] Disabling lock debugging due to kernel taint

--------------050207060609090108050504
Content-Type: application/gzip;
 name="dmesg-3.0.0-rc1.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-3.0.0-rc1.gz"

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
jC/vu3ETx88RWKfLWQYCCR3PEYuNfD8lC/5TJlKdCO9H2JG07fFtZ1Th7EhP1dMjRS3thDzq
bzQ+a+SkTRryPYdXpMYzT3kmMoo3s3ShDiUU9r+sXsVJeEsQPLQOmuPuYPwgJo8u0FTJfFmK
AwNN1tCVmeUbqYs/xDz3oq0VmCiwiWAvFg+2jT5r/2l9AmsurPPKcejOLVsmYErdkZn/SR6Q
BdOnAgtANC+RvVfDOJOmJB3Er0RsW+V2pd2/HtOIDcdDvTq3w25E75iy9QFlb2/EGuNX8b/2
sXbWQBw0NiC3dx/H9smAouYeOXl2XHL55fLur5fWNFal/3738d4oHcrS/lCUprq0KHpJRuRG
tFpMkphcgldAVI9RtgP9Gt566KnDJfq1rJv3r6F/tOpO/Yg4wXVEN1u+ga6G2Cc3X++/CMGA
H0nD3XW/6x0lmMEwiARvx0Bcjm+G/cbSLBIJoSuqw/61xt6ZjU1dX1SHOq4eqNHNcPybKErG
t9+6mlDwyq6hJFNXO9BHw+tPfXTmy7qzQ9NAoctXvKsrP4+vjLqzWKFHhyfZeVvS24F+eXf9
JwM9kwN1CSb9mblitK++EPX6PPy07pn767uRmo2u5+yaZKPL2z66pwTywdlR9xZdTrL2agf6
l1KcaipnTpJlsOTUsHjk8hnWFosjDbb8irR+nXUJYSb+zX+Q8egjOftLZ9tdFvB1VpmQtVnL
BVmUGXglJtH/ioMGx9dftT+1xY+CXlH92e4iqCNY1RXdVndRBMaiKyIytUXo9uaCi13NoXvI
Rqa2iDKKljdYPssl9Q/RgLpJqkY2Iy8rwsFHks21nIWkmr1OxCdiMfju/9AHRW50gF0zuBps
bbvYSOzPTteNUHdY92WXt942svv5dH/2IOQb2bd00UZ2TI9+a+cIrE9NMhNrWz0A0xm71PO3
zwvR+QPiB3IhhKWtBhdFjACsuNDB+8p4bZnW99qXmUWRq7Kfki8319/AS27Sx8HOmadKUfG1
3iNq1hUMAx9avYWQWdvYbuJqyjCKXSxlv6QbiwMiUaTKnoxHZ/fFnFfk5hsZl1UzkL5o9G8w
PrqIzH0izpCeFJm4rUCFQ7wsUn0pBKW8+F0Wz0Jw+wju8Qisj+Adj+D1EQIUwuQrrNsbKMKm
PhYPj4SLOwLgZTeQSH/sgLj5pmrR9ZseAwHEU531oS4mYvf33bFhFAB8MiC66mLP1J1BLp5R
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
7f/r/wEDvAoMCQEA
--------------050207060609090108050504--
