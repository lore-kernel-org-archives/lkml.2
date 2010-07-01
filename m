Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653Ab0GAWGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:06:41 -0400
Received: from kroah.org ([198.145.64.141]:47585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705Ab0GAUub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:31 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:33 2010
Message-Id: <20100701173433.549553484@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sebastien Dugue <sebastien.dugue@bull.net>,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 080/164] mlx4_core: Fix possible chunk sg list overflow in mlx4_alloc_icm()
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastien Dugue <sebastien.dugue@bull.net>

commit c0dc72bad9cf21071f5e4005de46f7c8b67a138a upstream.

If the number of sg entries in the ICM chunk reaches MLX4_ICM_CHUNK_LEN,
we must set chunk to NULL even for coherent mappings so that the next
time through the loop will allocate another chunk.  Otherwise we'll
overflow the sg list the next time through the loop.  This will lead to
memory corruption if this case is hit.

mthca does not have this bug.

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/mlx4/icm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/mlx4/icm.c
+++ b/drivers/net/mlx4/icm.c
@@ -174,9 +174,10 @@ struct mlx4_icm *mlx4_alloc_icm(struct m
 
 				if (chunk->nsg <= 0)
 					goto fail;
+			}
 
+			if (chunk->npages == MLX4_ICM_CHUNK_LEN)
 				chunk = NULL;
-			}
 
 			npages -= 1 << cur_order;
 		} else {


