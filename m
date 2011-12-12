Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab1LLMYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:24:42 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54597 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab1LLMYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:24:41 -0500
MIME-Version: 1.0
Date: Mon, 12 Dec 2011 20:24:39 +0800
Message-ID: <CAJd=RBAN7cK_6OstO=5gszW8cJ_d4-8iQC3gWG6HUtabiMN9Yg@mail.gmail.com>
Subject: [PATCH] mm: vmscan: try to free orphaned page
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the orphaned page has no buffer attached at the moment, we clean it up by
hand, then it has the chance to progress the freeing trip.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Sun Dec  4 13:10:08 2011
+++ b/mm/vmscan.c	Mon Dec 12 20:12:44 2011
@@ -487,12 +487,10 @@ static pageout_t pageout(struct page *pa
 		 * Some data journaling orphaned pages can have
 		 * page->mapping == NULL while being dirty with clean buffers.
 		 */
-		if (page_has_private(page)) {
-			if (try_to_free_buffers(page)) {
-				ClearPageDirty(page);
-				printk("%s: orphaned page\n", __func__);
-				return PAGE_CLEAN;
-			}
+		if (!page_has_private(page) || try_to_free_buffers(page)) {
+			ClearPageDirty(page);
+			printk(KERN_INFO "%s: orphaned page\n", __func__);
+			return PAGE_CLEAN;
 		}
 		return PAGE_KEEP;
 	}
