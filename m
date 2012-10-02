Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab2JBAUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:20:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43333 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2JBASE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:18:04 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 41/49] vfs: allow utimensat() calls to retry once on an ESTALE error
Date: Mon,  1 Oct 2012 20:16:50 -0400
Message-Id: <1349137018-21948-42-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearly, we can't handle the NULL filename case, but we can deal with
the case where there's a real pathname.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/utimes.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/utimes.c b/fs/utimes.c
index fa4dbe4..b6b2865 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -156,16 +156,21 @@ long do_utimes(int dfd, const char __user *filename, struct timespec *times,
 	} else {
 		struct path path;
 		int lookup_flags = 0;
+		unsigned int try = 0;
 
 		if (!(flags & AT_SYMLINK_NOFOLLOW))
 			lookup_flags |= LOOKUP_FOLLOW;
 
-		error = user_path_at(dfd, filename, lookup_flags, &path);
-		if (error)
-			goto out;
+		do {
+			error = user_path_at(dfd, filename,
+						lookup_flags, &path);
+			if (error)
+				break;
 
-		error = utimes_common(&path, times);
-		path_put(&path);
+			error = utimes_common(&path, times);
+			path_put(&path);
+			lookup_flags |= LOOKUP_REVAL;
+		} while (retry_estale(error, try++));
 	}
 
 out:
-- 
1.7.11.4

