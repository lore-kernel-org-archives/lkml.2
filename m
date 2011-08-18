Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1HRUaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:30:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49039 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752840Ab1HRUaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:30:15 -0400
Date: Thu, 18 Aug 2011 16:30:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] usb: gadget: get rid of USB_GADGET_DUALSPEED and
 USB_GADGET_SUPERSPEED
In-Reply-To: <op.v0fef7e2vgw7ix@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108181623390.1628-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011, Michal Nazarewicz wrote:

> usb_add_function() is called before usb_composite_probe() which only then
> calls usb_gadget_probe_driver().
> 
> What's more, if I understand it correctly, comment in usb_add_function()
> says that we support all the speeds usb_composite_driver structure claims
> we do but then return different sets of functions depending on speed.  Ie.
> if a function is only full speed and host requests high speed,  
> configuration
> will lack that function.  The comment in question is:
> 
> 	/* We allow configurations that don't work at both speeds.
> 	 * If we run into a lowspeed Linux system, treat it the same
> 	 * as full speed ... it's the function drivers that will need
> 	 * to avoid bulk and ISO transfers. */
> 
> usb_add_function() then proceeds to set config->fullspeed,  
> config->highspeed
> and config->superspeed depending on what descriptors function provides.

Have you misinterpreted that comment?  To me, it seems to be saying 
that the gadget should allow connections that are slower than the 
maximum supported speed.  But that's not what I'm talking about -- I'm 
suggesting that the gadget needs to avoid running faster than the 
maximum supported speed.

> Those are later used in config_desc() where it iterates over all
> configurations checking which have functions supporting given speed:
> 
> 	list_for_each_entry(c, &cdev->configs, list) {
> 		switch (speed) {
> 		case USB_SPEED_SUPER: if (!c->superspeed) continue; break;
> 		case USB_SPEED_HIGH: if (!c->highspeed) continue; break;
> 		default: if (!c->fullspeed) continue;
> 		}
> 		if (w_value == 0)
> 			return config_buf(c, speed, cdev->req->buf, type);
> 		w_value--;
> 	}
> 
> config_buf() at the same time, iterates over all functions and skips the  
> ones
> that do not provide descriptors for given speed:
> 
> 	list_for_each_entry(f, &config->functions, list) {
> 		switch (speed) {
> 		case USB_SPEED_SUPER: descriptors = f->ss_descriptors; break;
> 		case USB_SPEED_HIGH: descriptors = f->hs_descriptors; break;
> 		default: descriptors = f->descriptors;
> 		}
> 		if (!descriptors)
> 			continue;
> [...]
> 	}
> 
> So I think that your suggestion to use composite_driver.speed =
> driver->max_speed was by all means correct.

Okay, that line was probably all right, but it seems that something
else needs to be changed.  In a composite gadget, if none of the
function drivers support SuperSpeed then we don't want
composite_driver.speed to be set to USB_SPEED_SUPER.  It would be 
foolish to allow the UDC to connect at a speed which would make the 
gadget useless.

Alan Stern

