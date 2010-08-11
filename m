Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab0HKX7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:51 -0400
Received: from kroah.org ([198.145.64.141]:43749 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759251Ab0HKX7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:32 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:05 2010
Message-Id: <20100811235505.265838111@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sachin Prabhu <sprabhu@redhat.com>,
        Joel Becker <joel.becker@oracle.com>, Neil Brown <neilb@suse.de>
Subject: [105/111] [PATCH] Skip check for mandatory locks when unlocking
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sachin Prabhu <sprabhu@redhat.com>

commit ee860b6a650360c91f5d5f9a94262aad9be90015 upstream.

ocfs2_lock() will skip locks on file which has mode set to 02666. This
is a problem in cases where the mode of the file is changed after a
process has obtained a lock on the file.

ocfs2_lock() should skip the check for mandatory locks when unlocking a
file.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/locks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/locks.c
+++ b/fs/ocfs2/locks.c
@@ -133,7 +133,7 @@ int ocfs2_lock(struct file *file, int cm
 
 	if (!(fl->fl_flags & FL_POSIX))
 		return -ENOLCK;
-	if (__mandatory_lock(inode))
+	if (__mandatory_lock(inode) && fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
 	return ocfs2_plock(osb->cconn, OCFS2_I(inode)->ip_blkno, file, cmd, fl);


