Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1GQX0L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:26:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34190 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab1GQX0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:26:10 -0400
Date: Mon, 18 Jul 2011 00:26:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110717232605.GS11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
 <CA+55aFzDtunzxNf9TGJMt+VVu-ox1eBb5m1Tbn=+50hR6_=Bqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzDtunzxNf9TGJMt+VVu-ox1eBb5m1Tbn=+50hR6_=Bqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 03:59:26PM -0700, Linus Torvalds wrote:
> On Sun, Jul 17, 2011 at 3:00 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > The above (whitespace-damaged) patch may look trivial, but it is
> > *entirely* untested, and maybe my gut feel that the above is the right
> > way to solve the problem is just wrong.
> >
> > Al, any reactions? Hugh, does the above patch work for your
> > stress-test case? Or, indeed, at all?
> 
> Hmm, it worked for my small test, including under memory pressure that
> was shrinking dentries. But my test is not the kind of stress-test
> that you clearly have, so that only means that it has not *really*
> obvious breakages.

Let's not go there at the moment.  I really don't want to pile on more
things needing audit that late in the cycle...  I've posted what
I think is the minimal fix - two lines added in the lazy side of
do_lookup(); if Hugh can confirm that his breakage is gone with that,
I'd strongly suggest going with that one at the momemnt...

Speaking of things found late in cycle: today's catch so far is UFS
being buggered when exported over NFS (trivially fixed, d_splice_alias()
needed there) and cramfs calling d_add(dentry, ERR_PTR(-ENOMEM)) on
OOM...  Plus yesterday cifs and ceph holes, plus exofs_get_parent()
oopsable due to confusion about calling conventions (it should return
ERR_PTR() on stale, not NULL).

Pending ones: lack of i_mutex in btrfs get_default_root() and bad misuse
of d_splice_alias() in there, *really* nasty one in nfs async sillyrename
(d_move() outside of i_mutex if unlink() goes sillyrename way and gets
SIGKILL while waiting for server to reply) and cifs_get_root() lacking
permission checks, i_mutex and calling d_materialise_unique() on possibly
hashed dentry.  Plus a bunch of dubious places in ceph... ;-/  _And_
remaining fuckloads of places to wade through...
