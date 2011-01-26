Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1AZSGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:06:49 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:53540 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1AZSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:06:48 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 26 Jan 2011 10:06:28 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: sys_epoll_wait high CPU load in 2.6.37
In-Reply-To: <1296064311.2899.90.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1101261001550.14705@localhost6.localdomain6>
References: <20110126000932.GA23089@hostway.ca>  <1296026298.2633.19.camel@edumazet-laptop>  <1296040578.2899.59.camel@edumazet-laptop>  <alpine.DEB.2.00.1101260714280.1889@localhost6.localdomain6>  <1296056600.2899.66.camel@edumazet-laptop> 
 <alpine.DEB.2.00.1101260747320.1889@localhost6.localdomain6>  <1296057590.2899.73.camel@edumazet-laptop>  <1296058409.2899.81.camel@edumazet-laptop>  <20110126172006.GA9568@BohrerMBP.rgmadvisors.com> <1296064311.2899.90.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011, Eric Dumazet wrote:

> > > --- a/fs/eventpoll.c
> > > +++ b/fs/eventpoll.c
> > > @@ -1125,8 +1125,8 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
> > >  	ktime_t expires, *to = NULL;
> > >  
> > >  	if (timeout > 0) {
> > > -		ktime_get_ts(&end_time);
> > > -		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
> > > +		poll_select_set_timeout(&end_time, timeout / MSEC_PER_SEC,
> > > +				NSEC_PER_MSEC * (timeout % MSEC_PER_SEC));
> > >  		slack = select_estimate_accuracy(&end_time);
> > >  		to = &expires;
> > >  		*to = timespec_to_ktime(end_time);
> > 
> > poll_select_set_timeout() jumps through some extra hoops that
> > aren't necessary in the epoll case so I actually like your previous
> > patch better.
> 
> Well, I dont care, I let Davide decide, he is the boss ;)
> 
> This is a stable candidate, so adding timespec_add_ms() sounds overkill.

Eric, if you look at fs/select.c (~line 925), poll does exactly the same 
thing as epoll do.
It too, ignores the eventual return value of poll_select_set_timeout(), so 
maybe a little bit more optimized ktime_get_ts+timespec_add_ms could make 
sense.


- Davide


