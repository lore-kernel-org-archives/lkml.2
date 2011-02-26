Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab1BZDJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 22:09:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24349 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab1BZDJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 22:09:54 -0500
Message-ID: <4D686EB8.4080507@kernel.org>
Date: Fri, 25 Feb 2011 19:08:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86,mm,64bit: Round up memory boundary for init_memory_mapping_high()
References: <20110223171945.GI26065@htj.dyndns.org> <4D656D1A.7030006@kernel.org> <20110223204656.GA27738@atj.dyndns.org> <4D657359.5060901@kernel.org> <20110223210326.GB27738@atj.dyndns.org> <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com> <20110224091557.GD7840@htj.dyndns.org> <4D674A33.8000809@kernel.org> <20110225100336.GA26608@elte.hu>
In-Reply-To: <20110225100336.GA26608@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D686EE7.00D1,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tj pointed out:
	when node does not have 1G aligned boundary, like 128M.
init_memory_mapping_high() could render smaller mapping by 128M on one node,
and 896M on next node with 2M pages instead of 1g page. that could increase
TLB presure.

So if gb page is used, try to align the boundary to 1G before calling
init_memory_mapping_ext(), to make sure only use one 1g entry for that cross
node 1G.
Need to init_meory_mapping_ext() to table tbl_end, to make sure pgtable is on
previous node instead of next node.

