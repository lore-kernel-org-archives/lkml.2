Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab1GRBNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 21:13:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28557 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab1GRBNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 21:13:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=i3YzarFBDti0SKWpE9cflQHtVvOIpFhr+vU3yc67SjVVlOcQG4UL3yQaFR3nbPcwo
	ng0tzQdPyKf1Q4MoZFU4w==
Date: Sun, 17 Jul 2011 18:13:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
In-Reply-To: <20110718002524.GU11013@ZenIV.linux.org.uk>
Message-ID: <alpine.LSU.2.00.1107171740260.1327@sister.anvils>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils> <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com> <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, Al Viro wrote:
> On Sun, Jul 17, 2011 at 04:47:45PM -0700, Hugh Dickins wrote:
> > On Sun, 17 Jul 2011, Linus Torvalds wrote:
> > > On Sun, Jul 17, 2011 at 4:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > >
> > > > OR
> > > >
> > > > ?- keep part of the patch from Hugh, treating negative in RCU mode as
> > > > "need to unlazy".
> > > 
> > > No, urgh, that's horrible.
> > > 
> > > Not being able to do an RCU lookup of negative dentries would be
> > > really sad. There are some loads where a negative dentry is the
> > > *common* case.
> > 
> > Yes, that worried me too.
> 
> Grr...  What do you think we need to do when we find a negative dentry in
> RCU lookup?  We can
> 	* check its ->d_seq, to see if it's valid
> 	* somehow (e.g. with what Linus suggested) try to walk further and
> leave staleness checks for dentries we would encounter later in the walk.
> 
> If it's in the end of pathname, there is no choice at all - we need to
> check ->d_seq of this one.  Right?

Do we?

> And we do exactly that.  If we see
> that it's for real, fine we got ourselves a reference to negative dentry

Where do we get a reference to the negative dentry?  I thought
walk_component() was just terminating the walk and failing with -ENOENT.

> and can go ahead.  If it's something like stat(2), we'll just do dput()
> and bugger off.  Refcounts of everything on the path to it are unaffected,
> no global locks played with...
> 
> If it's in the middle of pathname, we could try to delay the check.  And
> what would it buy us?  If that dentry was stale, we'd just walk a bit
> deeper.  And found a stale one at some later point.  And restarted pathname
> resolution in non-lazy mode from the very beginning.  If it wasn't stale
> (i.e. real negative dentry), we *do* want -ENOENT and we'll get it as soon
> as unlazy_walk() will check ->d_seq and we plod through the rest of
> do_lookup() to check in walk_component().  We won't redo d_lookup(), lock
> i_mutex, etc.

Sorry, I still don't get it.

I can see that Linus's minus-1-liner to the pruning end might lead
do_lookup() one step deeper into the mire if there's a race, because
there's no NULL-d_inode advance warning; but I don't see that race
as a case we need to optimize for.

And in the genuine negative dentry case: at present (with or without
my or Linus's patches) there is no final nd->seq check, is there?

Having found a negative dentry, we just get out at that point with
-ENOENT.  Now, it's true that there might be a race in which the
negative dentry is being made positive just as we're getting out;
but since we're not digging in any deeper, that seems to me just
a natural inevitable race, nothing to be guarded against.

Whereas your "if (!*inode) goto unlazy;" is adding an additional
sequence check, isn't it?  Is that a race you see as important?
If so, it is a different matter than I was ever considering.

Or am I looking in the wrong place, focussing on walk_component()
where my -ENOENT came from, and should be looking somewhere else?
I've not looked to see where a negative dentry is made positive.

And your two patches are not mutually exclusive: we could use
both of them together if there's good reason (I like Linus's
argument that pruning is wrong to make dentry appear negative).

Hugh

p.s. As ever, there may be better uses of your time, than trying
to get your points into my skull: if Linus is satisfied by your
argument, please just ignore me!
