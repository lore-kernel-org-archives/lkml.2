Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab1KQF2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:28:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:39491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab1KQF2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:28:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,524,1315206000"; 
   d="scan'208";a="86268854"
Subject: Re: [PATCH] dmaengine/ste_dma40: support pm in dma40
From: Vinod Koul <vinod.koul@intel.com>
To: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
In-Reply-To: <20111117050443.GA6256@bnru01>
References: <1321425003-12062-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
	 <1321441623.1516.168.camel@vkoul-udesk3>  <20111117050443.GA6256@bnru01>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 10:53:52 +0530
Message-ID: <1321507432.1516.176.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 10:34 +0530, Narayanan G wrote:
> 
> > > +      */
> > > +     if (base->rev == 1)
> > > +             return;
> > > +
> > > +
> > > +     spin_lock_irqsave(&d40c->base->usage_lock, flags);
> > > +
> > > +     d40_power_off(d40c->base, d40c->phy_chan->num);
> > if this does what it says then it is wrong.
> > power_off should be done in your suspend callbacks.
> > same for on as well!!
> 
> Actually, we need to switch off the clocks for the event groups,
> that are not in use. Say, if only evengroup 2 is active, the other
> clocks can be switched off. The clocks for the unused event lines
> need not be on till the runtime suspend is called. May be, I should
> rename this function as d40_power_off_evt_grp(). 
> 
> > > -             d40c->busy = true;
> > > +             if (!d40c->busy) {
> > > +                     d40_usage_inc(d40c);
> > > +                     d40c->busy = true;
> > > +             }
> > well here is problem!
> > You don't need to check busy here, juts call pm_runtime_get(). Power
> on
> > will be take care if it requires resume in your resume callback. No
> need
> > to have checks of busy. You are not properly utilizing functionality
> > provided by runtime_pm
> 
> I have this usage_inc() function mainly for switching on and off the
> clocks for the desired event groups. The busy check here is to ensure
> that we don't need to do the usage_inc() (clock management) in case it
> is
> already on. 
> Is there a way to do this clock management at eventline granularity
> using the pm_runtime() framework? 
runtime pm manages the device power management. It will call your
suspend/resume callbacks when your device is idle/active and manages the
device usage for you.
Within your device you need to do your own management, which should be
linked to channel being active. You should not club the two.

I am not sure if the clock framework can help you on this

-- 
~Vinod

