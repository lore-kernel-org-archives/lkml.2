Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1KAMMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:12:39 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:33867 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab1KAMMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:12:38 -0400
Subject: [PATCH] fs: fix dentry leak in simple_fill_super()
To: Alexander Viro <viro@zeniv.linux.org.uk>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Tue, 01 Nov 2011 16:12:33 +0300
Message-ID: <20111101121233.15505.87415.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put dentry if inode allocation failed, d_genocide() cannot release it

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/libfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index c18e9a1..a2c0029 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -510,8 +510,10 @@ int simple_fill_super(struct super_block *s, unsigned long magic,
 		if (!dentry)
 			goto out;
 		inode = new_inode(s);
-		if (!inode)
+		if (!inode) {
+			dput(dentry);
 			goto out;
+		}
 		inode->i_mode = S_IFREG | files->mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inode->i_fop = files->ops;

