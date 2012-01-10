Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab2AJWrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:47:37 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17911 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab2AJWrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:47:35 -0500
Date: Tue, 10 Jan 2012 17:45:37 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, xen-devel@lists.xensource.com
Subject: Re: Bootup regression introduced by
 7bd0b0f0da3b1ec11cbcc798eb0ef747a1184077 ("memblock: Reimplement memblock
 allocation using reverse free area iterato") in v3.3-rc0
Message-ID: <20120110224537.GA6572@phenom.dumpdata.com>
References: <20120110202838.GA10402@phenom.dumpdata.com>
 <20120110222625.GA26832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110222625.GA26832@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F0CC000.00A5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 02:26:25PM -0800, Tejun Heo wrote:
> On Tue, Jan 10, 2012 at 03:28:38PM -0500, Konrad Rzeszutek Wilk wrote:
> > With that patch I get this when trying to launch a 4GB xen guest:
> > 
> > kernel="/mnt/lab/latest/vmlinuz"
> > ramdisk="/mnt/lab/latest/initramfs.cpio.gz"
> > extra="console=hvc0 debug earlyprintk=xen" 
> > memory=4096
> > maxmem=8192
> > vcpus=4
> > on_crash="preserve"
> > vif = [ 'mac=00:0F:4B:00:00:68, bridge=switch' ]
> > vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1'
> > 
> > If I change the "memory" to be "4000" it or if I revert the
> > mention git commit it boots. This is what I get with the mentioned
> > git commit:
> 
> Heh, interesting.  Can you please apply the following patch and report
> the failing boot log?
> 
> Thanks.
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 2f55f19..978b58eff 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -102,6 +102,10 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>  	/* align @size to avoid excessive fragmentation on reserved array */
>  	size = round_up(size, align);
>  
> +	printk("memblock_find: [0x%llx, 0x%llx) size=%llu align=%llu nid=%d\n",
> +	       (unsigned long long)start, (unsigned long long)end,
> +	       (unsigned long long)size, (unsigned long long)align, nid);
> +
>  	/* pump up @end */
>  	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
>  		end = memblock.current_limit;
> @@ -110,13 +114,27 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
>  	start = max3(start, size, (phys_addr_t)PAGE_SIZE);
>  	end = max(start, end);
>  
> +	printk("memblock_find: [0x%llx, 0x%llx) - adjusted\n",
> +	       (unsigned long long)start, (unsigned long long)end);
> +
>  	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
> +		printk("memblock_find: cand [0x%llx, 0x%llx) -> ",
> +		       (unsigned long long)this_start,
> +		       (unsigned long long)this_end);
> +
>  		this_start = clamp(this_start, start, end);
>  		this_end = clamp(this_end, start, end);
>  
> +		printk("[0x%llx, 0x%llx) ",
> +		       (unsigned long long)this_start,
> +		       (unsigned long long)this_end);
> +
>  		cand = round_down(this_end - size, align);
> -		if (cand >= this_start)
> +		if (cand >= this_start) {
> +			printk("- success %llx\n", (unsigned long long)cand);
>  			return cand;
> +		}
> +		printk("- rejected\n");
>  	}
>  	return 0;
>  }

