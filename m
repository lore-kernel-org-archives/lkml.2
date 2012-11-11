Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2KKWJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 17:09:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:58012 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab2KKWJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 17:09:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,758,1344236400"; 
   d="scan'208";a="247319139"
Date: Sun, 11 Nov 2012 15:09:43 -0700
From: Jon Mason <jon.mason@intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] dmatest: Fix NULL pointer dereference on ioat
Message-ID: <20121111220943.GB20133@jonmason-lab>
References: <1352494660-6650-1-git-send-email-jon.mason@intel.com>
 <CAOh2x=mE8d1YtRy_Efqbtc+24SCgEYuKwVpFHrFZBTpt2CB08w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x=mE8d1YtRy_Efqbtc+24SCgEYuKwVpFHrFZBTpt2CB08w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 09:00:15AM +0530, viresh kumar wrote:
> On Sat, Nov 10, 2012 at 2:27 AM, Jon Mason <jon.mason@intel.com> wrote:
> > device_control is an optional and not implemented in all DMA drivers.
> > Any calls to these will result in a NULL pointer dereference.  dmatest
> > makes two of these calls when completing the kernel thread and removing
> > the module.  These are corrected by calling the dmaengine_device_control
> > wrapper and checking for a non-existant device_control function pointer
> > there.
> >
> > Signed-off-by: Jon Mason <jon.mason@intel.com>
> > CC: Vinod Koul <vinod.koul@intel.com>
> > CC: Dan Williams <djbw@fb.com>
> > ---
> >  drivers/dma/dmatest.c     |    4 ++--
> >  include/linux/dmaengine.h |    5 ++++-
> >  2 files changed, 6 insertions(+), 3 deletions(-)
> >
> 
> > diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> > index d3201e4..e0004fb 100644
> > --- a/include/linux/dmaengine.h
> > +++ b/include/linux/dmaengine.h
> > @@ -608,7 +608,10 @@ static inline int dmaengine_device_control(struct dma_chan *chan,
> >                                            enum dma_ctrl_cmd cmd,
> >                                            unsigned long arg)
> >  {
> > -       return chan->device->device_control(chan, cmd, arg);
> > +       if (chan->device->device_control)
> > +               return chan->device->device_control(chan, cmd, arg);
> > +       else
> > +               return -EINVAL;
> 
> -ENOTSUPP or -ENOSYS ??

ENOSYS makes more sense to me.  I'll send out another version shortly.

Dan, do you want me to send the patch to Greg KH for inclusion in the
stable branches back to v3.2?

Thanks,
Jon

> 
> @Dan: I believe i don't have to send another version now. Correct??
> 
> --
> viresh
