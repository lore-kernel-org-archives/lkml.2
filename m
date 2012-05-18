Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031190Ab2ERDJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:09:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40414 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762517Ab2ERCw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:29 -0400
Message-Id: <20120518023255.184356984@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        "Pavel V. Panteleev" <pp_84@mail.ru>
Subject: [ 06/53] percpu: pcpu_embed_first_chunk() should free unused parts after all allocs are complete
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 42b64281453249dac52861f9b97d18552a7ec62b upstream.

pcpu_embed_first_chunk() allocates memory for each node, copies percpu
data and frees unused portions of it before proceeding to the next
group.  This assumes that allocations for different nodes doesn't
overlap; however, depending on memory topology, the bootmem allocator
may end up allocating memory from a different node than the requested
one which may overlap with the portion freed from one of the previous
percpu areas.  This leads to percpu groups for different nodes
overlapping which is a serious bug.

This patch separates out copy & partial free from the allocation loop
such that all allocations are complete before partial frees happen.

This also fixes overlapping frees which could happen on allocation
failure path - out_free_areas path frees whole groups but the groups
could have portions freed at that point.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "Pavel V. Panteleev" <pp_84@mail.ru>
Tested-by: "Pavel V. Panteleev" <pp_84@mail.ru>
LKML-Reference: <E1SNhwY-0007ui-V7.pp_84-mail-ru@f220.mail.ru>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/percpu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index f921fdf..ac5c626 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1650,6 +1650,16 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 		areas[group] = ptr;
 
 		base = min(ptr, base);
+	}
+
+	/*
+	 * Copy data and free unused parts.  This should happen after all
+	 * allocations are complete; otherwise, we may end up with
+	 * overlapping groups.
+	 */
+	for (group = 0; group < ai->nr_groups; group++) {
+		struct pcpu_group_info *gi = &ai->groups[group];
+		void *ptr = areas[group];
 
 		for (i = 0; i < gi->nr_units; i++, ptr += ai->unit_size) {
 			if (gi->cpu_map[i] == NR_CPUS) {
-- 
1.7.10



