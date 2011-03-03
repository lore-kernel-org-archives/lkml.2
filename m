Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1CCBZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:25:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37315 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab1CCBZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:25:49 -0500
Message-ID: <4D6EEDF2.6090201@kernel.org>
Date: Wed, 02 Mar 2011 17:25:06 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86, numa, emu: move size calculation into if block
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D6EEE0F.00A8,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



don't need to assign them that early.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/numa_64.c        |   11 +++++------
 arch/x86/mm/numa_emulation.c |    3 ++-
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -390,13 +390,12 @@ static void __init numa_nodemask_from_me
  */
 void __init numa_reset_distance(void)
 {
-	size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
-
 	/* numa_distance could be 1LU marking allocation failure, test cnt */
-	if (numa_distance_cnt)
-		memblock_x86_free_range(__pa(numa_distance),
-					__pa(numa_distance) + size);
-	numa_distance_cnt = 0;
+	if (numa_distance_cnt) {
+		size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
+		memblock_x86_free_range(__pa(numa_distance), __pa(numa_distance) + size);
+		numa_distance_cnt = 0;
+	}
 	numa_distance = NULL;	/* enable table creation */
 }
 
Index: linux-2.6/arch/x86/mm/numa_emulation.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_emulation.c
+++ linux-2.6/arch/x86/mm/numa_emulation.c
@@ -300,7 +300,7 @@ void __init numa_emulation(struct numa_m
 	static struct numa_meminfo pi __initdata;
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
 	u8 *phys_dist = NULL;
-	size_t phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
+	size_t phys_size = 0;
 	int i, j, ret;
 
 	if (!emu_cmdline)
@@ -341,6 +341,7 @@ void __init numa_emulation(struct numa_m
 	if (numa_dist_cnt) {
 		u64 phys;
 
+		phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
 		phys = memblock_find_in_range(0,
 					      (u64)max_pfn_mapped << PAGE_SHIFT,
 					      phys_size, PAGE_SIZE);
