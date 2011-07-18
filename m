Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab1GRCIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 22:08:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60918 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab1GRCIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 22:08:23 -0400
Date: Mon, 18 Jul 2011 03:08:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <20110718020818.GW11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
 <20110717231610.GR11013@ZenIV.linux.org.uk>
 <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils>
 <20110718002524.GU11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107171740260.1327@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1107171740260.1327@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 06:13:34PM -0700, Hugh Dickins wrote:

> And in the genuine negative dentry case: at present (with or without
> my or Linus's patches) there is no final nd->seq check, is there?

For stat() - no, there isn't.  We really bail out with -ENOENT, no matter
what.  Racy, which is what you are hitting.

> Having found a negative dentry, we just get out at that point with
> -ENOENT.  Now, it's true that there might be a race in which the
> negative dentry is being made positive just as we're getting out;
> but since we're not digging in any deeper, that seems to me just
> a natural inevitable race, nothing to be guarded against.
>
> Whereas your "if (!*inode) goto unlazy;" is adding an additional
> sequence check, isn't it?  Is that a race you see as important?
> If so, it is a different matter than I was ever considering.

Umm...  I really don't think that trying to avoid that ->d_seq comparison
is worth doing.  I understand your point, but... IMO it's safer to leave
->d_inode cleaning as-is, at least for now.  Hell knows; I'd be a lot
more optimistic if fs/dcache.c had been in better shape.  As it is, *and*
considering that we are within a spitting distance from -final...

It's not as if we'd been talking about a heavy contention or cacheline
bouncing here, let alone doing ->lookup().  I'm not entirely convinced
that it's a valid optimization in the first place (probably is, but I'm
seriously scared by the complexity we already have there), and I'm really
not fond of the idea of dealing with whatever subtle crap we might
discover with Linus' patch.  Again, dcache is not in a healthy shape
right now; at this point dumb and straightforward is, IMO, better than
subtle and risking to step on toes of very odd code out there.

Hell, stuff that walks towards root with just rcu_read_lock, checking
->d_inode as it goes and making assumptions about the lifecycle
stages of the dentries it sees is not even all that weird, compared to
the code actually in there ;-/

Once we are done with code audit, sure, I'm fine with ->d_inode being
kept until dentry is actually freed.  Any code that relies on that thing
being cleared is asking for trouble and should be rewritten anyway.
The only thing is, it needs to be found before we rewrite it...

Speaking of weird code - could somebody explain what the deuce is going
on in dget_parent()?
        rcu_read_lock();
        ret = dentry->d_parent;
        if (!ret) {
                rcu_read_unlock();
                goto out; 
        }
in the very beginning looks wrong - we *never* have NULL ->d_parent on
dentries that might be seen by anyone; d_alloc(NULL, name) callers all
set ->d_parent to dentry itself ASAP and we never put NULL there afterwards.

What the hell is going on there?  Note that callers of dget_parent() will
be really unimpressed by getting NULL from it; most of them will cheerfully
dereference what they get.  It seems to be Nick's change; is there anybody
who would remember reasons for it?
