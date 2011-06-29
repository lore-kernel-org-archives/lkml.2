Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1F2Jo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:44:58 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38022 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1F2Jo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:44:56 -0400
Date: Wed, 29 Jun 2011 11:44:51 +0200
From: Tejun Heo <tj@kernel.org>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Conny Seidel <conny.seidel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110629094451.GJ3386@htj.dyndns.org>
References: <20110621174131.054f0422.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628174613.GP478@escobedo.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing x86 and lkml.  Please keep them cc'd on x86 related issues).

Hello,

On Tue, Jun 28, 2011 at 07:46:14PM +0200, Hans Rosenfeld wrote:
> We found another related but different panic on a 4-socket 8-node system,
> caused by this commit:
> 
>     commit 2706a0bf7b02693ed88752df877f10c2206292ff
>     Author: Tejun Heo <tj@kernel.org>
>     Date:   Mon May 2 17:24:48 2011 +0200
> 
>     x86, NUMA: Enable CONFIG_AMD_NUMA on 32bit too
>     
>     Now that NUMA init path is unified, amdtopology can be enabled on
>     32bit.  Make amdtopology.c safe on 32bit by explicitly using u64 and
>     drop X86_64 dependency from Kconfig.
>     
>     Inclusion of bootmem.h is added for max_pfn declaration.
>     
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Cc: Ingo Molnar <mingo@redhat.com>
>     Cc: Yinghai Lu <yinghai@kernel.org>
>     Cc: David Rientjes <rientjes@google.com>
>     Cc: Thomas Gleixner <tglx@linutronix.de>
>     Cc: "H. Peter Anvin" <hpa@zytor.com>
> 
> 
> The fix for the other panic does not fix this one.
> Full bootlog and config are attached.

Hmmm, interesting.

> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 0000000000087800 (usable)
> [    0.000000]  BIOS-e820: 0000000000087800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000cc000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7e70000 (usable)
> [    0.000000]  BIOS-e820: 00000000c7e70000 - 00000000c7e8c000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000c7e8c000 - 00000000c7e8e000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000c7e8e000 - 00000000c8000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000001838000000 (usable)

Okay, a fairly large machine.  Memory goes over PAE limit.

> [    0.000000] Scanning NUMA topology in Northbridge 24
> [    0.000000] Number of physical nodes 8
> [    0.000000] Node 0 MemBase 0000000000000000 Limit 0000000238000000
> [    0.000000] Node 1 MemBase 0000000238000000 Limit 0000000638000000
> [    0.000000] Node 2 MemBase 0000000638000000 Limit 0000000838000000
> [    0.000000] Node 3 MemBase 0000000838000000 Limit 0000000c38000000
> [    0.000000] Node 4 MemBase 0000000c38000000 Limit 0000000e38000000
> [    0.000000] Node 5 MemBase 0000000e38000000 Limit 0000001000000000
> [    0.000000] Node 6 bogus settings 1238000000-1000000000.
> [    0.000000] Node 7 bogus settings 1438000000-1000000000.

amdtopology code behaved correctly.  It trimmed node 5 which spans
over the PAE limit and squashed nodes above that.

> [    0.000000] BUG: Int 6: CR2   (null)
> [    0.000000]      EDI   (null)  ESI 00000002  EBP 00000002  ESP c1543ecc
> [    0.000000]      EBX f2400000  EDX 00000006  ECX   (null)  EAX 00000001
> [    0.000000]      err   (null)  EIP c16209aa   CS 00000060  flg 00010002
> [    0.000000] Stack: f2400000 00220000 f7200800 c1620613 00220000 01000000 04400000 00238000
> [    0.000000]          (null) f7200000 00000002 f7200b58 f7200800 c1620929 000375fe   (null)
> [    0.000000]        f7200b80 c16395f0 00200a02 f7200a80   (null) 000375fe 00000002   (null)
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.39-rc5-00181-g2706a0b #17
> [    0.000000] Call Trace:
> [    0.000000]  [<c136b1e5>] ? early_fault+0x2e/0x2e
> [    0.000000]  [<c16209aa>] ? mminit_verify_page_links+0x12/0x42
> [    0.000000]  [<c1620613>] ? memmap_init_zone+0xaf/0x10c
> [    0.000000]  [<c1620929>] ? free_area_init_node+0x2b9/0x2e3
> [    0.000000]  [<c1607e99>] ? free_area_init_nodes+0x3f2/0x451
> [    0.000000]  [<c1601d80>] ? paging_init+0x112/0x118
> [    0.000000]  [<c15f578d>] ? setup_arch+0x791/0x82f
> [    0.000000]  [<c15f43d9>] ? start_kernel+0x6a/0x257

But it later tripped in mminit_verify_page_links().  Maybe
page_to_nid() doesn't match?

Hmmm... I can't see how it would have worked before.  amdtopology used
ulong for @end and would simply have been zero.  Maybe NUMA config
failed and it booted as flatmem instead?  Can you please post boot log
before the patch?

Also, can you please apply the following patch, reproduce the boot
failure and post the log?  Thank you.


diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4e0e265..cb230bf 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -124,6 +124,12 @@ void __init mminit_verify_pageflags_layout(void)
 void __meminit mminit_verify_page_links(struct page *page, enum zone_type zone,
 			unsigned long nid, unsigned long pfn)
 {
+	if (page_to_nid(page) != nid || page_zonenum(page) != zone ||
+	    page_to_pfn(page) != pfn)
+		printk(KERN_CRIT "mminit_verify_page_links: nid=%lu/%lu zone=%d/%d pfn=0x%lx/0x%lx\n",
+		       page_to_nid(page), nid, page_zonenum(page), zone,
+		       page_to_pfn(page), pfn);
+
 	BUG_ON(page_to_nid(page) != nid);
 	BUG_ON(page_zonenum(page) != zone);
 	BUG_ON(page_to_pfn(page) != pfn);
