Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab2FTPOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:14:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54964 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab2FTPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:14:00 -0400
Date: Wed, 20 Jun 2012 08:13:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mandeep Singh Baines <mandeep.baines@gmail.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mandeep Singh Baines <msb@chromium.org>, linux-pm@vger.kernel.org,
        stable@kernel.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Colin Cross <ccross@android.com>, Sameer Nanda <snanda@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous suspend
 after abort
Message-ID: <20120620151355.GC13770@kroah.com>
References: <1340158627-7586-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.44L0.1206201046020.1804-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206201046020.1804-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 10:58:25AM -0400, Alan Stern wrote:
> On Tue, 19 Jun 2012, Mandeep Singh Baines wrote:
> 
> > __device_suspend() must always send a completion. Otherwise, parent
> > devices will wait forever.
> > 
> > Commit 1e2ef05b, "PM: Limit race conditions between runtime PM and
> > system sleep (v2)", introduced a regression by short-circuiting the
> > complete_all() for certain error cases.
> > 
> > This patch fixes the bug by always signalling a completion.
> > 
> > Addresses http://crosbug.com/31972
> > 
> > Tested by injecting an abort via the following patch:
> > 
> > diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
> > index a004db3..e5a6fce 100644
> > --- a/drivers/usb/core/hcd-pci.c
> > +++ b/drivers/usb/core/hcd-pci.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/pci.h>
> >  #include <linux/usb.h>
> >  #include <linux/usb/hcd.h>
> > +#include <linux/string.h>
> > 
> >  #include <asm/io.h>
> >  #include <asm/irq.h>
> > @@ -477,6 +478,8 @@ static int resume_common(struct device *dev, int event)
> > 
> >  static int hcd_pci_suspend(struct device *dev)
> >  {
> > +       if (!strcmp("0000:00:1d.3", dev_name(dev)))
> > +               return -EBUSY;
> >         return suspend_common(dev, device_may_wakeup(dev));
> >  }
> 
> When you include one patch in front of another like this, doesn't it 
> confuse the automatic tools?  You might end up getting both changes 
> include in the final commit.  :-)

Yeah, that's going to mess with quilt big time, I don't know what git is
going to do with it, it should be interesting to see...

greg k-h
