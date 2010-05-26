Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760Ab0EZWbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:31:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933673Ab0EZWbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:31:00 -0400
Date: Wed, 26 May 2010 15:30:53 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Message-ID: <20100526223053.GA23521@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7266B8C4AC@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100526205134.GC7343@suse.de>
 <1FB5E1D5CA062146B38059374562DF7266B8C72B@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100526214842.GA27908@suse.de>
 <1FB5E1D5CA062146B38059374562DF7266B8C775@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7266B8C775@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 10:23:08PM +0000, Haiyang Zhang wrote:
> > From: Greg KH [mailto:gregkh@suse.de]
> > > As discussed previously, I used atomic_t to handle more general case
> > > if vmbus interrupts happen on every cpu.
> > 
> > Ok, but then you should use a lock to protect the variable, not an
> > atomic_t.
> > If you care about this, because some other thread is looking at it,
> > then
> > you really need to protect it with a lock.  Don't rely on a mb() to get
> > it all correct for you (hint, I doubt it will...)
> 
> Actually, since the interrupts only happen on cpu0, this is not a
> concern. How about use a simple int variable here? Also, remove the
> mb().

How about a lock!

What's so scary about a pretty little semaphore?  They are all cute and
cuddley and don't bite anyone.  You should not be afraid to use them,
they are here to do your bidding.

> > > The ic_channel_ready variable is called by VmbusChannelProcessOffer /
> > > osd_WaitEventSet(ic_channel_ready) to wake up vmbus_init(). So it's
> > > not a local variable.
> > 
> > But again, this logic should be within the init call, as it's part of
> > the proper init sequence.  So just put it in that call please.
> 
> The VmbusChannelProcessOffer() is called from interrupt context, and
> initialize the channels, wake up vmbus_init when all channels are
> ready. If using local variable only, how to pass the channel ready
> info to vmbus_init() which is in a different context?

No, I mean move the logic you added here, into the vmbus_init() call.

thanks,

greg k-h
