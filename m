Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104Ab2GYSxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab2GYSxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:53:18 -0400
Date: Wed, 25 Jul 2012 14:51:19 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH -mm] remove __GFP_NO_KSWAPD fixes
Message-ID: <20120725145119.75be021d@cuia.bos.redhat.com>
In-Reply-To: <20120724111222.2c5e6b30@annuminas.surriel.com>
References: <20120724111222.2c5e6b30@annuminas.surriel.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns out I missed two spots where __GFP_NO_KSWAPD is used.

The removal from the trace code is obvious, since the flag
got removed there is no need to print it.

For mtdcore.c, now that memory compaction has been fixed,
we should no longer see large swap storms from an attempt
to allocate a large buffer, removing the need to specify
__GFP_NO_KSWAPD.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 drivers/mtd/mtdcore.c           |    3 +--
 include/trace/events/gfpflags.h |    1 -
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 9a9ce71..af1e932 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -761,8 +761,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  */
 void *mtd_kmalloc_up_to(const struct mtd_info *mtd, size_t *size)
 {
-	gfp_t flags = __GFP_NOWARN | __GFP_WAIT |
-		       __GFP_NORETRY | __GFP_NO_KSWAPD;
+	gfp_t flags = __GFP_NOWARN | __GFP_WAIT | __GFP_NORETRY;
 	size_t min_alloc = max_t(size_t, mtd->writesize, PAGE_SIZE);
 	void *kbuf;
 
diff --git a/include/trace/events/gfpflags.h b/include/trace/events/gfpflags.h
index 9fe3a36..8ffc050 100644
--- a/include/trace/events/gfpflags.h
+++ b/include/trace/events/gfpflags.h
@@ -35,7 +35,6 @@
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
 	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
-	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
 	{(unsigned long)__GFP_OTHER_NODE,	"GFP_OTHER_NODE"}	\
 	) : "GFP_NOWAIT"
 

