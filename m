Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab2JQN2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:28:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab2JQN2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:28:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH v2 v2 v2 8/8] spi/s3c64xx: use correct dma_transfer_direction type
Date: Wed, 17 Oct 2012 13:27:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
References: <1349813638-4617-1-git-send-email-arnd@arndb.de> <1349813638-4617-9-git-send-email-arnd@arndb.de> <003a01cdac3f$08fe40d0$1afac270$%kim@samsung.com>
In-Reply-To: <003a01cdac3f$08fe40d0$1afac270$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201210171327.23182.arnd@arndb.de>
X-Provags-ID: V02:K0:N7eOxEXysJA/wDlAk4ejBPDbGamzTuOp6TAd7fBmLen
 OzERPO0DDsopiBG1deR9/ziITrII9QbR4UQesEMXtvKCAi6bgg
 pe5+MFsSivN230ojpzhS9VldugWoQm092GKooHcjwgGpaeH4T4
 SAlszkY1PODikrOhOtfJFjzmi+EJPSxyIFGHnDfOlgv08WLVwa
 QgLJquz75fzGm+FW0A76PjlSQvt0RAqbfQfH+N74dmxmVO3MtS
 IIFWSwBGYwh1GwwoWFX/Oxagm8RGTvr0ycblwtbc1ZqaBZJF07
 rn4Ty7dsn+pFQPZaLfbpKJu+jOVbkZ/VDgjKCsLGrFJp0Tmxhe
 Q0mX6dLXoAz7tHNDi3tQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2012, Kukjin Kim wrote:
> BTW, don't we need following accordingly?
> 
> diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
> index 1a81c90..a0bb55e 100644
> --- a/drivers/spi/spi-s3c64xx.c
> +++ b/drivers/spi/spi-s3c64xx.c
> @@ -1067,11 +1067,11 @@ static int __devinit s3c64xx_spi_get_dmares(
> 
>         if (tx) {
>                 dma_data = &sdd->tx_dma;
> -               dma_data->direction = DMA_TO_DEVICE;
> +               dma_data->direction = DMA_MEM_TO_DEV;
>                 chan_str = "tx";
>         } else {
>                 dma_data = &sdd->rx_dma;
> -               dma_data->direction = DMA_FROM_DEVICE;
> +               dma_data->direction = DMA_DEV_TO_MEM;
>                 chan_str = "rx";
>         }
> 

Yes, you are absolutely right, sorry for not seeing that earlier.
New version below.

	Arnd

>From c10356b9846b13651a8a24c3a31e029ffe6eafd9 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 30 Apr 2012 16:31:27 +0000
Subject: [PATCH] spi/s3c64xx: use correct dma_transfer_direction type

There is a subtle difference between dma_transfer_direction and
dma_data_direction: the former is used by the dmaengine framework,
while the latter is used by the dma-mapping API. Although the
purpose is comparable, the actual values are different and must
not be mixed. In this case, the driver just wants to use
dma_transfer_direction.

Without this patch, building s3c6400_defconfig results in:

drivers/spi/spi-s3c64xx.c: In function 's3c64xx_spi_dmacb':
drivers/spi/spi-s3c64xx.c:239:21: warning: comparison between
	'enum dma_data_direction' and 'enum dma_transfer_direction' [-Wenum-compare]

As pointed out by Kukjin Kim, this also changes the use of constants
from DMA_FROM_DEVICE/DMA_TO_DEVICE to DMA_DEV_TO_MEM/DMA_MEM_TO_DEV.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: spi-devel-general@lists.sourceforge.net

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index d1c8441f..cd43b4b 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -132,7 +132,7 @@
 
 struct s3c64xx_spi_dma_data {
 	unsigned		ch;
-	enum dma_data_direction direction;
+	enum dma_transfer_direction direction;
 	enum dma_ch	dmach;
 	struct property		*dma_prop;
 };
@@ -1065,11 +1065,11 @@ static int __devinit s3c64xx_spi_get_dmares(
 
 	if (tx) {
 		dma_data = &sdd->tx_dma;
-		dma_data->direction = DMA_TO_DEVICE;
+		dma_data->direction = DMA_MEM_TO_DEV;
 		chan_str = "tx";
 	} else {
 		dma_data = &sdd->rx_dma;
-		dma_data->direction = DMA_FROM_DEVICE;
+		dma_data->direction = DMA_DEV_TO_MEM;
 		chan_str = "rx";
 	}
 
