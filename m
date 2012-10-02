Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab2JBAVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:21:32 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58171 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab2JBAR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:59 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 37/49] vfs: make fchmodat retry once on ESTALE errors
Date: Mon,  1 Oct 2012 20:16:46 -0400
Message-Id: <1349137018-21948-38-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/open.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index a015cb8..232cbfb 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -506,12 +506,17 @@ SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode
 {
 	struct path path;
 	int error;
+	unsigned int try = 0;
+	int lookup_flags = LOOKUP_FOLLOW;
 
-	error = user_path_at(dfd, filename, LOOKUP_FOLLOW, &path);
-	if (!error) {
+	do {
+		error = user_path_at(dfd, filename, lookup_flags, &path);
+		if (error)
+			break;
 		error = chmod_common(&path, mode);
 		path_put(&path);
-	}
+		lookup_flags |= LOOKUP_REVAL;
+	} while (retry_estale(error, try++));
 	return error;
 }
 
-- 
1.7.11.4

