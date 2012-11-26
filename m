Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2KZQ76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:59:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab2KZQ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:59:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Hicks <tyhicks@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 004/270] eCryptfs: Copy up POSIX ACL and read-only flags from lower mount
Date: Mon, 26 Nov 2012 14:54:54 -0200
Message-Id: <1353949160-26803-5-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit 069ddcda37b2cf5bb4b6031a944c0e9359213262 upstream.

When the eCryptfs mount options do not include '-o acl', but the lower
filesystem's mount options do include 'acl', the MS_POSIXACL flag is not
flipped on in the eCryptfs super block flags. This flag is what the VFS
checks in do_last() when deciding if the current umask should be applied
to a newly created inode's mode or not. When a default POSIX ACL mask is
set on a directory, the current umask is incorrectly applied to new
inodes created in the directory. This patch ignores the MS_POSIXACL flag
passed into ecryptfs_mount() and sets the flag on the eCryptfs super
block depending on the flag's presence on the lower super block.

Additionally, it is incorrect to allow a writeable eCryptfs mount on top
of a read-only lower mount. This missing check did not allow writes to
the read-only lower mount because permissions checks are still performed
on the lower filesystem's objects but it is best to simply not allow a
rw mount on top of ro mount. However, a ro eCryptfs mount on top of a rw
mount is valid and still allowed.

https://launchpad.net/bugs/1009207

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Stefan Beller <stefanbeller@googlemail.com>
Cc: John Johansen <john.johansen@canonical.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ecryptfs/main.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 6895493..df217dc 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -505,7 +505,6 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 		goto out;
 	}
 
-	s->s_flags = flags;
 	rc = bdi_setup_and_register(&sbi->bdi, "ecryptfs", BDI_CAP_MAP_COPY);
 	if (rc)
 		goto out1;
@@ -541,6 +540,15 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 	}
 
 	ecryptfs_set_superblock_lower(s, path.dentry->d_sb);
+
+	/**
+	 * Set the POSIX ACL flag based on whether they're enabled in the lower
+	 * mount. Force a read-only eCryptfs mount if the lower mount is ro.
+	 * Allow a ro eCryptfs mount even when the lower mount is rw.
+	 */
+	s->s_flags = flags & ~MS_POSIXACL;
+	s->s_flags |= path.dentry->d_sb->s_flags & (MS_RDONLY | MS_POSIXACL);
+
 	s->s_maxbytes = path.dentry->d_sb->s_maxbytes;
 	s->s_blocksize = path.dentry->d_sb->s_blocksize;
 	s->s_magic = ECRYPTFS_SUPER_MAGIC;
-- 
1.7.9.5

