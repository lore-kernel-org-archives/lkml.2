Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab2LJVS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:18:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45046 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2LJVS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:18:58 -0500
Date: Mon, 10 Dec 2012 13:18:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Missing tags in my local stable git repo
Message-ID: <20121210211854.GA26470@kroah.com>
References: <1355160900.17101.229.camel@gandalf.local.home>
 <1355165264.17101.233.camel@gandalf.local.home>
 <20121210190247.GA32119@kroah.com>
 <1355166920.17101.239.camel@gandalf.local.home>
 <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
 <1355172274.17101.250.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355172274.17101.250.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 03:44:34PM -0500, Steven Rostedt wrote:
> On Mon, 2012-12-10 at 11:30 -0800, Linus Torvalds wrote:
> 
> > Any tree that is an alternate and ever has *any* objects in it that
> > can become unreachable is a really really really bad idea.
> 
> The only alternates that I use are my local copies of stable and your
> tree, which should always be safe.
> 
> > Also, you should never *ever* make an alternate object store be
> > *another* alternate object store, and I think that may be the problem
> > in your case. Iirc git doesn't follow alternates recursively. So what
> > can happen is that you got objects in the "middle" alternate, that
> > then get pruned away by "git gc" (because they exist in the origin
> > repository), but they got pruned away from the furthest alternate in
> > the meantime, and now the objects are "two hops" away, and will not
> > ever be seen.
> 
> OK, this may be my issue, as my stable.git has my copy of your tree as
> an alternate. Maybe I can merge the two trees. Although I'm not exactly
> sure how to. As I have my copies as both alternates as well as remotes
> for my working repos, to get them to pull everything in with a remote
> update. I have in my copy of the stable.git tree the following in the
> config file:
> 
> [remote "stable"]
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>         fetch = +refs/heads/*:refs/heads/*
> 
> Otherwise I don't get the updates from stable when I do a remote fetch
> of my local copies. Would something like this work?
> 
> [remote "origin"]
>         fetch = +refs/*:refs/*
>         mirror = true
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> [remote "stable"]
>         url = git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
>         fetch = +refs/heads/*:refs/heads/*
> 
> That is, if I have a single linus-stable.git repo that all my other
> repos use as an alternate and a remote, I could have this repo updated
> with:
> 
> git fetch
> git remote update stable
> 
> and all my other repos will get all the updates from both your tree and
> the stable tree with a single remote update of this copy?
> 
> Am I making any sense? ;-)

Kind of, but would would be even easier is if you just have one
"origin", pointing at linux-stable.git, and then every so often just do:
	git checkout master
	git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

As the master branch of linux-stable.git always is a "clean" linux.git
tree, although it might lag a few -rc releases back if I have forgotten
to update it recently.  When it does get updated, all should be fine as
the master branch has no merges from anything else, so it's just a
fast-forward.

That might be simpler overall than the different repos to be pulling
from in different ways.

greg k-h
