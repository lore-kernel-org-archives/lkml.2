Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab0HCPso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:48:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756981Ab0HCPsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:48:42 -0400
Date: Tue, 3 Aug 2010 18:42:52 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] uio: do not use PCI resources before
 pci_enable_device()
Message-ID: <20100803154252.GA6511@redhat.com>
References: <1280850264-6258-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280850264-6258-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 07:44:23PM +0400, Kulikov Vasiliy wrote:
> IRQ and resource[] may not have correct values until
> after PCI hotplug setup occurs at pci_enable_device() time.
> 
> The semantic match that finds this problem is as follows:
> 
> // <smpl>
> @@
> identifier x;
> identifier request ~= "pci_request.*|pci_resource.*";
> @@
> 
> (
> * x->irq
> |
> * x->resource
> |
> * request(x, ...)
> )
>  ...
> *pci_enable_device(x)
> // </smpl>
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Looks sane.
Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/uio/uio_pci_generic.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> index 85c9884..fc22e1e 100644
> --- a/drivers/uio/uio_pci_generic.c
> +++ b/drivers/uio/uio_pci_generic.c
> @@ -128,12 +128,6 @@ static int __devinit probe(struct pci_dev *pdev,
>  	struct uio_pci_generic_dev *gdev;
>  	int err;
>  
> -	if (!pdev->irq) {
> -		dev_warn(&pdev->dev, "No IRQ assigned to device: "
> -			 "no support for interrupts?\n");
> -		return -ENODEV;
> -	}
> -
>  	err = pci_enable_device(pdev);
>  	if (err) {
>  		dev_err(&pdev->dev, "%s: pci_enable_device failed: %d\n",
> @@ -141,6 +135,13 @@ static int __devinit probe(struct pci_dev *pdev,
>  		return err;
>  	}
>  
> +	if (!pdev->irq) {
> +		dev_warn(&pdev->dev, "No IRQ assigned to device: "
> +			 "no support for interrupts?\n");
> +		pci_disable_device(pdev);
> +		return -ENODEV;
> +	}
> +
>  	err = verify_pci_2_3(pdev);
>  	if (err)
>  		goto err_verify;
> -- 
> 1.7.0.4
