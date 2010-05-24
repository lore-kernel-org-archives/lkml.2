Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232Ab0EXXMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:12:06 -0400
Received: from kroah.org ([198.145.64.141]:36473 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759018Ab0EXXJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:32 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:51 2010
Message-Id: <20100524230351.313162248@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:59:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Mason <chris.mason@oracle.com>
Subject: [22/34] Btrfs: check for read permission on src file in the clone ioctl
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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
@@ -959,12 +959,17 @@ static noinline long btrfs_ioctl_clone(s
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


