Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0EYIk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756386Ab0EYIkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:40:55 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/3] GFS2: Fix permissions checking for setflags ioctl()
Date: Tue, 25 May 2010 09:21:29 +0100
Message-Id: <1274775689-4689-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274775689-4689-3-git-send-email-swhiteho@redhat.com>
References: <1274775689-4689-1-git-send-email-swhiteho@redhat.com>
 <1274775689-4689-2-git-send-email-swhiteho@redhat.com>
 <1274775689-4689-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be checking for the ownership of the file for which
flags are being set, rather than just for write access.

Reported-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/file.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index e6dd2ae..b20bfcc 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -218,6 +218,11 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	if (error)
 		goto out_drop_write;
 
+	error = -EACCES;
+	if (!is_owner_or_cap(inode))
+		goto out;
+
+	error = 0;
 	flags = ip->i_diskflags;
 	new_flags = (flags & ~mask) | (reqflags & mask);
 	if ((new_flags ^ flags) == 0)
@@ -275,8 +280,10 @@ static int gfs2_set_flags(struct file *filp, u32 __user *ptr)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	u32 fsflags, gfsflags;
+
 	if (get_user(fsflags, ptr))
 		return -EFAULT;
+
 	gfsflags = fsflags_cvt(fsflags_to_gfs2, fsflags);
 	if (!S_ISDIR(inode->i_mode)) {
 		if (gfsflags & GFS2_DIF_INHERIT_JDATA)
-- 
1.6.2.5

