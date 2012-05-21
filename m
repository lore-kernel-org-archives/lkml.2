Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab2EUWLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:11:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50198 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357Ab2EUWLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:11:48 -0400
MIME-Version: 1.0
In-Reply-To: <201205212128.38157.rjw@sisk.pl>
References: <4FB81981.3050509@suse.cz>
	<4FBA4946.8080905@suse.cz>
	<201205212111.34800.rjw@sisk.pl>
	<201205212128.38157.rjw@sisk.pl>
Date: Mon, 21 May 2012 15:11:46 -0700
Message-ID: <CAMP5XgcOgpRmbVoWvZ0ZqVCKXuyOCrB1yrTUv=qhY1tsg+SUGA@mail.gmail.com>
Subject: Re: [PATCH] epoll: Fix user space breakage related to EPOLLWAKEUP
 (was: Re: [-next regression] TCP window full with EPOLLWAKEUP)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 12:28 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Commit 4d7e30d (epoll: Add a flag, EPOLLWAKEUP, to prevent
> suspend while epoll events are ready) caused some applications to
> malfunction, because they set the bit corresponding to the new
> EPOLLWAKEUP flag in their eventpoll flags and they don't have the
> new CAP_EPOLLWAKEUP capability.
>
> To prevent that from happening, change epoll_ctl() to clear
> EPOLLWAKEUP in epds.events if the caller doesn't have the
> CAP_EPOLLWAKEUP capability instead of failing and returning an
> error code, which allows the affected applications to function
> normally.
>
> Reported-and-tested-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  fs/eventpoll.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/fs/eventpoll.c
> ===================================================================
> --- linux.orig/fs/eventpoll.c
> +++ linux/fs/eventpoll.c
> @@ -1711,7 +1711,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
>
>        /* Check if EPOLLWAKEUP is allowed */
>        if ((epds.events & EPOLLWAKEUP) && !capable(CAP_EPOLLWAKEUP))
> -               goto error_tgt_fput;
> +               epds.events &= ~EPOLLWAKEUP;
>
>        /*
>         * We have to check that the file structure underneath the file descriptor

Is there any way for the application to detect that it did not get the
EPOLLWAKEUP feature?

-- 
Arve Hjønnevåg
