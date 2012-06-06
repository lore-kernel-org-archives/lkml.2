Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab2FFXcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:32:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36453 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab2FFXcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:32:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120606230040.GA18089@redhat.com>
References: <20120603223617.GB7707@redhat.com> <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk> <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com> <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Jun 2012 16:31:51 -0700
X-Google-Sender-Auth: BqI1D4sgJg6gsunKmwxRhFg4lTI
Message-ID: <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 4:00 PM, Dave Jones <davej@redhat.com> wrote:
>
> It is possible that this is a bug stretching back further than 3.4.
> I'm continually adding new ways to do terrible things to the fuzzer,
> and this last week or so has seen quite a few changes. So maybe I've only
> just found a way to tickle this particular bug. (Just like the situation
> we had with the mbind corruption a few weeks back).

Possible. The directory i_mutex locking rules are subtle, and we have
that whole complex d_ancestor() logic for ordering them against the
child ordering locks (*plus* the s_vfs_rename_mutex to then make us
able to not have to worry about the ordering of non-ancestry-related
dentries).

Sure, the dentry->d_lock has some of that too, but not quite as bad.

It's definitely one of our most subtle orderings - most of the other
ones we can just compare the address of the lock itself or something
like that to avoid deadlock, there's no more complex topology among
the entries. Add to that the whole "i_mutex" *also* has the mmap sem
issue where the dependency is reversed for directories (readdir ->
copy_to_user mmap sem) from normal inodes (copy_to/from_user -> IO
->i_mutex), and it's perhaps no wonder i_mutex is not one of my
all-time favorite locks.

At the same time, the fact that you're running with lockdep makes me
think that *if* we got the ordering wrong, lockdep should still show
the deadlock. PeterZ - the fact that we use mutex_lock_nested with
I_MUTEX_PARENT/I_MUTEX_CHILD/nothing hopefully doesn't screw us up in
case we get it wrong, right? IOW, lockdep would still find an *actual*
circular dependency if we hit one, no?

Dave - could you try running with the "instance" patch from PeterZ
earlier in this thread? That should at least help improve the sysrq-d
output a bit, and might give us some clue.

Al, looking at i_mutex use and rename, the only odd thing I see is how
vfs_rename_dir() does the "d_move()" *after* it has dropped the target
i_mutex. That looks odd. But I guess it shouldn't matter, because if
we're doing cross-directory renames we will always serialize everybody
with that rename mutex anyway. Yes/no? But wouldn't it make more sense
to do it inside the i_mutex? And before we do the dput() on the
new_dentry?

Why *does* that vfs_rename_dir() thing do that d_move so late?
vfs_rename_other() looks saner. I'm assuming it wants to do it after
the dput() for some reason (wanting to prune any stale children of the
target?) but I can't for the life of me remember why and I'm too lazy
to look up the git history. Maybe a comment would be in order?

                  Linus
