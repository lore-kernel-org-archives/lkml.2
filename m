Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964866Ab1LPTxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:53:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760640Ab1LPTv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:51:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:09 2011
Message-Id: <20111216194209.042369367@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>
Subject: [14/45] mm: vmalloc: check for page allocation failure before vmlist insertion
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 1368edf0647ac112d8cfa6ce47257dc950c50f5c upstream.

Commit f5252e00 ("mm: avoid null pointer access in vm_struct via
/proc/vmallocinfo") adds newly allocated vm_structs to the vmlist after
it is fully initialised.  Unfortunately, it did not check that
__vmalloc_area_node() successfully populated the area.  In the event of
allocation failure, the vmalloc area is freed but the pointer to freed
memory is inserted into the vmlist leading to a a crash later in
get_vmalloc_info().

This patch adds a check for ____vmalloc_area_node() failure within
__vmalloc_node_range.  It does not use "goto fail" as in the previous
error path as a warning was already displayed by __vmalloc_area_node()
before it called vfree in its failure path.

Credit goes to Luciano Chavez for doing all the real work of identifying
exactly where the problem was.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Luciano Chavez <lnx1138@linux.vnet.ibm.com>
Tested-by: Luciano Chavez <lnx1138@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmalloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1648,6 +1648,8 @@ void *__vmalloc_node_range(unsigned long
 		return NULL;
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+	if (!addr)
+		return NULL;
 
 	/*
 	 * In this function, newly allocated vm_struct is not added


