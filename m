Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2IQR4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:56:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:30154 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026Ab2IQR4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:56:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,437,1344236400"; 
   d="scan'208";a="206347150"
Date: Mon, 17 Sep 2012 10:56:16 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Michael Spang <spang@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Increase XHCI suspend timeout to 16ms
Message-ID: <20120917175616.GA7924@xanatos>
References: <1347642349-9397-1-git-send-email-spang@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347642349-9397-1-git-send-email-spang@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 01:05:49PM -0400, Michael Spang wrote:
> The Intel XHCI specification says that after clearing the run/stop bit
> the controller may take up to 16ms to halt. We've seen a device take
> 14ms, which with the current timeout of 10ms causes the kernel to
> abort the suspend. Increasing the timeout to the recommended value
> fixes the problem.

Thanks for tracking this down, Michael.  I'll queue this to Greg in a
couple days.

> 
> Signed-off-by: Michael Spang <spang@chromium.org>
> ---
>  drivers/usb/host/xhci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index c59d5b5..7710ccf 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -785,7 +785,7 @@ int xhci_suspend(struct xhci_hcd *xhci)
>  	command &= ~CMD_RUN;
>  	xhci_writel(xhci, command, &xhci->op_regs->command);
>  	if (handshake(xhci, &xhci->op_regs->status,
> -		      STS_HALT, STS_HALT, 100*100)) {
> +		      STS_HALT, STS_HALT, XHCI_MAX_HALT_USEC)) {
>  		xhci_warn(xhci, "WARN: xHC CMD_RUN timeout\n");
>  		spin_unlock_irq(&xhci->lock);
>  		return -ETIMEDOUT;
> -- 
> 1.7.7.3
> 
