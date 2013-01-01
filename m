Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3AAVRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:17:31 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:35816 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3AAVR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:17:29 -0500
Date: Tue, 1 Jan 2013 21:17:28 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Jiri Olsa <jolsa@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Voellmy <andreas.voellmy@yale.edu>,
        "Junchang(Jason) Wang" <junchang.wang@yale.edu>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] poll: prevent missed events if _qproc is NULL
Message-ID: <20130101211728.GA13380@dcvr.yhbt.net>
References: <20121228014503.GA5017@dcvr.yhbt.net>
 <1356960060-1263-1-git-send-email-normalperson@yhbt.net>
 <1357065750.21409.12527.camel@edumazet-glaptop>
 <20130101210033.GA13255@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130101210033.GA13255@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > commit 626cf236608505d376e4799adb4f7eb00a8594af should not have this
> > side effect, at least for poll()/select() functions. The epoll() changes
> > I am not yet very confident.
> 
> I have a better explanation of the epoll problem below.
> 
> An alternate version (limited to epoll) would be:
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index cd96649..ca5f3d0 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1299,6 +1299,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
>  	 * Get current event bits. We can safely use the file* here because
>  	 * its usage count has been increased by the caller of this function.
>  	 */
> +	smp_mb();
>  	revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt);
>  
>  	/*
> 
> > I suspect a race already existed before this commit, it would be nice to
> > track it properly.
> 
> I don't believe this race existed before that change.

I was wrong, rereading 626cf236608505d376e4799adb4f7eb00a8594af,
I think this race existed before.

Perhaps my alternate patch above is a better fix.
