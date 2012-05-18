Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031301Ab2ERX2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:28:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946350Ab2ERXEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:09 -0400
Message-Id: <20120518211602.190242600@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        "Pavel V. Panteleev" <pp_84@mail.ru>
Subject: [ 30/54] percpu: pcpu_embed_first_chunk() should free unused parts after all allocs are complete
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/percpu.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1630,6 +1630,16 @@ int __init pcpu_embed_first_chunk(size_t
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


