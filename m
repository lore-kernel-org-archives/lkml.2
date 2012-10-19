Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab2JSNLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:11:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18637 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab2JSNLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:11:30 -0400
Date: Fri, 19 Oct 2012 08:59:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>, bhelgaas@google.com
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/5] xen-pcifront: handle backend CLOSED without CLOSING
Message-ID: <20121019125919.GC26830@phenom.dumpdata.com>
References: <507FD39F.4060601@citrix.com>
 <1350554618-14582-3-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350554618-14582-3-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 11:03:36AM +0100, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> Backend drivers shouldn't transistion to CLOSED unless the frontend is
> CLOSED.  If a backend does transition to CLOSED too soon then the
> frontend may not see the CLOSING state and will not properly shutdown.
> 
> So, treat an unexpected backend CLOSED state the same as CLOSING.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> Cc: linux-pci@vger.kernel.org
> Cc: Bjorn Helgaas <bhelgaas@google.com>

Bjorn, do you want me to prep a git pull with this patch
or can I have your Ack to put it my tree and have it part of my
git pull to Linus?

Thx.
> ---
>  drivers/pci/xen-pcifront.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
> index 0aab85a..a0c7312 100644
> --- a/drivers/pci/xen-pcifront.c
> +++ b/drivers/pci/xen-pcifront.c
> @@ -1068,13 +1068,16 @@ static void __init_refok pcifront_backend_changed(struct xenbus_device *xdev,
>  	case XenbusStateInitialising:
>  	case XenbusStateInitWait:
>  	case XenbusStateInitialised:
> -	case XenbusStateClosed:
>  		break;
>  
>  	case XenbusStateConnected:
>  		pcifront_try_connect(pdev);
>  		break;
>  
> +	case XenbusStateClosed:
> +		if (xdev->state == XenbusStateClosed)
> +			break;
> +		/* Missed the backend's CLOSING state -- fallthrough */
>  	case XenbusStateClosing:
>  		dev_warn(&xdev->dev, "backend going away!\n");
>  		pcifront_try_disconnect(pdev);
> -- 
> 1.7.2.5
