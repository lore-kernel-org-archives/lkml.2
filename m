Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab2HWUhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 16:37:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49871 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932826Ab2HWUht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 16:37:49 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/pcslSK8rpAoAwy+iHFywmDyPDG8q7EP2Y/oAVD+
	HCU2G+yxaHHrO6
Message-ID: <50369498.4010006@gmx.de>
Date: Thu, 23 Aug 2012 20:37:44 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Damien Cassou <damien.cassou@lifl.fr>
CC: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/video/gbefb.c: use devm_ functions
References: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr> <1343752762-16861-3-git-send-email-damien.cassou@lifl.fr>
In-Reply-To: <1343752762-16861-3-git-send-email-damien.cassou@lifl.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 04:39 PM, Damien Cassou wrote:
> From: Damien Cassou <damien.cassou@lifl.fr>
> 
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.
> 
> Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

Applied.


Thanks,

Florian Tobias Schandinat

> 
> ---
>  drivers/video/gbefb.c |   15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
> index 7e7b7a9..9b79d38 100644
> --- a/drivers/video/gbefb.c
> +++ b/drivers/video/gbefb.c
> @@ -1156,7 +1156,8 @@ static int __devinit gbefb_probe(struct platform_device *p_dev)
>  		goto out_release_framebuffer;
>  	}
>  
> -	gbe = (struct sgi_gbe *) ioremap(GBE_BASE, sizeof(struct sgi_gbe));
> +	gbe = (struct sgi_gbe *) devm_ioremap(&p_dev->dev, GBE_BASE,
> +					      sizeof(struct sgi_gbe));
>  	if (!gbe) {
>  		printk(KERN_ERR "gbefb: couldn't map mmio region\n");
>  		ret = -ENXIO;
> @@ -1170,12 +1171,13 @@ static int __devinit gbefb_probe(struct platform_device *p_dev)
>  	if (!gbe_tiles.cpu) {
>  		printk(KERN_ERR "gbefb: couldn't allocate tiles table\n");
>  		ret = -ENOMEM;
> -		goto out_unmap;
> +		goto out_release_mem_region;
>  	}
>  
>  	if (gbe_mem_phys) {
>  		/* memory was allocated at boot time */
> -		gbe_mem = ioremap_nocache(gbe_mem_phys, gbe_mem_size);
> +		gbe_mem = devm_ioremap_nocache(&p_dev->dev, gbe_mem_phys,
> +					       gbe_mem_size);
>  		if (!gbe_mem) {
>  			printk(KERN_ERR "gbefb: couldn't map framebuffer\n");
>  			ret = -ENOMEM;
> @@ -1241,13 +1243,9 @@ static int __devinit gbefb_probe(struct platform_device *p_dev)
>  out_gbe_unmap:
>  	if (gbe_dma_addr)
>  		dma_free_coherent(NULL, gbe_mem_size, gbe_mem, gbe_mem_phys);
> -	else
> -		iounmap(gbe_mem);
>  out_tiles_free:
>  	dma_free_coherent(NULL, GBE_TLB_SIZE * sizeof(uint16_t),
>  			  (void *)gbe_tiles.cpu, gbe_tiles.dma);
> -out_unmap:
> -	iounmap(gbe);
>  out_release_mem_region:
>  	release_mem_region(GBE_BASE, sizeof(struct sgi_gbe));
>  out_release_framebuffer:
> @@ -1264,12 +1262,9 @@ static int __devexit gbefb_remove(struct platform_device* p_dev)
>  	gbe_turn_off();
>  	if (gbe_dma_addr)
>  		dma_free_coherent(NULL, gbe_mem_size, gbe_mem, gbe_mem_phys);
> -	else
> -		iounmap(gbe_mem);
>  	dma_free_coherent(NULL, GBE_TLB_SIZE * sizeof(uint16_t),
>  			  (void *)gbe_tiles.cpu, gbe_tiles.dma);
>  	release_mem_region(GBE_BASE, sizeof(struct sgi_gbe));
> -	iounmap(gbe);
>  	gbefb_remove_sysfs(&p_dev->dev);
>  	framebuffer_release(info);
>  
> 
> 

