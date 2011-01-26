Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1AZPn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:43:26 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34183 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1AZPnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:43:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L28wn9aANy0WporMPb+kayR6ZAxOnpB5fbYkGOX9VKAKdkxdoEwx8+4ZXXO3s83WgK
         hums2eiTOmeZP+RL4s1n4SHcSMvEeS/QbF8d04RHrXrDJDRy1VCrOR4OqIiBGFFle1lJ
         hPA0pEHHx0uLl/qUphddTBoZnhILlh5Dv10zY=
Subject: Re: sys_epoll_wait high CPU load in 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Bohrer <shawn.bohrer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1101260714280.1889@localhost6.localdomain6>
References: <20110126000932.GA23089@hostway.ca>
	 <1296026298.2633.19.camel@edumazet-laptop>
	 <1296040578.2899.59.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1101260714280.1889@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 16:43:20 +0100
Message-ID: <1296056600.2899.66.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 26 janvier 2011 à 07:31 -0800, Davide Libenzi a écrit :
> On Wed, 26 Jan 2011, Eric Dumazet wrote:
> 

> > diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> > index cc8a9b7..7ec0890 100644
> > --- a/fs/eventpoll.c
> > +++ b/fs/eventpoll.c
> > @@ -1126,7 +1126,9 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
> >  
> >  	if (timeout > 0) {
> >  		ktime_get_ts(&end_time);
> > -		timespec_add_ns(&end_time, (u64)timeout * NSEC_PER_MSEC);
> > +		end_time.tv_sec += timeout / MSEC_PER_SEC;
> > +		timeout %= MSEC_PER_SEC;
> > +		timespec_add_ns(&end_time, timeout * NSEC_PER_MSEC);
> >  		slack = select_estimate_accuracy(&end_time);
> >  		to = &expires;
> >  		*to = timespec_to_ktime(end_time);
> 
> Yep, we can overflow the timeout, with the calculation above.
> A timespec_add_ms()?

Well, given timeout after modulo contains a number between 0 and 999,
multiply by 1.000.000 (NSEC_PER_MSEC) cant overflow.



