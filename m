Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0I3Dut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:50:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab0I3Duq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:50:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rta5HvddJKmlEPh92ve4HldwhowvRAtPHgPi6nK4xljtBc2WJ7eymhRnVYZXoLTayc
         zNa0YbcipHIcyDJRueRZfOowcSYbNssSMW65XhgEPbKMPULX2jhMZzQ8VVuJ+nyRL9/y
         VYQ5+poSTACzCU5w3z2Pg+GPdxTAK/3QsP2Ys=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] rmap: annotate lock context change on page_[un]lock_anon_vma()
Date: Thu, 30 Sep 2010 12:50:15 +0900
Message-Id: <1285818621-29890-7-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page_lock_anon_vma() conditionally grabs RCU and anon_vma lock
but page_unlock_anon_vma() releases them unconditionally. This leads
sparse to complain about context imbalance. Annotate them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/rmap.h |   15 ++++++++++++++-
 mm/rmap.c            |    4 +++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 31b2fd7..0fa7769 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -230,7 +230,20 @@ int try_to_munlock(struct page *);
 /*
  * Called by memory-failure.c to kill processes.
  */
-struct anon_vma *page_lock_anon_vma(struct page *page);
+struct anon_vma *__page_lock_anon_vma(struct page *page);
+
+static inline struct anon_vma *page_lock_anon_vma(struct page *page)
+{
+	struct anon_vma *anon_vma;
+
+	__cond_lock(RCU, anon_vma = __page_lock_anon_vma(page));
+
+	/* (void) is needed to make gcc happy */
+	(void) __cond_lock(&anon_vma->root->lock, anon_vma);
+
+	return anon_vma;
+}
+
 void page_unlock_anon_vma(struct anon_vma *anon_vma);
 int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
diff --git a/mm/rmap.c b/mm/rmap.c
index 9d2ba01..244ff06 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -314,7 +314,7 @@ void __init anon_vma_init(void)
  * Getting a lock on a stable anon_vma from a page off the LRU is
  * tricky: page_lock_anon_vma rely on RCU to guard against the races.
  */
-struct anon_vma *page_lock_anon_vma(struct page *page)
+struct anon_vma *__page_lock_anon_vma(struct page *page)
 {
 	struct anon_vma *anon_vma, *root_anon_vma;
 	unsigned long anon_mapping;
@@ -348,6 +348,8 @@ out:
 }
 
 void page_unlock_anon_vma(struct anon_vma *anon_vma)
+	__releases(&anon_vma->root->lock)
+	__releases(RCU)
 {
 	anon_vma_unlock(anon_vma);
 	rcu_read_unlock();
-- 
1.7.2.2

