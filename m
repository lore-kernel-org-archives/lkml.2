Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1LGBKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:10:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33241 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab1LGBKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:10:49 -0500
Date: Wed, 7 Dec 2011 01:10:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207011047.GQ2203@ZenIV.linux.org.uk>
References: <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
 <20111206205346.GK2203@ZenIV.linux.org.uk>
 <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com>
 <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
 <20111207003922.GO2203@ZenIV.linux.org.uk>
 <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 04:42:00PM -0800, Linus Torvalds wrote:

> This part is still just pure and utter sh*t.
> 
> You have not explained why that information is *ever* valid. And I
> claim it isn't.
> 
> We have a bug in our current __d_path(). And I claim that the
> underlying cause of the bug is the crazy "let's return this
> nonsensical and idiotic information that cannot possibly make sense to
> anybody".
> 
> We shouldn't have done that in the first place. And we certainly
> shouldn't *continue* doing that.

Sigh...  This is what it boils down to: there are 3 very different cases -
we'd walked to a global root, we'd raced with umount and we are someplace
never mounted at all.  Case 1 is fine; if apparmor cares whose namespace
it is, it can bloody well check path->mnt itself.  Case 2 is one where
I think that returning pathname does more damage than good; it's really
random in that case and returning NULL is the best thing we can do.
So far, so good, and we don't need to return *any* references to vfsmounts.

Unfortunately, there's also case 3.  Internal vfsmounts.  And that's where
it hits the fan.  Oh, wait...

Guys, I think I know how to deal with that crap.  We *CAN* recognize
internal vfsmounts just fine.  It's right there in ->mnt_flags.  And
in that case bothering with __d_path() and correcting it post-factum is
just plain wrong.

So let's add d_absolute_path(path, buf, buflen).  Having it check that
we'd walked to something mounted.  And returning NULL otherwise.  _Never_
mangle the pathname; replace that procfs weirdness in apparmor with
"Is our path on internal vfsmount?  If so, use dentry_path() on dentry
part and slap /proc/ in front if it was procfs" and that's it.
