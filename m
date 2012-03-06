Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030571Ab2CFM7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:59:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47145 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab2CFM44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:56:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.213.2.129 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz, stable@vger.kernel.org
Subject: [PATCH 2/9] vfs: fix return value from do_last()
Date: Tue,  6 Mar 2012 13:56:34 +0100
Message-Id: <1331038601-20353-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

complete_walk() returns either ECHILD or ESTALE.  do_last() turns this into
ECHILD unconditionally.  If not in RCU mode, this error will reach userspace
which is complete nonsense.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@vger.kernel.org
---
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f79aef1..46ea9cc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2162,7 +2162,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		/* sayonara */
 		error = complete_walk(nd);
 		if (error)
-			return ERR_PTR(-ECHILD);
+			return ERR_PTR(error);
 
 		error = -ENOTDIR;
 		if (nd->flags & LOOKUP_DIRECTORY) {
-- 
1.7.7

