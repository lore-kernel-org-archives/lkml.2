Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988Ab1KJD2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:28:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934975Ab1KJD2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:28:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:13 2011
Message-Id: <20111109212713.681763428@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [130/262] vfs: automount should ignore LOOKUP_FOLLOW
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Miklos Szeredi <mszeredi@suse.cz>

commit 0ec26fd0698285b31248e34bf1abb022c00f23d6 upstream.

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

[ It's not really clear what the right behavior is.  Apparently Solaris
  does the "automount on stat, leave alone on lstat".  And some programs
  can get unhappy when "stat+open+fstat" ends up giving a different
  result from the fstat than from the initial stat.

  But the change in 2.6.38 resulted in problems for some people, so
  we're going back to old behavior.  Maybe we can re-visit this
  discussion at some future date  - Linus ]

Reported-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
Acked-by: Ian Kent <raven@themaw.net>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |   33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -781,25 +781,22 @@ static int follow_automount(struct path
 	if ((flags & LOOKUP_NO_AUTOMOUNT) && !(flags & LOOKUP_CONTINUE))
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
-		if (!(flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
-			     LOOKUP_OPEN | LOOKUP_CREATE)) &&
-		    path->dentry->d_inode)
-			return -EISDIR;
-	}
+	if (!(flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
+		     LOOKUP_OPEN | LOOKUP_CREATE)) &&
+	    path->dentry->d_inode)
+		return -EISDIR;
+
 	current->total_link_count++;
 	if (current->total_link_count >= 40)
 		return -ELOOP;


