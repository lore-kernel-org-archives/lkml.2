Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab1DZQZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:25:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60952 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab1DZQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:25:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PP+Oeg+Occv2mvl7Ow80CKS4aeVMww6wJ57LyFjEeQ3o6XzSh2Yq1txO8ztHDb8bvk
         KAUz+/JwkVJQF5+mVh2+FFr5qIczIQP1WpgrrEq2uteHhpg0S3lv/R0NXrPSq6ioW+yO
         494apQIiua/oeFY2EYPPBoDQcU53UtUSFfNDs=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFC 2/8] compaction: make isolate_lru_page with filter aware
Date: Wed, 27 Apr 2011 01:25:19 +0900
Message-Id: <4dc5e63cfc8672426336e43dea29057d5bb6e863.1303833417.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1303833415.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1303833415.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In async mode, compaction doesn't migrate dirty or writeback pages.
So, it's meaningless to pick the page and re-add it to lru list.

Of course, when we isolate the page in compaction, the page might
be dirty or writeback but when we try to migrate the page, the page
would be not dirty, writeback. So it could be migrated. But it's
very unlikely as isolate and migration cycle is much faster than
writeout.

So, this patch helps cpu and prevent unnecessary LRU churning.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/compaction.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index dea32e3..9f80b5a 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -335,7 +335,7 @@ static unsigned long isolate_migratepages(struct zone *zone,
 		}
 
 		/* Try isolate the page */
-		if (__isolate_lru_page(page, ISOLATE_BOTH, 0, 0, 0) != 0)
+		if (__isolate_lru_page(page, ISOLATE_BOTH, 0, !cc->sync, 0) != 0)
 			continue;
 
 		VM_BUG_ON(PageTransCompound(page));
-- 
1.7.1

