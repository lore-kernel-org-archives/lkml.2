Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1G0Akb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:40:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:18089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab1G0AfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32380283"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: schmitzmic@googlemail.com, schmitz@debian.org, tg@debian.org,
        geert@linux-m68k.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [15/98] m68k/mm: Set all online nodes in N_NORMAL_MEMORY
Message-Id: <20110727003507.3DBB42403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Michael Schmitz <schmitzmic@googlemail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/m68k/mm/motorola.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/arch/m68k/mm/motorola.c
===================================================================
--- linux-2.6.35.y.orig/arch/m68k/mm/motorola.c
+++ linux-2.6.35.y/arch/m68k/mm/motorola.c
@@ -300,6 +300,8 @@ void __init paging_init(void)
 		zones_size[ZONE_DMA] = m68k_memory[i].size >> PAGE_SHIFT;
 		free_area_init_node(i, zones_size,
 				    m68k_memory[i].addr >> PAGE_SHIFT, NULL);
+		if (node_present_pages(i))
+			node_set_state(i, N_NORMAL_MEMORY);
 	}
 }
 
