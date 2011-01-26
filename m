Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1AZPwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:52:36 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:53894 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1AZPwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:52:35 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 26 Jan 2011 07:52:23 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@localhost6.localdomain6
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sys_epoll_wait high CPU load in 2.6.37
In-Reply-To: <1296056600.2899.66.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1101260747320.1889@localhost6.localdomain6>
References: <20110126000932.GA23089@hostway.ca>  <1296026298.2633.19.camel@edumazet-laptop>  <1296040578.2899.59.camel@edumazet-laptop>  <alpine.DEB.2.00.1101260714280.1889@localhost6.localdomain6> <1296056600.2899.66.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463810047-1238437340-1296057151=:1889"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463810047-1238437340-1296057151=:1889
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 26 Jan 2011, Eric Dumazet wrote:

> Le mercredi 26 janvier 2011 à 07:31 -0800, Davide Libenzi a écrit :
> > On Wed, 26 Jan 2011, Eric Dumazet wrote:
> > 
> 
> > > diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> > > index cc8a9b7..7ec0890 100644
> > > --- a/fs/eventpoll.c
> > > +++ b/fs/eventpoll.c
> > > @@ -1126,7 +1126,9 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
> > >  
> > >  	if (timeout > 0) {
> > >  		ktime_get_ts(&end_time);
> > > -		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
> > > +		end_time.tv_sec += timeout / MSEC_PER_SEC;
> > > +		timeout %= MSEC_PER_SEC;
> > > +		timespec_add_ns(&end_time, timeout * NSEC_PER_MSEC);
> > >  		slack = select_estimate_accuracy(&end_time);
> > >  		to = &expires;
> > >  		*to = timespec_to_ktime(end_time);
> > 
> > Yep, we can overflow the timeout, with the calculation above.
> > A timespec_add_ms()?
> 
> Well, given timeout after modulo contains a number between 0 and 999,
> multiply by 1.000.000 (NSEC_PER_MSEC) cant overflow.

For "above", I meant the current epoll expire time calculation, which was 
described above in the message ;)
The hint for a timespec_add_ms() was because we must be doing something 
similar in poll, don't we (/me got no code in front ATM)?

---1463810047-1238437340-1296057151=:1889--
