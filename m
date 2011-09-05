Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab1IEQGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 12:06:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37613 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1IEQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 12:06:36 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: automount should ignore LOOKUP_FOLLOW
CC: Leonardo Chiquitto <leonardo.lists@gmail.com>,
        David Howells <dhowells@redhat.com>, Ian Kent <raven@themaw.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        autofs@linux.kernel.org
Date: Mon, 05 Sep 2011 18:06:26 +0200
Message-ID: <87liu37z3x.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Prior to 2.6.38 automount would not trigger on either stat(2) or
lstat(2) on the automount point.

After 2.6.38, with the introduction of the ->d_automount()
infrastructure, stat(2) and others would start triggering automount
while lstat(2), etc. still would not.  This is a regression and a
userspace ABI change.

Problem originally reported here:

  http://thread.gmane.org/gmane.linux.kernel.autofs/6098

It appears that there was an attempt at fixing various userspace tools
to not trigger the automount.  But since the stat system call is
rather common it is impossible to "fix" all userspace.

This patch reverts the original behavior, which is to not trigger on
stat(2) and other symlink following syscalls.

Reported-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: David Howells <dhowells@redhat.com>
CC: Ian Kent <raven@themaw.net>
CC: stable@kernel.org
---
 fs/namei.c |   33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2011-09-05 14:37:25.000000000 +0200
+++ linux-2.6/fs/namei.c	2011-09-05 17:31:14.000000000 +0200
@@ -727,25 +727,22 @@ static int follow_automount(struct path
 	if ((flags & LOOKUP_NO_AUTOMOUNT) && !(flags & LOOKUP_PARENT))
 		return -EISDIR; /* we actually want to stop here */
 
-	/*
-	 * We don't want to mount if someone's just doing a stat and they've
-	 * set AT_SYMLINK_NOFOLLOW - unless they're stat'ing a directory and
-	 * appended a '/' to the name.
+	/* We don't want to mount if someone's just doing a stat -
+	 * unless they're stat'ing a directory and appended a '/' to
+	 * the name.
+	 *
+	 * We do, however, want to mount if someone wants to open or
+	 * create a file of any type under the mountpoint, wants to
+	 * traverse through the mountpoint or wants to open the
+	 * mounted directory.  Also, autofs may mark negative dentries
+	 * as being automount points.  These will need the attentions
+	 * of the daemon to instantiate them before they can be used.
 	 */
-	if (!(flags & LOOKUP_FOLLOW)) {
-		/* We do, however, want to mount if someone wants to open or
-		 * create a file of any type under the mountpoint, wants to
-		 * traverse through the mountpoint or wants to open the mounted
-		 * directory.
-		 * Also, autofs may mark negative dentries as being automount
-		 * points.  These will need the attentions of the daemon to
-		 * instantiate them before they can be used.
-		 */
-		if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
-			     LOOKUP_OPEN | LOOKUP_CREATE)) &&
-		    path->dentry->d_inode)
-			return -EISDIR;
-	}
+	if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
+		     LOOKUP_OPEN | LOOKUP_CREATE)) &&
+	    path->dentry->d_inode)
+		return -EISDIR;
+
 	current->total_link_count++;
 	if (current->total_link_count >= 40)
 		return -ELOOP;
