Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab2CMAbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:31:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:48872 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192Ab2CMAYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 180/196] cifs: add fallback in is_path_accessible for old servers
Date: Mon, 12 Mar 2012 20:21:33 -0400
Message-Id: <1331598109-31424-135-git-send-email-paul.gortmaker@windriver.com>
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

commit 221d1d797202984cb874e3ed9f1388593d34ee22 upstream.

The is_path_accessible check uses a QPathInfo call, which isn't
supported by ancient win9x era servers. Fall back to an older
SMBQueryInfo call if it fails with the magic error codes.

Reported-and-Tested-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/connect.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index cebbc29..1f6aae0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2254,6 +2254,11 @@ is_path_accessible(int xid, struct cifsTconInfo *tcon,
 			      0 /* not legacy */, cifs_sb->local_nls,
 			      cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	if (rc == -EOPNOTSUPP || rc == -EINVAL)
+		rc = SMBQueryInformation(xid, tcon, full_path, pfile_info,
+				cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
+				  CIFS_MOUNT_MAP_SPECIAL_CHR);
 	kfree(pfile_info);
 	return rc;
 }
-- 
1.7.9.3

