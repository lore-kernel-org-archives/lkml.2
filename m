Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1LGDmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 22:42:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35733 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab1LGDmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 22:42:39 -0500
Date: Wed, 7 Dec 2011 03:42:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207034238.GX2203@ZenIV.linux.org.uk>
References: <4EDE94DC.8010106@canonical.com>
 <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
 <20111207003922.GO2203@ZenIV.linux.org.uk>
 <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
 <20111207011047.GQ2203@ZenIV.linux.org.uk>
 <20111207013720.GS2203@ZenIV.linux.org.uk>
 <201112070326.pB73QPZo042162@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112070326.pB73QPZo042162@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 12:26:25PM +0900, Tetsuo Handa wrote:
> >         char *pos = ERR_PTR(-ENOMEM);
> >         if (buflen >= 256) {
> > -               struct path ns_root = { };
> >                 /* go to whatever namespace root we are under */
> > -               pos = __d_path(path, &ns_root, buffer, buflen - 1);
> > +               pos = d_absolute_path(path, buffer, buflen - 1);
> >                 if (!IS_ERR(pos) && *pos == '/' && pos[1]) {
> >                         struct inode *inode = path->dentry->d_inode;
> >                         if (inode && S_ISDIR(inode->i_mode)) {
> 
> Currently, TOMOYO assumes that -ENAMETOOLONG is the only error which __d_path()
> might return (and retries with larger buffer size unless kmalloc() fails).
> If d_absolute_path() starts returning -EINVAL, TOMOYO will deny requests even
> if "partial (I mean the result would have been different if reachable)"
> pathname is granted by the policy.
> 
> How commonly can conditions that make d_absolute_path() return -EINVAL happen?

Race with umount -l, basically.  In that case the pathname is completely
unreliable - if I do umount -l /mnt, pathnames that would be under mnt
may get truncated on *ANY* mountpoint.  Not "always cut on /mnt"; not "always
cut on the last mountpoint"; it's "everything from root to arbitrary mountpoint
on that path is not noticed".  If your policy really has to deal with such
situations (unexpected umount -l racing with operations in the subtree that
gets dissolved), you do have a problem.  Right now, in the mainline kernel.
Because the pathname you are currently getting is unreliable as hell and
making any decisions basing on it is, er, not particulary wise.

If you want to add handling of that -EINVAL in some form, feel free.  But
keep in mind that the *ONLY* part of pathname you can really recover at
that point is what dentry_path() would give you - i.e. from fs root to
object in question.  Everything prior to that is absolutely unreliable
and is bound to go away in a very short while - ->mnt_parent on the entire
chain is in process of being dissolved when we hit that race.
