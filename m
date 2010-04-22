Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0DVT1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:27:39 -0400
Received: from kroah.org ([198.145.64.141]:37167 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755839Ab0DVT1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:27:36 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:08 2010
Message-Id: <20100422190908.571068638@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:07:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, xfs@oss.sgi.com,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Alex Elder <aelder@sgi.com>
Subject: [013/197] xfs: Fix error return for fallocate() on XFS
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

commit 44a743f68705c681439f264deb05f8f38e9048d3 upstream

Noticed that through glibc fallocate would return 28 rather than -1
and errno = 28 for ENOSPC. The xfs routines uses XFS_ERROR format
positive return error codes while the syscalls use negative return
codes.  Fixup the two cases in xfs_vn_fallocate syscall to convert to
negative.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/linux-2.6/xfs_iops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -573,8 +573,8 @@ xfs_vn_fallocate(
 	bf.l_len = len;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
-	error = xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
-				      0, XFS_ATTR_NOLOCK);
+	error = -xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
+				       0, XFS_ATTR_NOLOCK);
 	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode))
 		new_size = offset + len;
@@ -585,7 +585,7 @@ xfs_vn_fallocate(
 
 		iattr.ia_valid = ATTR_SIZE;
 		iattr.ia_size = new_size;
-		error = xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
+		error = -xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
 	}
 
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);


