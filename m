Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1AZPFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:05:23 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:56096 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1AZPFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:05:21 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 26 Jan 2011 07:05:07 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, shawn.bohrer@gmail.com,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        mm-commits@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch]
 epoll-fix-compiler-warning-and-optimize-the-non-blocking-path-fix
In-Reply-To: <20110126102020.GA2244@cmpxchg.org>
Message-ID: <alpine.DEB.2.00.1101260704050.1889@localhost6.localdomain6>
References: <201101260021.p0Q0LxsS016458@imap1.linux-foundation.org> <20110126102020.GA2244@cmpxchg.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Johannes Weiner wrote:

> The non-blocking ep_poll path optimization introduced skipping over
> the return value setup.
> 
> Initialize it properly, my userspace gets upset by epoll_wait()
> returning random things.
> 
> In addition, remove the reinitialization at the fetch_events label,
> the return value is garuanteed to be zero when execution reaches
> there.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
> Cc: Davide Libenzi <davidel@xmailserver.org>

Thank you for posting it. Obvious ACK.



> ---
>  fs/eventpoll.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index f7cb6cb..afe4238 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1147,7 +1147,7 @@ static int ep_send_events(struct eventpoll *ep,
>  static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  		   int maxevents, long timeout)
>  {
> -	int res, eavail, timed_out = 0;
> +	int res = 0, eavail, timed_out = 0;
>  	unsigned long flags;
>  	long slack = 0;
>  	wait_queue_t wait;
> @@ -1173,7 +1173,6 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  fetch_events:
>  	spin_lock_irqsave(&ep->lock, flags);
>  
> -	res = 0;
>  	if (!ep_events_available(ep)) {
>  		/*
>  		 * We don't have any available event to return to the caller.
> -- 
> 1.7.3.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
