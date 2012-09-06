Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab2IFP4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:56:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44556 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab2IFP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:56:37 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: [RFC PATCH 0/2] issues with NFS filesystems as lower layer
Date: Thu,  6 Sep 2012 16:56:32 +0100
Message-Id: <1346946994-21286-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During some testing here we discovered that we could not successfully
use a NFS as the lower layer for overlayfs.  There are two separate issues:

Firstly when using an NFSv4 lower layer we tickle an issue when copying
up the xattrs for the underlying file.  NFS uses an xattr system.nfs4_acl
which the upper layer will not store (ext4 for example).  This triggers
an EOPNOTSUPP error when trying to copy up the xattrs for the file,
preventing the file being written.  I am a little unclear as to whether it
makes sense to generally ignore xattrs we cannot store in the upper layer,
this is based on the assumption the person creating the mount knew what
they were combining.  The first patch (for discussion) following this
email avoids this issue by ignoring the xattr if it is not storable.

Secondly when using an NFSv3 R/O lower layer the filesystem permissions
check refuses permission to write to the inode which prevents us from
copying it up even though we have a writable upper layer.  (With an ext4
lower layer the inode check will succeed if the inode  is writable even
if the filesystem is not.)  It is not clear what the right solution is
here.  One approach is to check the inode permissions only (avoiding the
filesystem specific permissions op), but it is not clear we can rely on
these for all underlying filesystems.  Perhaps this check should only be
used for NFS.  Perhaps it needs to be a mount option.  The second patch
(for discussion) following this email implements this, using the inode
permissions when the lowerlayer is read-only.  This seems to work as
expected in my limited testing.

Comments on both approaches appreciated.

-apw


Andy Whitcroft (2):
  ovl: copy_up_xattr may fail when the upper filesystem does not
    support the same xattrs
  overlayfs: when the underlying filesystem is read-only use inode
    permissions

 fs/namei.c             |   36 ++++++++++++++++++++++++++++++++++++
 fs/overlayfs/copy_up.c |    9 ++++++++-
 fs/overlayfs/inode.c   |   12 ++++++++++++
 include/linux/fs.h     |    1 +
 4 files changed, 57 insertions(+), 1 deletion(-)

-- 
1.7.9.5

