Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1HPR7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:59:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab1HPR7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:59:38 -0400
Date: Tue, 16 Aug 2011 19:56:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Petr Vandrovec <petr@vandrovec.name>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 40/41] ncpfs: Use set_current_blocked()
Message-ID: <20110816175643.GI29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-41-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313071035-12047-41-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Matt Fleming wrote:
>
> As described in e6fa16ab ("signal: sigprocmask() should do
> retarget_shared_pending()") the modification of current->blocked is
> incorrect as we need to check whether the signal we're about to block
> is pending in the shared queue.

I'd wish I could understand this code but this seems impossible ;)
IOW, "This doesn't seem right at all." looks reasonable, and the
PF_EXITING adds even more confusion.

As for this patch, it looks (almost) fine anyway. But,

> @@ -749,7 +749,7 @@ static int ncp_do_request(struct ncp_server *server, int size,
>  		return -EIO;
>  	}
>  	{
> -		sigset_t old_set;
> +		sigset_t old_set, blocked;
>  		unsigned long mask, flags;
>  
>  		spin_lock_irqsave(&current->sighand->siglock, flags);
> @@ -769,16 +769,14 @@ static int ncp_do_request(struct ncp_server *server, int size,
>  			if (current->sighand->action[SIGQUIT - 1].sa.sa_handler == SIG_DFL)
>  				mask |= sigmask(SIGQUIT);
>  		}
> -		siginitsetinv(&current->blocked, mask);
> -		recalc_sigpending();
> +
> +		siginitsetinv(&blocked, mask);
> +		__set_task_blocked(current, &blocked);
>  		spin_unlock_irqrestore(&current->sighand->siglock, flags);

Why do we take ->siglock in the first place?

I think it is not needed. We can calculate mask/blocked lockless and
use set_task_blocked(). This also makes sense because __set_task_blocked
is not exported ;)

the sighand->action[] checks are racy anyway in the mt case, siglock
can't help.

Oleg.

