Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab1GRAZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 20:25:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37548 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab1GRAZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 20:25:29 -0400
Date: Mon, 18 Jul 2011 01:25:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110718002524.GU11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
 <20110717231610.GR11013@ZenIV.linux.org.uk>
 <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1107171641130.1274@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 04:47:45PM -0700, Hugh Dickins wrote:
> On Sun, 17 Jul 2011, Linus Torvalds wrote:
> > On Sun, Jul 17, 2011 at 4:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > OR
> > >
> > > ?- keep part of the patch from Hugh, treating negative in RCU mode as
> > > "need to unlazy".
> > 
> > No, urgh, that's horrible.
> > 
> > Not being able to do an RCU lookup of negative dentries would be
> > really sad. There are some loads where a negative dentry is the
> > *common* case.
> 
> Yes, that worried me too.

Grr...  What do you think we need to do when we find a negative dentry in
RCU lookup?  We can
	* check its ->d_seq, to see if it's valid
	* somehow (e.g. with what Linus suggested) try to walk further and
leave staleness checks for dentries we would encounter later in the walk.

If it's in the end of pathname, there is no choice at all - we need to
check ->d_seq of this one.  Right?  And we do exactly that.  If we see
that it's for real, fine we got ourselves a reference to negative dentry
and can go ahead.  If it's something like stat(2), we'll just do dput()
and bugger off.  Refcounts of everything on the path to it are unaffected,
no global locks played with...

If it's in the middle of pathname, we could try to delay the check.  And
what would it buy us?  If that dentry was stale, we'd just walk a bit
deeper.  And found a stale one at some later point.  And restarted pathname
resolution in non-lazy mode from the very beginning.  If it wasn't stale
(i.e. real negative dentry), we *do* want -ENOENT and we'll get it as soon
as unlazy_walk() will check ->d_seq and we plod through the rest of
do_lookup() to check in walk_component().  We won't redo d_lookup(), lock
i_mutex, etc.
