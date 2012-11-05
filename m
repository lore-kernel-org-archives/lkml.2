Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2KESkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:40:41 -0500
Received: from mail.ispras.ru ([83.149.199.43]:43645 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab2KESkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:40:40 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] jffs2: Make handling of erase_completion_lock consistent in jffs2_do_reserve_space()
Date: Mon,  5 Nov 2012 22:40:14 +0400
Message-Id: <1352140814-25208-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of jffs2_do_reserve_space() expect they still held
erase_completion_lock after call to it. But there is a path
where jffs2_do_reserve_space() leaves erase_completion_lock unlocked.
The patch fixes it.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 fs/jffs2/nodemgmt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index 0c96eb5..0331072 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -417,14 +417,16 @@ static int jffs2_do_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 			spin_unlock(&c->erase_completion_lock);
 
 			ret = jffs2_prealloc_raw_node_refs(c, jeb, 1);
-			if (ret)
-				return ret;
+
 			/* Just lock it again and continue. Nothing much can change because
 			   we hold c->alloc_sem anyway. In fact, it's not entirely clear why
 			   we hold c->erase_completion_lock in the majority of this function...
 			   but that's a question for another (more caffeine-rich) day. */
 			spin_lock(&c->erase_completion_lock);
 
+			if (ret)
+				return ret;
+
 			waste = jeb->free_size;
 			jffs2_link_node_ref(c, jeb,
 					    (jeb->offset + c->sector_size - waste) | REF_OBSOLETE,
-- 
1.7.9.5

