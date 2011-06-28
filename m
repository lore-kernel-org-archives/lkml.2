Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab1F1Xn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:43:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15076 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab1F1Xnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:43:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=eEFl259fCTuCOgA7m8I6tnKctEsQZmJWIBoKYNWGRbuzWlHFe4BLCvQjwMSJlvoGY
	9HS6ClDPdvYIxLTT90Qng==
From: Curt Wohlgemuth <curtw@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] writeback: Don't wait for completion in writeback_inodes_sb_nr
Date: Tue, 28 Jun 2011 16:43:35 -0700
Message-Id: <1309304616-8657-1-git-send-email-curtw@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Contrary to the comment block atop writeback_inodes_sb_nr(),
we *were* calling

        wait_for_completion(&done);

which should not be done, as this is not called for data
integrity sync.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
 fs/fs-writeback.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 0f015a0..3f711ac 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1186,17 +1186,14 @@ static void wait_sb_inodes(struct super_block *sb)
  */
 void writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr)
 {
-	DECLARE_COMPLETION_ONSTACK(done);
 	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_NONE,
-		.done		= &done,
 		.nr_pages	= nr,
 	};
 
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 	bdi_queue_work(sb->s_bdi, &work);
-	wait_for_completion(&done);
 }
 EXPORT_SYMBOL(writeback_inodes_sb_nr);
 
-- 
1.7.3.1

