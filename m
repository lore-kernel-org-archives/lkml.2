Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab1A0PgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 10:36:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35629 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751012Ab1A0PgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 10:36:16 -0500
Date: Thu, 27 Jan 2011 10:36:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Yin Kangkai <kangkai.yin@intel.com>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: EHCI: fix scheduling while atomic during suspend
In-Reply-To: <1296119939-28732-1-git-send-email-kangkai.yin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1101271034490.2090-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Yin Kangkai wrote:

> There is a msleep with spin lock held during ehci pci suspend, which will
> cause kernel BUG: scheduling while atomic. Fix that.

> diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
> index 86f0815..a16c94a 100644
> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -111,14 +111,19 @@ static void ehci_adjust_port_wakeup_flags(struct ehci_hcd *ehci,
>  {
>  	int		port;
>  	u32		temp;
> +	unsigned long	flags;
> +
> +	spin_lock_irqsave(&ehci->lock, flags);
>  
>  	/* If remote wakeup is enabled for the root hub but disabled
>  	 * for the controller, we must adjust all the port wakeup flags
>  	 * when the controller is suspended or resumed.  In all other
>  	 * cases they don't need to be changed.
>  	 */
> -	if (!ehci_to_hcd(ehci)->self.root_hub->do_remote_wakeup || do_wakeup)
> +	if (!ehci_to_hcd(ehci)->self.root_hub->do_remote_wakeup || do_wakeup) {
> +		spin_unlock_irqrestore(&ehci->lock, flags);
>  		return;
> +	}

You should move the spin_lock_irqsave() down to here.  Then the 
spin_unlock_irqrestore() above won't be needed.

Alan Stern

