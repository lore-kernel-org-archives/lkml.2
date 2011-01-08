Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab1AHBdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 20:33:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185Ab1AHBdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 20:33:37 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 7 Jan 2011 17:32:46 -0800
Message-ID: <AANLkTi=eNucM5d=+zq5euz3dZirJEhPaH9f9ZXuHymEM@mail.gmail.com>
Subject: Quick merge window note..
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I've obviously been merging eagerly the last couple of days, but
I'm taking most of the weekend off, and I thought I'd just point
people at the fact that I merged the somewhat scary (but very
impressive) lockless name lookup tree from Nick today.

It's scary because this is some very core code, and the new RCU lookup
model is way more clever and subtle than the old dentry_lock spinlock.

But it's rather impressive and I really wanted to merge it, because
some of the performance numbers are pretty stunning. For example, a
hot-cache "find . -size" on my home directory (which basically just
does name lookups to get the stat information for every file
recursively) became 35% faster. And that's the _unthreaded_ case. Not
some odd high-end scalability thing, and not some recompiled binary
taking advantage of new facilities. Pathname lookup is just simply
faster.

On the scary side, it's worth noticing that if you see any problems,
and you think it might be due to the new rcu lookup, rather than
bisect _everything_ (the merge window has already brought in 3700+
commits), it may be worth just checking the VFS scale tip itself.
That's fairly easy, because it's based on plain 2.6.37 (which if it
isn't stable for you, we have bigger problems than the RCU lookup),
and is just 57 commits up until commit b3e19d924b6e ("fs: scale
mntget/mntput").

So rather than bisect the 3700+ commits, start out by trying that one
commit first.

Of course, I've already bisected one problem (firmware loading
"feature"), and that wasn't in the RCU pathname lookup, so maybe I'm
pointing out the new name lookup for no good reason. Traditionally, I
think most of our regressions by far tend to be in drivers etc rather
than core code and me being worried about the core may be silly.

(And btw, I do have more pull requests pending, and no, I didn't miss
them just because I haven't pulled yours yet. But I'm going to give it
a short rest, and continue pulling on Sunday)

                                 Linus
