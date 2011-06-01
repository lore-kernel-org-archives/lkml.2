Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab1FAU2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:28:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758875Ab1FAU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:28:37 -0400
MIME-Version: 1.0
In-Reply-To: <1306956328.10135.36.camel@gandalf.stny.rr.com>
References: <1306956328.10135.36.camel@gandalf.stny.rr.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Jun 2011 05:27:45 +0900
Message-ID: <BANLkTimgjdFQcSfOOFFjmSC+Wt_xPXr4Xg@mail.gmail.com>
Subject: Re: [PATCH] ide: Fix bug caused by git merge
To: Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <jaxboe@fusionio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Junio C Hamano <gitster@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 4:25 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> The issue here is that the commit 5b03a1b1 is a common ancestor to both
> commits. But even though the commit 7eec77a1 removed that line, for some
> reason, the merge put that line back. No other commit added that line to
> the code.

Incorrect.

What added that line back to the code was commit 698567f3fa79, a merge by Jens.

It had conflicts in drivers/ide/ide-cd.c (due to commit d4dc210f69bc,
which added the flag GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE on the line
just before). And Jens did a mis-merge there.

Jens - this is a prime example of why people SHOULD NOT DO CROSS-MERGES!

You are just not as used to doing merges as I am, and when there are
conflicts, you clearly didn't actually look at the two sides to notice
that one side removed the line, so when you resolved it by taking all
the conflicting stuff, you re-introduced the line that should have
been deleted!

At the time of the conflicting merge, a

    gitk --merge drivers/ide/ide-cd.c

would have shown the two conflicting commits, and told you that the
line needs to not exist in the merge.

You can re-create that "gitk --merge" in the current tree with

    gitk 698567f3fa79^...698567f3fa79^2 drivers/ide/ide-cd.c

and because you just picked the result from one parent (instead of
picking the proper result of *combining* the changes), a

    git show 698567f3fa79

doesn't show anything at all.

Grr. I now wondered about the OTHER conflicts that are mentioned in
that commit, AND THEY ALL HAVE THE SAME BUG. For all three files you
just picked one side, not the other.

Jens, you really can't do that. When you see a conflict marker, you
need to look at WHY. The conflict may well be because of removed lines
rather than added lines, the correct resolution is NOT necessarily to
just take everything within the conflicting region.

For example, the conflict in pcd.c looks like this (I'm re-doing the
merge properly to get the fixed diff):

                    disk->fops = &pcd_bdops;
    <<<<<<< HEAD
                    disk->flags = GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
                    disk->events = DISK_EVENT_MEDIA_CHANGE;
    =======
    >>>>>>> 698567f3fa79^2
            }

and the rsolution is simply to

                    disk->fops = &pcd_bdops;
                    disk->flags = GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
            }

not the one you did (which left the "disk->events = .." line that was
removed in the other branch,

And the merge diff should have looked like this:

    diff --cc drivers/block/paride/pcd.c
    index a0aabd904a51,8690e31d9932..000000000000
    --- a/drivers/block/paride/pcd.c
    +++ b/drivers/block/paride/pcd.c
    @@@ -320,8 -320,6 +320,7 @@@ static void pcd_init_units(void
                    disk->first_minor = unit;
                    strcpy(disk->disk_name, cd->name);      /* umm... */
                    disk->fops = &pcd_bdops;
     +              disk->flags = GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
    -               disk->events = DISK_EVENT_MEDIA_CHANGE;
            }
      }



which shows how one line was added in one branch, and another one
removed. But because you just mindlessly picked one side over the
other, the merge diff ends up being empty (that's the "trivially
resolved" thing).

Pretty much exactly the same thing for the two other files.

PLEASE DON'T DO MERGES IF YOU CANNOT DO THEM!

Don't do them to remove conflicts. I'm *good* at handling conflicts. I
do it every friggin day. I might get them wrong occasionally, but it
is very very rare, exactly because I'm so used to doing merges, and I
carefully look at what actually happened on the two sides when I
resolve things. Git has wonderful support for helping resolve merges
intelligently, but you need to know how to do it. See the gitk example
above - run it and ponder.

Grr.

I'll fix it properly.

And thanks Steven for noticing, even if your analysis ended up missing this.

(Junio - what made it harder for Steven to see the reason may be due
the default history simplification. I do wonder if we should just make
"--simplify-merges" the default, because the aggressive and simple
default culling makes it hard to see merge commits like this that just
pick one side  over the other. --simplify-merges is more expensive,
but doesn't have some of the problems the aggressive simplification
has)

                      Linus