on one AMD 512g system with not aligned boundary (extra 768M)
before the patch
[    0.000000] init_memory_mapping: [0x00000000000000-0x000000d7f9ffff]
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00d7e00000 page 2M
[    0.000000]  00d7e00000 - 00d7fa0000 page 4k
[    0.000000] kernel direct mapping tables up to d7fa0000 @ [0xd7f9d000-0xd7f9ffff] pre-allocated
[    0.000000] kernel direct mapping tables up to d7fa0000 @ [0xd7f9d000-0xd7f9efff] final
[    0.000000]     memblock_x86_reserve_range: [0xd7f9d000-0xd7f9efff]          PGTABLE
...
[    0.000000] Adding active range (0, 0x10, 0x98) 0 entries of 3200 used
[    0.000000] Adding active range (0, 0x100, 0xd7fa0) 1 entries of 3200 used
[    0.000000] Adding active range (0, 0x100000, 0x1028000) 2 entries of 3200 used
[    0.000000] Adding active range (1, 0x1028000, 0x2028000) 3 entries of 3200 used
[    0.000000] Adding active range (2, 0x2028000, 0x3028000) 4 entries of 3200 used
[    0.000000] Adding active range (3, 0x3028000, 0x4028000) 5 entries of 3200 used
[    0.000000] Adding active range (4, 0x4028000, 0x5028000) 6 entries of 3200 used
[    0.000000] Adding active range (5, 0x5028000, 0x6028000) 7 entries of 3200 used
[    0.000000] Adding active range (6, 0x6028000, 0x7028000) 8 entries of 3200 used
[    0.000000] Adding active range (7, 0x7028000, 0x8028000) 9 entries of 3200 used
[    0.000000] init_memory_mapping: [0x00000100000000-0x00001027ffffff]
[    0.000000]  0100000000 - 1000000000 page 1G
[    0.000000]  1000000000 - 1028000000 page 2M
[    0.000000] kernel direct mapping tables up to 1028000000 @ [0x1027ffe000-0x1027ffffff] pre-allocated
[    0.000000] kernel direct mapping tables up to 1028000000 @ [0x1027ffe000-0x1027ffefff] final
[    0.000000]     memblock_x86_reserve_range: [0x1027ffe000-0x1027ffefff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00001028000000-0x00002027ffffff]
[    0.000000]  1028000000 - 1040000000 page 2M
[    0.000000]  1040000000 - 2000000000 page 1G
[    0.000000]  2000000000 - 2028000000 page 2M
[    0.000000] kernel direct mapping tables up to 2028000000 @ [0x2027ffe000-0x2027ffffff] pre-allocated
[    0.000000] kernel direct mapping tables up to 2028000000 @ [0x2027ffe000-0x2027ffefff] final
[    0.000000]     memblock_x86_reserve_range: [0x2027ffe000-0x2027ffefff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00002028000000-0x00003027ffffff]
[    0.000000]  2028000000 - 2040000000 page 2M
[    0.000000]  2040000000 - 3000000000 page 1G
[    0.000000]  3000000000 - 3028000000 page 2M
[    0.000000] kernel direct mapping tables up to 3028000000 @ [0x3027ffe000-0x3027ffffff] pre-allocated
[    0.000000] kernel direct mapping tables up to 3028000000 @ [0x3027ffe000-0x3027ffefff] final
[    0.000000]     memblock_x86_reserve_range: [0x3027ffe000-0x3027ffefff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00003028000000-0x00004027ffffff]
[    0.000000]  3028000000 - 3040000000 page 2M
[    0.000000]  3040000000 - 4000000000 page 1G
[    0.000000]  4000000000 - 4028000000 page 2M
[    0.000000] kernel direct mapping tables up to 4028000000 @ [0x4027ffe000-0x4027ffffff] pre-allocated
[    0.000000] kernel direct mapping tables up to 4028000000 @ [0x4027ffe000-0x4027ffefff] final
[    0.000000]     memblock_x86_reserve_range: [0x4027ffe000-0x4027ffefff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00004028000000-0x00005027ffffff]
[    0.000000]  4028000000 - 4040000000 page 2M
[    0.000000]  4040000000 - 5000000000 page 1G
[    0.000000]  5000000000 - 5028000000 page 2M
[    0.000000] kernel direct mapping tables up to 5028000000 @ [0x5027ffe000-0x5027ffffff] pre-allocated
[    0.000000] kernel direct mapping tables up to 5028000000 @ [0x5027ffe000-0x5027ffefff] final
[    0.000000]     memblock_x86_reserve_range: [0x5027ffe000-0x5027ffefff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00005028000000-0x00006027ffffff]
[    0.000000]  5028000000 - 5040000000 page 2M
[    0.000000]  5040000000 - 6000000000 page 1G
[    0.000000]  6000000000 - 6028000000 page 2M
[    0.000000] kernel direct mapping tables up to 6028000000 @ [0x6027ffe000-0x6027ffffff] pre-allocated
[    0.000000] kernel direct mapping tables up to 6028000000 @ [0x6027ffe000-0x6027ffefff] final
[    0.000000]     memblock_x86_reserve_range: [0x6027ffe000-0x6027ffefff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00006028000000-0x00007027ffffff]
[    0.000000]  6028000000 - 6040000000 page 2M
[    0.000000]  6040000000 - 7000000000 page 1G
[    0.000000]  7000000000 - 7028000000 page 2M
[    0.000000] kernel direct mapping tables up to 7028000000 @ [0x7027ffe000-0x7027ffffff] pre-allocated
[    0.000000] kernel direct mapping tables up to 7028000000 @ [0x7027ffe000-0x7027ffefff] final
[    0.000000]     memblock_x86_reserve_range: [0x7027ffe000-0x7027ffefff]          PGTABLE
[    0.000000] init_memory_mapping: [0x00007028000000-0x00008027ffffff]
[    0.000000]  7028000000 - 7040000000 page 2M
[    0.000000]  7040000000 - 8000000000 page 1G
[    0.000000]  8000000000 - 8028000000 page 2M
[    0.000000] kernel direct mapping tables up to 8028000000 @ [0x8027ffd000-0x8027ffffff] pre-allocated
[    0.000000] kernel direct mapping tables up to 8028000000 @ [0x8027ffd000-0x8027ffefff] final
[    0.000000]     memblock_x86_reserve_range: [0x8027ffd000-0x8027ffefff]          PGTABLE

