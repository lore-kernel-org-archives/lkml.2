Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab2BPClP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:41:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:25464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428Ab2BPClN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:41:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126062338"
Subject: Re: [PATCH] usb: enable pci MSI/MSIX in usb core
From: "Alex,Shi" <alex.shi@intel.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: stern@rowland.harvard.edu, Greg KH <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, andiry.xu@amd.com,
        linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Takashi Iwai <tiwai@suse.de>, trenn@suse.de, linux-pci@vger.kernel.org,
        Michal Marek <MMarek@suse.com>
In-Reply-To: <20120214002030.GA10364@xanatos>
References: <1328531341-22705-1-git-send-email-alex.shi@intel.com>
	 <4F311233.9070404@intel.com> <20120207144204.GA7214@kroah.com>
	 <20120207172743.GA4780@xanatos> <20120207221317.GA6103@xanatos>
	 <1328664392.12669.233.camel@debian> <1328682430.12669.443.camel@debian>
	 <1328692300.12669.593.camel@debian>  <20120214002030.GA10364@xanatos>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Feb 2012 10:36:41 +0800
Message-ID: <1329359801.12669.2872.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ugh, this is a giant patch.  It's too big for stable, and it adds new
> host controller driver APIs.  We can't do that for stable.

Yes, agree!
> > +		return 1;
> > +	} else if (!(hcd->driver->flags & HCD_MSI_FIRST))
> > +		return 1;
> 
> You don't need the else statement here, since you always return in the
> previous if block.

Correct! remove 'else' here make code more clear. 
> > +/* msi irq handler should be here, if driver has */
> > +irqreturn_t hcd_msi_irq(int irq, struct usb_hcd *hcd)
> > +{
> > +	return hcd->driver->irq(hcd);
> > +}
> 
> This works for now, but it isn't going to work in the future.  We need
> the USB core to provide us with the irq number so we can map the MSI-X
> interrupt to the event ring that generated the interrupt, whenever we
> get around to adding multiple event rings.
> 
> I think you need to add a new USB hcd callback for MSI/MSI-X vectors.  The
> xHCI usb_hcd can provide both pointers.
> 

Do you mean to add 2 new vectors for MSI/MSIX in hc_driver?
---
@@ -205,11 +212,14 @@ struct hc_driver {
 
        /* irq handler */
        irqreturn_t     (*irq) (struct usb_hcd *hcd);
+       irqreturn_t     (*msi_irq) (struct usb_hcd *hcd);
+       irqreturn_t     (*msix_irq) (struct usb_hcd *hcd);
 
        int     flags;
---
It is reasonable. When I written the code, I thought it may need
different MSI/MSIX irq handlers later for different driver. :) 

Actually, There is 2 ways to implement this vectors for detail. 
a, let driver's self code to do request_irq() for each of vectors for
MSI/MSIX, and hc_driver just has a simple hook for them.
b, do detailed request_irq() work in usb-core(in hcd-pci.c). 

Consider all pci MSI/MSIX interface is similar, we may prefer the second
way to save some code. 

What's opinions for above 2 ways? 

