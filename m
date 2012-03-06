Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030588Ab2CFM5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:57:07 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58747 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab2CFM45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:56:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.213.15.212 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 3/9] vfs: fix d_need_lookup/d_revalidate order in do_lookup
Date: Tue,  6 Mar 2012 13:56:35 +0100
Message-Id: <1331038601-20353-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
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

