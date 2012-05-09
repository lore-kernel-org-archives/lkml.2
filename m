Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab2EIMj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:39:56 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:45720 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2EIMjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:39:55 -0400
Date: Wed, 9 May 2012 14:39:48 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] percpu: Fix rollback in pcpu_embed_first_chunk()
Message-ID: <20120509143948.4ba4e949@br98xy6r>
Organization: IBM
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12050912-1948-0000-0000-000001BF57C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: percpu: Fix rollback in pcpu_embed_first_chunk()

The "out_free_areas" rollback in pcpu_embed_first_chunk calls the
free_fn() function for all elements in area[]. This is not correct
because not all elements have been allocated.

To fix this we call free_fn() only for allocated elements.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
diff --git a/mm/percpu.c b/mm/percpu.c
index f47af91..5a7f631 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1692,9 +1692,9 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 	goto out_free;
 
 out_free_areas:
-	for (group = 0; group < ai->nr_groups; group++)
-		free_fn(areas[group],
-			ai->groups[group].nr_units * ai->unit_size);
+	for (;group > 0; group--)
+		free_fn(areas[group - 1],
+			ai->groups[group - 1].nr_units * ai->unit_size);
 out_free:
 	pcpu_free_alloc_info(ai);
 	if (areas)

