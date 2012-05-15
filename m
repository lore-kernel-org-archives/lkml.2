Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965393Ab2EOCRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:54 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52990 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964891Ab2EOCQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 034/179] UBIFS: fix a rare memory leak in ro to rw remounting path
Date: Mon, 14 May 2012 22:12:10 -0400
Message-ID: <1337048075-6132-35-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit eaeee242c531cd4b0a4a46e8b5dd7ef504380c42 upstream.

When re-mounting from R/O mode to R/W mode and the LEB count in the superblock
is not up-to date, because for the underlying UBI volume became larger, we
re-write the superblock. We allocate RAM for these purposes, but never free it.
So this is a memory leak, although very rare one.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ubifs/sb.c    |    3 ++-
 fs/ubifs/super.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index 96cb62c..f75f89b 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -475,7 +475,8 @@ failed:
  * @c: UBIFS file-system description object
  *
  * This function returns a pointer to the superblock node or a negative error
- * code.
+ * code. Note, the user of this function is responsible of kfree()'ing the
+ * returned superblock buffer.
  */
 struct ubifs_sb_node *ubifs_read_sb_node(struct ubifs_info *c)
 {
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 4d2f215..f4d0c36 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1545,6 +1545,7 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 		}
 		sup->leb_cnt = cpu_to_le32(c->leb_cnt);
 		err = ubifs_write_sb_node(c, sup);
+		kfree(sup);
 		if (err)
 			goto out;
 	}
-- 
1.7.9.6

