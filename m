Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab2CMAt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:49:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:48104 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881Ab2CMAXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Michael Schmitz <schmitzmic@googlemail.com>,
        Michael Schmitz <schmitz@debian.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 102/196] m68k/mm: Set all online nodes in N_NORMAL_MEMORY
Date: Mon, 12 Mar 2012 20:20:15 -0400
Message-Id: <1331598109-31424-57-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Schmitz <schmitzmic@googlemail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4aac0b4815ba592052758f4b468f253d383dc9d6 upstream.

For m68k, N_NORMAL_MEMORY represents all nodes that have present memory
since it does not support HIGHMEM.  This patch sets the bit at the time
node_present_pages has been set by free_area_init_node.
At the time the node is brought online, the node state would have to be
done unconditionally since information about present memory has not yet
been recorded.

If N_NORMAL_MEMORY is not accurate, slub may encounter errors since it
uses this nodemask to setup per-cache kmem_cache_node data structures.

This pach is an alternative to the one proposed by David Rientjes
<rientjes@google.com> attempting to set node state immediately when
bringing the node online.

Signed-off-by: Michael Schmitz <schmitz@debian.org>
Tested-by: Thorsten Glaser <tg@debian.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/m68k/mm/motorola.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index 02b7a03..8b3db1c 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -300,6 +300,8 @@ void __init paging_init(void)
 		zones_size[ZONE_DMA] = m68k_memory[i].size >> PAGE_SHIFT;
 		free_area_init_node(i, zones_size,
 				    m68k_memory[i].addr >> PAGE_SHIFT, NULL);
+		if (node_present_pages(i))
+			node_set_state(i, N_NORMAL_MEMORY);
 	}
 }
 
-- 
1.7.9.3

