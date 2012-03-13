Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193Ab2CMA1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:27:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:49080 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030181Ab2CMAZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Timo Warns <Warns@pre-sense.de>,
        Timo Warns <warns@pre-sense.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 195/196] befs: Validate length of long symbolic links.
Date: Mon, 12 Mar 2012 20:21:48 -0400
Message-Id: <1331598109-31424-150-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timo Warns <Warns@pre-sense.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 338d0f0a6fbc82407864606f5b64b75aeb3c70f2 upstream.

Signed-off-by: Timo Warns <warns@pre-sense.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/befs/linuxvfs.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 34ddda8..9158c07 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -469,17 +469,22 @@ befs_follow_link(struct dentry *dentry, struct nameidata *nd)
 		befs_data_stream *data = &befs_ino->i_data.ds;
 		befs_off_t len = data->size;
 
-		befs_debug(sb, "Follow long symlink");
-
-		link = kmalloc(len, GFP_NOFS);
-		if (!link) {
-			link = ERR_PTR(-ENOMEM);
-		} else if (befs_read_lsymlink(sb, data, link, len) != len) {
-			kfree(link);
-			befs_error(sb, "Failed to read entire long symlink");
+		if (len == 0) {
+			befs_error(sb, "Long symlink with illegal length");
 			link = ERR_PTR(-EIO);
 		} else {
-			link[len - 1] = '\0';
+			befs_debug(sb, "Follow long symlink");
+
+			link = kmalloc(len, GFP_NOFS);
+			if (!link) {
+				link = ERR_PTR(-ENOMEM);
+			} else if (befs_read_lsymlink(sb, data, link, len) != len) {
+				kfree(link);
+				befs_error(sb, "Failed to read entire long symlink");
+				link = ERR_PTR(-EIO);
+			} else {
+				link[len - 1] = '\0';
+			}
 		}
 	} else {
 		link = befs_ino->i_data.symlink;
-- 
1.7.9.3

