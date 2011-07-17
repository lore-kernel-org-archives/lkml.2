Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1GQXQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:16:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34636 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1GQXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:16:16 -0400
Date: Mon, 18 Jul 2011 00:16:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110717231610.GR11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 03:00:06PM -0700, Linus Torvalds wrote:

> Yes. However, looking at it, I'm not very happy with your patch. It
> doesn't really make sense to me to special-case the NULL inode and
> only do a seq_retry for that case.
> 
> I kind of see why you do it for that particular bug, but at the same
> time, it just makes me go "Eww". If that inode isn't NULL yet, you
> then return the dentry that can get a NULL d_inode later. So the only
> special thing there is that we happen to check for a NULL inode there.
> What protects *later* checks for a NULL d_inode?
> 
> So my gut feel is that we should instead
> 
>  - either remove the -ENOENT return at that point entirely, and move
> it to after we have re-verified the dentry lookup for other reasons.
> That looks pretty involved, though, and those paths do end up
> accessing inode data structures etc, so it looks less than trivial.
> 
> OR
> 
>  - simply just not clear d_inode at all in d_kill(), so that when we
> prune a dentry due to memory pressure, it doesn't actually change the
> state of the dentry.

OR

 - keep part of the patch from Hugh, treating negative in RCU mode as
"need to unlazy".  Leaving everything else as-is.  Normally we'll
confirm that sucker is negative and that'll be it.  Or we'll see that
it's being evicted and fall back to non-lazy mode, which is what we'll
need to do anyway.  IOW, this:

diff --git a/fs/namei.c b/fs/namei.c
index 5c867dd..48a38de 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1171,6 +1171,8 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 		path->dentry = dentry;
 		if (unlikely(!__follow_mount_rcu(nd, path, inode)))
 			goto unlazy;
+		if (unlikely(!*inode))
+			goto unlazy;
 		if (unlikely(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT))
 			goto unlazy;
 		return 0;
