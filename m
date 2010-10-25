Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab0JYTC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:02:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58877 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406Ab0JYTC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:02:26 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18l3kG7aT1TijuuF89dWMxL
Date: Mon, 25 Oct 2010 12:02:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, Balaji T K <balajitk@ti.com>,
        "Kamat, Nishant" <nskamat@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
Message-ID: <20101025190221.GC7206@atomide.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com>
 <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
 <87bp6pviwf.fsf@deeprootsystems.com>
 <AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
 <8739s0sobc.fsf@deeprootsystems.com>
 <AANLkTikdjtYtzhgM_=io3SFdUZq=8Xcc8n24bW=SFgTA@mail.gmail.com>
 <20101022165612.GF9149@atomide.com>
 <AANLkTimysu4L+ecFvpGAQ0bj3fhLQC1cveWddFNNp=JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimysu4L+ecFvpGAQ0bj3fhLQC1cveWddFNNp=JQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ohad Ben-Cohen <ohad@wizery.com> [101024 10:45]:
> Hi Tony,
> 
> On Fri, Oct 22, 2010 at 6:56 PM, Tony Lindgren <tony@atomide.com> wrote:
> > Guys, let's try to come up with a generic interface for this instead of
> > polluting the device drivers with more omap specific interfaces.
> >
> > We really want to keep the drivers generic and platform independent.
> 
> I share this concern as well.
> 
> We basically have three options here:
> 
> 1. Have the hwspinlock driver inside the omap folders and use pdata func ptrs
> 2. Have a generic hwspinlock framework, with a small omap-specific
> implementation
> 3. Have a misc driver which is currently omap specific, but can very
> easily be converted to a common framework
> 
> I don't like (1) so much; it's a driver that has very little that is
> hardware specific (mainly just the two lines that actually access the
> hardware - the lock and the unlock), and it's growing. E.g., we will
> need to add it a user space interface (to allow userland IPC
> implementations), we will need to add it a "virtual" locks layer that
> would provide more locks than the hardware currently has, etc..
> 
> In addition, there seem to be a general discontent about drivers
> piling up in the ARM folders, instead of having them visible in
> drivers/ so they can become useful for other platforms as well.
> 
> Here's something Linus wrote about this awhile back:
> 
> http://www.spinics.net/lists/linux-arm-msm/msg00324.html
> 
> So initially I opted for (2). I have an implementation ready - it's a
> common drivers/hwspinlock/core.c framework with a small omap-specific
> part at drivers/hwspinlock/omap_hwspinlock.c. The core has all the
> logic while the latter, omap-specific implementation, is really small
> - it is basically just registering lock instances, that have a
> trylock/unlock/relax ops struct, with the common framework.
> 
> But lack of additional users (besides the OMAP hardware), and lack of
> generic drivers that would use it (we have syslink, which currently
> tend to only need this from user space, i2c-omap and omap's upcoming
> resource manager), made it look like an overkill for now.
> 
> So simplicity won, and (3) was eventually submitted. It exposes
> exactly the same interface like (2) would (s/omap_hwspin/hwspin/), and
> it's relatively easy to turn it back into a common framework in case
> additional users show up.
> 
> But if you feel that (2) is justifiable/desirable, I would be more
> than happy to submit that version.

Yes (2) please. I would assume there will be more use of this. And then
we (or probably me again!) don't have to deal with cleaning up the drivers
again in the future.
 
> > Unless somebody has better ideas, I suggest we pass a lock function
> > in the platform_data to the drivers that need it, and do the omap
> > specific nasty stuff in the platform code.
> 
> Do you mean (1) and then pass the whole bunch of APIs
> (request/free/lock variants/unlock/get_id) via pdata ?
> 
> Or do you mean a variation of (2) with only the specific locking bits
> coming from pdata func pointers ? I guess that in this case we just
> might as well go with the full (2).

Yes variation of (2) where you only pass the locking function via
platform data would be best.

Regards,

Tony
