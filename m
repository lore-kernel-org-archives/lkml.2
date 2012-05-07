Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab2EGTcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:32:08 -0400
Received: from relay3.sgi.com ([192.48.152.1]:44058 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752760Ab2EGTcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:32:06 -0400
Date: Mon, 7 May 2012 14:32:03 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Yinghai Lu <yinghai@kernel.org>, David Miller <davem@davemloft.net>
Cc: Russ Anderson <rja@sgi.com>
Subject: [patch] mm: nobootmem: fix sign extend problem in __free_pages_memory()
Message-ID: <20120507193202.GA11518@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Systems with 8 TBytes of memory or greater can hit a problem 
where only the the first 8 TB of memory shows up.  This is
due to "int i" being smaller than "unsigned long start_aligned",
causing the high bits to be dropped.

The fix is to change i to unsigned long to match start_aligned
and end_aligned.

Thanks to Jack Steiner (steiner@sgi.com) for assistance tracking
this down.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 mm/nobootmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/mm/nobootmem.c
===================================================================
--- linux.orig/mm/nobootmem.c	2012-05-05 08:39:39.470845187 -0500
+++ linux/mm/nobootmem.c	2012-05-05 08:39:42.714784530 -0500
@@ -82,8 +82,7 @@ void __init free_bootmem_late(unsigned l
 
 static void __init __free_pages_memory(unsigned long start, unsigned long end)
 {
-	int i;
-	unsigned long start_aligned, end_aligned;
+	unsigned long i, start_aligned, end_aligned;
 	int order = ilog2(BITS_PER_LONG);
 
 	start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
