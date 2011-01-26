Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab1AZRUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:20:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41428 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1AZRUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:20:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Ye/oQ7IyTiBVcdxsQERIzt47TrfIjTmsq5R8+8v8exF2IdkgvIY2T++ZgV8URoD/t3
         rx7xfl6DNnZPrnS+JiuhFNBx5W0y2T1HeQvjL+EPpJ5dVh6AvRwompmhZWTqbvkZXuEM
         0lqdTRCBazkAW2ZkfN5ycoy9q+qXfySHGrWic=
Date: Wed, 26 Jan 2011 11:20:06 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: sys_epoll_wait high CPU load in 2.6.37
Message-ID: <20110126172006.GA9568@BohrerMBP.rgmadvisors.com>
References: <20110126000932.GA23089@hostway.ca>
 <1296026298.2633.19.camel@edumazet-laptop>
 <1296040578.2899.59.camel@edumazet-laptop>
 <alpine.DEB.2.00.1101260714280.1889@localhost6.localdomain6>
 <1296056600.2899.66.camel@edumazet-laptop>
 <alpine.DEB.2.00.1101260747320.1889@localhost6.localdomain6>
 <1296057590.2899.73.camel@edumazet-laptop>
 <1296058409.2899.81.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1296058409.2899.81.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 05:13:29PM +0100, Eric Dumazet wrote:
> Le mercredi 26 janvier 2011 à 16:59 +0100, Eric Dumazet a écrit :
> > Le mercredi 26 janvier 2011 à 07:52 -0800, Davide Libenzi a écrit :
> > 
> > > For "above", I meant the current epoll expire time calculation, which was 
> > > described above in the message ;)
> > 
> > Well, problem was not an overflow, but doing a loop 2.000.000 times ;)
> > 
> > > The hint for a timespec_add_ms() was because we must be doing something 
> > > similar in poll, don't we (/me got no code in front ATM)?
> > 
> > Apparently its done differently in poll(), using
> > poll_select_set_timeout() helper.
> > 
> > 
> > Give me some minutes I'll try to cook an alternate patch
> > 
> 
> Here is the alternate patch, using poll_select_set_timeout() helper
> 
> Thanks
> 
> [PATCH v2] epoll: epoll_wait() should not use timespec_add_ns()
> 
> commit 95aac7b1cd224f (epoll: make epoll_wait() use the hrtimer range
> feature) added a performance regression because it uses
> timespec_add_ns() with potential very large 'ns' values.
> 
> Use poll_select_set_timeout() helper like poll()/select()
> 
> Reported-by: Simon Kirby <sim@hostway.ca>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Shawn Bohrer <shawn.bohrer@gmail.com>
> CC: Davide Libenzi <davidel@xmailserver.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> ---
>  fs/eventpoll.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index cc8a9b7..94d887b 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1125,8 +1125,8 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
>  	ktime_t expires, *to = NULL;
>  
>  	if (timeout > 0) {
> -		ktime_get_ts(&end_time);
> -		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
> +		poll_select_set_timeout(&end_time, timeout / MSEC_PER_SEC,
> +				NSEC_PER_MSEC * (timeout % MSEC_PER_SEC));
>  		slack = select_estimate_accuracy(&end_time);
>  		to = &expires;
>  		*to = timespec_to_ktime(end_time);

poll_select_set_timeout() jumps through some extra hoops that
aren't necessary in the epoll case so I actually like your previous
patch better.

--
Shawn
