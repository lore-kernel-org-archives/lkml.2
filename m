Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1JWGeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:34:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab1JWGeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:17 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:40 2011
Message-Id: <20111023062540.684446582@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:50 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>, Ian Kent <raven@themaw.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Chuck Ebbert <cebbert@redhat.com>
Subject: [22/27] VFS: Fix automount for negative autofs dentries
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -779,19 +779,25 @@ static int follow_automount(struct path
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
+		if (!(flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY |
+			     LOOKUP_OPEN | LOOKUP_CREATE)) &&
+		    path->dentry->d_inode)
+			return -EISDIR;
+	}
 	current->total_link_count++;
 	if (current->total_link_count >= 40)
 		return -ELOOP;


