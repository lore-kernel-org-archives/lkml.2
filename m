Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0DVT3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:29:36 -0400
Received: from kroah.org ([198.145.64.141]:41194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab0DVT3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:14 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:19 2010
Message-Id: <20100422190918.971781814@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sachin Prabhu <sprabhu@redhat.com>,
       Eric Van Hensbergen <ericvh@gmail.com>, maximilian attems <max@stro.at>
Subject: [130/197] 9p: Skip check for mandatory locks when unlocking
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sachin Prabhu <sprabhu@redhat.com>

commit f78233dd44a110c574fe760ad6f9c1e8741a0d00 upstream.

While investigating a bug, I came across a possible bug in v9fs. The
problem is similar to the one reported for NFS by ASANO Masahiro in
http://lkml.org/lkml/2005/12/21/334.

v9fs_file_lock() will skip locks on file which has mode set to 02666.
This is a problem in cases where the mode of the file is changed after
a process has obtained a lock on the file. Such a lock will be skipped
during unlock and the machine will end up with a BUG in
locks_remove_flock().

v9fs_file_lock() should skip the check for mandatory locks when
unlocking a file.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/9p/vfs_file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -114,7 +114,7 @@ static int v9fs_file_lock(struct file *f
 	P9_DPRINTK(P9_DEBUG_VFS, "filp: %p lock: %p\n", filp, fl);
 
 	/* No mandatory locks */
-	if (__mandatory_lock(inode))
+	if (__mandatory_lock(inode) && fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
 	if ((IS_SETLK(cmd) || IS_SETLKW(cmd)) && fl->fl_type != F_UNLCK) {


