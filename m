Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab0LRBTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:19:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756381Ab0LRBTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:19:01 -0500
Date: Fri, 17 Dec 2010 17:18:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCHv6 07/16] pps: move idr stuff to pps.c
Message-Id: <20101217171829.814a6be3.akpm@linux-foundation.org>
In-Reply-To: <20101218040738.64ab69f6@apollo.gnet>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<8f66dc7613bb4a7d34e6d76465df3bf6bb2f66a8.1292604060.git.lasaine@lvk.cs.msu.su>
	<20101217161328.457ac8e6.akpm@linux-foundation.org>
	<20101218040738.64ab69f6@apollo.gnet>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010 04:07:38 +0300
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> > > +	if (err < 0)
> > > +		return err;
> > 
> > The IDR interface really sucks :(
> > 
> > What this code should be doing is
> > 
> > retry:
> > 	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0)
> > 		return -ENOMEM;
> > 	spin_lock_irq(&pps_idr_lock);
> > 	err = idr_get_new(&pps_idr, pps, &pps->id);
> > 	spin_unlock_irq(&pps_idr_lock);
> > 	if (err < 0) {
> > 		if (err == -EAGAIN)
> > 			goto retry;
> > 		return err;
> > 	}
> > 
> > this way it correctly handles the case where the idr_pre_get()
> > succeeded in precharging the pool, but some other task cam in and stole
> > your reservation.
> 
> Yeah, I see. Maybe switching from spin lock to mutex and protecting the
> whole thing with it can do? Like this:
> 
> ...
> mutex_lock(&pps_idr_lock);
> if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
> 	mutex_unlock(&pps_idr_lock);
> 	return -ENOMEM;
> }
> err = idr_get_new(&pps_idr, pps, &pps->id);
> mutex_unlock(&pps_idr_lock);
> 
> if (err < 0)
> 	return err;
> ...

That works so, as long as no code path will take pps_idr_lock in the
page allocator direct-reclaim path.

That's unlikely to be happening in the PPS driver of course.  It's
conceivable that some filesystems might want to read the time when
playing with file timestamps in the direct-reclaim path, but I assume
pps_idr_lock wouldn't be taken on any read-system-time paths.

