Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab1LGGy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:54:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50045 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1LGGy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:54:58 -0500
Date: Wed, 7 Dec 2011 06:54:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207065437.GB2203@ZenIV.linux.org.uk>
References: <20111207001643.GN2203@ZenIV.linux.org.uk>
 <20111207003922.GO2203@ZenIV.linux.org.uk>
 <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
 <20111207011047.GQ2203@ZenIV.linux.org.uk>
 <20111207013720.GS2203@ZenIV.linux.org.uk>
 <201112070326.pB73QPZo042162@www262.sakura.ne.jp>
 <20111207034238.GX2203@ZenIV.linux.org.uk>
 <201112070501.pB751LoP064331@www262.sakura.ne.jp>
 <20111207051908.GA2203@ZenIV.linux.org.uk>
 <201112070544.pB75iX12072157@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112070544.pB75iX12072157@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 02:44:33PM +0900, Tetsuo Handa wrote:

> Excuse me, what "once the race window is over" means?
> Does
> 
>   do {
>     pos = d_absolute_path(path, buffer, buflen - 1);
>   } while (pos == ERR_PTR(-EINVAL));
> 
> work (i.e. racing with "umount -l" is a temporary failure)?

I said "what your original use of __d_path() would stabilize to".  IOW,
that's what you'd get after all ->mnt_parent in the chain are killed
by release_mounts().  And no, since the moment that release_mounts()
started there was *no* *absolute* *path* *at* *all*.

>From that moment on, the point you are looking at is not connected to any
global root.  Or to anything still mounted, of course.  What changes is
how little of what used to be the path to root remains; very shortly
it's down to just path->mnt not connected to *anything*.  __d_path() call
as you have it in the current tree will report the remaining (shrinking)
part of path, eventually settling to just the part from path->mnt->root
to path->dentry.  d_absolute_path() will be giving you ERR_PTR(-EINVAL)
all along; the thing it is supposed to give you does not exist anymore.

Racing with umount -l is temporary in a sense that as soon as a vfsmount
detached by umount -l ceases being busy, it gets killed.  If you stand
there, holding a reference and looking for a path connecting it to something
mounted, well... (a) such path won't appear and (b) vfsmount will remain
busy for as long as you are holding that reference...

The real question is what pathname do you _want_ in this situation.  Define
that and we'll be able to do something about it; if you really are asking
for "whatever this code used to do, modulo races", then what you want is
	if (pos == ERR_PTR(-EINVAL)) {
		/* it got unmounted; just report what's left and be quiet */
		struct path root = {path->mnt, path->mnt->root};
		pos = __d_path(path, &root, buf, buflen - 1);
		if (!pos) /* it's really, *REALLY* screwed up somehow */
			return ERR_PTR(-EINVAL);
	}
and that's it.  But at that point I would start seriously thinking about the
usefulness of checks done on that tail of pathname, false negatives, etc.

We could, I guess, make d_absolute_path() do just that on such paths as an
automatic fallback [1].  apparmor's use of our_mnt(path->mnt) would've caught
those, so we are not introducing false negatives there.

However, I *really* wonder if that's the right thing to do in any sense.
BTW, what your current code does if you have a file bound on another
file, open it, umount -l it, let the dust settle and then do some operation
that triggers tomoyo_get_absolute_path() on it?  Because you'll be getting
a vfsmount/dentry pair that has
	* dentry == vfsmount->mnt_root
	* vfsmount->mnt_parent == vfsmount
	* dentry->d_inode being a non-directory
and there is nothing whatsoever in what remains of the pathname.  Not a single
component.  IOW, you'll get "/" in buf.  Might be good in a testsuite - is
there any code in security/tomoyo that would be relying on assumption that
only directory might have a name entirely without components?
