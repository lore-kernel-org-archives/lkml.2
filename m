Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2BPME4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:04:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45967 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2BPMEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:04:54 -0500
MIME-Version: 1.0
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH] mm: extend prefault helpers to fault in more than PAGE_SIZE
Date: Thu, 16 Feb 2012 13:01:36 +0100
Message-Id: <1329393696-4802-2-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1329393696-4802-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1329393696-4802-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm/i915 wants to read/write more than one page in its fastpath
and hence needs to prefault more than PAGE_SIZE bytes.

I've checked the callsites and they all already clamp size when
calling fault_in_pages_* to the same as for the subsequent
__copy_to|from_user and hence don't rely on the implicit clamping
to PAGE_SIZE.

Also kill a copy&pasted spurious space in both functions while at it.

Cc: linux-mm@kvack.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 include/linux/pagemap.h |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index cfaaa69..689527d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -408,6 +408,7 @@ extern void add_page_wait_queue(struct page *page, wait_queue_t *waiter);
 static inline int fault_in_pages_writeable(char __user *uaddr, int size)
 {
 	int ret;
+	char __user *end = uaddr + size - 1;
 
 	if (unlikely(size == 0))
 		return 0;
@@ -416,17 +417,20 @@ static inline int fault_in_pages_writeable(char __user *uaddr, int size)
 	 * Writing zeroes into userspace here is OK, because we know that if
 	 * the zero gets there, we'll be overwriting it.
 	 */
-	ret = __put_user(0, uaddr);
+	while (uaddr <= end) {
+		ret = __put_user(0, uaddr);
+		if (ret != 0)
+			return ret;
+		uaddr += PAGE_SIZE;
+	}
 	if (ret == 0) {
-		char __user *end = uaddr + size - 1;
-
 		/*
 		 * If the page was already mapped, this will get a cache miss
 		 * for sure, so try to avoid doing it.
 		 */
-		if (((unsigned long)uaddr & PAGE_MASK) !=
+		if (((unsigned long)uaddr & PAGE_MASK) ==
 				((unsigned long)end & PAGE_MASK))
-		 	ret = __put_user(0, end);
+			ret = __put_user(0, end);
 	}
 	return ret;
 }
@@ -435,17 +439,21 @@ static inline int fault_in_pages_readable(const char __user *uaddr, int size)
 {
 	volatile char c;
 	int ret;
+	const char __user *end = uaddr + size - 1;
 
 	if (unlikely(size == 0))
 		return 0;
 
-	ret = __get_user(c, uaddr);
+	while (uaddr <= end) {
+		ret = __get_user(c, uaddr);
+		if (ret != 0)
+			return ret;
+		uaddr += PAGE_SIZE;
+	}
 	if (ret == 0) {
-		const char __user *end = uaddr + size - 1;
-
-		if (((unsigned long)uaddr & PAGE_MASK) !=
+		if (((unsigned long)uaddr & PAGE_MASK) ==
 				((unsigned long)end & PAGE_MASK)) {
-		 	ret = __get_user(c, end);
+			ret = __get_user(c, end);
 			(void)c;
 		}
 	}
-- 
1.7.7.5

