Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936546Ab2C3Wgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:36:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55577 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935429Ab2C3VI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:08:59 -0400
Message-Id: <20120330194834.173272806@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:48:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andrea Righi <andrea@betterlinux.com>
Subject: [ 005/149] staging: zcache: avoid AB-BA deadlock condition
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <andrea@betterlinux.com>

commit cfbc6a92212e74b07aa76c9e2f20c542e36077fb upstream.

Commit 9256a47 fixed a deadlock condition, being sure that the buddy
list spinlock is always taken before the page spinlock.

However in zbud_free_and_delist() locking order is the opposite
(page lock -> list lock).

Possible unsafe locking scenario (reported by lockdep):

        CPU0                    CPU1
        ----                    ----
   lock(&(&zbpg->lock)->rlock);
                                lock(zbud_budlists_spinlock);
                                lock(&(&zbpg->lock)->rlock);
   lock(zbud_budlists_spinlock);

Fix by grabbing the locks in opposite order in zbud_free_and_delist().

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zcache/zcache-main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -299,10 +299,12 @@ static void zbud_free_and_delist(struct
 	struct zbud_page *zbpg =
 		container_of(zh, struct zbud_page, buddy[budnum]);
 
+	spin_lock(&zbud_budlists_spinlock);
 	spin_lock(&zbpg->lock);
 	if (list_empty(&zbpg->bud_list)) {
 		/* ignore zombie page... see zbud_evict_pages() */
 		spin_unlock(&zbpg->lock);
+		spin_unlock(&zbud_budlists_spinlock);
 		return;
 	}
 	size = zbud_free(zh);
@@ -310,7 +312,6 @@ static void zbud_free_and_delist(struct
 	zh_other = &zbpg->buddy[(budnum == 0) ? 1 : 0];
 	if (zh_other->size == 0) { /* was unbuddied: unlist and free */
 		chunks = zbud_size_to_chunks(size) ;
-		spin_lock(&zbud_budlists_spinlock);
 		BUG_ON(list_empty(&zbud_unbuddied[chunks].list));
 		list_del_init(&zbpg->bud_list);
 		zbud_unbuddied[chunks].count--;
@@ -318,7 +319,6 @@ static void zbud_free_and_delist(struct
 		zbud_free_raw_page(zbpg);
 	} else { /* was buddied: move remaining buddy to unbuddied list */
 		chunks = zbud_size_to_chunks(zh_other->size) ;
-		spin_lock(&zbud_budlists_spinlock);
 		list_del_init(&zbpg->bud_list);
 		zcache_zbud_buddied_count--;
 		list_add_tail(&zbpg->bud_list, &zbud_unbuddied[chunks].list);


