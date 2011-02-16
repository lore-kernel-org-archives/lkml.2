Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1BPQd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:33:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900Ab1BPQdy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:33:54 -0500
MIME-Version: 1.0
In-Reply-To: <20110216161929.GF22723@ZenIV.linux.org.uk>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
 <1297854842.3201.197.camel@edumazet-laptop> <AANLkTimnLPF0wz+ya-Wj1U1hQjPJpUhmL893OxBWqZYM@mail.gmail.com>
 <20110216160643.GE22723@ZenIV.linux.org.uk> <20110216161929.GF22723@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Feb 2011 08:33:32 -0800
Message-ID: <AANLkTi=8O1ZJZ2dWWwmcdV3G8LtrxSHWp=GgLxAYQE3A@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc5
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 8:19 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>        Let's shift that call of nameidata_dentry_drop_rcu_maybe() into both
> callers of do_follow_link() instead.  Marginally less obvious that we won't
> reach the guts of do_follow_link() in RCU mode, just as obvious that overall
> structure is ugly as hell and avoids making it even uglier by passing inode
> down there.  How about this:

Well, that just reverts to the old state, so it certainly will work.
But isn't it much nicer to try to keep the shared logic - including
the BUG_ON() - in do_follow_link().

Sure, it means that we have to pass in 'inode', but that's largely
free (just about everything passes three arguments in registers), and
we could eventually decide that we don't need the BUG_ON() any more
and then drop it.

So I don't see the point of duplicating logic just to remove the
(almost free) inode argument.

Does it make tons of conceptual sense to pass in 'inode' to
do_follow_link? No, it's clearly redundant information, which is the
whole point of the BUG_ON(). But it does allow that extra shared
sanity test, and we _could_ also then do

  -       if (!IS_ERR(cookie) && path->dentry->d_inode->i_op->put_link)
  -               path->dentry->d_inode->i_op->put_link(path->dentry,
nd, cookie);
  +       if (!IS_ERR(cookie) && inode->i_op->put_link)
  +               inode->i_op->put_link(path->dentry, nd, cookie);

since we've verified that 'inode' is 'path->dentry->d_inode', and all
of those should be stable over all the calls (in the non-RCU case,
which we are in).

I dunno. I don't care _deeply_, but I do have to say that I much liked
how you moved the

    if (nameidata_dentry_drop_rcu_maybe(nd, path->dentry))
      ..

into do_follow_link(). I think it made it clearer that do_follow_link
(and __do_follow_link()) aren't done with RCU.

But whatever.

                  Linus
