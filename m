Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab1LGAQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:16:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37729 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1LGAQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:16:47 -0500
Date: Wed, 7 Dec 2011 00:16:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207001643.GN2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk>
 <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
 <20111206205346.GK2203@ZenIV.linux.org.uk>
 <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com>
 <20111206224100.GM2203@ZenIV.linux.org.uk>
 <4EDEA152.90804@canonical.com>
 <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 03:45:15PM -0800, Linus Torvalds wrote:
> How about this change:
>  - don't change 'root' (and mark it const)
>  - if we hit the expected root, we're all happy and do what we do now
>  - if we hit some *unexpected* root (the "global root") add a '?' or
> something at the head of the path.
> 
> End result: callers like getcwd() can trivially replace their current
> "path_equal(&tmp,&root)" (or whatever they do) with just checking the
> first character of the end result. A good path always starts with '/'.

You get broken /proc/self/mountinfo for chrooted processes with that patch.
You also get /proc/mounts contents change for the same.

Moreover, while we _probably_ can get away with that "prepend '?'",
we'll need to make sure that all checks are comparing with '?', _not_
with '/', or you'll get nasty surprises when __d_path() gets called
on e.g. pipe dentry (pipe:[...]).  And while we are at it, we'd better
document that "->d_dname() should never use '?' as the first character"
restriction we've got.

I don't know... playing with magical substrings in what it returns is,
IMO, a bad idea.  I really wonder if we'd be better off with just
this:
	__d_path(path, root, buf, buflen) - expects non-NULL in
root->mnt, never changes root, returns NULL if path is not under root
	d_absolute_path(path, ancestor, buf, buflen) - grabs the
reference to the most remote ancestor it can find, puts pathname
into buf, never returns NULL.

Let tomoyo use that one and path_put(ancestor) afterwards (or look at
it first, if it cares).  And let apparmor do the following:
	* first call __d_path(), unless asked not to.  If it returns
non-NULL, great we've got that path, game over.  Otherwise call
d_absolute_path() and log that partial pathname, check where we'd got,
etc.  Just remember to path_put(ancestor) after that.

We are trying to shove two different things in one function and result
is ugly; so let's just split it instead of trying to breed weird
hybrids.

Comments?
