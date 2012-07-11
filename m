Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2GKOYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:24:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52154 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755233Ab2GKOYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:24:34 -0400
Date: Wed, 11 Jul 2012 10:24:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/host/ehci-hub: Fix the issue EG20T USB host controller
 has long resuming time, when pen drive is attached.
In-Reply-To: <1341966511-4373-1-git-send-email-tomoya.rohm@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1207111021020.1559-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Tomoya MORINAGA wrote:

> 
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

There's no patch description.  What is the cause of the problem and how
does the patch fix it?

> ---
>  drivers/usb/host/ehci-hub.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
> index fc9e7cc..d596d0f 100644
> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -207,6 +207,7 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
>  	int			port;
>  	int			mask;
>  	int			changed;
> +	int			temp;
>  
>  	ehci_dbg(ehci, "suspend root hub\n");
>  
> @@ -324,6 +325,9 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
>  	 * want, and so we must delete any pending watchdog timer events.
>  	 */
>  	del_timer_sync(&ehci->watchdog);
> +	temp = ehci_readl(ehci, &ehci->regs->status);
> +	if (temp & STS_FLR)
> +		ehci_writel(ehci, STS_FLR, &ehci->regs->status);
>  	return 0;

Operations like this should be done while holding the spinlock.

Also, why do you need the ehci_readl and the test?  You could always 
clear the STS_FLR flag.

Alan Stern

