Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1LFUxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:53:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52153 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab1LFUxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:53:48 -0500
Date: Tue, 6 Dec 2011 20:53:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111206205346.GK2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk>
 <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:54:16AM -0800, Linus Torvalds wrote:
> Is AA *worth* that special case? Does it even care that deeply?
> 
> So my argument is that I think your change to make 'root' const an
> dnot be changed is good, and should stay. But 'bastard' should just go
> away, amusingly named or not. All sane callers already call it with a
> NULL pointer. The one case that doesn't isn't worth worrying about,
> and should strive to solve its problems some saner way.
> 
> John explicitly cc'd, since he's the one that would have to figure out
> that /sys special case. Is it possible that just calling __d_path()
> with the global system root would be sufficient for apparmor in this
> case to figure out the /sys part?

The trouble is, might very well stop *NOT* at the global root.  Consider
a race with umount -l; we have no way to tell "it had been outside of
chroot jail" from "it had walked up to the place where ->mnt_parent had
been already reset, sorry, no idea what it was".

That's why __d_path() modifying root had been asking for trouble (besides
being in bad taste); the really are situations when it's very tempting
to look at the place where it had stopped.

Hell knows...  We definitely want to be able to distinguish global roots from
detached vfsmounts.  We _might_ want to distinguish the root of our namespace
from those of others, but I'm less sure about that.

And we don't have a lot of channels for returning extra information, short
of passing a pointer to store it in.  In which case we might bloody well
return the entire vfsmount/dentry pair and let the caller sort it out.

Don't get me wrong, I'm not particulary enthusiastic about that variant;
it's just that I don't see an alternative that would be any better.  I mean,
__d_path(path, root, buf, buflen, &enum_what_kind_of_place_have_I_ended_up_in)?
Can be done, but that'll be just as ugly *and* we'll end up with a growing
zoo of those "kinds" over the next few years... ;-/