Using config file "/mnt/lab/latest/pv.xm".
Started domain latest (id=28)
(early) [    0.000000] Initializing cgroup subsys cpuset
(early) [    0.000000] Initializing cgroup subsys cpu
(early) [    0.000000] Linux version 3.2.0-05808-g597987c (konrad@build.dumpdata.com) (gcc version 4.4.4 20100503 (Red Hat 4.4.4-2) (GCC) ) #1 SMP PREEMPT Tue Jan 10 17:31:15 EST 2012
(early) [    0.000000] Command line: console=hvc0 debug earlyprintk=xenboot memblock=debug loglevel=8
(early) [    0.000000] ACPI in unprivileged domain disabled
(early) [    0.000000] Released 0 pages of unused memory
(early) [    0.000000] Set 0 page(s) to 1-1 mapping
(early) [    0.000000] BIOS-provided physical RAM map:
(early) [    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
(early) [    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
(early) [    0.000000]  Xen: 0000000000100000 - 0000000200800000 (usable)
(early) [    0.000000] bootconsole [xenboot0] enabled
(early) [    0.000000] NX (Execute Disable) protection: active
(early) [    0.000000] DMI not present or invalid.
(early) [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (early) (usable)(early)  ==> (early) (reserved)(early) 
(early) [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (early) (usable)(early) 
(early) [    0.000000] No AGP bridge found
(early) [    0.000000] last_pfn = 0x200800 max_arch_pfn = 0x400000000
(early) [    0.000000] last_pfn = 0x100000 max_arch_pfn = 0x400000000
(early) [    0.000000] memblock_reserve: [0x00000001dec000-0x00000001e03000] setup_arch+0x592/0xafb
(early) [    0.000000] MEMBLOCK configuration:
(early) [    0.000000]  memory size = 0x200790000 reserved size = 0x10f960000
(early) [    0.000000]  memory.cnt  = 0x2
(early) [    0.000000]  memory[0x0]	[0x00000000010000-0x0000000009ffff], 0x90000 bytes
(early) [    0.000000]  memory[0x1]	[0x00000000100000-0x000002007fffff], 0x200700000 bytes
(early) [    0.000000]  reserved.cnt  = 0x3
(early) [    0.000000]  reserved[0x0]	[0x00000001000000-0x00000001e02fff], 0xe03000 bytes
(early) [    0.000000]  reserved[0x1]	[0x0000000220a000-0x00000010566fff], 0xe35d000 bytes
(early) [    0.000000]  reserved[0x2]	[0x00000100000000-0x000002007fffff], 0x100800000 bytes
(early) [    0.000000] initial memory mapped : 0 - 0fcdd000
(early) [    0.000000] memblock_find: [0x0, 0x100000) size=20480 align=4096 nid=1024
(early) [    0.000000] memblock_find: [0x5000, 0x100000) - adjusted
(early) [    0.000000] memblock_find: cand [0x10567000, 0x100000000) -> (early) [0x100000, 0x100000) (early) - rejected
(early) [    0.000000] memblock_find: cand [0x1e03000, 0x220a000) -> (early) [0x100000, 0x100000) (early) - rejected
(early) [    0.000000] memblock_find: cand [0x100000, 0x1000000) -> (early) [0x100000, 0x100000) (early) - rejected
(early) [    0.000000] memblock_find: cand [0x10000, 0xa0000) -> (early) [0x10000, 0xa0000) (early) - success 9b000
(early) [    0.000000] memblock_reserve: [0x0000000009b000-0x000000000a0000] setup_trampolines+0x66/0x9c
(early) [    0.000000] Base memory trampoline at [ffff88000009b000] 9b000 size 20480
(early) [    0.000000] init_memory_mapping: 0000000000000000-0000000100000000
(early) [    0.000000]  0000000000 - 0100000000 page 4k
(early) [    0.000000] memblock_find: [0x0, 0xfcdd000) size=8409088 align=4096 nid=1024
(early) [    0.000000] memblock_find: [0x805000, 0xfcdd000) - adjusted
(early) [    0.000000] memblock_find: cand [0x10567000, 0x100000000) -> (early) [0xfcdd000, 0xfcdd000) (early) - rejected
(early) [    0.000000] memblock_find: cand [0x1e03000, 0x220a000) -> (early) [0x1e03000, 0x220a000) (early) - rejected
(early) [    0.000000] memblock_find: cand [0x100000, 0x1000000) -> (early) [0x805000, 0x1000000) (early) - rejected
(early) [    0.000000] memblock_find: cand [0x10000, 0x9b000) -> (early) [0x805000, 0x805000) (early) - rejected
(early) [    0.000000] Kernel panic - not syncing: Cannot find space for the kernel page tables
(early) [    0.000000] Pid: 0, comm: swapper Not tainted 3.2.0-05808-g597987c #1
(early) [    0.000000] Call Trace:
(early) [    0.000000]  [<ffffffff816011e5>] panic+0x96/0x1c4
(early) [    0.000000]  [<ffffffff815e4612>] init_memory_mapping+0x562/0x590
(early) [    0.000000]  [<ffffffff81ae88c6>] setup_arch+0x63a/0xafb
(early) [    0.000000]  [<ffffffff8160134f>] ? printk+0x3c/0x3e
(early) [    0.000000]  [<ffffffff81ae2baf>] start_kernel+0xe6/0x403
(early) [    0.000000]  [<ffffffff81ae2346>] x86_64_start_reservations+0x131/0x136
(early) [    0.000000]  [<ffffffff81ae5b5d>] xen_start_kernel+0x60d/0x614