after patch
...
[    0.000000] init_memory_mapping: [0x00000100000000-0x0000103fffffff]
[    0.000000]  0100000000 - 1040000000 page 1G
[    0.000000] kernel direct mapping tables up to 1040000000 @ [0x1027fff000-0x1027ffffff] pre-allocated
[    0.000000] init_memory_mapping: [0x00001040000000-0x0000203fffffff]
[    0.000000]  1040000000 - 2040000000 page 1G
[    0.000000] kernel direct mapping tables up to 2040000000 @ [0x2027fff000-0x2027ffffff] pre-allocated
[    0.000000] init_memory_mapping: [0x00002040000000-0x0000303fffffff]
[    0.000000]  2040000000 - 3040000000 page 1G
[    0.000000] kernel direct mapping tables up to 3040000000 @ [0x3027fff000-0x3027ffffff] pre-allocated
[    0.000000] init_memory_mapping: [0x00003040000000-0x0000403fffffff]
[    0.000000]  3040000000 - 4040000000 page 1G
[    0.000000] kernel direct mapping tables up to 4040000000 @ [0x4027fff000-0x4027ffffff] pre-allocated
[    0.000000] init_memory_mapping: [0x00004040000000-0x0000503fffffff]
[    0.000000]  4040000000 - 5040000000 page 1G
[    0.000000] kernel direct mapping tables up to 5040000000 @ [0x5027fff000-0x5027ffffff] pre-allocated
[    0.000000] init_memory_mapping: [0x00005040000000-0x0000603fffffff]
[    0.000000]  5040000000 - 6040000000 page 1G
[    0.000000] kernel direct mapping tables up to 6040000000 @ [0x6027fff000-0x6027ffffff] pre-allocated
[    0.000000] init_memory_mapping: [0x00006040000000-0x0000703fffffff]
[    0.000000]  6040000000 - 7040000000 page 1G
[    0.000000] kernel direct mapping tables up to 7040000000 @ [0x7027fff000-0x7027ffffff] pre-allocated
[    0.000000] init_memory_mapping: [0x00007040000000-0x00008027ffffff]
[    0.000000]  7040000000 - 8000000000 page 1G
[    0.000000]  8000000000 - 8028000000 page 2M
[    0.000000] kernel direct mapping tables up to 8028000000 @ [0x8027ffd000-0x8027ffffff] pre-allocated
[    0.000000] kernel direct mapping tables up to 8028000000 @ [0x8027ffd000-0x8027ffefff] final
[    0.000000]     memblock_x86_reserve_range: [0x8027ffd000-0x8027ffefff]          PGTABLE

So it fix the extra mapping problem.

-v2:  Ingo is not happy with the #ifdef detection etc.
	use page_size_mask instead of checking if gbpage is used or not.

Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/init_64.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -614,6 +614,7 @@ struct mapping_work_data {
 	unsigned long start;
 	unsigned long end;
 	unsigned long pfn_mapped;
+	unsigned long align;
 };
 
 static int __init_refok
@@ -621,7 +622,14 @@ mapping_work_fn(unsigned long start_pfn,
 {
 	struct mapping_work_data *data = datax;
 	unsigned long pfn_mapped;
-	unsigned long final_start, final_end;
+	unsigned long final_start, final_end, tbl_end;
+
+	tbl_end = end_pfn << PAGE_SHIFT;
+	/* need to align them to 1G or 2M boundary to avoid smaller mapping */
+	start_pfn = round_down(start_pfn, data->align>>PAGE_SHIFT);
+	if (start_pfn < data->pfn_mapped)
+		start_pfn = data->pfn_mapped;
+	end_pfn = round_up(end_pfn, data->align>>PAGE_SHIFT);
 
 	final_start = max_t(unsigned long, start_pfn<<PAGE_SHIFT, data->start);
 	final_end = min_t(unsigned long, end_pfn<<PAGE_SHIFT, data->end);
@@ -629,7 +637,7 @@ mapping_work_fn(unsigned long start_pfn,
 	if (final_end <= final_start)
 		return 0;
 
-	pfn_mapped = init_memory_mapping(final_start, final_end);
+	pfn_mapped = init_memory_mapping_ext(final_start, final_end, tbl_end);
 
 	if (pfn_mapped > data->pfn_mapped)
 		data->pfn_mapped = pfn_mapped;
@@ -645,6 +653,7 @@ init_memory_mapping_active_regions(unsig
 	data.start = start;
 	data.end = end;
 	data.pfn_mapped = 0;
+	data.align = (page_size_mask & (1<<PG_LEVEL_1G)) ? 1UL<<30 : 1UL<<21;
 
 	work_with_active_regions(MAX_NUMNODES, mapping_work_fn, &data);
 
