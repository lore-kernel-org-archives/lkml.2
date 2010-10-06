Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327Ab0JFQyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:54:13 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:50396 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758798Ab0JFQyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:54:12 -0400
X-ASG-Debug-ID: 1286384049-08b7e8220001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CACA9AD.9070900@fusionio.com>
Date: Wed, 6 Oct 2010 18:54:05 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] one writeback regression fix for .36
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] one writeback regression fix for .36
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1286384049
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.42910
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The recent patch series from Jan introduced a WARN_ON() regression.
The real fix for this is adding a super_operations->get_bdi(), which
we'll do for 2.6.37.

Please pull.

are available in the git repository at:
  git://git.kernel.dk/linux-2.6-block.git for-linus

Christoph Hellwig (1):
      writeback: always use sb->s_bdi for writeback purposes

 fs/fs-writeback.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5581122..ab38fef 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -72,22 +72,11 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
-	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
 
-	/*
-	 * For inodes on standard filesystems, we use superblock's bdi. For
-	 * inodes on virtual filesystems, we want to use inode mapping's bdi
-	 * because they can possibly point to something useful (think about
-	 * block_dev filesystem).
-	 */
-	if (sb->s_bdi && sb->s_bdi != &noop_backing_dev_info) {
-		/* Some device inodes could play dirty tricks. Catch them... */
-		WARN(bdi != sb->s_bdi && bdi_cap_writeback_dirty(bdi),
-			"Dirtiable inode bdi %s != sb bdi %s\n",
-			bdi->name, sb->s_bdi->name);
-		return sb->s_bdi;
-	}
-	return bdi;
+	if (strcmp(sb->s_type->name, "bdev") == 0)
+		return inode->i_mapping->backing_dev_info;
+
+	return sb->s_bdi;
 }
 
 static void bdi_queue_work(struct backing_dev_info *bdi,

-- 
Jens Axboe

