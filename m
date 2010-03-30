Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab0C3XYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:24:42 -0400
Received: from kroah.org ([198.145.64.141]:46918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab0C3XWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:23 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:01 2010
Message-Id: <20100330224900.838995181@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:43:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sachin Prabhu <sprabhu@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [155/156] GFS2: Skip check for mandatory locks when unlocking
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sachin Prabhu <sprabhu@redhat.com>

commit 720e7749279bde0d08684b1bb4e7a2eedeec6394 upstream.

gfs2_lock() will skip locks on file which have mode set to 02666. This is a problem in cases where the mode of the file is changed after a process has obtained a lock on the file. Such a lock will be skipped and will result in a BUG in locks_remove_flock().

gfs2_lock() should skip the check for mandatory locks when unlocking a file.

Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/gfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -640,7 +640,7 @@ static int gfs2_lock(struct file *file,
 
 	if (!(fl->fl_flags & FL_POSIX))
 		return -ENOLCK;
-	if (__mandatory_lock(&ip->i_inode))
+	if (__mandatory_lock(&ip->i_inode) && fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
 	if (cmd == F_CANCELLK) {


