Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab2K3KTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:19:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab2K3KSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:42 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/16] GFS2: Set gl_object during inode create
Date: Fri, 30 Nov 2012 09:52:21 +0000
Message-Id: <1354269141-3311-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a cluster coherency problem that occurs when one
node creates a file, does several writes, then a different node
tries to write to the same file. When the inode's glock is demoted,
the inode wasn't synced to the media properly because the gl_object
wasn't set. Later, the flush daemon noticed the uncommitted data
and tried to flush it, only to discover the glock was no longer locked
properly in exclusive mode. That caused an assert withdraw.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 2405695..2b6f569 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -702,6 +702,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_free_inode;
 
+	ip->i_gl->gl_object = ip;
 	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, ghs + 1);
 	if (error)
 		goto fail_free_inode;
-- 
1.7.4

