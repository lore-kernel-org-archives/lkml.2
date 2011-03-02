Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1CBKZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:25:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64480 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab1CBKZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:25:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X3S2HgFDrMOT7U+JfMczKBzt7ZCEqVPzRS+pwuLIQEogR8A39OhXQ9iQRCGi1GAp5Q
         pIvot0luhwEEuGHrxHyH4+7ZadhWdhS0BdoNoievvbAhyGcSFSRQKzVsx+Ewm17g9djH
         dLmAnVgzy1I97u9twADkYWxgoIJHfyTR/163A=
Date: Wed, 2 Mar 2011 11:25:30 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH x86/mm UPDATED] x86-64, NUMA: Fix distance table handling
Message-ID: <20110302102530.GB3319@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302100400.GK19669@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d968be2ff381c667bfd09795f82248558902a1ae Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Wed, 2 Mar 2011 11:22:14 +0100

NUMA distance table handling has the following problems.

* numa_reset_distance() uses numa_distance * sizeof(numa_distance[0])
  as the table size when it should be using the square of
  numa_distance.

* The same size miscalculation when allocation space for phys_dist in
  numa_emulation().

* In numa_emulation(), phys_dist must be reserved; otherwise, the new
  emulated distance table may overlap it.

Fix them and, while at it, take numa_distance_cnt resetting in
numa_reset_distance() out of the if block to simplify the code a bit.

David Rientjes reported incorrect handling of distance table during
emulation and Yinghai identified the above problems and wrote the
original patch to fix the problems.  This patch is based on Yinghai's
patch.

-v2: Ingo was unhappy with 80-column limit induced linebreaks.  Let
     lines run over 80-column.

Reported-by: David Rientjes <rientjes@google.com>
Patch-originally-from: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/numa_64.c        |    8 +++-----
 arch/x86/mm/numa_emulation.c |   14 ++++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 7757d22..541746f 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -390,14 +390,12 @@ static void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
  */
 void __init numa_reset_distance(void)
 {
-	size_t size;
+	size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
 
-	if (numa_distance_cnt) {
-		size = numa_distance_cnt * sizeof(numa_distance[0]);
+	if (numa_distance_cnt)
 		memblock_x86_free_range(__pa(numa_distance),
 					__pa(numa_distance) + size);
-		numa_distance_cnt = 0;
-	}
+	numa_distance_cnt = 0;
 	numa_distance = NULL;
 }
 
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 607a2e8..0afa25d 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -300,6 +300,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	static struct numa_meminfo pi __initdata;
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
 	u8 *phys_dist = NULL;
+	size_t phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
 	int i, j, ret;
 
 	if (!emu_cmdline)
@@ -336,21 +337,18 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 		goto no_emu;
 	}
 
-	/*
-	 * Copy the original distance table.  It's temporary so no need to
-	 * reserve it.
-	 */
+	/* copy the physical distance table */
 	if (numa_dist_cnt) {
-		size_t size = numa_dist_cnt * sizeof(phys_dist[0]);
 		u64 phys;
 
 		phys = memblock_find_in_range(0,
 					      (u64)max_pfn_mapped << PAGE_SHIFT,
-					      size, PAGE_SIZE);
+					      phys_size, PAGE_SIZE);
 		if (phys == MEMBLOCK_ERROR) {
 			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
 			goto no_emu;
 		}
+		memblock_x86_reserve_range(phys, phys + phys_size, "TMP NUMA DIST");
 		phys_dist = __va(phys);
 
 		for (i = 0; i < numa_dist_cnt; i++)
@@ -398,6 +396,10 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 			numa_set_distance(i, j, dist);
 		}
 	}
+
+	/* free the copied physical distance table */
+	if (phys_dist)
+		memblock_x86_free_range(__pa(phys_dist), __pa(phys_dist) + phys_size);
 	return;
 
 no_emu:
-- 
1.7.1

