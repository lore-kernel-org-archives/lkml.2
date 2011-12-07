Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab1LGFTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 00:19:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46033 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab1LGFTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 00:19:10 -0500
Date: Wed, 7 Dec 2011 05:19:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207051908.GA2203@ZenIV.linux.org.uk>
References: <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
 <20111207003922.GO2203@ZenIV.linux.org.uk>
 <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
 <20111207011047.GQ2203@ZenIV.linux.org.uk>
 <20111207013720.GS2203@ZenIV.linux.org.uk>
 <201112070326.pB73QPZo042162@www262.sakura.ne.jp>
 <20111207034238.GX2203@ZenIV.linux.org.uk>
 <201112070501.pB751LoP064331@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112070501.pB751LoP064331@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 02:01:21PM +0900, Tetsuo Handa wrote:
> Al Viro wrote:
> > > How commonly can conditions that make d_absolute_path() return -EINVAL happen?
> > 
> > Race with umount -l, basically.
> 
> d_absolute_path() will return -EINVAL if lazy unmount happens. I see.
> 
> Then, I prefer not denying the request with -EINVAL no matter how unreliable
> the returned pathname is. I don't want to deny the request unless -ENOMEM
> happens or rejected by the policy.
> 
> > In that case the pathname is completely
> > unreliable - if I do umount -l /mnt, pathnames that would be under mnt
> > may get truncated on *ANY* mountpoint.  Not "always cut on /mnt"; not "always
> > cut on the last mountpoint"; it's "everything from root to arbitrary mountpoint
> > on that path is not noticed".
> 
> Unfortunate specification for pathname based access control.
> But since I assume that multiple LSM modules can run in parallel
> ( http://sourceforge.jp/projects/tomoyo/docs/lca2009-kumaneko.pdf),
> I leave more stricter decisions to inode based access control.
> 
> So, can we keep behavior of tomoyo_get_absolute_path() unchanged?

Sure, you are always free to add
	if (pos == ERR_PTR(-EINVAL)) {
		pos = dentry_path(path->dentry, ...)
		/* do whatever you want to buffer to indicate that
		 * beginning had been lost
		 */
	}
since that's the _only_ reliable part of pathname information there is in
such situation.  What should be done to buffer contents is *really* up
to you - what you have there is the path from the root of filesystem path
points to and to path->dentry.  Beginning *is* lost; the thing had been
unmounted and this is all you have.

Or you might want to do __d_path() from (path->mnt,path->mnt->mnt_root) to
path - that's the path from the last mountpoint to your object; i.e. it may
be shorter if that vfsmount had been a binding into the guts of filesystem,
but that is what __d_path() as you used it would stabilize to once the race
window is over.

Again, that's what happens if you are hit with umount and there is *no*
absolute path anymore.  What should be done in such situation is really
up to you - as far as I'm concerned, those races are among the reasons why
pathname-based MAC is a fundamentally wrong idea.
