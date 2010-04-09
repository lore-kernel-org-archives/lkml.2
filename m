Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0DIJ4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:56:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:44835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897Ab0DIJ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:56:08 -0400
Message-ID: <4BBEFA59.2050807@kernel.org>
Date: Fri, 09 Apr 2010 18:58:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, graff.yang@gmail.com, dhowells@redhat.com,
       akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       sonic.adi@gmail.com, cl@linux-foundation.org, mingo@elte.hu
Subject: [PATCH 2/5 UPDATED] percpu: reorganize chunk creation and destruction
References: <1270699865-16954-1-git-send-email-tj@kernel.org> <1270699865-16954-3-git-send-email-tj@kernel.org>
In-Reply-To: <1270699865-16954-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 09 Apr 2010 09:55:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize alloc/free_pcpu_chunk() such that chunk struct alloc/free
live in pcpu_alloc/free_chunk() and the rest in
pcpu_create/destroy_chunk().  While at it, add missing error handling
for chunk->map allocation failure.

This is to allow alternate chunk management implementation for percpu
nommu support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Graff Yang <graff.yang@gmail.com>
Cc: Sonic Zhang <sonic.adi@gmail.com>
---
Add code to handle chunk->map alloc failure.  Git tree updated
accordingly.  Thanks.

 mm/percpu.c |   70 +++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 24 deletions(-)

Index: work/mm/percpu.c
===================================================================
--- work.orig/mm/percpu.c
+++ work/mm/percpu.c
@@ -636,6 +636,38 @@ static void pcpu_free_area(struct pcpu_c
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
+	if (!chunk->map) {
+		kfree(chunk);
+		return NULL;
+	}
+
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
@@ -1028,41 +1060,31 @@ err_free:
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

@@ -1155,7 +1177,7 @@ restart:
 	/* hmmm... no space left, create a new chunk */
 	spin_unlock_irqrestore(&pcpu_lock, flags);

-	chunk = alloc_pcpu_chunk();
+	chunk = pcpu_create_chunk();
 	if (!chunk) {
 		err = "failed to allocate new chunk";
 		goto fail_unlock_mutex;
@@ -1267,7 +1289,7 @@ static void pcpu_reclaim(struct work_str

 	list_for_each_entry_safe(chunk, next, &todo, list) {
 		pcpu_depopulate_chunk(chunk, 0, pcpu_unit_size);
-		free_pcpu_chunk(chunk);
+		pcpu_destroy_chunk(chunk);
 	}

 	mutex_unlock(&pcpu_alloc_mutex);
