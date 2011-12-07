Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1LGAw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:52:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45082 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab1LGAw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:52:57 -0500
Date: Wed, 7 Dec 2011 00:52:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207005253.GP2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk>
 <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
 <20111206205346.GK2203@ZenIV.linux.org.uk>
 <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com>
 <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
 <20111207001643.GN2203@ZenIV.linux.org.uk>
 <CA+55aFzEE+qoRsiSQt7PecvS+hhnMRT9ytsRQKcBrjTQFg9kPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzEE+qoRsiSQt7PecvS+hhnMRT9ytsRQKcBrjTQFg9kPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 04:39:40PM -0800, Linus Torvalds wrote:
> I suspect some users really might want a path for debugging, though.
> 
> > ? ? ? ?d_absolute_path(path, ancestor, buf, buflen) - grabs the
> > reference to the most remote ancestor it can find, puts pathname
> > into buf, never returns NULL.
> 
> But why do you want that ancestor thing?

Because the path is useless without some idea where it starts?
"It was /foo/bar/baz counting from some point; might have
been global root, might have been any random mountpoint if we'd
raced with umount and you've got no way to tell one from another"
is not particulary useful in logs.

The thing is, on the next boot exact same line might grow or lose
a prefix.  Randomness of that kind is OK if you know that the
pathname is just the best-effort thing here and you *always*
end up guessing which one it was.  But here most of the real-world
cases will have them relative to absolute root and stable.  That's
a really ugly combination - something that works most of the time
until you hit a race.  Then, without any notice, you need to
guess that _this_ time have to go looking for what that pathname
might have been appended to...  Not fun.
