Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab1JRJGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:06:10 -0400
Received: from mail.de.keymile.com ([195.8.104.1]:49467 "HELO
	mail.de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757006Ab1JRJGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:06:08 -0400
From: Gerlando Falauto <gerlando.falauto@keymile.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Cc: Gerlando Falauto <gerlando.falauto@keymile.com>
Subject: [PATCH] CIFS: fix automount for DFS shares
Date: Tue, 18 Oct 2011 10:58:50 +0200
Message-Id: <1318928330-4498-1-git-send-email-gerlando.falauto@keymile.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1318845543-15085-1-git-send-email-gerlando.falauto@keymile.com>
References: <1318845543-15085-1-git-send-email-gerlando.falauto@keymile.com>
X-ESAFE-STATUS: [srvhellgate.de.keymile.net] Mail clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automounting directories are now invalidated by .d_revalidate()
so to be d_instantiate()d again with the right DCACHE_NEED_AUTOMOUNT
flag

Reviewed-by: Jeff Layton <jlayton@samba.org>
Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
---
 fs/cifs/dir.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 9ea65cf..ca3b571 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -637,8 +637,16 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 	if (direntry->d_inode) {
 		if (cifs_revalidate_dentry(direntry))
 			return 0;
-		else
+		else {
+			/*
+			 * Forcibly invalidate automounting directory inodes
+			 * (remote DFS directories) so to have them
+			 * instantiated again for automount
+			 */
+			if (IS_AUTOMOUNT(direntry->d_inode))
+				return 0;
 			return 1;
+		}
 	}
 
 	/*
-- 
1.7.1

