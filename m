Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab2CFM46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:56:58 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53962 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247Ab2CFM4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:56:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.213.114.148 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz, stable@vger.kernel.org
Subject: [PATCH 1/9] vfs: fix double put after complete_walk()
Date: Tue,  6 Mar 2012 13:56:33 +0100
Message-Id: <1331038601-20353-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

complete_walk() already puts nd->path, no need to do it again at cleanup time.

This would result in Oopses if triggered, apparently the codepath is not too
well exercised.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: stable@vger.kernel.org
---
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e2ba628..f79aef1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2261,7 +2261,7 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	/* Why this, you ask?  _Now_ we might have grown LOOKUP_JUMPED... */
 	error = complete_walk(nd);
 	if (error)
-		goto exit;
+		return ERR_PTR(error);
 	error = -EISDIR;
 	if (S_ISDIR(nd->inode->i_mode))
 		goto exit;
-- 
1.7.7

