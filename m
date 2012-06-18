Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2FRQOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:14:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2FRQOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:14:50 -0400
Date: Mon, 18 Jun 2012 09:14:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] usb: Convert dbg to pr_eliminated and pr_debug
Message-ID: <20120618161445.GA17155@kroah.com>
References: <cover.1339985626.git.joe@perches.com>
 <25071de4def201f947780d6937b9732ccac3b3f0.1339985627.git.joe@perches.com>
 <20120618152315.GB1050@kroah.com>
 <1340035630.2182.19.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340035630.2182.19.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 09:07:10AM -0700, Joe Perches wrote:
> On Mon, 2012-06-18 at 08:23 -0700, Greg Kroah-Hartman wrote:
> > On Sun, Jun 17, 2012 at 07:25:10PM -0700, Joe Perches wrote:
> > > Change the dbg macro to use pr_eliminated when not
> > > DEBUG and pr_debug with DEBUG so dynamic_debug can
> > > be used.
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > ---
> > >  include/linux/usb.h |   12 +++++-------
> > >  1 files changed, 5 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/include/linux/usb.h b/include/linux/usb.h
> > > index f717fbd..56b88b8 100644
> > > --- a/include/linux/usb.h
> > > +++ b/include/linux/usb.h
> > > @@ -1714,14 +1714,12 @@ extern void usb_register_notify(struct notifier_block *nb);
> > >  extern void usb_unregister_notify(struct notifier_block *nb);
> > >  
> > >  #ifdef DEBUG
> > > -#define dbg(format, arg...)						\
> > > -	printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg)
> > > +#define dbg(format, ...)						\
> > > +	pr_debug("%s: " format "\n", __FILE__, ##__VA_ARGS__)
> > 
> > No, I really want to delete this macro entirely, and am slowly working
> > toward that, moving drivers to use the correct dev_dbg() macro instead.
> 
> It'd be hard to replace it with only dev_dbg
> as no struct device is always available.

Agreed, but for almost all cases, a USB driver does have a struct
device.  If it doesn't, odds are, the driver shouldn't be sending out
debug messages anyway :)

> And anyway, why go slowly?  Why not just do it?

I take it you didn't see the 200+ patches in 3.5-rc1 that did a lot of
this work already?  Is that slow?

> There's 41 files / 1442 instances
> 
> $ git grep --name-only -E "^\s*#\s*include\s*[\<\"]linux/usb\.h[\>\"]" | \
> 	xargs grep -El "\bdbg\s*\("|wc -l
> 41
> $ git grep --name-only -E "^\s*#\s*include\s*[\<\"]linux/usb\.h[\>\"]" | \
> 	xargs grep -E "\bdbg\s*\(" | wc -l
> 1442
> 
> There are also 5 redefinitions of dbg in there.

Yup, the usb-serial drivers have their own version as well.

It will happen, just give it a release or two to complete.

thanks,

greg k-h
