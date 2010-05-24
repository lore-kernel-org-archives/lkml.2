Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab0EXXYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:24:07 -0400
Received: from kroah.org ([198.145.64.141]:59473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab0EXXXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:23:50 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:18:15 2010
Message-Id: <20100524231815.887482743@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:15:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Mason <chris.mason@oracle.com>
Subject: [30/39] Btrfs: check for read permission on src file in the clone ioctl
In-Reply-To: <20100524231840.GA17857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>

commit 5dc6416414fb3ec6e2825fd4d20c8bf1d7fe0395 upstream.

The existing code would have allowed you to clone a file that was
only open for writing

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/ioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -964,12 +964,17 @@ static noinline long btrfs_ioctl_clone(s
 		ret = -EBADF;
 		goto out_drop_write;
 	}
+
 	src = src_file->f_dentry->d_inode;
 
 	ret = -EINVAL;
 	if (src == inode)
 		goto out_fput;
 
+	/* the src must be open for reading */
+	if (!(src_file->f_mode & FMODE_READ))
+		goto out_fput;
+
 	ret = -EISDIR;
 	if (S_ISDIR(src->i_mode) || S_ISDIR(inode->i_mode))
 		goto out_fput;


