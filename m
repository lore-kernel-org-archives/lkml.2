Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2IWTwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 15:52:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35376 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754155Ab2IWTwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 15:52:12 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/ohrtm0dLohvNpqLNyxYg4N6DQ+fz7V/dMsuVBAV
	8ZUS+5FtgNHIQx
Message-ID: <505F6860.7000908@gmx.de>
Date: Sun, 23 Sep 2012 19:52:00 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: paul.gortmaker@windriver.com, hsweeten@visionengravers.com, agust@denx.de,
        davidb@codeaurora.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 01/10] drivers/video/mb862xx/mb862xxfbdrv.c: fix error
 return code
References: <1347970080-25175-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1347970080-25175-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied all 10 patches of this series.


Thanks,

Florian Tobias Schandinat


On 09/18/2012 12:07 PM, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  drivers/video/mb862xx/mb862xxfbdrv.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/mb862xx/mb862xxfbdrv.c b/drivers/video/mb862xx/mb862xxfbdrv.c
> index 57d940b..d68e332 100644
> --- a/drivers/video/mb862xx/mb862xxfbdrv.c
> +++ b/drivers/video/mb862xx/mb862xxfbdrv.c
> @@ -1052,12 +1052,14 @@ static int __devinit mb862xx_pci_probe(struct pci_dev *pdev,
>  		break;
>  	default:
>  		/* should never occur */
> +		ret = -EIO;
>  		goto rel_reg;
>  	}
>  
>  	par->fb_base = ioremap(par->fb_base_phys, par->mapped_vram);
>  	if (par->fb_base == NULL) {
>  		dev_err(dev, "Cannot map framebuffer\n");
> +		ret = -EIO;
>  		goto rel_reg;
>  	}
>  
> @@ -1073,11 +1075,13 @@ static int __devinit mb862xx_pci_probe(struct pci_dev *pdev,
>  	dev_dbg(dev, "mmio phys 0x%llx 0x%lx\n",
>  		(unsigned long long)par->mmio_base_phys, (ulong)par->mmio_len);
>  
> -	if (mb862xx_pci_gdc_init(par))
> +	ret = mb862xx_pci_gdc_init(par);
> +	if (ret)
>  		goto io_unmap;
>  
> -	if (request_irq(par->irq, mb862xx_intr, IRQF_SHARED,
> -			DRV_NAME, (void *)par)) {
> +	ret = request_irq(par->irq, mb862xx_intr, IRQF_SHARED,
> +			  DRV_NAME, (void *)par);
> +	if (ret) {
>  		dev_err(dev, "Cannot request irq\n");
>  		goto io_unmap;
>  	}

