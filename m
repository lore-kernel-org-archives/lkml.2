Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab2EGQ4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:56:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:19926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007Ab2EGQ4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="137865903"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] jffs2: remove unnecessary GC pass on umount
Date: Mon,  7 May 2012 19:56:51 +0300
Message-Id: <1336409813-6365-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336409813-6365-1-git-send-email-dedekind1@gmail.com>
References: <1336409813-6365-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We do not need to call 'jffs2_write_super()' on unmount. This function
causes a GC pass to make sure the current contents is pushed out with
the data which we already have on the media.

But this is not needed on unmount and only slows unmount down unnecessarily.
It is enough to just sync the write-buffer.

This call was added by one of the generic VFS rework patch-sets,
see 8c85e125124a473d6f3e9bb187b0b84207f81d91.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/jffs2/super.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 3422a2d..d3dc9d8 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -316,9 +316,6 @@ static void jffs2_put_super (struct super_block *sb)
 
 	jffs2_dbg(2, "%s()\n", __func__);
 
-	if (sb->s_dirt)
-		jffs2_write_super(sb);
-
 	mutex_lock(&c->alloc_sem);
 	jffs2_flush_wbuf_pad(c);
 	mutex_unlock(&c->alloc_sem);
-- 
1.7.7.6

