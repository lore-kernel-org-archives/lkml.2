Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab2AFOHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:07:31 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43877 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab2AFOHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:07:30 -0500
MIME-Version: 1.0
Date: Fri, 6 Jan 2012 22:07:29 +0800
Message-ID: <CAJd=RBAMtT04n8p4ht4oCSOYKVcUcG0-hbSvmjrP-yhwBYhU1A@mail.gmail.com>
Subject: [PATCH] mm: vmscan: recompute page status when putting back
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If unlikely the given page is isolated from lru list again, its status is
recomputed before putting back to lru list, since the comment says page's
status can change while we move it among lru.


Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
+++ b/mm/vmscan.c	Fri Jan  6 21:31:56 2012
@@ -633,12 +633,14 @@ int remove_mapping(struct address_space
 void putback_lru_page(struct page *page)
 {
 	int lru;
-	int active = !!TestClearPageActive(page);
-	int was_unevictable = PageUnevictable(page);
+	int active;
+	int was_unevictable;

 	VM_BUG_ON(PageLRU(page));

 redo:
+	active = !!TestClearPageActive(page);
+	was_unevictable = PageUnevictable(page);
 	ClearPageUnevictable(page);

 	if (page_evictable(page, NULL)) {
