Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab1KQFFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 00:05:07 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:47893 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714Ab1KQFFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 00:05:05 -0500
Date: Thu, 17 Nov 2011 10:34:43 +0530
From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
To: Vinod Koul <vkoul@infradead.org>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] dmaengine/ste_dma40: support pm in dma40
Message-ID: <20111117050443.GA6256@bnru01>
References: <1321425003-12062-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
 <1321441623.1516.168.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321441623.1516.168.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 12:07:03 +0100, Vinod Koul wrote:
> On Wed, 2011-11-16 at 12:00 +0530, Narayanan G wrote:
> 
> when you fix something in patch usually convention is to reply in same
> thread and not new one!
> 
> >                               desc = d;
> > -                             memset(desc, 0, sizeof(*desc));
> > +                             memset(desc, 0, sizeof(struct d40_desc));
> Bogus changes, previous one is better

Will revert this change.

> > +static void d40_power_off(struct d40_base *base, int phy_num)
> > +{
> > +     u32 gcc;
> > +     int i;
> > +     int j;
> > +     int p;
> this is just waste of line; int 1, j p; would make sense as well
> do consider them naming to something more meaningful as well

OK. Will correct this.

> > +
> > +     /*
> > +      * Disable the rest of the code for v1, because of GCC register HW bugs
> > +      * which are not worth working around.
> last time I had questioned this one too?

Yes! I have changed the unconditional return to make it return only
for v1 H/W.

> > +      */
> > +     if (base->rev == 1)
> > +             return;
> > +
> > +
> > +     spin_lock_irqsave(&d40c->base->usage_lock, flags);
> > +
> > +     d40_power_off(d40c->base, d40c->phy_chan->num);
> if this does what it says then it is wrong.
> power_off should be done in your suspend callbacks.
> same for on as well!!

Actually, we need to switch off the clocks for the event groups,
that are not in use. Say, if only evengroup 2 is active, the other
clocks can be switched off. The clocks for the unused event lines
need not be on till the runtime suspend is called. May be, I should
rename this function as d40_power_off_evt_grp(). 

> > -             d40c->busy = true;
> > +             if (!d40c->busy) {
> > +                     d40_usage_inc(d40c);
> > +                     d40c->busy = true;
> > +             }
> well here is problem!
> You don't need to check busy here, juts call pm_runtime_get(). Power on
> will be take care if it requires resume in your resume callback. No need
> to have checks of busy. You are not properly utilizing functionality
> provided by runtime_pm

I have this usage_inc() function mainly for switching on and off the
clocks for the desired event groups. The busy check here is to ensure
that we don't need to do the usage_inc() (clock management) in case it is
already on. 
Is there a way to do this clock management at eventline granularity
using the pm_runtime() framework?

> > +     pm_runtime_irq_safe(base->dev);
> > +     pm_runtime_set_autosuspend_delay(base->dev, DMA40_AUTOSUSPEND_DELAY);
> > +     pm_runtime_use_autosuspend(base->dev);
> > +     pm_runtime_enable(base->dev);
> > +     pm_runtime_resume(base->dev);
> seriously we need so many calls to initialize?

The autosuspend_delay and irq_safe are causing the extra calls.
I think we need this.

Thanks,

Narayanan
