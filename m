Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1GQXxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:53:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53449 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1GQXxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:53:17 -0400
Date: Mon, 18 Jul 2011 00:53:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110717235313.GT11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
 <20110717231610.GR11013@ZenIV.linux.org.uk>
 <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 04:38:24PM -0700, Linus Torvalds wrote:
> On Sun, Jul 17, 2011 at 4:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OR
> >
> > ?- keep part of the patch from Hugh, treating negative in RCU mode as
> > "need to unlazy".
> 
> No, urgh, that's horrible.
> 
> Not being able to do an RCU lookup of negative dentries would be
> really sad. There are some loads where a negative dentry is the
> *common* case.

No.  Check the patch, please - what it does is exactly "if RCU lookup
in the middle of pathname gave us a negative dentry, check that it's
really negative ASAP".

Negative on the last component is not affected by that and there we
*do* go unlazy immediately anyway.  If dentry in the middle of pathname
is really negative and not stale, we'll get unlazy_walk() check its
->d_seq and fall through the rest - all the way to failure exit in
walk_component().  Yes, we'll bump and drop ->d_count.  On that
negative dentry in the middle.

On the other hand, if that sucker is stale, unlazy_walk() will check
->d_seq and bugger off.  And no matter what we do, that pathname
resolution is going to have to be done in non-RCU mode at that point
and earlier is better.

Your variant could only lead to walking deeper into the tree before
we discover a stale dentry.  Because it *can't* have non-stale
descendents anymore.  Just more work for us...

IOW, once we run into negative dentry in RCU mode in do_lookup(), we
really need to drop out of RCU mode ASAP.  Note that it's *NOT* about
not finding negative dentries in RCU dcache lookups or any such
silliness - that, of course, would be dumb.
