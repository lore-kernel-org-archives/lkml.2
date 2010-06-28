Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab0F1OS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:18:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55703 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753828Ab0F1OS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:18:57 -0400
Date: Mon, 28 Jun 2010 10:18:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrea Righi <arighi@develer.com>
cc: Rodolfo Giometti <giometti@enneenne.com>,
       Amit Walambe <amit.walambe@eurotech.com>,
       Chris Leahy <leahycm@gmail.com>, Giovanni Bajo <rasky@develer.com>,
       <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: EHCI: fix NULL pointer dererence in HCDs that use
 HCD_LOCAL_MEM
In-Reply-To: <20100628141355.GA3807@linux.develer.com>
Message-ID: <Pine.LNX.4.44L0.1006281017460.1977-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Andrea Righi wrote:

> If we use the HCD_LOCAL_MEM flag and dma_declare_coherent_memory() to
> enforce the host controller's local memory utilization we also need to
> disable native scatter-gather support, otherwise hcd_alloc_coherent() in
> map_urb_for_dma() is called with urb->transfer_buffer == NULL, that
> triggers a NULL pointer dereference.
> 
> We can also consider to add a WARN_ON() and return an error code to
> better catch this problem in the future.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> ---
>  drivers/usb/core/hcd.c      |    5 +++++
>  drivers/usb/host/ehci-hcd.c |    3 ++-
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 12742f1..161c757 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -1219,6 +1219,11 @@ static int hcd_alloc_coherent(struct usb_bus *bus,
>  {
>  	unsigned char *vaddr;
>  
> +	if (*vaddr_handle == NULL) {
> +		WARN_ON_ONCE(1);
> +		return -EFAULT;
> +	}
> +
>  	vaddr = hcd_buffer_alloc(bus, size + sizeof(vaddr),
>  				 mem_flags, dma_handle);
>  	if (!vaddr)
> diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> index a3ef2a9..27e0351 100644
> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -606,7 +606,8 @@ static int ehci_init(struct usb_hcd *hcd)
>  	ehci->command = temp;
>  
>  	/* Accept arbitrarily long scatter-gather lists */
> -	hcd->self.sg_tablesize = ~0;
> +	if (!(hcd->driver->flags & HCD_LOCAL_MEM))
> +		hcd->self.sg_tablesize = ~0;
>  	return 0;
>  }

Looks okay to me.  You can add my Acked-by: when you submit this to 
Greg KH.

Alan Stern

