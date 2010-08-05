Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393Ab0HEQX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:23:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760095Ab0HEQXY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <m1d3txzfuq.fsf@fess.ebiederm.org>
References: <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> 
	<20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com> 
	<201008030055.o730tgXK091413@www262.sakura.ne.jp> <30552.1280828047@redhat.com> 
	<AANLkTikwM0+cxJqgQ+N_svzyyc+FKreO8XPr8oYNh6OU@mail.gmail.com> 
	<m1d3txzfuq.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Aug 2010 09:14:50 -0700
Message-ID: <AANLkTikavQKkvmdY5=8jh8KSV7vit=WcmDHWjnZfVWnv@mail.gmail.com>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner 
	comment
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 12:19 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> No.  When we send a signal to multiple processes it needs to be an
> atomic operation so that kill -KILL -pgrp won't let processes escape.
> It is what posix specifies, it is what real programs expect, and it
> is the useful semantic in userspace.

Ok. However, in that case, it's not really about the whole list
traversal, it's a totally separate thing, and it's really sad that we
end up using the (rather hot) tasklist_lock for something like that.
With the dcache/inode locks basically going away, I think
tasklist_lock ends up being one of the few hot locks left.

Wouldn't it be much nicer to:
 - make it clear that all the "real" signal locking can rely on RCU
 - use a separate per-pgrp lock that ends up being the one that gives
the signal _semantic_ meaning?

That would automatically document why we get the lock too, which
certainly isn't clear from the code as-is.

The per-pgrp lock might be something as simple as a silly hash that
just spreads out the process groups over some random number of simple
spinlocks.

> With the tasklist_lock the rule in these functions is that the caller
> will take the lock, so we probably make the rule the caller should
> take the lock in the same scenarios for the rcu_read_lock(). Aka just
> say:
>
> read_lock(&tasklist_lock);
> rcu_read_lock();
>
> everywhere, that today we say just:
>
> read_lock(&tasklist_lock);

I agree that we probably should have done that originally, in order to
not have these bugs show up later. However, I don't think it makes
sense any more, especially not if tasklist_lock isn't even a "real"
lock from a kernel internal consistency standpoint, but has a totally
secondary meaning.

                       Linus
