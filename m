Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1LGCR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:17:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57946 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1LGCRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:17:24 -0500
Date: Wed, 7 Dec 2011 02:17:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207021721.GV2203@ZenIV.linux.org.uk>
References: <4EDE94DC.8010106@canonical.com>
 <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
 <CA+55aFzEE+qoRsiSQt7PecvS+hhnMRT9ytsRQKcBrjTQFg9kPg@mail.gmail.com>
 <20111207005253.GP2203@ZenIV.linux.org.uk>
 <CA+55aFxzZOL_TgQSvCUBNsm8OjR_UDHADL=bBeLe-xJ=3PsNhg@mail.gmail.com>
 <20111207012318.GR2203@ZenIV.linux.org.uk>
 <CA+55aFzz7M=SoPwzACxQK+mc8BZRHy03z-T-Q_4mmcCQ0YhtJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzz7M=SoPwzACxQK+mc8BZRHy03z-T-Q_4mmcCQ0YhtJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 06:02:22PM -0800, Linus Torvalds wrote:
> You are the only one who seems to think that it matters. No code
> agrees with you except for the clearly broken AppArmor code that
> everybody agrees should just go the f*ck away.
> 
> > See what I'm talking about? ?I'm fine with giving the pathname to global
> > root. ?It's doing that to *random* just-unmounted vfsmount that is not
> > a good thing.
> 
> It *never* matters. The pathname should never be used at all.
> 
> We want to *see* what the pathname is, but no code should ever use it.
> 
> The *only* valid use for the broken pathname is for a "show user debug
> information". That's all I've ever claimed. The "where it was mounted
> - or *if* it was mounted" part is pointless.

Sigh...  OK, let's leave that.  I'm not saying that any code uses that
information - in fact, if you look at the last patch I've posted, nothing
(including apparmor) does.  I have a problem with wildly racy debug info
randomly intermixed with reliable one, but in the end it doesn't matter.

Could you look at that patch and comment on it, on its merits alone?
What's done there:
	* prepend_path() root argument becomes const.  I think everyone
agrees with that.
	* __d_path() is never called with NULL/NULL root.  It was a kludge
to start with.  Instead, we have an explicit function - d_absolute_root().
Same as __d_path(), except that it doesn't get root passed and stops where
it stops.  apparmor and tomoyo are using it.
	* __d_path() returns NULL on path outside of root.  The main
caller is show_mountinfo() and that's precisely what we pass root for - to
skip those outside chroot jail.  Those who don't want that can (and do)
use d_path().
	* __d_path() root argument becomes const.  Everyone agrees, I hope.
	* apparmor does *NOT* try to use __d_path() or any of its variants
when it sees that path->mnt is an internal vfsmount.  In that case it's
definitely not mounted anywhere and dentry_path() is exactly what we want
there.  Handling of sysctl()-triggered weirdness is moved to that place.
	* if apparmor is asked to do pathname relative to chroot jail
and __d_path() tells it we it's not in that jail, the sucker just calls
d_absolute_path() instead.  That's the other remaining caller of __d_path(),
BTW.

Are you OK with the above?
