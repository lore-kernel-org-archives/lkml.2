Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab0LHBAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:00:30 -0500
Received: from kroah.org ([198.145.64.141]:48787 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058Ab0LHBA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:27 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:30 2010
Message-Id: <20101208005730.541399764@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [092/289] reiserfs: fix inode mutex - reiserfs lock misordering
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit da905873effecd1c0166e578bc4b5006f041b18b upstream.

reiserfs_unpack() locks the inode mutex with reiserfs_mutex_lock_safe()
to protect against reiserfs lock dependency.  However this protection
requires to have the reiserfs lock to be locked.

This is the case if reiserfs_unpack() is called by reiserfs_ioctl but
not from reiserfs_quota_on() when it tries to unpack tails of quota
files.

Fix the ordering of the two locks in reiserfs_unpack() to fix this
issue.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Markus Gapp <markus.gapp@gmx.net>
Reported-by: Jan Kara <jack@suse.cz>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/ioctl.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -186,12 +186,11 @@ int reiserfs_unpack(struct inode *inode,
 		return 0;
 	}
 
-	/* we need to make sure nobody is changing the file size beneath
-	 ** us
-	 */
-	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
 	depth = reiserfs_write_lock_once(inode->i_sb);
 
+	/* we need to make sure nobody is changing the file size beneath us */
+	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
+
 	write_from = inode->i_size & (blocksize - 1);
 	/* if we are on a block boundary, we are already unpacked.  */
 	if (write_from == 0) {


