Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0GVIHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:07:14 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:20752 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab0GVIHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:07:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAF+XR0x5Lc6U/2dsb2JhbACfdXLAfoU2BA
Date: Thu, 22 Jul 2010 18:07:06 +1000
From: Nick Piggin <npiggin@suse.de>
To: Tero.Kristo@nokia.com
Cc: dedekind1@gmail.com, npiggin@suse.de, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
Message-ID: <20100722080706.GB9377@amd>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
 <20100722031922.GA3446@amd>
 <1279781304.3044.12.camel@localhost>
 <1F18D6510CF0474A8C9500565A7E41A22D4D24C4C2@NOK-EUMSG-02.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1F18D6510CF0474A8C9500565A7E41A22D4D24C4C2@NOK-EUMSG-02.mgdnok.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 09:22:16AM +0200, Tero.Kristo@nokia.com wrote:
> >-----Original Message-----
> >From: Artem Bityutskiy [mailto:dedekind1@gmail.com]
> >Sent: 22 July, 2010 09:48
> >To: Nick Piggin; Kristo Tero (Nokia-MS/Tampere)
> >Cc: Jens Axboe; linux-fsdevel@vger.kernel.org; linux-
> >kernel@vger.kernel.org
> >Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
> >wakeups
> >
> >Hi Nick,
> >
> >On Thu, 2010-07-22 at 13:19 +1000, Nick Piggin wrote:
> >> >  out:
> >> >  	spin_unlock(&inode_lock);
> >> > +
> >> > +	if (wakeup_bdi) {
> >> > +		spin_lock(&bdi->wb_lock);
> >> > +		if (!bdi->wb.task)
> >> > +			wake_up_process(default_backing_dev_info.wb.task);
> >> > +		else
> >> > +			wake_up_process(bdi->wb.task);
> >> > +		spin_unlock(&bdi->wb_lock);
> >> > +	}
> >> >  }
> >>
> >> We really want to wake up the bdi right away when first dirtying
> >> the inode? I haven't looked at where the state of the bdi code is
> >> now, but isn't it better to have a a delay there?
> >
> >Yes, I guess we want to wake up the bdi thread after 5 secs (assuming
> >default settings). I could implement a "wake_up_process_delayed"
> >function which would use a timer, but I think it is not necessary to
> >introduce these complications. We can just wake-up the bdi thread, it'll
> >find out there is nothing to do, and will go sleep for 5 secs. I think
> >this is good enough.
> >
> >IOW, delayed wake-up is not worth the trouble.
> >
> >> And rather than spreading details of how bdi tasks are managed
> >> would you consider putting this into its own function?
> >
> >Sure, will do.
> >
> >> Other than that, I like your patches.
> >
> >Thanks :-)
> >
> >>  Out of interest, is 5 seconds
> >> very detremental to power usage? What is a reasonable goal for
> >> wakeups? (eg. 95%+ of possible efficiency)
> >
> >I cannot tell for sure. In Nokia N900 phone we use OMAP3 and we have
> >dynamic OFF-mode, so we switch off the CPU and peripherals completely
> >when there is nothing to do, and SDRAM stays in low-power auto-refresh
> >mode. Every useless wake-up makes us do a lot of job re-constructing the
> >CPU state. I cannot tell the numbers, but I'm CCing Tero, who is working
> >on OMAP3 PM and makes a lot of battery current measurements, he can
> >provide some numbers.
> 
> Well, it is hard to give any good guidelines here, as it really
> depends on the device architecture, possible power saving modes etc.,
> but I can give some sort of guestimate. Basically I think kernel
> should not generate any extra wakeups at all if it is not doing
> "anything too useful". In ideal world, everything should be interrupt
> driven as much as possible, and we would only have timers for things
> that are clearly visible for user, or can cause some sort of failure
> if neglected. Like if we ignore watchdogs, the device will reset
> itself.
> 
> 5 seconds by itself is not that bad, the reason we want to get rid of
> these is that every single wakeup source cumulates. If we have 2
> wakeups occurring at 5 second intervals and they are not synced, we
> effectively can wakeup every 2.5 seconds and so on. I guess a good
> target is to have 1 device level wakeup every 30 seconds or so, but
> due to cumulation, I tend to complain about anything that happens more
> often than once a minute.

Thanks, I'm just interested in a rough idea. I agree that it would be
better to eliminate polling timeouts completely where possible.

