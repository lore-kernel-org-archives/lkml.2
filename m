Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab1LEOH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 09:07:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab1LEOH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 09:07:57 -0500
Date: Mon, 5 Dec 2011 14:07:51 +0000
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Namhyung Kim <namhyung@gmail.com>,
        Luciano Chavez <lnx1138@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: vmalloc: Check for page allocation failure before vmlist
 insertion
Message-ID: <20111205140750.GB5070@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit [f5252e00: mm: avoid null pointer access in vm_struct via
/proc/vmallocinfo] adds newly allocated vm_structs to the vmlist
after it is fully initialised. Unfortunately, it did not check that
__vmalloc_area_node() successfully populated the area. In the event
of allocation failure, the vmalloc area is freed but the pointer to
freed memory is inserted into the vmlist leading to a a crash later
in get_vmalloc_info().

This patch adds a check for ____vmalloc_area_node() failure within
__vmalloc_node_range. It does not use "goto fail" as in the previous
error path as a warning was already displayed by __vmalloc_area_node()
before it called vfree in its failure path.

Credit goes to Luciano Chavez for doing all the real work of
identifying exactly where the problem was.

If accepted, this should be considered a -stable candidate.

Reported-and-tested-by: Luciano Chavez <lnx1138@linux.vnet.ibm.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmalloc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3231bf3..1d8b32f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1633,6 +1633,8 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 		goto fail;
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
+	if (!addr)
+		return NULL;
 
 	/*
 	 * In this function, newly allocated vm_struct is not added
