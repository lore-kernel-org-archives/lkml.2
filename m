Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab0DHEM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:12:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:53239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab0DHEMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:12:20 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, graff.yang@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       sonic.adi@gmail.com, cl@linux-foundation.org, mingo@elte.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] percpu: reorganize chunk creation and destruction
Date: Thu,  8 Apr 2010 13:11:02 +0900
Message-Id: <1270699865-16954-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270699865-16954-1-git-send-email-tj@kernel.org>
References: <1270699865-16954-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 08 Apr 2010 04:11:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize alloc/free_pcpu_chunk() such that chunk struct alloc/free
live in pcpu_alloc/free_chunk() and the rest in
pcpu_create/destroy_chunk().

This patch doesn't cause any functional change.  This is to allow
alternate chunk management implementation for percpu nommu support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Graff Yang <graff.yang@gmail.com>
Cc: Sonic Zhang <sonic.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>
---
 mm/percpu.c |   65 +++++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 1aeb081..c30ca03 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -636,6 +636,33 @@ static void pcpu_free_area(struct pcpu_chunk *chunk, int freeme)
 	pcpu_chunk_relocate(chunk, oslot);
 }
 
+static struct pcpu_chunk *pcpu_alloc_chunk(void)
+{
+	struct pcpu_chunk *chunk;
+
+	chunk = kzalloc(pcpu_chunk_struct_size, GFP_KERNEL);
+	if (!chunk)
+		return NULL;
+
+	chunk->map = pcpu_mem_alloc(PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
+	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
+	chunk->map[chunk->map_used++] = pcpu_unit_size;
+
+	INIT_LIST_HEAD(&chunk->list);
+	chunk->free_size = pcpu_unit_size;
+	chunk->contig_hint = pcpu_unit_size;
+
+	return chunk;
+}
+
+static void pcpu_free_chunk(struct pcpu_chunk *chunk)
+{
+	if (!chunk)
+		return;
+	pcpu_mem_free(chunk->map, chunk->map_alloc * sizeof(chunk->map[0]));
+	kfree(chunk);
+}
+
 /**
  * pcpu_get_pages_and_bitmap - get temp pages array and bitmap
  * @chunk: chunk of interest
@@ -1028,41 +1055,31 @@ err_free:
 	return rc;
 }
 
-static void free_pcpu_chunk(struct pcpu_chunk *chunk)
+static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
 {
-	if (!chunk)
-		return;
-	if (chunk->vms)
+	if (chunk && chunk->vms)
 		pcpu_free_vm_areas(chunk->vms, pcpu_nr_groups);
-	pcpu_mem_free(chunk->map, chunk->map_alloc * sizeof(chunk->map[0]));
-	kfree(chunk);
+	pcpu_free_chunk(chunk);
 }
 
-static struct pcpu_chunk *alloc_pcpu_chunk(void)
+static struct pcpu_chunk *pcpu_create_chunk(void)
 {
 	struct pcpu_chunk *chunk;
+	struct vm_struct **vms;
 
-	chunk = kzalloc(pcpu_chunk_struct_size, GFP_KERNEL);
+	chunk = pcpu_alloc_chunk();
 	if (!chunk)
 		return NULL;
 
-	chunk->map = pcpu_mem_alloc(PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
-	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
-	chunk->map[chunk->map_used++] = pcpu_unit_size;
-
-	chunk->vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
-				       pcpu_nr_groups, pcpu_atom_size,
-				       GFP_KERNEL);
-	if (!chunk->vms) {
-		free_pcpu_chunk(chunk);
+	vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
+				pcpu_nr_groups, pcpu_atom_size, GFP_KERNEL);
+	if (!vms) {
+		pcpu_free_chunk(chunk);
 		return NULL;
 	}
 
-	INIT_LIST_HEAD(&chunk->list);
-	chunk->free_size = pcpu_unit_size;
-	chunk->contig_hint = pcpu_unit_size;
-	chunk->base_addr = chunk->vms[0]->addr - pcpu_group_offsets[0];
-
+	chunk->vms = vms;
+	chunk->base_addr = vms[0]->addr - pcpu_group_offsets[0];
 	return chunk;
 }
 
@@ -1155,7 +1172,7 @@ restart:
 	/* hmmm... no space left, create a new chunk */
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
-	chunk = alloc_pcpu_chunk();
+	chunk = pcpu_create_chunk();
 	if (!chunk) {
 		err = "failed to allocate new chunk";
 		goto fail_unlock_mutex;
@@ -1267,7 +1284,7 @@ static void pcpu_reclaim(struct work_struct *work)
 
 	list_for_each_entry_safe(chunk, next, &todo, list) {
 		pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size);
-		free_pcpu_chunk(chunk);
+		pcpu_destroy_chunk(chunk);
 	}
 
 	mutex_unlock(&pcpu_alloc_mutex);
-- 
1.6.4.2

