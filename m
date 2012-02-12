Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2BLAXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 19:23:41 -0500
Received: from mail.betterlinux.com ([199.58.199.50]:56629 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2BLAXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 19:23:36 -0500
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 75F5D82A54
From: Andrea Righi <andrea@betterlinux.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>,
        John Stultz <john.stultz@linaro.org>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 2/3] mm: filemap: introduce mark_page_usedonce
Date: Sun, 12 Feb 2012 01:21:37 +0100
Message-Id: <1329006098-5454-3-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a helper function to drop a page from the page cache if it is
evictable, inactive and unreferenced.

This can be used to drop used-once pages from the file cache with
POSIX_FADV_NOREUSE.

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 include/linux/swap.h |    1 +
 mm/swap.c            |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3e60228..2e5d1b8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -222,6 +222,7 @@ extern void lru_add_page_tail(struct zone* zone,
 			      struct page *page, struct page *page_tail);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
+extern void mark_page_usedonce(struct page *page);
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
diff --git a/mm/swap.c b/mm/swap.c
index fff1ff7..2c19c92 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -352,6 +352,30 @@ void activate_page(struct page *page)
 }
 #endif
 
+/**
+ * mark_page_usedonce - handle used-once pages
+ * @page: the page set as used-once
+ *
+ * Drop a page from the page cache if it is evictable, inactive and
+ * unreferenced.
+ */
+void mark_page_usedonce(struct page *page)
+{
+	int ret;
+
+	if (!PageLRU(page))
+		return;
+	if (PageActive(page) || PageUnevictable(page) || PageReferenced(page))
+		return;
+	if (lock_page_killable(page))
+		return;
+	ret = invalidate_inode_page(page);
+	unlock_page(page);
+	if (!ret)
+		deactivate_page(page);
+}
+EXPORT_SYMBOL(mark_page_usedonce);
+
 /*
  * Mark a page as having seen activity.
  *
-- 
1.7.5.4

