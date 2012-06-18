Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab2FRQHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:07:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41859 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752545Ab2FRQHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:07:11 -0400
Message-ID: <1340035630.2182.19.camel@joe2Laptop>
Subject: Re: [PATCH 3/5] usb: Convert dbg to pr_eliminated and pr_debug
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Jun 2012 09:07:10 -0700
In-Reply-To: <20120618152315.GB1050@kroah.com>
References: <cover.1339985626.git.joe@perches.com>
	 <25071de4def201f947780d6937b9732ccac3b3f0.1339985627.git.joe@perches.com>
	 <20120618152315.GB1050@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 08:23 -0700, Greg Kroah-Hartman wrote:
> On Sun, Jun 17, 2012 at 07:25:10PM -0700, Joe Perches wrote:
> > Change the dbg macro to use pr_eliminated when not
> > DEBUG and pr_debug with DEBUG so dynamic_debug can
> > be used.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  include/linux/usb.h |   12 +++++-------
> >  1 files changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/usb.h b/include/linux/usb.h
> > index f717fbd..56b88b8 100644
> > --- a/include/linux/usb.h
> > +++ b/include/linux/usb.h
> > @@ -1714,14 +1714,12 @@ extern void usb_register_notify(struct notifier_block *nb);
> >  extern void usb_unregister_notify(struct notifier_block *nb);
> >  
> >  #ifdef DEBUG
> > -#define dbg(format, arg...)						\
> > -	printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg)
> > +#define dbg(format, ...)						\
> > +	pr_debug("%s: " format "\n", __FILE__, ##__VA_ARGS__)
> 
> No, I really want to delete this macro entirely, and am slowly working
> toward that, moving drivers to use the correct dev_dbg() macro instead.

It'd be hard to replace it with only dev_dbg
as no struct device is always available.

And anyway, why go slowly?  Why not just do it?

There's 41 files / 1442 instances

$ git grep --name-only -E "^\s*#\s*include\s*[\<\"]linux/usb\.h[\>\"]" | \
	xargs grep -El "\bdbg\s*\("|wc -l
41
$ git grep --name-only -E "^\s*#\s*include\s*[\<\"]linux/usb\.h[\>\"]" | \
	xargs grep -E "\bdbg\s*\(" | wc -l
1442

There are also 5 redefinitions of dbg in there.

> > -#define dbg(format, arg...)						\
> > -do {									\
> > -	if (0)								\
> > -		printk(KERN_DEBUG "%s: " format "\n", __FILE__, ##arg); \
> > -} while (0)
> > +#define dbg(format, ...)						\
> > +	printk_eliminated(KERN_DEBUG "%s: " format "\n",		\
> > +			  __FILE__, ##__VA_ARGS)
> 
> As Paul pointed out, this breaks the build,

Yeah, Typos happen.

Paul's imagery was certainly colorful though a bit
umm, dispassionate. ;)


