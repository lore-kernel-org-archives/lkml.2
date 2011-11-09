Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934782Ab1KJD1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:27:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934348Ab1KJD07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:13 2011
Message-Id: <20111109212713.879189869@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ian Kent <raven@themaw.net>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [132/262] vfs pathname lookup: Add LOOKUP_AUTOMOUNT flag
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Linus Torvalds <torvalds@linux-foundation.org>

Since we've now turned around and made LOOKUP_FOLLOW *not* force an
automount, we want to add the ability to force an automount event on
lookup even if we don't happen to have one of the other flags that force
it implicitly (LOOKUP_OPEN, LOOKUP_DIRECTORY, LOOKUP_PARENT..)

Most cases will never want to use this, since you'd normally want to
delay automounting as long as possible, which usually implies
LOOKUP_OPEN (when we open a file or directory, we really cannot avoid
the automount any more).

But Trond argued sufficiently forcefully that at a minimum bind mounting
a file and quotactl will want to force the automount lookup.  Some other
cases (like nfs_follow_remote_path()) could use it too, although
LOOKUP_DIRECTORY would work there as well.

This commit just adds the flag and logic, no users yet, though.  It also
doesn't actually touch the LOOKUP_NO_AUTOMOUNT flag that is related, and
was made irrelevant by the same change that made us not follow on
LOOKUP_FOLLOW.

Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Ian Kent <raven@themaw.net>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/namei.c            |    2 +-
 include/linux/namei.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -793,7 +793,7 @@ static int follow_automount(struct path
 	 * of the daemon to instantiate them before they can be used.
 	 */
 	if (!(flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY |
-		     LOOKUP_OPEN | LOOKUP_CREATE)) &&
+		     LOOKUP_OPEN | LOOKUP_CREATE | LOOKUP_AUTOMOUNT)) &&
 	    path->dentry->d_inode)
 		return -EISDIR;
 
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -49,6 +49,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_FOLLOW		0x0001
 #define LOOKUP_DIRECTORY	0x0002
 #define LOOKUP_CONTINUE		0x0004
+#define LOOKUP_AUTOMOUNT	0x0008
 
 #define LOOKUP_PARENT		0x0010
 #define LOOKUP_REVAL		0x0020


