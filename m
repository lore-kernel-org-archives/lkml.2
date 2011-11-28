Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1K1LhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:37:13 -0500
Received: from bender.cm4all.net ([87.106.27.49]:40929 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab1K1LhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:37:11 -0500
Subject: [PATCH] fs/namei: waiting for mutex during name lookups is "killable"
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
From: Max Kellermann <mk@cm4all.com>
Date: Mon, 28 Nov 2011 12:39:18 +0100
Message-ID: <20111128113918.23050.25938.stgit@rabbit.intern.cm-ag>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex_lock_killable() instead of mutex_lock() during name lookups,
to allow killing the process while it's waiting.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---
 fs/namei.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3d15072..08a3163 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1169,7 +1169,10 @@ retry:
 		struct inode *dir = parent->d_inode;
 		BUG_ON(nd->inode != dir);
 
-		mutex_lock(&dir->i_mutex);
+		err = mutex_lock_killable(&dir->i_mutex);
+		if (unlikely(err))
+			return err;
+
 		dentry = d_lookup(parent, name);
 		if (likely(!dentry)) {
 			dentry = d_alloc_and_lookup(parent, name, nd);
@@ -2166,7 +2169,9 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (nd->last.name[nd->last.len])
 		goto exit;
 
-	mutex_lock(&dir->d_inode->i_mutex);
+	error = mutex_lock_killable(&dir->d_inode->i_mutex);
+	if (unlikely(error))
+		goto exit;
 
 	dentry = lookup_hash(nd);
 	error = PTR_ERR(dentry);

