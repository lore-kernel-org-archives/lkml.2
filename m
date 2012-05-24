Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab2EXJRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:17:31 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36805 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2EXJR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:17:29 -0400
MIME-Version: 1.0
In-Reply-To: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
Date: Thu, 24 May 2012 17:17:27 +0800
Message-ID: <CAJxxZ0MyEFfs9MT8ffZroUXtxsZ2ftd2Zky4ktywF4yeD9__nw@mail.gmail.com>
Subject: Re: [PATCH 1/8] i2c: i2c-bfin-twi: Illegal i2c bus lock upon certain
 transfer scenarios.
From: Sonic Zhang <sonic.adi@gmail.com>
To: sonic.zhang@analog.com
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PING


On Wed, May 16, 2012 at 3:20 PM,  <sonic.zhang@analog.com> wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>
> For transfer counts > 255 bytes i2c-bfin-twi sets the data
> transfer counter DCNT to 0xFF indicating unlimited transfers.
> It then uses a flag iface->manual_stop to manually issue the STOP
> condition, once the required amount of bytes are received.
>
> We found that on I2C receive operation issuing the STOP condition
> together with a FULL RCV FIFO (2bytes) will cause SDA and SCL be
> constantly driven low.
>
> Temporary workaround until further investigation:
> Discard the RCV FIFO before issuing the STOP condition.
>
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>
> git-svn-id: svn://localhost/svn/linux-kernel/trunk@9011 526b6c2d-f592-4532-a319-5dd88ccb003d
> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index cdb59e5..e6dd3c9 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -131,6 +131,10 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>                        iface->transPtr++;
>                        iface->readNum--;
>                } else if (iface->manual_stop) {
> +                       /* Avoid possible bus stall -
> +                        * Flush FIFO before issuing the STOP condition
> +                        */
> +                       read_RCV_DATA16(iface);
>                        write_MASTER_CTL(iface,
>                                read_MASTER_CTL(iface) | STOP);
>                } else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
