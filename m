Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab2CMAWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:47515 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492Ab2CMAWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:11 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 055/196] cifs: always do is_path_accessible check in cifs_mount
Date: Mon, 12 Mar 2012 20:19:28 -0400
Message-Id: <1331598109-31424-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 70945643722ffeac779d2529a348f99567fa5c33 upstream.

Currently, we skip doing the is_path_accessible check in cifs_mount if
there is no prefixpath. I have a report of at least one server however
that allows a TREE_CONNECT to a share that has a DFS referral at its
root. The reporter in this case was using a UNC that had no prefixpath,
so the is_path_accessible check was not triggered and the box later hit
a BUG() because we were chasing a DFS referral on the root dentry for
the mount.

This patch fixes this by removing the check for a zero-length
prefixpath.  That should make the is_path_accessible check be done in
this situation and should allow the client to chase the DFS referral at
mount time instead.

Reported-and-Tested-by: Yogesh Sharma <ysharma@cymer.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/connect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d9566bf..f6afb59 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2555,7 +2555,7 @@ try_mount_again:
 
 remote_path_check:
 	/* check if a whole path (including prepath) is not remote */
-	if (!rc && cifs_sb->prepathlen && tcon) {
+	if (!rc && tcon) {
 		/* build_path_to_root works only when we have a valid tcon */
 		full_path = cifs_build_path_to_root(cifs_sb);
 		if (full_path == NULL) {
-- 
1.7.9.3

