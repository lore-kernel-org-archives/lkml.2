Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0D0NCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:02:08 -0400
Received: from smtp.nokia.com ([192.100.122.230]:39793 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab0D0NCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:02:01 -0400
Subject: Re: [PATCH] Fix Oops with Atmel SPI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Anders Larsen <al@alarsen.net>
Cc: linux-mtd@lists.infradead.org, Ian McDonnell <ian@brightstareng.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Matthias Kaehlcke <matthias@kaehlcke.net>,
       Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1271158315l.25331l.9l@i-dmzi_al.realan.de>
References: <1271158315l.25331l.9l@i-dmzi_al.realan.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 15:57:29 +0300
Message-ID: <1272373049.7750.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Apr 2010 13:01:43.0363 (UTC) FILETIME=[C8EE3930:01CAE609]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 13:31 +0200, Anders Larsen wrote:
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

This is an old problem. Instead of doing this dirty hack, change the
code and teach it to work with array of 1-4 pages , not with buffers.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

