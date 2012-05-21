Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab2EUUpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:45:11 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45024 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480Ab2EUUpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:45:09 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH] fs/namei: fix possible uninitialized use of inode
Date: Mon, 21 May 2012 22:44:18 +0200
Message-Id: <1337633058-3866-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 12f8ad4b0533d9212cb1d5e58ed73d2170114785 introduces a path
which might lead to uninitialized use.

fs/namei.c: In function ‘walk_component’:
fs/namei.c:1293:6: warning: ‘inode’ may be used uninitialized in this function [-Wuninitialized]
fs/namei.c:1308:16: note: ‘inode’ was declared here

The commit mentioned above removed this:

	*inode = nd->inode;

And now there's a possible that path looks like this:
...
  1147                  dentry = __d_lookup_rcu(parent, name, &seq, nd->inode);
  1148                  if (!dentry)
  1149                          goto unlazy;
...
  1187  unlazy:
...
  1204          if (unlikely(status <= 0)) {
  1205                  if (status < 0) {
  1206                          dput(dentry);
  1207                          return status;
  1208                  }
  1209                  if (!d_invalidate(dentry)) {
  1210                          dput(dentry);
  1211                          goto need_lookup;
  1212                  }
  1213          }

So we might return 0 to walk_component, which does this compare right after
check the return code from do_lookup:

  1312:		if (!inode) {

Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index f9e883c..f77b69b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1295,7 +1295,7 @@ static inline int should_follow_link(struct inode *inode, int follow)
 static inline int walk_component(struct nameidata *nd, struct path *path,
 		struct qstr *name, int type, int follow)
 {
-	struct inode *inode;
+	struct inode *inode = NULL;
 	int err;
 	/*
 	 * "." and ".." are special - ".." especially so because it has
-- 
1.7.10

