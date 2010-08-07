Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0HGVBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 17:01:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216Ab0HGVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 17:01:21 -0400
MIME-Version: 1.0
In-Reply-To: <4C5D0BE2.3050209@fusionio.com>
References: <4C5BE640.2050801@fusionio.com> <AANLkTindzwVR93MN=6HpevQZh5EqfvnmbzEj9OeG-PLJ@mail.gmail.com> 
	<4C5D0BE2.3050209@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 7 Aug 2010 14:00:24 -0700
Message-ID: <AANLkTi=KkPhw8nA9PmQ7D8atKjTYXVCixUt=FHHNMy+S@mail.gmail.com>
Subject: Re: [GIT PULL] block/IO bits for 2.6.36-rc1
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 7, 2010 at 12:31 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> Sometimes urgent patches will sit in for-linus and then I will merge
> those in to for-2.6.36 to save Stephen the hassle of carrying conflict
> update patches.

The merges I saw weren't even urgent, because you had never actually
pushed them to me as such for the previous release. So both sides of
the merge was "for-2.3.36" as far as I can tell. That's what makes me
think there's some odd duplication of branches with no point (except
to make the history look ugly).

Now, don't get me wrong - I _like_ branches. I love it when people
maintain different branches for different features, and then merge
them together in order for me to pull them (or just ask me to pull
multiple branches). See for example merge commit  415cb47998 that
Pekka did to create one single thing for me to pull when he had
maintained four different topic branches. Or see the x86 "tip" pulls
from Ingo, Thomas and Peter as an example of just asking me to pull
multiple branches separately.

So branches (and the merges that go with them) are a wonderful thing
when they _clarify_ history. I don't mind merges at all in that case.
When the merge has a reason for existing, it's actually a good thing,
and one guiding model for that is to ask yourself "Does this merge
message make sense and tell people something interesting"?

So just to take a look at that merge by Pekka:

  commit 415cb47998c5
  Merge: 9fe6206f4006 78b435368fcd d602dabaeba7 2bce64858442 bc6488e91078
  Author: Pekka Enberg <penberg@cs.helsinki.fi>
  Date:   Wed Aug 4 22:04:43 2010 +0300

      Merge branches 'slab/fixes', 'slob/fixes', 'slub/cleanups' and
'slub/fixes' into for-linus

and even outside of the history itself, I'd argue that the merge
message already tells you _why_ the merge was done. Despite it being
just the trivial automatic merge message that git generates on its
own. The merge actually clarifies history, I think.

So one guiding light for doing merges is really just to ask yourself
whether the merge message will actually tell anybody anything. And in
particular, merge messages like

   Merge branch 'master' into for-2.6.36

don't do that. Think about it as an outsider: what does the above tell
anybody? It looks like it has no relevant information in it. That's a
hint that the merge simply shouldn't have been done.

It's just a _hint_ though. I'm not saying that the merge message
always has to be a revelation. I'm just saying that a merge message
like "Merge branch 'master' ..." should raise red flags.

Now, the "into for-2.6.36" part is still informative. But if there are
multiple merges of the same branch into that same thing, then that is
another red flag, bringing up the question "why did he merge something
that wasn't ready yet".

What I'm trying to say is that if you start thinking about what the
merge messages tell outsiders, then you probably are thinking about
merges the right way. And if the automatic git messages don't seem to
tell the reason, one thing you can actually do is to do

  git pull --no-commit ....
  git commit

and edit the merge message manually to explain what/why the merge does
(or you could do "git commit --amend" after the pull, but I would
encourage people to do the commit separately if only because it
actually shows that you thought about the issue _before_ you did the
pull rather than as a "oops, that merge message was uninformative, let
me fix it up" after-the-fact)

> I tend to merge in your tree when I _know_ there's a conflict there,
> since it's much easier to fix things up when they happen and the change
> is fresh, than wait potentially 2-3 months and then have to resolve
> everything in one go.

Now, this is a good reason for a merge. But:
 - make that reason known
and
 - DON'T DO THIS WHILE THE CODE IS STILL UNDER DEVELOPMENT

I'm shouting, because the second thing is what really gets me: daily
merges. If you are doing daily merges for conflict resolution, that's
a big big red flag. That means that you're merging stuff while it's
still being developed.

So the "let's do a merge to avoid hard merges much later" is a good
reason to merge, but in that case do point it out, and do it after the
development has died down, and after you know that you aren't going to
have another thing that will also clash.

In other words, wait a few days. Or even a week or two. Don't think
"Oh, I just applied something that I know will clash, so let's merge
it now". Let the code calm down, and make sure it's all done. And
never _ever_ merge a random point. If the merge window is months away,
you'll know that there is going to be a few -rc releases still, so
there's ample time to just wait a week or so, and then do a merge like

   # I know this is going to have conflicts, so I'm not even doing --no-commit

   git merge v2.6.35-rc5

   # edit the message to say _why_ you're merging an -rc release,
talking about resolving the conflicts early

see? If you do this, your history will suddenly make sense. There
won't be the daily merges, and the merges that _are_ there are
actually explanatory. A bad merge has turned into a good merge, and
history doesn't look ugly.

So again, I'm not saying that merges are bad. I'm saying that random
and unexplained merges are bad.

> But if you don't like that way of doing things, I will stop and just
> keep for-2.6.X+1 patches in a branch that is based off 2.6.X and never
> updated. I will try that for the next release and see how that goes.

It's worth trying. In fact, it might be worth trying having a few
different branches, especially since there has been several clearly
different development threads for the block layer. It would be
_beautiful_ if you were to send me a couple of different pull requests
for things like "fix writeback" and "update cfs", and they'd be
independent. Because I think they really _are_ independent things.

But see above. Merges per se are not evil or bad. But thoughtless
merges are bad (and quite frankly, I don't mind a _couple_ of
unnecessary merges. It's when I see the daily kind that I go "no,
there's something seriously wrong here". So none of this is about hard
rules that have to be followed 100%, it's more flexible than that).

Give it a try,

               Linus
