Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab0KLRub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:50:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751829Ab0KLRua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:50:30 -0500
MIME-Version: 1.0
In-Reply-To: <0d30dc$k5i5ji@orsmga001.jf.intel.com>
References: <alpine.DEB.2.00.1011110021320.12522@skynet.skynet.ie>
 <AANLkTik8-=Ku+4k0+KVZknAgx2zJGRo-n10jaNW-fke6@mail.gmail.com> <0d30dc$k5i5ji@orsmga001.jf.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Nov 2010 09:50:04 -0800
Message-ID: <AANLkTin11MC8yXONG65FYs0B28Vp+7Kx5AkTQujJmQtO@mail.gmail.com>
Subject: Re: [git pull] drm fixes
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 9:21 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> My bad, I cherry-picked it from our public drm-intel-next tree and thought
> it wise to include the cross-reference to explain the duplication and
> merge conflicts and to provide some additional test history into the commit.
> Obviously not enough information.
>
> Is there a right approach here? I'm trying to be strict in that what is
> sent upstream in -fixes are purely known regression fixes, and to preserve
> test history on both -fixes and -next. That leads to situations like the
> above where we have a commit that does not appear to relevant to stable at
> first, but then is later shown to be required. How best to resolve the
> eventual conflict that will show up in your tree? Just cherry-pick and be
> dammed?

Generally "just cherry-pick and be damned". Duplicate patches happen
all the time, and it has nothing to do with cherry-picking: the same
patch gets done by two different people (or just forwarded to two
different maintainers). So duplication isn't problematic per se.

And if it happens so much that it then causes real problems elsewhere
(for example lots of merge conflicts due to other related changes
around it), that's indicative of something _else_ going on.

Maybe it's just a lack of good topic branches, so that you mix
everything up in one place, and get conflicts due to that. With well
chosen topic branches, you do fixes in one particular branch that can
be merged into both -next and -stable. But then you really have to do
topic branches based on _topic_, not just "this is a random collection
of -stable crap". Name the branch by the actual problem it fixes, and
do NOT merge it into either -next _nor_ -stable until that particular
problem has really been fixed and you're sure (otherwise you'll just
end up with lots of daily merges of random fixes, and that will be
_worse_. You may avoid the merge conflicts, but your history will look
like sh*t, and your topic branches will be meaningless).

Or you have two people who work in the same area, and your code is
just not modular enough, so when they work on the same file, they
invariably step on each others fingers. Functions too big, actions not
clearly enough abstracted out, people just adding things to the same
area even when they work on two different chips (the intel DRM code
tends to be _full_ of "common" functions that then test individual
chip ID's and do different things. Dammit, if they do that, they
aren't common functions, and you write them the wrong way around:
instead of having "common function testing if ID==sandybridge", you
should have "sandybridge function doing its thing and calling _truly_
common helper functions that do things that other chip functions will
need too")

Merge conflicts (of anything but the totally trivial kind) are almost
always a sign of something being wrong in the development.  Trivial
merge conflicts (and merges that had the same patch and got resolved
totally automatically - they were so trivial that a human never even
saw it) are normal. But if it's at the point that it causes pain,
there is some more fundamental problem, and marking commits as "this
is the same as in that other branch" is not the solution.

                           Linus
