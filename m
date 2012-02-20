Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2BTML6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 07:11:58 -0500
Received: from mail.betterlinux.com ([199.58.199.50]:38059 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2BTML5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 07:11:57 -0500
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 2EAF282A0D
From: Andrea Righi <andrea@betterlinux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] zcache: avoid AB-BA deadlock condition
Date: Mon, 20 Feb 2012 13:11:49 +0100
Message-Id: <1329739909-3174-1-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/staging/zcache/zcache-main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index ef7c52b..dce04be 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -299,10 +299,12 @@ static void zbud_free_and_delist(struct zbud_hdr *zh)
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
@@ -310,7 +312,6 @@ static void zbud_free_and_delist(struct zbud_hdr *zh)
 	zh_other = &zbpg->buddy[(budnum == 0) ? 1 : 0];
 	if (zh_other->size == 0) { /* was unbuddied: unlist and free */
 		chunks = zbud_size_to_chunks(size) ;
-		spin_lock(&zbud_budlists_spinlock);
 		BUG_ON(list_empty(&zbud_unbuddied[chunks].list));
 		list_del_init(&zbpg->bud_list);
 		zbud_unbuddied[chunks].count--;
@@ -318,7 +319,6 @@ static void zbud_free_and_delist(struct zbud_hdr *zh)
 		zbud_free_raw_page(zbpg);
 	} else { /* was buddied: move remaining buddy to unbuddied list */
 		chunks = zbud_size_to_chunks(zh_other->size) ;
-		spin_lock(&zbud_budlists_spinlock);
 		list_del_init(&zbpg->bud_list);
 		zcache_zbud_buddied_count--;
 		list_add_tail(&zbpg->bud_list, &zbud_unbuddied[chunks].list);
-- 
1.7.5.4

