Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1LGC3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 21:29:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63606 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab1LGC32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 21:29:28 -0500
MIME-Version: 1.0
In-Reply-To: <20111207021721.GV2203@ZenIV.linux.org.uk>
References: <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk> <CA+55aFzEE+qoRsiSQt7PecvS+hhnMRT9ytsRQKcBrjTQFg9kPg@mail.gmail.com>
 <20111207005253.GP2203@ZenIV.linux.org.uk> <CA+55aFxzZOL_TgQSvCUBNsm8OjR_UDHADL=bBeLe-xJ=3PsNhg@mail.gmail.com>
 <20111207012318.GR2203@ZenIV.linux.org.uk> <CA+55aFzz7M=SoPwzACxQK+mc8BZRHy03z-T-Q_4mmcCQ0YhtJg@mail.gmail.com>
 <20111207021721.GV2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 18:29:06 -0800
X-Google-Sender-Auth: -_bgfhomJB4OvECTqTMwPzQhvc8
Message-ID: <CA+55aFzjxLKk=qGdQ_g1o515wGaCnyEHDiswv7rXCw4aaem85A@mail.gmail.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 6:17 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Could you look at that patch and comment on it, on its merits alone?
> What's done there:
>        * prepend_path() root argument becomes const.  I think everyone
> agrees with that.

So I like your prepend_path() changes. Returning the status of the
thing as a positive number looks good, and you never lose any
information.

In some ways, I'd prefer to make "prepend_path()" the "real"
interface, but whatever.

>        * __d_path() is never called with NULL/NULL root.  It was a kludge
> to start with.  Instead, we have an explicit function - d_absolute_root().
> Same as __d_path(), except that it doesn't get root passed and stops where
> it stops.  apparmor and tomoyo are using it.

Again, my only real complaint about this is that you are trying too
hard to pander to crazy users, but I have no complaints about the code
itself any more. In this form, the patch looks fine, now it's just the
*callers* that are insane.

>        * __d_path() returns NULL on path outside of root.  The main
> caller is show_mountinfo() and that's precisely what we pass root for - to
> skip those outside chroot jail.  Those who don't want that can (and do)
> use d_path().

Looks fine.

>        * __d_path() root argument becomes const.  Everyone agrees, I hope.

Absolutely.

>        * apparmor does *NOT* try to use __d_path() or any of its variants
> when it sees that path->mnt is an internal vfsmount.  In that case it's
> definitely not mounted anywhere and dentry_path() is exactly what we want
> there.  Handling of sysctl()-triggered weirdness is moved to that place.

So I think this crazy code should just be deleted, but whatever. At
least now it's fairly well insulated, and now it's "Apparmor crazy
code" rather than "VFS layer crazy code", which makes it a lot more
palatable to me from a maintenance standpoint.

Crazy security policies are almost par for the course. Crazy VFS layer
functions I get upset about.

>        * if apparmor is asked to do pathname relative to chroot jail
> and __d_path() tells it we it's not in that jail, the sucker just calls
> d_absolute_path() instead.  That's the other remaining caller of __d_path(),
> BTW.

Again, I'm not convinced that is actually a sane security model, and
I'd really hope that code just goes away or gets handled totally
differently. But again, at least now it's "internal to apparmor"
craziness, and as such not as horrible at all.

> Are you OK with the above?

Yes.

                     Linus
