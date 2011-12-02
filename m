Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab1LBFyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:54:50 -0500
Received: from bender.cm4all.net ([87.106.27.49]:42651 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1LBFys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:54:48 -0500
Subject: [PATCH] fs/namespace: waiting for mutex in lock_mount() is "killable"
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
From: Max Kellermann <mk@cm4all.com>
Cc: max@duempel.org
Date: Fri, 02 Dec 2011 06:56:58 +0100
Message-ID: <20111202055658.22371.21820.stgit@rabbit.intern.cm-ag>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow killing the process while it's indirectly waiting for the NFS
server's response.
---
 fs/namespace.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e5e1c7d..9560bec 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1651,8 +1651,13 @@ static int attach_recursive_mnt(struct vfsmount *source_mnt,
 static int lock_mount(struct path *path)
 {
 	struct vfsmount *mnt;
+	int err;
+
 retry:
-	mutex_lock(&path->dentry->d_inode->i_mutex);
+	err = mutex_lock_killable(&path->dentry->d_inode->i_mutex);
+	if (unlikely(err))
+		return err;
+
 	if (unlikely(cant_mount(path->dentry))) {
 		mutex_unlock(&path->dentry->d_inode->i_mutex);
 		return -ENOENT;

