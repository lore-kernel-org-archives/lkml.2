Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2GQNqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:46:00 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:41275 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab2GQNp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:45:59 -0400
Date: Tue, 17 Jul 2012 13:46:13 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mtk@lwn.net
Subject: Re: [patch] Rename CAP_EPOLLWAKEUP to CAL_BLOCK_SUSPEND
Message-ID: <20120717134613.GA30892@mail.hallyn.com>
References: <5004EBF9.3040406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5004EBF9.3040406@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Kerrisk (mtk.manpages@gmail.com):
> Rafael,
> 
> As discussed in
> http://thread.gmane.org/gmane.linux.kernel/1249726/focus=1288990,
> the capability introduced in 4d7e30d98939a0340022ccd49325a3d70f7e0238
> to govern EPOLLWAKEUP seems misnamed: this capability is about governing
> the ability to suspend the system, not using a particular API flag
> (EPOLLWAKEUP). We should make the name of the capability more general
> to encourage reuse in related cases. (Whether or not this capability
> should also be used to govern the use of /sys/power/wake_lock is a
> question that needs to be separately resolved.)
> 
> This patch renames the capability to CAP_BLOCK_SUSPEND. In order to ensure
> that the old capability name doesn't make it out into the wild, could you
> please apply and push up the tree to ensure that it is incorporated
> for the 3.5 release.
> 
> Thanks,
> 
> Michael
> 
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

I definately like that name better, thanks.  Don't know if renaming it
without an alias could cause trouble for some bleeding edge userspaces?
Would it be worth keeping the 

#define CAP_EPOLLWAKEUP      36

line?  If this is deemed early enough I do prefer not to complicate with
a duplicate name.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> 
> ---
>  fs/eventpoll.c             |    2 +-
>  include/linux/capability.h |    6 +++---
>  include/linux/eventpoll.h  |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 74598f6..1c8b556 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1710,7 +1710,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
>  		goto error_tgt_fput;
>  
>  	/* Check if EPOLLWAKEUP is allowed */
> -	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_EPOLLWAKEUP))
> +	if ((epds.events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
>  		epds.events &= ~EPOLLWAKEUP;
>  
>  	/*
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 68d56ef..d10b7ed 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -360,11 +360,11 @@ struct cpu_vfs_cap_data {
>  
>  #define CAP_WAKE_ALARM            35
>  
> -/* Allow preventing system suspends while epoll events are pending */
> +/* Allow preventing system suspends */
>  
> -#define CAP_EPOLLWAKEUP      36
> +#define CAP_BLOCK_SUSPEND    36
>  
> -#define CAP_LAST_CAP         CAP_EPOLLWAKEUP
> +#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
>  
>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>  
> diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
> index 6f8be32..f4bb378 100644
> --- a/include/linux/eventpoll.h
> +++ b/include/linux/eventpoll.h
> @@ -34,7 +34,7 @@
>   * re-allowed until epoll_wait is called again after consuming the wakeup
>   * event(s).
>   *
> - * Requires CAP_EPOLLWAKEUP
> + * Requires CAP_BLOCK_SUSPEND
>   */
>  #define EPOLLWAKEUP (1 << 29)
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
