Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0I2TBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:01:18 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60747 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754022Ab0I2TBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:01:16 -0400
Message-Id: <20100929190115.766603780@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Wed, 29 Sep 2010 14:00:56 -0500
From: Robin Holt <holt@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>,
        Badari Pulavarty <pbadari@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Dave Hansen <haveblue@us.ibm.com>,
        Matt Tolentino <matthew.e.tolentino@intel.com>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [Patch 3/3] Convert link_mem_sections to use find_memory_block_hinted.
References: <20100929190053.992911934@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=link_mem_sections-hints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modify link_mem_sections() to pass in the previous mem_block as a hint to
locating the next mem_block.  Since they are typically added in order this
results in a massive saving in time during boot of a very large system.
For example, on a 16TB x86_64 machine, it reduced the total time spent
linking all node's memory sections from 1 hour, 27 minutes to 46 seconds.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Gary Hade <garyhade@us.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>

---

 drivers/base/node.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: pv1010359/drivers/base/node.c
===================================================================
--- pv1010359.orig/drivers/base/node.c	2010-09-29 11:03:14.076094048 -0500
+++ pv1010359/drivers/base/node.c	2010-09-29 11:03:44.739949033 -0500
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
 

