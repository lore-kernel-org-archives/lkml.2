Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1LFVl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:41:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40651 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab1LFVl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:41:27 -0500
Date: Tue, 6 Dec 2011 21:41:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111206214126.GL2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk>
 <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
 <20111206205346.GK2203@ZenIV.linux.org.uk>
 <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 01:07:56PM -0800, Linus Torvalds wrote:
> On Tue, Dec 6, 2011 at 12:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > The trouble is, might very well stop *NOT* at the global root. ?Consider
> > a race with umount -l; we have no way to tell "it had been outside of
> > chroot jail" from "it had walked up to the place where ->mnt_parent had
> > been already reset, sorry, no idea what it was".
> 
> Sure, but you made that case return NULL already as part of the "no
> bastard" case, didn't you?
> 
> That part of the patch looked fine.
> 
> It was just the extra convolutions around 'bastard' that seemed to be
> over-designed, and made for just a single use that seems very
> peripheral anyway.
> 
> Apart from AppArmor, afaik nobody even really cared where they ended
> up, and even AppArmor really didn't want to know - it just had this
> totally crazy special case about "/sys".

It's not /sys, actually, it's implicit /proc/sys/something from sysctl() ;-/

Hell knows.  Frankly, the whole "let's build a pathname and decide basing
on it" thing had been insane from the very beginning.  For many reasons,
starting with "pathname in which namespace?" and continuing through "who said
that it still means what it used to at the moment of operation" to "what
if it's not a part of any namespace anymore/had never been in one".

Hey, it wasn't me who insisted that pathname-based stuff made any sense
whatsoever...  But "path to the nearest thing that has no ancestor now"
is _meaningless_ if we know nothing about that ancestor.  Cases include
	* that ancestor is the root of our namespace.
	* that ancestor is a solitary vfsmount we'd started in, never had
been mounted in any namespace (e.g. procfs internal vfsmount, etc.)
	* that ancestor is a random vfsmount in a subtree that had been
hit by umount -l, just as we'd been looking at it.  Might be its root,
might be equal to path->mnt, might be something in between.
	* cases 1 and 3 in another process' namespace

In case 3 and analogs the path we'd obtained is pure junk, so I can agree
with "let's just return NULL on those".  The trouble is, how do you tell
(3) from (2)?  And do we want (1)-not-our-namespace to be distinguished
from (1)-our-namespace?
