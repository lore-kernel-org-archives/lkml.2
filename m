Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1LGAkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:40:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55417 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab1LGAkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:40:03 -0500
MIME-Version: 1.0
In-Reply-To: <20111207001643.GN2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk> <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
 <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Dec 2011 16:39:40 -0800
X-Google-Sender-Auth: vZCxp9sLaaCzDtJJp2xCMTJKWoY
Message-ID: <CA+55aFzEE+qoRsiSQt7PecvS+hhnMRT9ytsRQKcBrjTQFg9kPg@mail.gmail.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 4:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> You get broken /proc/self/mountinfo for chrooted processes with that patch.
> You also get /proc/mounts contents change for the same.

I have no objections to your

+		if (!p)
+			return SEQ_SKIP;

part of the patch, although it would just become "if (*p == '?')" in my version.

It's the "bastard" thing I dislike, because I don't think there
could/should *ever* be any valid use of that interface. The one user
(AppArmor) was just broken.

And no, I'm not married to the '?' either. I do think that giving
*some* value for the broken case is quite healthy, because it allows
debug output (as in "I'm giving you this path, but I know it's crap")

> I don't know... playing with magical substrings in what it returns is,
> IMO, a bad idea.  I really wonder if we'd be better off with just
> this:
>        __d_path(path, root, buf, buflen) - expects non-NULL in
> root->mnt, never changes root, returns NULL if path is not under root

I'm ok with that. *Most* users want that.

I suspect some users really might want a path for debugging, though.

>        d_absolute_path(path, ancestor, buf, buflen) - grabs the
> reference to the most remote ancestor it can find, puts pathname
> into buf, never returns NULL.

But why do you want that ancestor thing?

Nobody *ever* wants the ancestor. Even AppArmor didn't really want it,
it's just being terminally confused.

Even the thing that AppArmor actually checks ("is the ancestor in
/proc/sys") is totally broken. It doesn't even *work*. It's entirely
possible that /proc/sys was unmounted, but it's also possible that
it's mounted outside of the root, and then the ancestor is something
totally different. Testing the ancestor is *crazy*. Even *asking* for
it is a sign of terminal confusion. It's useless. It's meaningless.

So stop doing it. It doesn't become any better from having been
renamed "ancestor" instead of "bastard". The concept is broken and
wrong.

The "deepest ancestor I can reach" is simply not useful information.
Any user is broken by design. It cannot work.

So any interface that returns that ancestor/bastard is simply wrong.

                     Linus
