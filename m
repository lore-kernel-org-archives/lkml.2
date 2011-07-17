Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab1GQWAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 18:00:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479Ab1GQWAa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 18:00:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 17 Jul 2011 15:00:06 -0700
Message-ID: <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
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

On Sun, Jul 17, 2011 at 2:03 PM, Hugh Dickins <hughd@google.com> wrote:
>
> That -ENOENT in walk_component: isn't it assuming we found a negative
> dentry, before reaching the read_seqcount_retry which complete_walk
> (or nameidata_drop_rcu_last before 3.0) would use to confirm a successful
> lookup?

Hmm. I think you're right. The ENOENT will basically short-circuit the
full proper checks.

>  And can't memory pressure prune a dentry, coming to dentry_kill
> which __d_drops to unhash before dentry_iput resets d_inode to NULL, but
> the dentry_rcuwalk_barrier between those is ineffective if the other end
> ignores the seqcount?

Yes. However, looking at it, I'm not very happy with your patch. It
doesn't really make sense to me to special-case the NULL inode and
only do a seq_retry for that case.

I kind of see why you do it for that particular bug, but at the same
time, it just makes me go "Eww". If that inode isn't NULL yet, you
then return the dentry that can get a NULL d_inode later. So the only
special thing there is that we happen to check for a NULL inode there.
What protects *later* checks for a NULL d_inode?

So my gut feel is that we should instead

 - either remove the -ENOENT return at that point entirely, and move
it to after we have re-verified the dentry lookup for other reasons.
That looks pretty involved, though, and those paths do end up
accessing inode data structures etc, so it looks less than trivial.

OR

 - simply just not clear d_inode at all in d_kill(), so that when we
prune a dentry due to memory pressure, it doesn't actually change the
state of the dentry.

and I think the second solution is the right one. It's kind of odd:
we'll have called down to the iput() routine, and the inode will be
"gone", but that is already true for the *normal* race of actually
deleting a file too, and we have that whole "inodes are RCU-released",
so the inode allocation will still exist.

So my gut feel is that we should instead just do this:

  --- a/fs/dcache.c
  +++ b/fs/dcache.c
  @@ -187,7 +187,6 @@ static void dentry_iput(struct dentry * dentry)
   {
          struct inode *inode = dentry->d_inode;
          if (inode) {
  -               dentry->d_inode = NULL;
                  list_del_init(&dentry->d_alias);
                  spin_unlock(&dentry->d_lock);
                  spin_unlock(&inode->i_lock);

and see what the fall-out from that would be. Nobody should then *use*
the stale inode, because __d_drop has done that
dentry_rcuwalk_barrier(). So we avoid the NULL inode special case
entirely.

Comments?

The above (whitespace-damaged) patch may look trivial, but it is
*entirely* untested, and maybe my gut feel that the above is the right
way to solve the problem is just wrong.

Al, any reactions? Hugh, does the above patch work for your
stress-test case? Or, indeed, at all?

                       Linus
