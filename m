Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2FTWiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:38:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64939 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab2FTWiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:38:00 -0400
Date: Wed, 20 Jun 2012 15:37:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
Message-ID: <20120620223754.GA5864@kroah.com>
References: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
 <20120615220343.GA8928@kroah.com>
 <CACVXFVO6h6wiHdTwVcjQLNtncO+ezVX3RJZPVenHEmhHjErRhg@mail.gmail.com>
 <20120618222550.GB11737@kroah.com>
 <CACVXFVOr1mnjaEoGpc3O_MDuvi_KHTXtsEBQ7LLoaeWxWRa0aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVOr1mnjaEoGpc3O_MDuvi_KHTXtsEBQ7LLoaeWxWRa0aQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 10:00:36AM +0800, Ming Lei wrote:
> On Tue, Jun 19, 2012 at 6:25 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> 
> > Have you read Documentation/stable_kernel_patches.txt?  Please do so and
> 
> I haven't read Documentation/stable_kernel_patches.txt, but read
> Documentation/stable_kernel_rules.txt, :-)

Sorry, you are correct :)

> > see why I can't take this patch for a stable tree.  Note that no one has
> > ever reported this as a bug before, and the original poster ran away
> > never to be heard from again, so I really don't think it was a real
> > problem that people ever saw.
> 
> If Documentation/stable_kernel_rules.txt is the correct doc for stable rule,
> looks reporter requirement isn't listed in the file, but the below can be found:
> 
>           - No "theoretical race condition" issues, unless an explanation of
>          how the race can be exploited is also provided.
> 
> so I marked it as -stable because I have explained how the race can be
> exploited in reality.

Ok, but as this has been there since when, 2.5, I'll refrain from
marking it this way, as no one has reported a real problem like this
before.

> >> >> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> >> >> ---
> >> >> v2:
> >> >>       - take Alan's suggestion to use device_trylock to avoid
> >> >>       hanging during shutdown by buggy device or driver
> >> >>       - hold parent reference counter
> >> >>
> >> >>  drivers/base/core.c |   32 ++++++++++++++++++++++++++++++++
> >> >>  1 file changed, 32 insertions(+)
> >> >>
> >> >> diff --git a/drivers/base/core.c b/drivers/base/core.c
> >> >> index 346be8b..f2fc989 100644
> >> >> --- a/drivers/base/core.c
> >> >> +++ b/drivers/base/core.c
> >> >> @@ -1796,6 +1796,16 @@ out:
> >> >>  }
> >> >>  EXPORT_SYMBOL_GPL(device_move);
> >> >>
> >> >> +static int __try_lock(struct device *dev)
> >> >> +{
> >> >> +     int i = 0;
> >> >> +
> >> >> +     while (!device_trylock(dev) && i++ < 100)
> >> >> +             msleep(10);
> >> >> +
> >> >> +     return i < 100;
> >> >> +}
> >> >
> >> > That's a totally arbritary time, why does this work and other times do
> >> > not?  And what is this returning, if the lock was grabbed successfully?
> >>
> >>  It is a timeout time and is 1sec now. If the lock can't be held in 1sec, the
> >>  function will return 0, otherwise it will return 1 and indicates that the lock
> >>  has been held successfully.
> >
> > My point is why 1 second?  That's completly arbitrary and means nothing.
> 
> 1 second is a estimated value, just like many other timeout values in kernel.
> 
> For example, the timeout passed to usb_control_msg() is mostly estimated
> first, then may be adjusted later from some new report.
> 
> Another example is one recent xhci fix commit:
> 
> 622eb783fe(xHCI: Increase the timeout for controller save/restore state
> operation)
> 
> the timeout value is just increased arbitrarily to adapt new device.
> 
> I still have more many examples in kernel about timeout value...

Yes, I know this, but now you are putting a limit on the amount of time
a probe function can take, when before, we have never had one.  That's
not something to be taken lightly, and is one I know is not true.

> > Why not just do a real lock and try for forever?
> 
> IMO, there are two advantages not just doing a real lock for forever:
> 
> - avoiding buggy device/driver to hang the system
> - with trylock, we can log the buggy device so that it is a bit
> easier to troubleshoot the buggy drivers, suppose the bug is
> only triggered 1 time in one year or more

No, just fix the driver, I don't want to put a time limit on how long
probe can take, as we never have in the past and I'm sure that whatever
we pick, will be wrong for someone.

I have seen devices that take many seconds, and minutes for some if bad
things happen (i.e. the firmware doesn't download properly).  Don't
break people's working systems.

greg k-h
