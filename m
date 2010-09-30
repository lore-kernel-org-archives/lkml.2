Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab0I3INz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:13:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041Ab0I3INy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:13:54 -0400
Date: Thu, 30 Sep 2010 01:14:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] fs: inode per-cpu last_ino allocator
Message-Id: <20100930011417.6ca16ed7.akpm@linux-foundation.org>
In-Reply-To: <1285833189.2615.31.camel@edumazet-laptop>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-16-git-send-email-david@fromorbit.com>
	<20100929215312.5fcb6976.akpm@linux-foundation.org>
	<1285824982.5211.675.camel@edumazet-laptop>
	<1285833189.2615.31.camel@edumazet-laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 09:53:09 +0200 Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 30 septembre 2010 __ 07:36 +0200, Eric Dumazet a __crit :
> > Le mercredi 29 septembre 2010 __ 21:53 -0700, Andrew Morton a __crit :
> 
> > > > +static unsigned int last_ino_get(void)
> > > > +{
> > > > +	static unsigned int last_ino;
> > > > +
> > > > +	return ++last_ino;
> > > > +}
> > > 
> > > This is racy with CONFIG_PREEMPT on some architectures, I suspect.  I'd
> > > suggest conversion to atomic_t with, of course, an explanatory comment ;)
> > > 
> > 
> 
> In fact this code was OK when I submitted my original patch back in
> 2008, since it replaced fs/inode.c
> 
> 	inode->i_ino = ++last_ino;
> 
> And this was protected by a surrounding spinlock
> (spin_lock(&inode_lock); at that time)
> 
> Even after Nick patches, preemption is still disabled (by two
> spinlocks... spin_lock(&sb_inode_list_lock); /
> spin_lock(&inode->i_lock);)

You know, if it took you and me this long to work that out then perhaps
the code isn't quite as clear as we would like it to be, no?

I think you know what's coming next ;)

As a general rule, if a reviewer's comment doesn't result in a code
change then it should result in a changelog fix or a code comment. 
Because if the code wasn't clear enough to the reviewer then it won't be
clear enough to later readers.

> So patch 15/17 seems good to me, I re-sign it as-is ;)
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> 
> If it happens preemption is re-enabled later (with future patches), we
> might need to change last_ino_get() too.

Perhaps

	WARN_ON_ONCE(preemptible());

if we had a developer-only version of WARN_ON_ONCE, which we don't.
