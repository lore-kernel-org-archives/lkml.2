Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab0I1UZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:25:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790Ab0I1UZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:25:35 -0400
MIME-Version: 1.0
In-Reply-To: <4CA09977.80506@panasas.com>
References: <4CA09977.80506@panasas.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Sep 2010 13:24:40 -0700
Message-ID: <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2: arch/um/drivers:
 remove duplicate structure field initialization
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Julia Lawall <julia@diku.dk>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping, no comments?

On Mon, Sep 27, 2010 at 6:17 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>
> [bharrosh@fs2 ~/dev/git/pub/scsi-misc] 1115$ git bisect good
> f25c80a4b2bf93c99820f470573626557db35202 is the first bad commit
> commit f25c80a4b2bf93c99820f470573626557db35202

It looks like that commit is indeed very misleading. The commit message says:

  "arch/um/drivers: remove duplicate structure field initialization"

but it is in fact not duplicate: there's two field initializations,
but they are _different_. Looking at the patch, it has:

        .ndo_set_mac_address    = uml_net_set_mac,
-       .ndo_set_mac_address    = eth_mac_addr,

so it removes the later one, but it is not at all clear which one the
compiler actually used. My guess is that it used to use the later one
(the standard eth_mac_addr function), and the patch made it suddenly
use the uml_net_set_mac function.

I didn't check what gcc used to do, but this:

> The patch Reverts cleanly on top of 2.6.36-rc5 and after Revert works perfectly as
> before.

makes me suspect that nobody else checked it either.

> <RANT A HEAD CAN BE IGNORED>
>
> It has become extremely hard to bisect a simple problem in latest Kernels!

It's always been extremely hard, it just depends on luck how well it
works. Sometimes you never see any problems (except the one you
bisect, which is obviously the problem you _want_ to see), and then
sometimes bisection is really painful because there are multiple
independent ones you hit.

> For instance I found the bug I see was already present in 2.6.36-rc2
> and that a good point was 2.6.35. Bisecting two bad(s) quickly took me
> to some 2.6.35-rc1 Kernel that did not boot at all. So I was clever I
> decided to merge in 2.6.35 at each bisect point.

That really wasn't clever. Don't do it. It will cause untold pain. All
your problems resulted from that initial thing - you were basically
bisecting commits that weren't even part of the original "bad" state.
After a while, git-bisect ends up hitting those commits that aren't
even reachable from 'bad', and now you're screwed.

So all the other problems you had were due to that.

Now, admittedly, the thing that caused you to do this in the first
place (hitting a bad kernel that you couldn't even test) is painful.
And no, "git bisect skip" doesn't necessarily work all that well. But
what you tried really just made things worse.

If the real thing to do, just so you know next time, is to do the "git
bisect visualize", and try to pick a good point, and just select that
(with "git reset --hard xyzzy").

Now, that "good" is obviously a matter of judgement, because you don't
want to pick it too close to a known-bad or known-good commit (that
just makes bisection not work very efficiently), and seeing that can
be hard. But usually a good strategy is to pick something that looks
_reasonably_ central in the gitk view, and also looks like it's not in
the middle of some big upheaval (and preferably as far as reasonable
from the commit you know you can't test - pick a point on a different
branch before that got merged, for example)



> Then reset and continue.
> But for some reason the bisect got mixed up and complained about an impossible
> merge common bases. So out of desperation I did a very very^ stupid thing.
> []$ git rebase -i v2.6.35 v2.6.36-rc1

This _really_ won't work. I mean yes, it can work, but with any kind
of complex history, you're setting yourself up for more pain than it's
worth. It _can_ be worthwhile, but it's absolutely the last thing you
should try.

> In short I wish at some 2.6.XX-rc[45] of every Kernel cycle. Maintainers
> would rebase their next's tree of [XX+1] to a some what more stable rc.
> Sure re-run all the tests. They still have time for the new tree in next
> to be tested and verified before the next merge window.
> (Hell one of my bisect points took me as back as 2.6.34)
>
> Please remind me why maintainers should not rebase their trees once
> committed, to the point that they don't rebase even for buggy patches
> that are already in next, and apply fix patches, all within the same
> merge window. The same is also done with merge conflicts with the
> rc-cycle of their own code, instead of rebasing.

Umm. Rebasing often makes things much _worse_.

The real problem is that maintainers often pick random - and not at
all stable - points for their development to begin with. They just
pick some random "this is where Linus -git tree is today", and do
their development on top of that. THAT is the problem - they are
unaware that there's some nasty bug in that version.

It's actually made worse by rebasing. A lot of people end up rebasing
on top of such a random kernel (again, just because it's the 'most
recent'). It's very annoying.

Not to mention that rebasing easily results in bugs of its own, when
you do hit merge conflicts or double-apply something that already got
applied (and wasn't seen as a duplicate and merged away automatically,
because the code had been further modified since). We had that in the
DVB pull request just yesterday.

> So in short this is a call for, possibly, cleaner History in main Kernel.
> Please remind me why re-writing history is a bad thing.

Rebasing doesn't result in cleaner history. It just results in
_incorrect_ history that looks simpler.

To get cleaner history, people should try to keep their tree clean.
Not add random patches to random branches, and not start random
branches at random points in time that aren't necessarily stable.

                                    Linus
