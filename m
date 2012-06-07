Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2FGHHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 03:07:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38203 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2FGHHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 03:07:11 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
CC: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
Date: Thu, 07 Jun 2012 09:07:55 +0200
Message-ID: <87fwa7ha5w.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> They do change some other things, though. In particular, I mislike the
> last patch in that series ("vfs: retry last component if opening stale
> dentry"), which does the whole "save_parent" thing. There's a few
> things that look odd there, and I don't like this code, for example:
> 
> +               save_parent.dentry = nd->path.dentry;
> +               save_parent.mnt = mntget(path->mnt);
> +               nd->path.dentry = path->dentry;
> ...
> +               path_put(&save_parent);
> 
> whete there isn't a dget() on the dentry (but path_put() will do a
> dput() on it). I'm guessing it's because we lose a refcount to it when
> we overwrite nd->path.dentry, but why isn't there a dget() on *that*
> one? The patch just makes me nervous. Miklos, can you explain more?
> The interactions with "path_put_conditional()" makes me extra nervous.

Yeah, see the comment in below patch for how it's supposed to work.  I
*think* it's correct.

Thanks,
Miklos


Subject: vfs: add comment to save_parent
From: Miklos Szeredi <mszeredi@suse.cz>

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namei.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2012-06-05 19:29:39.000000000 +0200
+++ linux-2.6/fs/namei.c	2012-06-07 08:41:55.000000000 +0200
@@ -2355,6 +2355,16 @@ static struct file *do_last(struct namei
 	if ((nd->flags & LOOKUP_RCU) || nd->path.mnt != path->mnt) {
 		path_to_nameidata(path, nd);
 	} else {
+		/*
+		 * We are not in RCU mode and nd->path.mnt == path->mnt.
+		 * In that case path_to_nameidata() would just do
+		 *
+		 * 	dput(nd->path.dentry)
+		 *	nd->path.dentry = path->dentry;
+		 *
+		 * So here we can save a dget/dput pair by just transferring the
+		 * ref to save_parent.dentry.
+		 */
 		save_parent.dentry = nd->path.dentry;
 		save_parent.mnt = mntget(path->mnt);
 		nd->path.dentry = path->dentry;
