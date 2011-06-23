Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1FWFBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 01:01:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:25711 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1FWFBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 01:01:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,411,1304319600"; 
   d="scan'208";a="17141986"
Date: Thu, 23 Jun 2011 13:09:21 +0800
From: Feng Tang <feng.tang@intel.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 09/11] spi-dw: Fix condition in spi_dw_{writer/reader}
Message-ID: <20110623130921.574d299a@feng-i7>
In-Reply-To: <4E02B33A.3060805@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
	<1308794413-11069-10-git-send-email-dirk.brandewie@gmail.com>
	<20110623104506.3cfd55ce@feng-i7>
	<4E02AE6E.5010307@gmail.com>
	<20110623112552.6f22c3de@feng-i7>
	<4E02B33A.3060805@gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011 11:30:02 +0800
Dirk Brandewie <dirk.brandewie@gmail.com> wrote:

> This patch should have been:
> 
> spi-dw: Fix condition in spi_dw_{writer/reader}
> 
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> Fix the condition based on whether the current transfer has a tx/rx
> buffer.
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>   drivers/spi/spi-dw.c |   10 +++++-----
>   1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
> index 96ae4a7..0a848bc 100644
> --- a/drivers/spi/spi-dw.c
> +++ b/drivers/spi/spi-dw.c
> @@ -193,15 +193,15 @@ static void spi_dw_writer(struct spi_dw *dws)
>          u16 txw = 0;
> 
>          while (max--) {
> -               /* Set the tx word if the transfer's original "tx" is
> not null */
> -               if (dws->tx_end - dws->len) {
> +               /* Set the tx word if the transfer's "tx" is not null
> */
> +               if (dws->tx) {
>                          if (dws->n_bytes == 1)
>                                  txw = *(u8 *)(dws->tx);
>                          else
>                                  txw = *(u16 *)(dws->tx);
> +                       dws->tx += dws->n_bytes;
>                  }
>                  dw_writew(dws, dr, txw);
> -               dws->tx += dws->n_bytes;
>          }
>   }

emm, this patch still break the NULL original tx buf case, as it is used in

/* Return the max entries we can fill into tx fifo */
static inline u32 tx_max(struct dw_spi *dws)
{
	u32 tx_left, tx_room, rxtx_gap;

	tx_left = (dws->tx_end - dws->tx) / dws->n_bytes;
	tx_room = dws->fifo_len - dw_readw(dws, txflr);



> 
> @@ -213,13 +213,13 @@ static void spi_dw_reader(struct spi_dw *dws)
>          while (max--) {
>                  rxw = dw_readw(dws, dr);
>                  /* Care rx only if the transfer's original "rx" is
> not null */
> -               if (dws->rx_end - dws->len) {
> +               if (dws->rx) {
>                          if (dws->n_bytes == 1)
>                                  *(u8 *)(dws->rx) = rxw;
>                          else
>                                  *(u16 *)(dws->rx) = rxw;
> +                       dws->rx += dws->n_bytes;
>                  }
> -               dws->rx += dws->n_bytes;
>          }
>   }
> 
