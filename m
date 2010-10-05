Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab0JEXVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:21:33 -0400
Received: from kroah.org ([198.145.64.141]:46760 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757907Ab0JEXVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:21:32 -0400
Subject: patch "driver core: Convert link_mem_sections to use find_memory_block_hinted." added to gregkh-2.6 tree
To: holt@sgi.com, garyhade@us.ibm.com, gregkh@suse.de, haveblue@us.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        matthew.e.tolentino@intel.com, mingo@elte.hu, pbadari@us.ibm.com,
        rpjday@crashcourse.ca
From: <gregkh@suse.de>
Date: Tue, 05 Oct 2010 16:18:09 -0700
In-Reply-To: <20100929190115.766603780@gulag1.americas.sgi.com>
Message-ID: <1286320689207@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: Convert link_mem_sections to use find_memory_block_hinted.

to my gregkh-2.6 tree which can be found in directory form at:
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
 and in git form at:
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git

The filename of this patch is:
    driver-core-convert-link_mem_sections-to-use-find_memory_block_hinted.patch

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

If this patch meets the merge guidelines for a bugfix, it should be
merged into Linus's tree before the next major kernel release.
If not, it will be merged into Linus's tree during the next merge window.

Either way, you will probably be copied on the patch when it gets sent
to Linus for merging so that others can see what is happening in kernel
development.

If you have any questions about this process, please let me know.


>From holt@sgi.com  Tue Oct  5 15:51:00 2010
Message-Id: <20100929190115.766603780@gulag1.americas.sgi.com>
Date: Wed, 29 Sep 2010 14:00:56 -0500
From: Robin Holt <holt@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>,
	Gary Hade <garyhade@us.ibm.com>,
	Badari Pulavarty <pbadari@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Dave Hansen <haveblue@us.ibm.com>,
	Matt Tolentino <matthew.e.tolentino@intel.com>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: driver core: Convert link_mem_sections to use find_memory_block_hinted.


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
 1 file changed, 5 insertions(+), 3 deletions(-)

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
 

