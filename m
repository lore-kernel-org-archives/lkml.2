Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698Ab2D0Pm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:42:59 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:44536 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760252Ab2D0Pm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:42:58 -0400
Date: Fri, 27 Apr 2012 08:42:53 -0700
From: Tejun Heo <tj@kernel.org>
To: "Pavel V. Panteleev" <pp_84@mail.ru>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-mm <linux-mm@kvak.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        andi <andi@firstfloor.org>
Subject: [PATCH] percpu: pcpu_embed_first_chunk() should free unused parts
 after all allocs are complete
Message-ID: <20120427154253.GL27486@google.com>
References: <E1SNhwY-0007ui-V7.pp_84-mail-ru@f220.mail.ru>
 <20120427141704.GH27486@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427141704.GH27486@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org
Reported-by: "Pavel V. Panteleev" <pp_84@mail.ru>
LKML-Reference: <E1SNhwY-0007ui-V7.pp_84-mail-ru@f220.mail.ru>
---
Can you please verify this patch fixes the problem?

Thanks.

 mm/percpu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index f47af91..7975693 100644
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
