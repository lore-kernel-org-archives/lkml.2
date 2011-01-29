Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1A2WUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 17:20:30 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23633 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab1A2WU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 17:20:28 -0500
Date: Sat, 29 Jan 2011 23:21:40 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@kernel.org>
Subject: [PATCH] SCSI, target: Avoid mem leak and needless work in
 transport_generic_get_mem().
Message-ID: <alpine.LNX.2.00.1101292316490.19392@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/target/target_core_transport.c::transport_generic_get_mem() 
there are a few potential memory leaks in the error paths. This patch 
makes sure that we free previously allocated memory when other allocations 
fail. It also moves some work (INIT_LIST_HEAD() and assignment to 
se_mem->se_len) below all the allocations so that if something fails we 
don't do the work at all.

Please review and consider for inclusion.
I don't have any hardware to actually test this so it is compile tested 
only.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 target_core_transport.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 28b6292..4776293 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4334,11 +4334,9 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 			printk(KERN_ERR "Unable to allocate struct se_mem\n");
 			goto out;
 		}
-		INIT_LIST_HEAD(&se_mem->se_list);
-		se_mem->se_len = (length > dma_size) ? dma_size : length;
 
 /* #warning FIXME Allocate contigous pages for struct se_mem elements */
-		se_mem->se_page = (struct page *) alloc_pages(GFP_KERNEL, 0);
+		se_mem->se_page = alloc_pages(GFP_KERNEL, 0);
 		if (!(se_mem->se_page)) {
 			printk(KERN_ERR "alloc_pages() failed\n");
 			goto out;
@@ -4349,6 +4347,8 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 			printk(KERN_ERR "kmap_atomic() failed\n");
 			goto out;
 		}
+		INIT_LIST_HEAD(&se_mem->se_list);
+		se_mem->se_len = (length > dma_size) ? dma_size : length;
 		memset(buf, 0, se_mem->se_len);
 		kunmap_atomic(buf, KM_IRQ0);
 
@@ -4367,6 +4367,9 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 
 	return 0;
 out:
+	if (se_mem)
+		__free_pages(se_mem->se_page, 0);
+	kmem_cache_free(se_mem_cache, se_mem);
 	return -1;
 }
 


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

