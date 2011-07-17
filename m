Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab1GQXxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 19:53:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756356Ab1GQXxN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:53:13 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1107171604150.1237@sister.anvils>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com> <alpine.LSU.2.00.1107171604150.1237@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 17 Jul 2011 16:52:47 -0700
Message-ID: <CA+55aFyui7SrHuidgN1Y5E4Hapqs2+Uv34==hkwefUbz6WrEvQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 4:31 PM, Hugh Dickins <hughd@google.com> wrote:
>>
>> I kind of see why you do it for that particular bug, but at the same
>> time, it just makes me go "Eww". If that inode isn't NULL yet, you
>> then return the dentry that can get a NULL d_inode later. So the only
>> special thing there is that we happen to check for a NULL inode there.
>> What protects *later* checks for a NULL d_inode?
>
> I was imagining that all the later uses of the inode were using
> walk_component()'s local struct inode *inode, or nd->inode which
> it sets on success.  Until complete_walk(), or the next level down
> of lookup, has validated that stage by checking nd->seq.

You are very likely right. The code *should* look up the inode
information before it actually does the final RCU check, since after
the sequence number check the window is open again.

So it's very possible that your patch is a real fix, and doesn't
really have any problems. It's just that I personally hate it ;)

So the reason I prefer my one-liner is not because it's smaller per se
- that's just a nice side issue. The reason I prefer my version is
that I think the current dentry pruning is actively wrong in turning a
dentry into a negative one due to memory pressure. So I think the name
lookup code is "correct", and the bug is literally that dentry pruning
(knowingly - there's even a comment about how the dentry is still
reachable for RCU lookups) turned a visible dentry into a negative one
even though nobody deleted it.

So I see your hack as being a workaround for the real bug, rather than a fix.

> If any does dereference dentry->d_inode in between, then it would
> already be oopsing in this situation, which I've not seen.

Good point, and it does probably mean that nobody accesses d_inode any more.

But another way of thinking about that is that the old lookup code
just created a cached copy of the d_inode pointer, so the code
literally always used a "stale" d_inode thing, and always relied on
the RCU freeing of inodes. So in a very real sense, my patch to just
remove the "d_inode = NULL" doesn't *change* anything. It just means
that now the dentry doesn't ever look negative.

So it should be a very safe patch, in that any stale inode pointer
issues are pre-existing, and not newly introduced issues by not
clearing the pointer.

> At first it looked worrying to interfere with the sequence
> "inode = dentry->d_inode; if (inode) { dentry->d_inode = NULL;"
> but seeing as dentry_iput() is only called from the one place,
> I think the test is merely about negative dentries, and setting
> d_inode to NULL is just long-standing tidiness, nothing vital.

Indeed. I checked that the "d_iput()" functions don't do anything with
d_inode either, and the only other thing we do afterwards is to
kfree() the dentry and the name (which is often RCU-delayed,. of
course, so there's that indirection through the RCU-freeing thing).

> Well, my stress tests don't blow up in the first half hour.
> But I was not successful in re-reproducing the issue (I got
> yesterday in 2.5 hours) within 7 hours, so it's probably going
> to take days to be sure that your minus-1-liner fixes it.

If you can keep running it, that would be good. I was *really* hoping
to do the final 3.0 tomorrow, but if we have a known thing to be
worried about, I guess I can delay it a bit.

> Just a nagging doubt that leaving d_inode set may be wrong for somewhere.

So see above: I don't think it's conceptually any different at all
from the RCU lookup code caching d_inode in nd->inode (or the local
*inode pointer).

But it's possible I'm missing something. As mentioned, I think my
one-liner is the more "correct" fix, but it's certainly more indirect
and perhaps a bit "subtler".

                   Linus
