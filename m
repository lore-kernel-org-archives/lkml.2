Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1HRMUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:20:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878Ab1HRMT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:19:29 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com
Subject: [PATCH 4/5] xfs: use fs netlink interface for ENOSPC conditions
Date: Thu, 18 Aug 2011 14:18:25 +0200
Message-Id: <1313669906-14931-5-git-send-email-lczerner@redhat.com>
In-Reply-To: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register fs netlink interface and send proper warning if ENOSPC is
encountered. Note that we differentiate between enospc for metadata and
enospc for data.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: xfs@oss.sgi.com
---
 fs/xfs/linux-2.6/xfs_file.c  |    2 ++
 fs/xfs/linux-2.6/xfs_super.c |    1 +
 fs/xfs/xfs_vnodeops.c        |   10 ++++++++--
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 7f7b424..ab41603 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -896,6 +896,8 @@ xfs_file_aio_write(
 out_unlock:
 	xfs_aio_write_newsize_update(ip);
 	xfs_rw_iunlock(ip, iolock);
+	if (unlikely(-ENOSPC == ret))
+		fs_nl_send_warning(inode->i_sb->s_dev, FS_NL_ENOSPC_WARN);
 	return ret;
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 9a72dda..dd167a0 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1731,6 +1731,7 @@ init_xfs_fs(void)
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
 		goto out_sysctl_unregister;
+	init_fs_nl_family();
 	return 0;
 
  out_sysctl_unregister:
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 51fc429..1a95115 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -996,6 +996,8 @@ xfs_create(
  out_trans_abort:
 	cancel_flags |= XFS_TRANS_ABORT;
  out_trans_cancel:
+	if (ENOSPC == error)
+		fs_nl_send_warning(mp->m_super->s_dev, FS_NL_META_ENOSPC_WARN);
 	xfs_trans_cancel(tp, cancel_flags);
  out_release_inode:
 	/*
@@ -2302,7 +2304,7 @@ xfs_change_file_space(
 		error = xfs_alloc_file_space(ip, startoffset, bf->l_len,
 						prealloc_type, attr_flags);
 		if (error)
-			return error;
+			goto alloc_failed;
 		setprealloc = 1;
 		break;
 
@@ -2321,7 +2323,7 @@ xfs_change_file_space(
 			error = xfs_alloc_file_space(ip, fsize,
 					startoffset - fsize, 0, attr_flags);
 			if (error)
-				break;
+				goto alloc_failed;
 		}
 
 		iattr.ia_valid = ATTR_SIZE;
@@ -2384,5 +2386,9 @@ xfs_change_file_space(
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
+alloc_failed:
+	if (unlikely(ENOSPC == error))
+		fs_nl_send_warning(mp->m_super->s_dev, FS_NL_ENOSPC_WARN);
+
 	return error;
 }
-- 
1.7.4.4

