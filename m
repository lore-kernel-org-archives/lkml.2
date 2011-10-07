Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910Ab1JGLUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:20:44 -0400
Received: from mail.de.keymile.com ([195.8.104.1]:34875 "HELO
	mail.de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759808Ab1JGLUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:20:43 -0400
X-Greylist: delayed 646 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Oct 2011 07:20:42 EDT
From: Gerlando Falauto <gerlando.falauto@keymile.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Gerlando Falauto <gerlando.falauto@keymile.com>
Subject: [PATCH] CIFS: fix automount for DFS shares
Date: Fri,  7 Oct 2011 13:09:31 +0200
Message-Id: <1317985771-28876-2-git-send-email-gerlando.falauto@keymile.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1317985771-28876-1-git-send-email-gerlando.falauto@keymile.com>
References: <1317985771-28876-1-git-send-email-gerlando.falauto@keymile.com>
X-ESAFE-STATUS: [srvhellgate.de.keymile.net] Mail clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automounting directories are now invalidated by .d_revalidate()
so to be d_instantiate()d again with the right DCACHE_NEED_AUTOMOUNT
flag

Signed-off-by: Gerlando Falauto <gerlando.falauto@keymile.com>
---
 fs/cifs/dir.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 9ea65cf..67f54d3 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -637,8 +637,13 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 	if (direntry->d_inode) {
 		if (cifs_revalidate_dentry(direntry))
 			return 0;
-		else
+		else {
+			/* We want automonting inodes to be
+			 * considered invalid or so */
+			if (IS_AUTOMOUNT(direntry->d_inode))
+				return 0;
 			return 1;
+		}
 	}
 
 	/*
-- 
1.7.1

