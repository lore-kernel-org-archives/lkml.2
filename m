Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690Ab1D2TBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:01:44 -0400
Received: from kroah.org ([198.145.64.141]:50392 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933617Ab1D2S6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:56 2011
Message-Id: <20110429185656.703014966@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Schmitz <schmitz@debian.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [43/55] m68k/mm: Set all online nodes in N_NORMAL_MEMORY
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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

---
 arch/m68k/mm/motorola.c |    2 ++
 1 file changed, 2 insertions(+)

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
 


