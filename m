Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856Ab0D3SHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:07:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:57490 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933718Ab0D3SHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:07:09 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19V1sQ+5jxVgjKyMsQTSHRL/oiNqyA1qxsdgtdOvj
	ibvgDC/ac+ATeR
Message-ID: <4BDB1C46.8020101@gmx.de>
Date: Fri, 30 Apr 2010 20:07:02 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
       linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn
Subject: Re: [PATCH 13/30] viafb: Separate global and fb-specific data
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>	<1272493051-25380-14-git-send-email-corbet@lwn.net>	<20100429201902.6379f8d3@neptune.home> <20100430102157.5eb59055@bike.lwn.net>
In-Reply-To: <20100430102157.5eb59055@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jonathan Corbet schrieb:
> On Thu, 29 Apr 2010 20:19:02 +0200
> Bruno Prémont <bonbons@linux-vserver.org> wrote:
> 
>>> +	vdev->engine_start = pci_resource_start(vdev->pdev, 1);
>>> +	vdev->engine_len = pci_resource_len(vdev->pdev, 1);
>>> +	/* If this fails, others will notice later */
>>> +	vdev->engine_mmio = ioremap_nocache(vdev->engine_start,
>>> +			vdev->engine_len);
>> Shouldn't this ioremap_nocache() have error-checking
>> as the one below (instead of relying on later code to bail out)?
> 
> It would be better, yes, I'll add a patch to fix it up.

Please don't do this. The reason for not failing in viafb is that 
ioremap failure of the engine is not critical it just disables the 
hardware acceleration but otherwiese it works quite nice. The problem is 
that ioremap failures are quite common as we really try to remap huge 
amount (sometimes above 128 or even 256 MB). In fact the bug (or missing 
feature) is that the first ioremap is fatal and that needs to be fixed 
on the long run. Sorry but I don't want to make viafb unusable for many 
people if they don't add the "vmalloc=" kernel option so failing here 
would be a step in the wrong direction.


Thanks,

Florian Tobias Schandinat

> viafb: Fix initialization error paths
> 
> Properly localize error cleanup, and make sure that the iomem regions are
> unmapped if framebuffer initialization fails.
> 
> Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/video/via/via-core.c |   26 ++++++++++++++++----------
>  1 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
> index 2b5773a..b8a8783 100644
> --- a/drivers/video/via/via-core.c
> +++ b/drivers/video/via/via-core.c
> @@ -454,26 +454,32 @@ static int viafb_get_fb_size_from_pci(int chip_type)
>   */
>  static int __devinit via_pci_setup_mmio(struct viafb_dev *vdev)
>  {
> +	int ret;
>  	/*
>  	 * Hook up to the device registers.
>  	 */
>  	vdev->engine_start = pci_resource_start(vdev->pdev, 1);
>  	vdev->engine_len = pci_resource_len(vdev->pdev, 1);
> -	/* If this fails, others will notice later */
>  	vdev->engine_mmio = ioremap_nocache(vdev->engine_start,
>  			vdev->engine_len);
> -
> +	if (vdev->engine_mmio == NULL)
> +		return -ENOMEM;
>  	/*
> -	 * Likewise with I/O memory.
> +	 * Likewise with framebuffer memory.
>  	 */
>  	vdev->fbmem_start = pci_resource_start(vdev->pdev, 0);
> -	vdev->fbmem_len = viafb_get_fb_size_from_pci(vdev->chip_type);
> -	if (vdev->fbmem_len < 0)
> -		return vdev->fbmem_len;
> +	ret = vdev->fbmem_len = viafb_get_fb_size_from_pci(vdev->chip_type);
> +	if (ret < 0)
> +		goto out_unmap;
>  	vdev->fbmem = ioremap_nocache(vdev->fbmem_start, vdev->fbmem_len);
> -	if (vdev->fbmem == NULL)
> -		return -ENOMEM;
> +	if (vdev->fbmem == NULL) {
> +		ret = -ENOMEM;
> +		goto out_unmap;
> +	}
>  	return 0;
> +out_unmap:
> +	iounmap(vdev->engine_mmio);
> +	return ret;
>  }
>  
>  static void __devexit via_pci_teardown_mmio(struct viafb_dev *vdev)
> @@ -566,13 +572,13 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
>  	spin_lock_init(&global_dev.reg_lock);
>  	ret = via_pci_setup_mmio(&global_dev);
>  	if (ret)
> -		goto out_teardown;
> +		return ret;
>  	/*
>  	 * Set up the framebuffer device
>  	 */
>  	ret = via_fb_pci_probe(&global_dev);
>  	if (ret)
> -		return ret;
> +		goto out_teardown;
>  	/*
>  	 * Create our subdevices.
>  	 */

