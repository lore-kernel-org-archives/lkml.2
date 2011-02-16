Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab1BPQTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:19:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51294 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BPQTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:19:31 -0500
Date: Wed, 16 Feb 2011 16:19:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc5
Message-ID: <20110216161929.GF22723@ZenIV.linux.org.uk>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
 <1297854842.3201.197.camel@edumazet-laptop>
 <AANLkTimnLPF0wz+ya-Wj1U1hQjPJpUhmL893OxBWqZYM@mail.gmail.com>
 <20110216160643.GE22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216160643.GE22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 04:06:43PM +0000, Al Viro wrote:

> Sigh...  I see what's going on.  We'd got inode from dentry that is getting
> crapped under us.  We will *not* survive dropping RCU - it's bad enough for
> full restart in normal mode.  So right after we'd seen that (already wrong)
> inode has ->follow_link(), we decide to drop RCU.  Originally this BUG_ON
> hadn't been reached in that case - we had already failed with -ECHILD before
> we got to it.  Now we don't...
> 
> _However_, I don't like passing inode to do_follow_link().  I'd rather set
> nd->inode to inode first and use it there.  Let me think a bit and see if
> it's feasible...

No, that won't do.  The damn thing uses previous value of nd->inode if
it walks into relative symlink...

	Let's shift that call of nameidata_dentry_drop_rcu_maybe() into both
callers of do_follow_link() instead.  Marginally less obvious that we won't
reach the guts of do_follow_link() in RCU mode, just as obvious that overall
structure is ugly as hell and avoids making it even uglier by passing inode
down there.  How about this:

diff --git a/fs/namei.c b/fs/namei.c
index 9e701e2..d7003cf 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -800,10 +800,6 @@ static inline int do_follow_link(struct path *path, struct nameidata *nd)
 	void *cookie;
 	int err = -ELOOP;
 
-	/* We drop rcu-walk here */
-	if (nameidata_dentry_drop_rcu_maybe(nd, path->dentry))
-		return -ECHILD;
-
 	if (current->link_count >= MAX_NESTED_LINKS)
 		goto loop;
 	if (current->total_link_count >= 40)
@@ -1413,6 +1409,9 @@ exec_again:
 			goto out_dput;
 
 		if (inode->i_op->follow_link) {
+			/* We drop rcu-walk here */
+			if (nameidata_dentry_drop_rcu_maybe(nd, next.dentry))
+				return -ECHILD;
 			BUG_ON(inode != next.dentry->d_inode);
 			err = do_follow_link(&next, nd);
 			if (err)
@@ -1458,6 +1457,8 @@ last_component:
 			break;
 		if (inode && unlikely(inode->i_op->follow_link) &&
 		    (lookup_flags & LOOKUP_FOLLOW)) {
+			if (nameidata_dentry_drop_rcu_maybe(nd, next.dentry))
+				return -ECHILD;
 			BUG_ON(inode != next.dentry->d_inode);
 			err = do_follow_link(&next, nd);
 			if (err)
