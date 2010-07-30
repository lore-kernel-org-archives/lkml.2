Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600Ab0G3TOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:14:33 -0400
Received: from kroah.org ([198.145.64.141]:46318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab0G3RSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:07 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:02 2010
Message-Id: <20100730171502.284364105@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Chris Mason <chris.mason@oracle.com>
Subject: [029/165] Btrfs: fix checks in BTRFS_IOC_CLONE_RANGE
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <dan.j.rosenberg@gmail.com>

commit 2ebc3464781ad24474abcbd2274e6254689853b5 upstream.

1.  The BTRFS_IOC_CLONE and BTRFS_IOC_CLONE_RANGE ioctls should check
whether the donor file is append-only before writing to it.

2.  The BTRFS_IOC_CLONE_RANGE ioctl appears to have an integer
overflow that allows a user to specify an out-of-bounds range to copy
from the source file (if off + len wraps around).  I haven't been able
to successfully exploit this, but I'd imagine that a clever attacker
could use this to read things he shouldn't.  Even if it's not
exploitable, it couldn't hurt to be safe.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -947,7 +947,7 @@ static noinline long btrfs_ioctl_clone(s
 	 */
 
 	/* the destination must be opened for writing */
-	if (!(file->f_mode & FMODE_WRITE))
+	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND))
 		return -EINVAL;
 
 	ret = mnt_want_write(file->f_path.mnt);
@@ -1000,7 +1000,7 @@ static noinline long btrfs_ioctl_clone(s
 
 	/* determine range to clone */
 	ret = -EINVAL;
-	if (off >= src->i_size || off + len > src->i_size)
+	if (off + len > src->i_size || off + len < off)
 		goto out_unlock;
 	if (len == 0)
 		olen = len = src->i_size - off;


