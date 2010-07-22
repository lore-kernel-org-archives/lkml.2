Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0GVIF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:05:26 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:56892 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537Ab0GVIFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:05:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAF+XR0x5Lc6U/2dsb2JhbACfdXLAfoU2BA
Date: Thu, 22 Jul 2010 18:05:11 +1000
From: Nick Piggin <npiggin@suse.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, Kristo Tero Tapani <tero.kristo@nokia.com>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
Message-ID: <20100722080511.GA9377@amd>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
 <20100722031922.GA3446@amd>
 <1279781304.3044.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279781304.3044.12.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 09:48:24AM +0300, Artem Bityutskiy wrote:
> Hi Nick,
> 
> On Thu, 2010-07-22 at 13:19 +1000, Nick Piggin wrote:
> > >  out:
> > >  	spin_unlock(&inode_lock);
> > > +
> > > +	if (wakeup_bdi) {
> > > +		spin_lock(&bdi->wb_lock);
> > > +		if (!bdi->wb.task)
> > > +			wake_up_process(default_backing_dev_info.wb.task);
> > > +		else
> > > +			wake_up_process(bdi->wb.task);
> > > +		spin_unlock(&bdi->wb_lock);
> > > +	}
> > >  }
> > 
> > We really want to wake up the bdi right away when first dirtying
> > the inode? I haven't looked at where the state of the bdi code is
> > now, but isn't it better to have a a delay there?
> 
> Yes, I guess we want to wake up the bdi thread after 5 secs (assuming
> default settings). I could implement a "wake_up_process_delayed"
> function which would use a timer, but I think it is not necessary to
> introduce these complications. We can just wake-up the bdi thread, it'll
> find out there is nothing to do, and will go sleep for 5 secs. I think
> this is good enough.
> 
> IOW, delayed wake-up is not worth the trouble.

I can see what you mean, but I think the designs in core code should
be made as efficient as possible _unless_ there is some complication
in doing otherwise (not the other way around).

This is producing 2 unrequired context switches, so I really would
like to see it done properly. Setting up a timer is really pretty
simple (or if you would care to implement a delayed process wakeup
API, I think that would be useful -- I'm surprised there isn't one
already).

 
> > And rather than spreading details of how bdi tasks are managed
> > would you consider putting this into its own function?
> 
> Sure, will do.
> 
> > Other than that, I like your patches.
> 
> Thanks :-)
> 
> >  Out of interest, is 5 seconds
> > very detremental to power usage? What is a reasonable goal for
> > wakeups? (eg. 95%+ of possible efficiency)
> 
> I cannot tell for sure. In Nokia N900 phone we use OMAP3 and we have
> dynamic OFF-mode, so we switch off the CPU and peripherals completely
> when there is nothing to do, and SDRAM stays in low-power auto-refresh
> mode. Every useless wake-up makes us do a lot of job re-constructing the
> CPU state. I cannot tell the numbers, but I'm CCing Tero, who is working
> on OMAP3 PM and makes a lot of battery current measurements, he can
> provide some numbers.
