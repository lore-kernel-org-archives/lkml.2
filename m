Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab0EYIlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:41:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab0EYIkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:40:52 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/3] GFS2: Don't "get" xattrs for ACLs when ACLs are turned off
Date: Tue, 25 May 2010 09:21:28 +0100
Message-Id: <1274775689-4689-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274775689-4689-2-git-send-email-swhiteho@redhat.com>
References: <1274775689-4689-1-git-send-email-swhiteho@redhat.com>
 <1274775689-4689-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to match ext3 behaviour. We should not allow getting of
xattrs relating to ACLs when ACLs are turned off.

Reported-by: Nate Straz <nstraz@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/acl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 87ee309..ca991d7 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -236,10 +236,14 @@ static int gfs2_xattr_system_get(struct dentry *dentry, const char *name,
 				 void *buffer, size_t size, int xtype)
 {
 	struct inode *inode = dentry->d_inode;
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct posix_acl *acl;
 	int type;
 	int error;
 
+	if (!sdp->sd_args.ar_posix_acl)
+		return -EOPNOTSUPP;
+
 	type = gfs2_acl_type(name);
 	if (type < 0)
 		return type;
-- 
1.6.2.5

