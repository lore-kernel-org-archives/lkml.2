Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab1EYOXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:23:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45973 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932913Ab1EYOXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:23:08 -0400
Date: Wed, 25 May 2011 10:23:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: balbi@ti.com, "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>,
        <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <01c601cc1acf$8e28e920$aa7abb60$@org>
Message-ID: <Pine.LNX.4.44L0.1105251010580.1987-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Tanya Brokhman wrote:

> Ok so just to make sure I understand you correctly:
> You want me to remove the modification made to usb_composite_probe() and
> instead add:
> static struct usb_gadget_driver composite_driver = {
> +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> +       .speed          = USB_SPEE_SUPER,
> +#else
> 	  .speed          = USB_SPEED_HIGH,
> +#endif
> 	  .unbind         = composite_unbind,
> 
> And then you'll be ok with change? Or is there anything else?
> 
> If this is it then I'm relieved :) and of course will update the code.

I have looked this over more carefully.  It turns out that both of you
have misunderstood the purpose of CONFIG_USB_GADGET_DUALSPEED (and by
extension, CONFIG_USB_GADGET_SUPERSPEED).  In fact, the existing
Kconfig file is also wrong.

The _only_ reason for CONFIG_USB_GADGET_DUALSPEED is so that gadget
drivers can use conditional compilation to avoid including the
high-speed descriptors when the UDC doesn't support high-speed 
operation.  That's all.  This means that the 
CONFIG_USB_GAGDET_DUALSPEED option does not need to be 
user-controllable in Kconfig.  It should default to N, and UDC drivers 
that support high speed should select it.

The same should be true of CONFIG_USB_GADGET_HIGHSPEED.  It should not
be user-controllable.  It should default to N, and UDC drivers that
support SuperSpeed operation (after these patches, only dummy-hcd)  
should select it.

There remains the other question, about whether composite_driver.speed
should be set to USB_SPEED_SUPER.  I think the matter can be settled at
runtime.  Iterate through all the function drivers; if all of them
support SuperSpeed and CONFIG_USB_GADGET_SUPERSPEED is enabled then set
composite_driver.speed to USB_SPEED_SUPER.  Otherwise, if all of them
support high speed and CONFIG_USB_GADGET_DUALSPEED is enabled then set
composite_driver.speed to USB_SPEED_HIGH.  Otherwise set it to
USB_SPEED_FULL.

Alan Stern

