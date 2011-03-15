Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1COJgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:36:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab1COJeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/15] GFS2: Improve cluster mmap scalability
Date: Tue, 15 Mar 2011 09:11:34 +0000
Message-Id: <1300180305-5993-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mmap system call grabs a glock when an update to atime maybe
required. It does this in order to ensure that the flags on the
inode are uptodate, but since it will only mark atime for a future
update, an exclusive lock is not required here (one will be taken
later when the actual update is performed).

Also, the lock can be skipped when the mount is marked noatime in
addition to the original check which only looked at the noatime
flag for the inode itself.

This should increase the scalability of the mmap call when multiple
nodes are all mmaping the same file.

Reported-by: Scooter Morris <scooter@cgl.ucsf.edu>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 7cfdcb9..216ad27 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -448,15 +448,20 @@ static int gfs2_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
 
-	if (!(file->f_flags & O_NOATIME)) {
+	if (!(file->f_flags & O_NOATIME) &&
+	    !IS_NOATIME(&ip->i_inode)) {
 		struct gfs2_holder i_gh;
 		int error;
 
-		gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &i_gh);
+		gfs2_holder_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
 		error = gfs2_glock_nq(&i_gh);
-		file_accessed(file);
-		if (error == 0)
-			gfs2_glock_dq_uninit(&i_gh);
+		if (error == 0) {
+			file_accessed(file);
+			gfs2_glock_dq(&i_gh);
+		}
+		gfs2_holder_uninit(&i_gh);
+		if (error)
+			return error;
 	}
 	vma->vm_ops = &gfs2_vm_ops;
 	vma->vm_flags |= VM_CAN_NONLINEAR;
-- 
1.7.4

