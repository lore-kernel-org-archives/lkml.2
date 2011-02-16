Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1BPQGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:06:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49169 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1BPQGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:06:46 -0500
Date: Wed, 16 Feb 2011 16:06:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc5
Message-ID: <20110216160643.GE22723@ZenIV.linux.org.uk>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
 <1297854842.3201.197.camel@edumazet-laptop>
 <AANLkTimnLPF0wz+ya-Wj1U1hQjPJpUhmL893OxBWqZYM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimnLPF0wz+ya-Wj1U1hQjPJpUhmL893OxBWqZYM@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 07:46:20AM -0800, Linus Torvalds wrote:
> On Wed, Feb 16, 2011 at 3:14 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > Using this kernel on my dev machine (2x4x2 cpus), I hit BUG_ON() in
> > fs/namei.c:1461 on my kernel build (make -j16)
> 
> Uhhuh. We replaced one BUG_ON() with another.
> 
> And I think it's a really silly problem too: when Al moved the
> 
>         /* We drop rcu-walk here */
>         if (nameidata_dentry_drop_rcu_maybe(nd, path->dentry))
>                 return -ECHILD;
> 
> test into do_follow_link(), he _should_ have moved the BUG_ON() in
> there too, methinks. He didn't, and as a result the BUG_ON() is now
> before the "drop_rcu_maybe".
> 
> This patch should fix it. Al? Comments?

Sigh...  I see what's going on.  We'd got inode from dentry that is getting
crapped under us.  We will *not* survive dropping RCU - it's bad enough for
full restart in normal mode.  So right after we'd seen that (already wrong)
inode has ->follow_link(), we decide to drop RCU.  Originally this BUG_ON
hadn't been reached in that case - we had already failed with -ECHILD before
we got to it.  Now we don't...

_However_, I don't like passing inode to do_follow_link().  I'd rather set
nd->inode to inode first and use it there.  Let me think a bit and see if
it's feasible...
