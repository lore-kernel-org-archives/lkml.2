Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab1FWCfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:35:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:57582 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238Ab1FWCfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:35:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,410,1304319600"; 
   d="scan'208";a="17203464"
Date: Thu, 23 Jun 2011 10:41:44 +0800
From: Feng Tang <feng.tang@intel.com>
To: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 08/11] spi-dw: Ensure fifo lenght is set.
Message-ID: <20110623104144.024cc955@feng-i7>
In-Reply-To: <1308794413-11069-9-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
	<1308794413-11069-9-git-send-email-dirk.brandewie@gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Jun 2011 10:00:10 +0800
"dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com> wrote:

> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> Bug on fifo_len not being set.  The fifo sizing routine does not work
> since the txfltr register can not be written while the controller is
> enabled. The max value of txfltr can be larger than the fifo.  The
> register allows values upto 0x3f (63) the fifo depth on the Intel
> SOC's if 40
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  drivers/spi/spi-dw.c |   18 ++----------------
>  1 files changed, 2 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
> index ad92826..cc38aa0 100644
> --- a/drivers/spi/spi-dw.c
> +++ b/drivers/spi/spi-dw.c
> @@ -776,25 +776,11 @@ static int destroy_queue(struct spi_dw *dws)
>  /* Restart the controller, disable all interrupts, clean rx fifo */
>  static void spi_dw_hw_init(struct spi_dw *dws)
>  {
> +	BUG_ON(!dws->fifo_len);
> +
>  	spi_dw_disable(dws);
>  	spi_dw_mask_intr(dws, 0xff);
>  	spi_dw_enable(dws);
> -
> -	/*
> -	 * Try to detect the FIFO depth if not set by interface
> driver,
> -	 * the depth could be from 2 to 256 from HW spec
> -	 */
> -	if (!dws->fifo_len) {
> -		u32 fifo;
> -		for (fifo = 2; fifo <= 257; fifo++) {
> -			dw_writew(dws, txfltr, fifo);
> -			if (fifo != dw_readw(dws, txfltr))
> -				break;
> -		}
> -
> -		dws->fifo_len = (fifo == 257) ? 0 : fifo;
> -		dw_writew(dws, txfltr, 0);
> -	}
>  }

This code is requested by other community developers, the FIFO
length is adjustable for the dw_spi core when deployed on
different platforms, for those who are not certain about the
FIFO len, they can use this code to probe the FIFO len.

So we need to keep it.

>  
>  int __devinit spi_dw_add_host(struct spi_dw *dws)
