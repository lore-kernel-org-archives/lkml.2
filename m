Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab2CZKyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:54:13 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51418 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2CZKyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:54:10 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 1/6] vfs: fix d_need_lookup/d_revalidate order in do_lookup
Date: Mon, 26 Mar 2012 12:54:19 +0200
Message-Id: <1332759264-23533-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
References: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Doing revalidate on a dentry which has not yet been looked up makes no sense.

Move the d_need_lookup() check before d_revalidate().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 46ea9cc..599e4a0 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1139,6 +1139,8 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 			return -ECHILD;
 		nd->seq = seq;
 
+		if (unlikely(d_need_lookup(dentry)))
+			goto unlazy;
 		if (unlikely(dentry->d_flags & DCACHE_OP_REVALIDATE)) {
 			status = d_revalidate(dentry, nd);
 			if (unlikely(status <= 0)) {
@@ -1147,8 +1149,6 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 				goto unlazy;
 			}
 		}
-		if (unlikely(d_need_lookup(dentry)))
-			goto unlazy;
 		path->mnt = mnt;
 		path->dentry = dentry;
 		if (unlikely(!__follow_mount_rcu(nd, path, inode)))
-- 
1.7.7

