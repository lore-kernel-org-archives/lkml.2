Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845Ab2D0Imx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:42:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61450 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546Ab2D0Imv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:42:51 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-91-4f9a5c07e9ae
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, npiggin@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@gmail.com,
        rientjes@google.com, Minchan Kim <minchan@kernel.org>,
        Neil Brown <neilb@suse.de>, Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sage Weil <sage@newdream.net>
Subject: [RFC] vmalloc: add warning in __vmalloc
Date: Fri, 27 Apr 2012 17:42:24 +0900
Message-Id: <1335516144-3486-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there are several places to use __vmalloc with GFP_ATOMIC,
GFP_NOIO, GFP_NOFS but unfortunately __vmalloc calls map_vm_area
which calls alloc_pages with GFP_KERNEL to allocate page tables.
It means it's possible to happen deadlock.
I don't know why it doesn't have reported until now.

Firstly, I tried passing gfp_t to lower functions to support __vmalloc
with such flags but other mm guys don't want and decided that
all of caller should be fixed.

http://marc.info/?l=linux-kernel&m=133517143616544&w=2

To begin with, let's listen other's opinion whether they can fix it
by other approach without calling __vmalloc with such flags.

So this patch adds warning to detect and to be fixed hopely.
I Cced related maintainers.
If I miss someone, please Cced them.

side-note:
  I added WARN_ON instead of WARN_ONCE to detect all of callers
  and each WARN_ON for each flag to detect to use any flag easily.
  After we fix all of caller or reduce such caller, we can merge
  a warning with WARN_ONCE.

Cc: Neil Brown <neilb@suse.de>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: James Morris <jmorris@namei.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Sage Weil <sage@newdream.net>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmalloc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 94dff88..36beccb 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1700,6 +1700,15 @@ static void *__vmalloc_node(unsigned long size, unsigned long align,
 			    gfp_t gfp_mask, pgprot_t prot,
 			    int node, void *caller)
 {
+	/*
+	 * This function calls map_vm_area so that it allocates
+	 * page table with GFP_KERNEL so caller should avoid using
+	 * GFP_NOIO, GFP_NOFS and !__GFP_WAIT.
+	 */
+	WARN_ON(!(gfp_mask & __GFP_WAIT));
+	WARN_ON(!(gfp_mask & __GFP_IO));
+	WARN_ON(!(gfp_mask & __GFP_FS));
+
 	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
 				gfp_mask, prot, node, caller);
 }
-- 
1.7.9.5

