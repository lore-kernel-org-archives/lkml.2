Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab2KEPbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:31:03 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:48884 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962Ab2KEPWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:22:52 -0500
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v9 17/34] vfs: make fchmodat retry once on ESTALE errors
Date: Mon,  5 Nov 2012 10:21:56 -0500
Message-Id: <1352128933-28526-18-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
References: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/open.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index a1331f1..06f04bd 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -503,12 +503,17 @@ SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename, umode_t, mode
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
1.7.11.7

