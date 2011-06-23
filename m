Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab1FWDzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:55:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52582 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406Ab1FWDzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:55:42 -0400
MIME-Version: 1.0
In-Reply-To: <1308794413-11069-9-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com> <1308794413-11069-9-git-send-email-dirk.brandewie@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 22 Jun 2011 21:55:22 -0600
X-Google-Sender-Auth: sWx2HD1tRVDc-uqvVxK_8XXuxls
Message-ID: <BANLkTi=Jv2aVuHqVXh77aGxMFV_Q_wXQCg@mail.gmail.com>
Subject: Re: [PATCH 08/11] spi-dw: Ensure fifo lenght is set.
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 8:00 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Bug on fifo_len not being set.  The fifo sizing routine does not work
> since the txfltr register can not be written while the controller is
> enabled. The max value of txfltr can be larger than the fifo.  The
> register allows values upto 0x3f (63) the fifo depth on the Intel
> SOC's if 40
>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  drivers/spi/spi-dw.c |   18 ++----------------
>  1 files changed, 2 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
> index ad92826..cc38aa0 100644
> --- a/drivers/spi/spi-dw.c
> +++ b/drivers/spi/spi-dw.c
> @@ -776,25 +776,11 @@ static int destroy_queue(struct spi_dw *dws)
>  /* Restart the controller, disable all interrupts, clean rx fifo */
>  static void spi_dw_hw_init(struct spi_dw *dws)
>  {
> +       BUG_ON(!dws->fifo_len);
> +

Ditto here.  BUG is too big a reaction.  Fail to initialize the
device, sure, and print a warning, but don't BUG.

g.

>        spi_dw_disable(dws);
>        spi_dw_mask_intr(dws, 0xff);
>        spi_dw_enable(dws);
> -
> -       /*
> -        * Try to detect the FIFO depth if not set by interface driver,
> -        * the depth could be from 2 to 256 from HW spec
> -        */
> -       if (!dws->fifo_len) {
> -               u32 fifo;
> -               for (fifo = 2; fifo <= 257; fifo++) {
> -                       dw_writew(dws, txfltr, fifo);
> -                       if (fifo != dw_readw(dws, txfltr))
> -                               break;
> -               }
> -
> -               dws->fifo_len = (fifo == 257) ? 0 : fifo;
> -               dw_writew(dws, txfltr, 0);
> -       }
>  }
>
>  int __devinit spi_dw_add_host(struct spi_dw *dws)
> --
> 1.7.3.4
>
>
> ------------------------------------------------------------------------------
> Simplify data backup and recovery for your virtual environment with vRanger.
> Installation's a snap, and flexible recovery options mean your data is safe,
> secure and there when you need it. Data protection magic?
> Nope - It's vRanger. Get your free trial download today.
> http://p.sf.net/sfu/quest-sfdev2dev
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
