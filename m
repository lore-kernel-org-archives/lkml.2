Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1CERvE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:51:04 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47135 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1CERuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:50:39 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/4] fs/9p: Open writeback fid in O_SYNC mode
Date: Sat,  5 Mar 2011 23:20:23 +0530
Message-Id: <1299347425-16810-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299347425-16810-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1299347425-16810-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older version of protocol don't support tsyncfs operation.
So for them force a O_SYNC flag on the server

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/fid.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index cd63e00..99a1a7b 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -286,9 +286,11 @@ static struct p9_fid *v9fs_fid_clone_with_uid(struct dentry *dentry, uid_t uid)
 
 struct p9_fid *v9fs_writeback_fid(struct dentry *dentry)
 {
-	int err;
+	int err, flags;
 	struct p9_fid *fid;
+	struct v9fs_session_info *v9ses;
 
+	v9ses = v9fs_inode2v9ses(dentry->d_inode);
 	fid = v9fs_fid_clone_with_uid(dentry, 0);
 	if (IS_ERR(fid))
 		goto error_out;
@@ -297,8 +299,17 @@ struct p9_fid *v9fs_writeback_fid(struct dentry *dentry)
 	 * dirty pages. We always request for the open fid in read-write
 	 * mode so that a partial page write which result in page
 	 * read can work.
+	 *
+	 * we don't have a tsyncfs operation for older version
+	 * of protocol. So make sure the write back fid is
+	 * opened in O_SYNC mode.
 	 */
-	err = p9_client_open(fid, O_RDWR);
+	if (!v9fs_proto_dotl(v9ses))
+		flags = O_RDWR | O_SYNC;
+	else
+		flags = O_RDWR;
+
+	err = p9_client_open(fid, flags);
 	if (err < 0) {
 		p9_client_clunk(fid);
 		fid = ERR_PTR(err);
-- 
1.7.1

