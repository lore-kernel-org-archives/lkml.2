Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0ESIo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:44:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44958 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0ESIo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:44:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Shaohua Li <shaohua.li@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at first
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100519174327.9591.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 19 May 2010 17:44:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li reported parallel file copy on tmpfs can lead to
OOM killer. This is regression of caused by commit 9ff473b9a7
(vmscan: evict streaming IO first). Wow, It is 2 years old patch!

Currently, tmpfs file cache is inserted active list at first. It
mean the insertion doesn't only increase numbers of pages in anon LRU,
but also reduce anon scanning ratio. Therefore, vmscan will get totally
confusion. It scan almost only file LRU even though the system have
plenty unused tmpfs pages.

Historically, lru_cache_add_active_anon() was used by two reasons.
1) Intend to priotize shmem page rather than regular file cache.
2) Intend to avoid reclaim priority inversion of used once pages.

But we've lost both motivation because (1) Now we have separate
anon and file LRU list. then, to insert active list doesn't help
such priotize. (2) In past, one pte access bit will cause page
activation. then to insert inactive list with pte access bit mean
higher priority than to insert active list. Its priority inversion
may lead to uninteded lru chun. but it was already solved by commit
645747462 (vmscan: detect mapped file pages used only once).
(Thanks Hannes, you are great!)

Thus, now we can use lru_cache_add_anon() instead.

Reported-by: Shaohua Li <shaohua.li@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/filemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b941996..023ef61 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -452,7 +452,7 @@ int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
 		if (page_is_file_cache(page))
 			lru_cache_add_file(page);
 		else
-			lru_cache_add_active_anon(page);
+			lru_cache_add_anon(page);
 	}
 	return ret;
 }
-- 
1.6.5.2



