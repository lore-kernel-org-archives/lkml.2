Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab2LJUoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:44:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16304 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LJUog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:44:36 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F1vn84g2v5IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=GbT8ctTW91IA:10 a=VwQbUJbxAAAA:8 a=T2SYdzpF24tShrCfHBsA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355172274.17101.250.camel@gandalf.local.home>
Subject: Re: Missing tags in my local stable git repo
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Dec 2012 15:44:34 -0500
In-Reply-To: <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
References: <1355160900.17101.229.camel@gandalf.local.home>
	 <1355165264.17101.233.camel@gandalf.local.home>
	 <20121210190247.GA32119@kroah.com>
	 <1355166920.17101.239.camel@gandalf.local.home>
	 <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 11:30 -0800, Linus Torvalds wrote:

> Any tree that is an alternate and ever has *any* objects in it that
> can become unreachable is a really really really bad idea.

The only alternates that I use are my local copies of stable and your
tree, which should always be safe.

> Also, you should never *ever* make an alternate object store be
> *another* alternate object store, and I think that may be the problem
> in your case. Iirc git doesn't follow alternates recursively. So what
> can happen is that you got objects in the "middle" alternate, that
> then get pruned away by "git gc" (because they exist in the origin
> repository), but they got pruned away from the furthest alternate in
> the meantime, and now the objects are "two hops" away, and will not
> ever be seen.

OK, this may be my issue, as my stable.git has my copy of your tree as
an alternate. Maybe I can merge the two trees. Although I'm not exactly
sure how to. As I have my copies as both alternates as well as remotes
for my working repos, to get them to pull everything in with a remote
update. I have in my copy of the stable.git tree the following in the
config file:

[remote "stable"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
        fetch = +refs/heads/*:refs/heads/*

Otherwise I don't get the updates from stable when I do a remote fetch
of my local copies. Would something like this work?

[remote "origin"]
        fetch = +refs/*:refs/*
        mirror = true
        url = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
[remote "stable"]
        url = git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
        fetch = +refs/heads/*:refs/heads/*

That is, if I have a single linus-stable.git repo that all my other
repos use as an alternate and a remote, I could have this repo updated
with:

git fetch
git remote update stable

and all my other repos will get all the updates from both your tree and
the stable tree with a single remote update of this copy?

Am I making any sense? ;-)


> 
> Moral of the story: be *very* careful when using alternates. Only ever
> point the alternate file at a *real* repository (not another one with
> alternates), and only one that never has references removed.

Note, I can just keep my normal set up, as it looks like the only damage
that can happen is my copy of stable.git tree getting corrupted (as it
did), and the fix is simply to blow it away and recreate it. No big
deal.

-- Steve


