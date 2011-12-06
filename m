Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1LFWlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:41:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42811 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab1LFWlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:41:05 -0500
Date: Tue, 6 Dec 2011 22:41:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John Johansen <john.johansen@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111206224100.GM2203@ZenIV.linux.org.uk>
References: <20111206154854.GH2203@ZenIV.linux.org.uk>
 <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com>
 <20111206205346.GK2203@ZenIV.linux.org.uk>
 <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com>
 <4EDE94DC.8010106@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDE94DC.8010106@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 02:19:08PM -0800, John Johansen wrote:
> On 12/06/2011 01:07 PM, Linus Torvalds wrote:
> > On Tue, Dec 6, 2011 at 12:53 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >>
> >> The trouble is, might very well stop *NOT* at the global root.  Consider
> >> a race with umount -l; we have no way to tell "it had been outside of
> >> chroot jail" from "it had walked up to the place where ->mnt_parent had
> >> been already reset, sorry, no idea what it was".
> > 
> > Sure, but you made that case return NULL already as part of the "no
> > bastard" case, didn't you?
> > 
> > That part of the patch looked fine.
> > 
> > It was just the extra convolutions around 'bastard' that seemed to be
> > over-designed, and made for just a single use that seems very
> > peripheral anyway.
> > 
> it is, and the plan is to not need the bastard even.  What apparmor should
> be doing is lazy labeling the live objects, and anything that is disconnected
> is evaluated based on the previous labeling.

I still don't understand how you deal with objects seen by processes in
different namespaces.  Please, explain lazy labeling in details...

You do realize that there's no hope whatsoever for prohibiting access
to struct file opened in parent's namespace and already written into
there, right?

> This will also remove its
> use of passing root = { NULL, NULL } to __d_path.

One word: tomoyo...  You are not the only weird one.  They want an absolute
pathname and don't care about races with umount.  Whatever it's relative
to, the thing just goes ahead and plays with itse^Wthe string it got.  As
long as they are not dereferencing pointers to free objects, I Don't Want To
Know(tm).

> Right now we could drop the bastard parameter and passing root = { NULL, NULL }

OK, please tell me what do you need from __d_path().  Suppose it has missed
the supplied root; what do you want to know about the place it had stopped
in?  If we don't do extra arguments, we are limited by this:
	* some condition is checked by __d_path(); if it's satisfied,
pointer to relative pathname (based hell-knows-where) is returned as
usual; we *can't* tell that from normal "reached root, here's your
pathname" case.
	* if it isn't satisfied, we return NULL.  No relative pathname
to look at, etc.

Unless you are OK with what __d_path(path, root, NULL, buf, buflen) is doing
with this patch, we'd need to split it; seq_path_root()/show_mountinfo()
requirements leave no wiggling space for case root->mnt != NULL,
bastard == NULL.
