Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1BPQj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:39:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43755 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab1BPQjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:39:55 -0500
Date: Wed, 16 Feb 2011 16:39:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        npiggin@kernel.dk
Subject: Re: Linux 2.6.38-rc5
Message-ID: <20110216163951.GG22723@ZenIV.linux.org.uk>
References: <AANLkTi=Mc8O8cNWYOKgD0cESQhfa2jiHor11DBuagJDF@mail.gmail.com>
 <1297854842.3201.197.camel@edumazet-laptop>
 <AANLkTimnLPF0wz+ya-Wj1U1hQjPJpUhmL893OxBWqZYM@mail.gmail.com>
 <20110216160643.GE22723@ZenIV.linux.org.uk>
 <20110216161929.GF22723@ZenIV.linux.org.uk>
 <AANLkTi=8O1ZJZ2dWWwmcdV3G8LtrxSHWp=GgLxAYQE3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=8O1ZJZ2dWWwmcdV3G8LtrxSHWp=GgLxAYQE3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 08:33:32AM -0800, Linus Torvalds wrote:
> Does it make tons of conceptual sense to pass in 'inode' to
> do_follow_link? No, it's clearly redundant information, which is the
> whole point of the BUG_ON(). But it does allow that extra shared
> sanity test, and we _could_ also then do
> 
>   -       if (!IS_ERR(cookie) && path->dentry->d_inode->i_op->put_link)
>   -               path->dentry->d_inode->i_op->put_link(path->dentry,
> nd, cookie);
>   +       if (!IS_ERR(cookie) && inode->i_op->put_link)
>   +               inode->i_op->put_link(path->dentry, nd, cookie);
> 
> since we've verified that 'inode' is 'path->dentry->d_inode', and all
> of those should be stable over all the calls (in the non-RCU case,
> which we are in).
> 
> I dunno. I don't care _deeply_, but I do have to say that I much liked
> how you moved the
> 
>     if (nameidata_dentry_drop_rcu_maybe(nd, path->dentry))
>       ..
> 
> into do_follow_link(). I think it made it clearer that do_follow_link
> (and __do_follow_link()) aren't done with RCU.

OK, I can live with that.  Consider me convinced, let's go with your variant.
Speaking of ugliness: Nick, why the _fuck_ have you reverted non-create case
in do_filp_open() to do_path_lookup()?
