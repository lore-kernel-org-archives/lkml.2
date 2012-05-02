Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2EBE2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 00:28:38 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60885 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab2EBE2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 00:28:37 -0400
X-AuditID: 9c93016f-b7b1bae0000044da-7f-4fa0b7ed5194
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@gmail.com, rientjes@google.com,
        Minchan Kim <minchan@kernel.org>, Neil Brown <neilb@suse.de>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sage Weil <sage@newdream.net>
Subject: [PATCH] vmalloc: add warning in __vmalloc
Date: Wed,  2 May 2012 13:28:09 +0900
Message-Id: <1335932890-25294-1-git-send-email-minchan@kernel.org>
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

So this patch adds warning in __vmalloc_node_range to detect it and
to be fixed hopely. __vmalloc_node_range isn't random chocie because
all caller which has gfp_mask of map_vm_area use it through __vmalloc_area_node.
And __vmalloc_area_node is current static function and is called by only
__vmalloc_node_range. So warning in __vmalloc_node_range would cover all
vmalloc functions which have gfp_t argument.

I Cced related maintainers.
If I miss someone, please Cced them.

* Changelog
  * Replace WARN_ON with WARN_ON_ONCE - by Andrew Morton, Nick Piggin.

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
 mm/vmalloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c28b0b9..def5943 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1648,6 +1648,10 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	void *addr;
 	unsigned long real_size = size;
 
+	WARN_ON_ONCE(!(gfp_mask & __GFP_WAIT) ||
+			!(gfp_mask & __GFP_IO) ||
+			!(gfp_mask & __GFP_FS));
+
 	size = PAGE_ALIGN(size);
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		goto fail;
-- 
1.7.9.5

