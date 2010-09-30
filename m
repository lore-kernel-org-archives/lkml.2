Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0I3HxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 03:53:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34581 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab0I3HxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 03:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k+AXdqFQwOoHmvNl06SVOWPIf0ZrdUCy1Y7ERaueTktfcsppbP/BX8CWZ9cJPr5Vib
         L0ZfgNJCtUQWS8j1Us+fW4nKkcB+mLIOiA5KqQuxWU14kb7Rp+E7ypy7p2dIw4mDLuXy
         2EhyTSRQjCzqLxuKAs6p86ouPob6xlCR4zWs4=
Subject: Re: [PATCH 15/17] fs: inode per-cpu last_ino allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1285824982.5211.675.camel@edumazet-laptop>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-16-git-send-email-david@fromorbit.com>
	 <20100929215312.5fcb6976.akpm@linux-foundation.org>
	 <1285824982.5211.675.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 09:53:09 +0200
Message-ID: <1285833189.2615.31.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 07:36 +0200, Eric Dumazet a écrit :
> Le mercredi 29 septembre 2010 à 21:53 -0700, Andrew Morton a écrit :

> > > +static unsigned int last_ino_get(void)
> > > +{
> > > +	static unsigned int last_ino;
> > > +
> > > +	return ++last_ino;
> > > +}
> > 
> > This is racy with CONFIG_PREEMPT on some architectures, I suspect.  I'd
> > suggest conversion to atomic_t with, of course, an explanatory comment ;)
> > 
> 

In fact this code was OK when I submitted my original patch back in
2008, since it replaced fs/inode.c

	inode->i_ino = ++last_ino;

And this was protected by a surrounding spinlock
(spin_lock(&inode_lock); at that time)

Even after Nick patches, preemption is still disabled (by two
spinlocks... spin_lock(&sb_inode_list_lock); /
spin_lock(&inode->i_lock);)

So patch 15/17 seems good to me, I re-sign it as-is ;)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

If it happens preemption is re-enabled later (with future patches), we
might need to change last_ino_get() too.

Thanks !


