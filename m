Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1DSOPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:15:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54065 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751692Ab1DSOPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:15:02 -0400
Date: Tue, 19 Apr 2011 10:14:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <roger.quadros@nokia.com>
cc: gregkh@suse.de, <mina86@mina86.com>, <m-sonasath@ti.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: gadget: composite: Allow function drivers to
 defer setup responses
In-Reply-To: <1303220033-5274-2-git-send-email-roger.quadros@nokia.com>
Message-ID: <Pine.LNX.4.44L0.1104191001590.1835-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011, Roger Quadros wrote:

> +/**
> + * usb_composite_setup_continue() - Continue the delayed setup transfer

You're should say "control transfer", not "setup transfer".  Control 
transfers consist of a setup stage, an optional data stage, and a 
status stage.  The setup stage has already ended by the time the 
function's setup handler is called.

> + * @cdev: the composite device who's setup transfer was delayed
> + *
> + * This function must be called by the USB function driver to continue
> + * with the setup transfer's data/status phase in case it had requested to

Data and Status are stages, not phases.  See section 8.5.3 of the
USB-2.0 spec.

You made these mistakes in a few different places throughout the patch.

> + * delay the status phase. A USB function's setup handler (e.g. set_alt())
> + * can request the composite framework to delay the setup request's status phase
> + * by returning USB_GADGET_DELAYED_STATUS.
> + */
> +void usb_composite_setup_continue(struct usb_composite_dev *cdev)
> +{
> +	int			value;
> +	struct usb_request	*req = cdev->req;
> +	unsigned long		flags;
> +
> +	DBG(cdev, "%s\n", __func__);
> +	spin_lock_irqsave(&cdev->lock, flags);
> +
> +	if (cdev->delayed_status == 0) {
> +		WARN(cdev, "%s: Unexpected call\n", __func__);
> +
> +	} else if (--cdev->delayed_status == 0) {
> +		DBG(cdev, "%s: Completing delayed status\n", __func__);
> +		req->length = 0;
> +		req->zero = 1;

There's no reason to set this flag.  It has no effect when req->length 
is 0.

Alan Stern

