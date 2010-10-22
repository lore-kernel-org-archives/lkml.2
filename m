Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0JVS1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:27:35 -0400
Received: from kroah.org ([198.145.64.141]:37848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758992Ab0JVSZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Robin Holt <holt@sgi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/31] driver core: Convert link_mem_sections to use find_memory_block_hinted.
Date: Fri, 22 Oct 2010 11:25:11 -0700
Message-Id: <1287771916-15016-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>

Modify link_mem_sections() to pass in the previous mem_block as a hint to
locating the next mem_block.  Since they are typically added in order this
results in a massive saving in time during boot of a very large system.
For example, on a 16TB x86_64 machine, it reduced the total time spent
linking all node's memory sections from 1 hour, 27 minutes to 46 seconds.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Gary Hade <garyhade@us.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/node.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 2872e86..ee53558 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -409,25 +409,27 @@ static int link_mem_sections(int nid)
 	unsigned long start_pfn = NODE_DATA(nid)->node_start_pfn;
 	unsigned long end_pfn = start_pfn + NODE_DATA(nid)->node_spanned_pages;
 	unsigned long pfn;
+	struct memory_block *mem_blk = NULL;
 	int err = 0;
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
 		struct mem_section *mem_sect;
-		struct memory_block *mem_blk;
 		int ret;
 
 		if (!present_section_nr(section_nr))
 			continue;
 		mem_sect = __nr_to_section(section_nr);
-		mem_blk = find_memory_block(mem_sect);
+		mem_blk = find_memory_block_hinted(mem_sect, mem_blk);
 		ret = register_mem_sect_under_node(mem_blk, nid);
 		if (!err)
 			err = ret;
 
 		/* discard ref obtained in find_memory_block() */
-		kobject_put(&mem_blk->sysdev.kobj);
 	}
+
+	if (mem_blk)
+		kobject_put(&mem_blk->sysdev.kobj);
 	return err;
 }
 
-- 
1.7.2

