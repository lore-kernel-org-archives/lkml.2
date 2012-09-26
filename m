Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2IZIwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab2IZIwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:52:09 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 27/27] GFS2: Write out dirty inode metadata in delayed deletes
Date: Wed, 26 Sep 2012 09:25:48 +0100
Message-Id: <1348647948-3219-28-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

If a dirty GFS2 inode was being deleted but was in use by another node, its
metadata was not getting written out before GFS2 checked for dirty buffers in
gfs2_ail_flush().  GFS2 was relying on inode_go_sync() to write out the
metadata when the other node tried to free the file, but it failed the error
check before it got that far. This patch writes out the metadata before calling
gfs2_ail_flush()

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 79cac70..a8d90f2 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1545,6 +1545,11 @@ static void gfs2_evict_inode(struct inode *inode)
 
 out_truncate:
 	gfs2_log_flush(sdp, ip->i_gl);
+	if (test_bit(GLF_DIRTY, &ip->i_gl->gl_flags)) {
+		struct address_space *metamapping = gfs2_glock2aspace(ip->i_gl);
+		filemap_fdatawrite(metamapping);
+		filemap_fdatawait(metamapping);
+	}
 	write_inode_now(inode, 1);
 	gfs2_ail_flush(ip->i_gl, 0);
 
-- 
1.7.4

