Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934974Ab1KJD2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:28:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934093Ab1KJD2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:28:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:13 2011
Message-Id: <20111109212713.580334654@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
        Ian Kent <raven@themaw.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Chuck Ebbert <cebbert@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [129/262] VFS: Fix automount for negative autofs dentries
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 5a30d8a2b8ddd5102c440c7e5a7c8e1fd729c818 upstream.
[ backport for 3.0.x: LOOKUP_PARENT => LOOKUP_CONTINUE by Chuck Ebbert
<cebbert@redhat.com> ]

Autofs may set the DCACHE_NEED_AUTOMOUNT flag on negative dentries.  These
need attention from the automounter daemon regardless of the LOOKUP_FOLLOW flag.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -781,19 +781,25 @@ static int follow_automount(struct path
 	if ((flags & LOOKUP_NO_AUTOMOUNT) && !(flags & LOOKUP_CONTINUE))
 		return -EISDIR; /* we actually want to stop here */
 
-	/* We want to mount if someone is trying to open/create a file of any
-	 * type under the mountpoint, wants to traverse through the mountpoint
-	 * or wants to open the mounted directory.
-	 *
+	/*
 	 * We don't want to mount if someone's just doing a stat and they've
 	 * set AT_SYMLINK_NOFOLLOW - unless they're stat'ing a directory and
 	 * appended a '/' to the name.
 	 */
-	if (!(flags & LOOKUP_FOLLOW) &&
-	    !(flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
-		       LOOKUP_OPEN | LOOKUP_CREATE)))
-		return -EISDIR;
-
+	if (!(flags & LOOKUP_FOLLOW)) {
+		/* We do, however, want to mount if someone wants to open or
+		 * create a file of any type under the mountpoint, wants to
+		 * traverse through the mountpoint or wants to open the mounted
+		 * directory.
+		 * Also, autofs may mark negative dentries as being automount
+		 * points.  These will need the attentions of the daemon to
+		 * instantiate them before they can be used.
+		 */
+		if (!(flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
+			     LOOKUP_OPEN | LOOKUP_CREATE)) &&
+		    path->dentry->d_inode)
+			return -EISDIR;
+	}
 	current->total_link_count++;
 	if (current->total_link_count >= 40)
 		return -ELOOP;


