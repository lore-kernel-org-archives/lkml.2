Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1GIIcN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 04:32:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53948 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1GIIcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 04:32:11 -0400
Date: Sat, 9 Jul 2011 10:32:06 +0200
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Conny Seidel <conny.seidel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: Re: [PATCH x86/urgent 2/2] x86: Implement pfn -> nid mapping
 granularity check
Message-ID: <20110709083206.GB943@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
 <20110701162239.GX3386@htj.dyndns.org>
 <20110701162327.GY3386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701162327.GY3386@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 06:23:27PM +0200, Tejun Heo wrote:
> Both SPARSEMEM and DISCONTIGMEM have limited granularity when mapping
> pfn to nid.  If NUMA nodes are laid out such that the mapping cannot
> be accurate, boot will fail triggering BUG_ON() in
> mminit_verify_page_links().
> 
> On 32bit, it's 512MiB w/ PAE and SPARSEMEM.  This seems to have been
> granular enough until commit 2706a0bf7b (x86, NUMA: Enable
> CONFIG_AMD_NUMA on 32bit too).  Apparently, there is a machine which
> aligns NUMA nodes to 128MiB and has only AMD NUMA but not SRAT.  As
> x86_64 has granularity of 128MiB, NUMA config worked fine on the
> machine; however, the commit enabled AMD NUMA config on 32bit too and
> the 512MiB granularity wasn't enough.
> 
>  On node 0 totalpages: 2096615
>    DMA zone: 32 pages used for memmap
>    DMA zone: 0 pages reserved
>    DMA zone: 3927 pages, LIFO batch:0
>    Normal zone: 1740 pages used for memmap
>    Normal zone: 220978 pages, LIFO batch:31
>    HighMem zone: 16405 pages used for memmap
>    HighMem zone: 1853533 pages, LIFO batch:31
>  BUG: Int 6: CR2   (null)
>       EDI   (null)  ESI 00000002  EBP 00000002  ESP c1543ecc
>       EBX f2400000  EDX 00000006  ECX   (null)  EAX 00000001
>       err   (null)  EIP c16209aa   CS 00000060  flg 00010002
>  Stack: f2400000 00220000 f7200800 c1620613 00220000 01000000 04400000 00238000
>           (null) f7200000 00000002 f7200b58 f7200800 c1620929 000375fe   (null)
>         f7200b80 c16395f0 00200a02 f7200a80   (null) 000375fe 00000002   (null)
>  Pid: 0, comm: swapper Not tainted 2.6.39-rc5-00181-g2706a0b #17
>  Call Trace:
>   [<c136b1e5>] ? early_fault+0x2e/0x2e
>   [<c16209aa>] ? mminit_verify_page_links+0x12/0x42
>   [<c1620613>] ? memmap_init_zone+0xaf/0x10c
>   [<c1620929>] ? free_area_init_node+0x2b9/0x2e3
>   [<c1607e99>] ? free_area_init_nodes+0x3f2/0x451
>   [<c1601d80>] ? paging_init+0x112/0x118
>   [<c15f578d>] ? setup_arch+0x791/0x82f
>   [<c15f43d9>] ? start_kernel+0x6a/0x257
> 
> This patch implements node_map_pfn_alignment() which determines
> maximum internode alignment and update numa_register_memblks() to
> reject NUMA configuration if alignment exceeds the pfn -> nid mapping
> granularity of the memory model as determined by PAGES_PER_SECTION.
> 
> This makes the problematic machine boot w/ flatmem by rejecting the
> NUMA config and provides protection against crazy NUMA configurations.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> LKML-Reference: <20110628174613.GP478@escobedo.osrc.amd.com>
> Reported-and-Tested-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
> Cc: Conny Seidel <conny.seidel@amd.com>

Ping?  If the change is too invasive at this stage, we can disable AMD
NUMA on x86_32 for 3.0 and queue these two for 3.1.

Thanks.

-- 
tejun
