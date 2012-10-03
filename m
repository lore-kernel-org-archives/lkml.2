Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab2JCQru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:47:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51470 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932206Ab2JCQrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:47:48 -0400
Date: Wed, 3 Oct 2012 12:47:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 25/25] USB: ohci: remove Alchemy OHCI platform driver.
In-Reply-To: <1349276601-8371-27-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1210031233090.1441-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Florian Fainelli wrote:

> All users have been converted to use the OHCI platform driver instead.
> The driver was also doing quirky things with the internal OHCI hcd
> structure during suspend/resume, work that is taken care of by the
> core OHCI code in ohci-hub.c.

This is highly questionable.  It depends on the platform's details (how
wakeup signals are transmitted).

> -#ifdef CONFIG_PM
> -static int ohci_hcd_au1xxx_drv_suspend(struct device *dev)
> -{
> -	struct usb_hcd *hcd = dev_get_drvdata(dev);
> -	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
> -	unsigned long flags;
> -	int rc;
> -
> -	rc = 0;
> -
> -	/* Root hub was already suspended. Disable irq emission and
> -	 * mark HW unaccessible, bail out if RH has been resumed. Use
> -	 * the spinlock to properly synchronize with possible pending
> -	 * RH suspend or resume activity.
> -	 */
> -	spin_lock_irqsave(&ohci->lock, flags);
> -	if (ohci->rh_state != OHCI_RH_SUSPENDED) {
> -		rc = -EINVAL;
> -		goto bail;
> -	}

This stuff about checking the root hub isn't needed.

> -	ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrdisable);
> -	(void)ohci_readl(ohci, &ohci->regs->intrdisable);
> -
> -	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);

But this stuff _is_ needed.

The right way to do this is to move the contents of ohci_pci_suspend()
and ohci_pci_resume() into ohci-hcd.c; call them ohci_suspend() and
ohci_resume().  The ohci_finish_controller_resume()  routine should be
merged into ohci_resume(); there's no reason to have two separate
functions for this.  Then the platform drivers can call these new
routines at the appropriate times.

The part about checking that the root hub is suspended can be removed.  
That bug hasn't shown up in years.

Alan Stern

