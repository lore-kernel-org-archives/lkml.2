Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab2KEPXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:23:01 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:33250 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab2KEPW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:22:56 -0500
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v9 19/34] vfs: fix user_statfs to retry once on ESTALE errors
Date: Mon,  5 Nov 2012 10:21:58 -0500
Message-Id: <1352128933-28526-20-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
References: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/statfs.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/statfs.c b/fs/statfs.c
index f8e832e..7b42ca3 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -77,11 +77,19 @@ EXPORT_SYMBOL(vfs_statfs);
 int user_statfs(const char __user *pathname, struct kstatfs *st)
 {
 	struct path path;
-	int error = user_path_at(AT_FDCWD, pathname, LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT, &path);
-	if (!error) {
+	int error;
+	unsigned int try = 0;
+	unsigned int lookup_flags = LOOKUP_FOLLOW|LOOKUP_AUTOMOUNT;
+
+	do {
+		error  = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+		if (error)
+			break;
+
 		error = vfs_statfs(&path, st);
 		path_put(&path);
-	}
+		lookup_flags |= LOOKUP_REVAL;
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.7

