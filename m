Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab2EXJSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:18:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63027 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2EXJSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <1337152826-9850-2-git-send-email-sonic.zhang@analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
	<1337152826-9850-2-git-send-email-sonic.zhang@analog.com>
Date: Thu, 24 May 2012 17:18:09 +0800
Message-ID: <CAJxxZ0OsOG+MpZpKFboCffd=U=Wtbzeqb=anPmL7LNF12UX8eQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] i2c: i2c-bfin-twi: Stop receiving operation
 immediately in last rx interrupt.
From: Sonic Zhang <sonic.adi@gmail.com>
To: sonic.zhang@analog.com
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PING

On Wed, May 16, 2012 at 3:20 PM,  <sonic.zhang@analog.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Also wake up waiting process when transfer completes.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>
> git-svn-id: svn://localhost/svn/linux-kernel/trunk@9105 526b6c2d-f592-4532-a319-5dd88ccb003d
> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |   43 ++++++++++++++++++++----------------
>  1 files changed, 24 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index e6dd3c9..376e331 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -130,21 +130,25 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>                        }
>                        iface->transPtr++;
>                        iface->readNum--;
> -               } else if (iface->manual_stop) {
> -                       /* Avoid possible bus stall -
> -                        * Flush FIFO before issuing the STOP condition
> -                        */
> -                       read_RCV_DATA16(iface);
> -                       write_MASTER_CTL(iface,
> -                               read_MASTER_CTL(iface) | STOP);
> -               } else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
> -                          iface->cur_msg + 1 < iface->msg_num) {
> -                       if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
> -                               write_MASTER_CTL(iface,
> -                                       read_MASTER_CTL(iface) | RSTART | MDIR);
> -                       else
> +               }
> +
> +               if (iface->readNum == 0) {
> +                       if (iface->manual_stop) {
> +                               /* Avoid possible bus stall -
> +                                * Flush FIFO before issuing the STOP condition
> +                                */
> +                               read_RCV_DATA16(iface);
>                                write_MASTER_CTL(iface,
> -                                       (read_MASTER_CTL(iface) | RSTART) & ~MDIR);
> +                                       read_MASTER_CTL(iface) | STOP);
> +                       } else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
> +                                       iface->cur_msg + 1 < iface->msg_num) {
> +                               if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
> +                                       write_MASTER_CTL(iface,
> +                                               read_MASTER_CTL(iface) | RSTART | MDIR);
> +                               else
> +                                       write_MASTER_CTL(iface,
> +                                               (read_MASTER_CTL(iface) | RSTART) & ~MDIR);
> +                       }
>                }
>        }
>        if (twi_int_status & MERR) {
> @@ -245,12 +249,13 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>                                }
>                        }
>
> -                       if (iface->pmsg[iface->cur_msg].len <= 255)
> -                                       write_MASTER_CTL(iface,
> +                       if (iface->pmsg[iface->cur_msg].len <= 255) {
> +                               write_MASTER_CTL(iface,
>                                        (read_MASTER_CTL(iface) &
>                                        (~(0xff << 6))) |
> -                               (iface->pmsg[iface->cur_msg].len << 6));
> -                       else {
> +                                       (iface->pmsg[iface->cur_msg].len << 6));
> +                               iface->manual_stop = 0;
> +                       } else {
>                                write_MASTER_CTL(iface,
>                                        (read_MASTER_CTL(iface) |
>                                        (0xff << 6)));
> @@ -264,8 +269,8 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>                        write_INT_MASK(iface, 0);
>                        write_MASTER_CTL(iface, 0);
>                }
> +               complete(&iface->complete);
>        }
> -       complete(&iface->complete);
>  }
>
>  /* Interrupt handler */
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
