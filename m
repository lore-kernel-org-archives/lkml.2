Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965206Ab2CAVt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:49:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35281 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965064Ab2CAVt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:49:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.130.233 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213924.203091866@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [ 12/34] Ban ecryptfs over ecryptfs
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------


From: Al Viro <viro@zeniv.linux.org.uk>

(cherry picked from commit 4403158ba295c8e36f6736b1bb12d0f7e1923dac)

This is a seriously simplified patch from Eric Sandeen; copy of
rationale follows:
===
  mounting stacked ecryptfs on ecryptfs has been shown to lead to bugs
  in testing.  For crypto info in xattr, there is no mechanism for handling
  this at all, and for normal file headers, we run into other trouble:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  IP: [<ffffffffa015b0b3>] ecryptfs_d_revalidate+0x43/0xa0 [ecryptfs]
  ...

  There doesn't seem to be any good usecase for this, so I'd suggest just
  disallowing the configuration.

  Based on a patch originally, I believe, from Mike Halcrow.
===

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -487,6 +487,7 @@ out:
 }
 
 struct kmem_cache *ecryptfs_sb_info_cache;
+static struct file_system_type ecryptfs_fs_type;
 
 /**
  * ecryptfs_fill_super
@@ -561,6 +562,13 @@ static int ecryptfs_read_super(struct su
 		ecryptfs_printk(KERN_WARNING, "path_lookup() failed\n");
 		goto out;
 	}
+	if (path.dentry->d_sb->s_type == &ecryptfs_fs_type) {
+		rc = -EINVAL;
+		printk(KERN_ERR "Mount on filesystem of type "
+			"eCryptfs explicitly disallowed due to "
+			"known incompatibilities\n");
+		goto out_free;
+	}
 	ecryptfs_set_superblock_lower(sb, path.dentry->d_sb);
 	sb->s_maxbytes = path.dentry->d_sb->s_maxbytes;
 	sb->s_blocksize = path.dentry->d_sb->s_blocksize;


