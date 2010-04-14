Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0DNHfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 03:35:53 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52059 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597Ab0DNHfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 03:35:52 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2010 03:35:52 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEANcLxUs7p+/x/2dsb2JhbACcR7x8hQ0Ehjw
Message-ID: <4BC56F21.6040909@call-direct.com.au>
Date: Wed, 14 Apr 2010 17:30:41 +1000
From: Iwo Mergler <iwo@call-direct.com.au>
User-Agent: Thunderbird 2.0.0.12 (X11/20080302)
MIME-Version: 1.0
To: Anders Larsen <al@alarsen.net>
CC: linux-mtd@lists.infradead.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ian McDonnell <ian@brightstareng.com>, Nicolas Pitre <nico@fluxnic.net>,
       linux-kernel@vger.kernel.org, Matthias Kaehlcke <matthias@kaehlcke.net>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Fix Oops with Atmel SPI
References: <1271158315l.25331l.9l@i-dmzi_al.realan.de>
In-Reply-To: <1271158315l.25331l.9l@i-dmzi_al.realan.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anders,

I wouldn't recommend that. MTD erase blocks are 64K or more. In a typical
embedded system you will not be able to kmalloc that much memory after
a few day's of operation - the page pool gets fragmented.

A possibly better approach is to arrange for that memory to get allocated
at driver start time.

An even better approach would be to change the algorithm to operate on
a list of smaller allocations, e.g. MTD page size.


Best regards,

Iwo


Anders Larsen wrote:
> Tweak MTD's cache allocation to make it work with the atmel DMA'ed SPI.
> Substitute kmalloc for vmalloc so the cache buffer is mappable as per
> the Atmel SPI driver's requirements, otherwise an Oops would occur.
> 
> The original patch by Ian McDonnell <ian@brightstareng.com> was found here:
> http://lists.infradead.org/pipermail/linux-mtd/2007-December/020184.html
> 
> Signed-off-by: Anders Larsen <al@alarsen.net>
> Cc: Ian McDonnell <ian@brightstareng.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Matthias Kaehlcke <matthias@kaehlcke.net>
> Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> ---
>  drivers/mtd/mtdblock.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: b/drivers/mtd/mtdblock.c
> ===================================================================
> --- a/drivers/mtd/mtdblock.c
> +++ b/drivers/mtd/mtdblock.c
> @@ -253,7 +253,11 @@ static int mtdblock_writesect(struct mtd
>  {
>  	struct mtdblk_dev *mtdblk = mtdblks[dev->devnum];
>  	if (unlikely(!mtdblk->cache_data && mtdblk->cache_size)) {
> +#ifdef CONFIG_SPI_ATMEL
> +		mtdblk->cache_data = kmalloc(mtdblk->mtd->erasesize, GFP_KERNEL);
> +#else
>  		mtdblk->cache_data = vmalloc(mtdblk->mtd->erasesize);
> +#endif
>  		if (!mtdblk->cache_data)
>  			return -EINTR;
>  		/* -EINTR is not really correct, but it is the best match
> @@ -322,7 +326,11 @@ static int mtdblock_release(struct mtd_b
>  		mtdblks[dev] = NULL;
>  		if (mtdblk->mtd->sync)
>  			mtdblk->mtd->sync(mtdblk->mtd);
> +#ifdef CONFIG_SPI_ATMEL
> +		kfree(mtdblk->cache_data);
> +#else
>  		vfree(mtdblk->cache_data);
> +#endif
>  		kfree(mtdblk);
>  	}
>  
> 
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 
> 


