Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1A1AR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 19:17:29 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42637 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1A1AR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 19:17:28 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Jan 2011 16:17:22 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: sys_epoll_wait high CPU load in 2.6.37
In-Reply-To: <1296067537.2899.153.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1101271615490.30861@localhost6.localdomain6>
References: <20110126000932.GA23089@hostway.ca>  <1296026298.2633.19.camel@edumazet-laptop>  <1296040578.2899.59.camel@edumazet-laptop>  <alpine.DEB.2.00.1101260714280.1889@localhost6.localdomain6>  <1296056600.2899.66.camel@edumazet-laptop> 
 <alpine.DEB.2.00.1101260747320.1889@localhost6.localdomain6>  <1296057590.2899.73.camel@edumazet-laptop>  <1296058409.2899.81.camel@edumazet-laptop>  <20110126172006.GA9568@BohrerMBP.rgmadvisors.com>  <1296064311.2899.90.camel@edumazet-laptop> 
 <alpine.DEB.2.00.1101261001550.14705@localhost6.localdomain6>  <1296065900.2899.108.camel@edumazet-laptop> <1296067537.2899.153.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-32887014-320500456-1296173847=:30861"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---32887014-320500456-1296173847=:30861
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 26 Jan 2011, Eric Dumazet wrote:

> Le mercredi 26 janvier 2011 à 19:18 +0100, Eric Dumazet a écrit :
> > Le mercredi 26 janvier 2011 à 10:06 -0800, Davide Libenzi a écrit :
> > 
> > > Eric, if you look at fs/select.c (~line 925), poll does exactly the same 
> > > thing as epoll do.
> > > It too, ignores the eventual return value of poll_select_set_timeout(), so 
> > > maybe a little bit more optimized ktime_get_ts+timespec_add_ms could make 
> > > sense.
> > > 
> > 
> > OK, I'll post a V3 ;)
> 
> Well in the poll() case we handle a zero timeout, not in epoll().
> 
> So the helper function cannot be shared and can be static to epoll.
> 
> 
> [PATCH v3] epoll: epoll_wait() should not use timespec_add_ns()
> 
> commit 95aac7b1cd224f (epoll: make epoll_wait() use the hrtimer range
> feature) added a performance regression because it uses
> timespec_add_ns() with potential very large 'ns' values.
> 
> Reported-by: Simon Kirby <sim@hostway.ca>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Shawn Bohrer <shawn.bohrer@gmail.com>
> CC: Davide Libenzi <davidel@xmailserver.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/eventpoll.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index cc8a9b7..d517aa3 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1114,6 +1114,17 @@ static int ep_send_events(struct eventpoll *ep,
>  	return ep_scan_ready_list(ep, ep_send_events_proc, &esed);
>  }
>  
> +static inline struct timespec epoll_set_mstimeout(long ms)
> +{
> +	struct timespec now, ts = {
> +		.tv_sec = ms / MSEC_PER_SEC,
> +		.tv_nsec = NSEC_PER_MSEC * (ms % MSEC_PER_SEC),
> +	};
> +
> +	ktime_get_ts(&now);
> +	return timespec_add_safe(now, ts);
> +}
> +
>  static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  		   int maxevents, long timeout)
>  {
> @@ -1121,12 +1132,11 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  	unsigned long flags;
>  	long slack;
>  	wait_queue_t wait;
> -	struct timespec end_time;
>  	ktime_t expires, *to = NULL;
>  
>  	if (timeout > 0) {
> -		ktime_get_ts(&end_time);
> -		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
> +		struct timespec end_time = epoll_set_mstimeout(timeout);
> +
>  		slack = select_estimate_accuracy(&end_time);
>  		to = &expires;
>  		*to = timespec_to_ktime(end_time);

Looks OK for me. The epoll_ prefix fights with the ep_ standard on the 
original file, but I will post a one-liner for it, given Andrew already 
got this.


- Davide


---32887014-320500456-1296173847=:30861--
