Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1LWLK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 06:10:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab1LWLK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 06:10:57 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] udf: Mark LVID buffer as uptodate before marking it dirty
Date: Fri, 23 Dec 2011 12:10:33 +0100
Message-Id: <1324638633-25230-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we hit EIO while writing LVID, the buffer uptodate bit is cleared.
This then results in an anoying warning from mark_buffer_dirty() when we
write the buffer again. So just set uptodate flag unconditionally.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

  I carry this patch in my tree and will merge it with Linus in the next
merge window if noone objects.

diff --git a/fs/udf/super.c b/fs/udf/super.c
index e185253..87cb24a 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1799,6 +1799,12 @@ static void udf_close_lvid(struct super_block *sb)
 				le16_to_cpu(lvid->descTag.descCRCLength)));
 
 	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
+	/*
+	 * We set buffer uptodate unconditionally here to avoid spurious
+	 * warnings from mark_buffer_dirty() when previous EIO has marked
+	 * the buffer as !uptodate
+	 */
+	set_buffer_uptodate(bh);
 	mark_buffer_dirty(bh);
 	sbi->s_lvid_dirty = 0;
 	mutex_unlock(&sbi->s_alloc_mutex);
-- 
1.7.1

