Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1EKRRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:17:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54288 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab1EKRRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Bs2wp25kvN2UDzhHgMgozsoMYPywUvVi+JOJY4a0qfiM83EAYA9I6+pjjdn0KsizJa
         rw3QQ5i36zeKinp7Mko0Pg+ugWteZzafkwL1cmxa6NSlOMPD6hubnr9TwhahzvXClRqk
         3Ux8u2jbol6L5yIqawivnC33XEMJPW233UEBE=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH v1 04/10] Add additional isolation mode
Date: Thu, 12 May 2011 02:16:43 +0900
Message-Id: <a54d85ccce0a50dd3bf297c34e04bc46c443693d.1305132792.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1305132792.git.minchan.kim@gmail.com>
References: <cover.1305132792.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1305132792.git.minchan.kim@gmail.com>
References: <cover.1305132792.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some places to isolate lru page and I believe
users of isolate_lru_page will be growing.
The purpose of them is each different so part of isolated pages
should put back to LRU, again.

The problem is when we put back the page into LRU,
we lose LRU ordering and the page is inserted at head of LRU list.
It makes unnecessary LRU churning so that vm can evict working set pages
rather than idle pages.

This patch adds new modes when we isolate page in LRU so we don't isolate pages
if we can't handle it. It could reduce LRU churning.

This patch doesn't change old behavior. It's just used by next patches.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/swap.h |    2 ++
 mm/vmscan.c          |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index a7cc199..0badb13 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -249,6 +249,8 @@ enum ISOLATE_PAGE_MODE {
 	ISOLATE_INACTIVE = 1,	/* Isolate inactive pages */
 	ISOLATE_ACTIVE = 2,	/* Isolate active pages */
 	ISOLATE_BOTH = 4,	/* Isolate both active and inactive pages */
+	ISOLATE_CLEAN = 8,	/* Isolate clean file */
+	ISOLATE_UNMAPPED = 16,	/* Isolate unmapped file */
 };
 
 /* linux/mm/vmscan.c */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5d83e06..4bd5513 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -996,6 +996,12 @@ int __isolate_lru_page(struct page *page, enum ISOLATE_PAGE_MODE mode,
 
 	ret = -EBUSY;
 
+	if (mode & ISOLATE_CLEAN && (PageDirty(page) || PageWriteback(page)))
+		return ret;
+
+	if (mode & ISOLATE_UNMAPPED && page_mapped(page))
+		return ret;
+
 	if (likely(get_page_unless_zero(page))) {
 		/*
 		 * Be careful not to clear PageLRU until after we're
-- 
1.7.1

