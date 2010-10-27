Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862Ab0J0KoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:44:01 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:57575 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760838Ab0J0KoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:44:00 -0400
Message-ID: <4CC80220.6010609@ge.com>
Date: Wed, 27 Oct 2010 11:42:40 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: greg@kroah.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vme: Fix warning in free_irq for ca91cx42
References: <20101027103806.2783.47604.stgit@ES-BJ21R4J>
In-Reply-To: <20101027103806.2783.47604.stgit@ES-BJ21R4J>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 10:43:57.0487 (UTC) FILETIME=[DBADE3F0:01CB75C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Please dis-regard this patch - trying to do to many things at once leads
to mistakes...

Martyn

On 27/10/10 11:38, Martyn Welch wrote:
> As discovered by Emilio Cota for the tsi148, the cookie passed to request_irq
> isn't the same as the one passed to free_irq.
> 
> Fix it by passing the same cookie to both functions.
> 
> Signed-off-by: Martyn Welch <martyn.welch@ge.com>
> ---
> 
>  drivers/staging/vme/bridges/vme_ca91cx42.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> index 1f2089f..5f7f458 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
> @@ -242,9 +242,11 @@ static int ca91cx42_irq_init(struct vme_bridge *ca91cx42_bridge)
>  	return 0;
>  }
>  
> -static void ca91cx42_irq_exit(struct ca91cx42_driver *bridge,
> +static void ca91cx42_irq_exit(struct vme_driver *ca91cx42_bridge,
>  	struct pci_dev *pdev)
>  {
> +	struct ca91cx42_driver *bridge = ca91cx42_bridge->driver_priv;
> +
>  	/* Disable interrupts from PCI to VME */
>  	iowrite32(0, bridge->base + VINT_EN);
>  
> @@ -253,7 +255,7 @@ static void ca91cx42_irq_exit(struct ca91cx42_driver *bridge,
>  	/* Clear Any Pending PCI Interrupts */
>  	iowrite32(0x00FFFFFF, bridge->base + LINT_STAT);
>  
> -	free_irq(pdev->irq, pdev);
> +	free_irq(pdev->irq, ca91cx42_bridge);
>  }
>  
>  /*
> @@ -1815,7 +1817,7 @@ err_master:
>  		kfree(master_image);
>  	}
>  
> -	ca91cx42_irq_exit(ca91cx42_device, pdev);
> +	ca91cx42_irq_exit(ca91cx42_bridge, pdev);
>  err_irq:
>  err_test:
>  	iounmap(ca91cx42_device->base);
> @@ -1899,7 +1901,7 @@ void ca91cx42_remove(struct pci_dev *pdev)
>  		kfree(master_image);
>  	}
>  
> -	ca91cx42_irq_exit(bridge, pdev);
> +	ca91cx42_irq_exit(ca91cx42_bridge, pdev);
>  
>  	iounmap(bridge->base);
>  
> 
> 
> --
> Martyn Welch (Principal Software Engineer)   |   Registered in England and
> GE Intelligent Platforms                     |   Wales (3828642) at 100
> T +44(0)127322748                            |   Barbirolli Square, Manchester,
> E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
