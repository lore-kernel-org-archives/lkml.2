Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0EZVtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:49:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753378Ab0EZVtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:49:00 -0400
Date: Wed, 26 May 2010 14:48:42 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Message-ID: <20100526214842.GA27908@suse.de>
References: <1FB5E1D5CA062146B38059374562DF7266B8C4AC@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100526205134.GC7343@suse.de>
 <1FB5E1D5CA062146B38059374562DF7266B8C72B@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF7266B8C72B@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 09:25:31PM +0000, Haiyang Zhang wrote:
> > From: Greg KH [mailto:gregkh@suse.de]
> > > +	static atomic_t ic_channel_initcnt = ATOMIC_INIT(0);
> > Why is this an atomic_t?
> 
> As discussed previously, I used atomic_t to handle more general case 
> if vmbus interrupts happen on every cpu.

Ok, but then you should use a lock to protect the variable, not an atomic_t.

> 
> > > +			    VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
> > > +					     2 * PAGE_SIZE, NULL, 0,
> > > +					     hv_cb_utils[cnt].callback,
> > > +					     newChannel) == 0) {
> > > +				hv_cb_utils[cnt].channel = newChannel;
> > > +				mb();
> > 
> > What is the mb() call for?  Why is it necessary?  (hint, if you need it,
> > something else is really wrong...)
> 
> It ensures the channel assignment happens before the wakeup call: 
> osd_WaitEventSet(ic_channel_ready), if the compiler optimization re-arrange 
> the execution order. 

If you care about this, because some other thread is looking at it, then
you really need to protect it with a lock.  Don't rely on a mb() to get
it all correct for you (hint, I doubt it will...)

> > Something wierd happened with your indentation here, it doesn't line up
> > properly.  That call to VmbusChannelOpen() needs to go in a full tab,
> > not 4 spaces.
> > 
> > Please always run your patch through the checkpatch.pl script before
> > sending it to me.
> 
> Sure, I will replace it with TAB. I already ran checkpatch.pl on 
> this patch -- no error:
> staging-next-2.6> scripts/checkpatch.pl 0525-Fix-race-condition-on-IC-channel-initialization.patch
> total: 0 errors, 0 warnings, 71 lines checked
> 
> 0525-Fix-race-condition-on-IC-channel-initialization.patch has no obvious style problems and is ready for submission.

Looks like a bug in checkpatch.pl, go poke Andy about that please.

> > > +struct osd_waitevent *ic_channel_ready;
> > 
> > What's with the "ic_" naming scheme here?  It should be "hv_" right?
> 
> IC stands for "integration components", such as Shutdown, Timesync, 
> Heartbeat, etc.

Yes, I know what it stands for, but the rest of the world doesn't :)

> > As you are using this "ic_channel_ready variable only within the
> > vmbus_bus_init() call, why not just make it local to there?  Then
> > there's no need to do the create/init/wait/free sequence outside the
> > init call.
> > 
> > The init call should just do all of this for us, right?
> 
> The ic_channel_ready variable is called by VmbusChannelProcessOffer /
> osd_WaitEventSet(ic_channel_ready) to wake up vmbus_init(). So it's
> not a local variable.

But again, this logic should be within the init call, as it's part of
the proper init sequence.  So just put it in that call please.

thanks,

greg k-h
