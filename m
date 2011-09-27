Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1I0CSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:18:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33826 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab1I0CSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:18:35 -0400
MIME-Version: 1.0
In-Reply-To: <1316759153-17608-1-git-send-email-sonic.adi@gmail.com>
References: <1316759153-17608-1-git-send-email-sonic.adi@gmail.com>
Date: Tue, 27 Sep 2011 10:18:33 +0800
Message-ID: <CAJxxZ0OVRnjUE3kigvab0XU2Tke0yimfmKkZb2TPNtfkbNftWA@mail.gmail.com>
Subject: Re: [PATCH] i2c:i2c-bfin-twi: TWI controller fails to restart next
 transfer in high system load.
From: Sonic Zhang <sonic.adi@gmail.com>
To: khali@linux-fr.org, ben-linux@fluff.org
Cc: linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.


Sonic Zhang

On Fri, Sep 23, 2011 at 2:25 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Current driver was developed based on BF537 0.2 HRM. In high system load, BUFRDERR error
> interrupt may be raised if XMTSERV interrupt of last TX byte is not served in time
> (set RSTART bit), which breaks restart tranfer as expected.
>
> "Buffer Read Error (BUFRDERR)" description in Blackfin HRM only applys to BF537
> rev. < 0.3. In later rev. and later announced Blackfin chips, such as BF527 and
> BF548, a new TWI master feature "Clock Stretching" is added into the TWI controller,
> BUFRDERR interrupt is not triggered after TX FIFO is empty.
>
> This patch sets RSTART bit at the beginning of the first transfer. The SCL and SDA
> is hold till XMTSERV interrupt of last TX byte is served. Restart transfer is not broken
> in high system load.
>
> Reported-by: Lukas Weiss <lukas.weiss@janitza.de>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |   42 +++++++++++++++++++++---------------
>  1 files changed, 24 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index cbc98ae..5887ca4 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -99,7 +99,7 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>                 */
>                else if (iface->cur_mode == TWI_I2C_MODE_COMBINED)
>                        write_MASTER_CTL(iface,
> -                               read_MASTER_CTL(iface) | MDIR | RSTART);
> +                               read_MASTER_CTL(iface) | MDIR);
>                else if (iface->manual_stop)
>                        write_MASTER_CTL(iface,
>                                read_MASTER_CTL(iface) | STOP);
> @@ -107,10 +107,10 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>                         iface->cur_msg + 1 < iface->msg_num) {
>                        if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
>                                write_MASTER_CTL(iface,
> -                                       read_MASTER_CTL(iface) | RSTART | MDIR);
> +                                       read_MASTER_CTL(iface) | MDIR);
>                        else
>                                write_MASTER_CTL(iface,
> -                                       (read_MASTER_CTL(iface) | RSTART) & ~MDIR);
> +                                       read_MASTER_CTL(iface) & ~MDIR);
>                }
>        }
>        if (twi_int_status & RCVSERV) {
> @@ -130,17 +130,20 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>                        }
>                        iface->transPtr++;
>                        iface->readNum--;
> -               } else if (iface->manual_stop) {
> -                       write_MASTER_CTL(iface,
> -                               read_MASTER_CTL(iface) | STOP);
> -               } else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
> -                          iface->cur_msg + 1 < iface->msg_num) {
> -                       if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
> -                               write_MASTER_CTL(iface,
> -                                       read_MASTER_CTL(iface) | RSTART | MDIR);
> -                       else
> +               }
> +               if (iface->readNum == 0) {
> +                       if (iface->manual_stop) {
>                                write_MASTER_CTL(iface,
> -                                       (read_MASTER_CTL(iface) | RSTART) & ~MDIR);
> +                                       read_MASTER_CTL(iface) | STOP);
> +                       } else if (iface->cur_mode == TWI_I2C_MODE_REPEAT &&
> +                                  iface->cur_msg + 1 < iface->msg_num) {
> +                               if (iface->pmsg[iface->cur_msg + 1].flags & I2C_M_RD)
> +                                       write_MASTER_CTL(iface,
> +                                               read_MASTER_CTL(iface) | MDIR);
> +                               else
> +                                       write_MASTER_CTL(iface,
> +                                               read_MASTER_CTL(iface) & ~MDIR);
> +                       }
>                }
>        }
>        if (twi_int_status & MERR) {
> @@ -252,9 +255,10 @@ static void bfin_twi_handle_interrupt(struct bfin_twi_iface *iface,
>                                        (0xff << 6)));
>                                iface->manual_stop = 1;
>                        }
> -                       /* remove restart bit and enable master receive */
> -                       write_MASTER_CTL(iface,
> -                               read_MASTER_CTL(iface) & ~RSTART);
> +                       /* remove restart bit before last message */
> +                       if (iface->cur_msg+1 == iface->msg_num)
> +                               write_MASTER_CTL(iface,
> +                                       read_MASTER_CTL(iface) & ~RSTART);
>                } else {
>                        iface->result = 1;
>                        write_INT_MASK(iface, 0);
> @@ -311,7 +315,8 @@ static int bfin_twi_do_master_xfer(struct i2c_adapter *adap,
>                return -EINVAL;
>        }
>
> -       iface->cur_mode = TWI_I2C_MODE_REPEAT;
> +       if (iface->msg_num > 1)
> +               iface->cur_mode = TWI_I2C_MODE_REPEAT;
>        iface->manual_stop = 0;
>        iface->transPtr = pmsg->buf;
>        iface->writeNum = iface->readNum = pmsg->len;
> @@ -356,6 +361,7 @@ static int bfin_twi_do_master_xfer(struct i2c_adapter *adap,
>
>        /* Master enable */
>        write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN |
> +               (iface->msg_num > 1 ? RSTART : 0) |
>                ((iface->read_write == I2C_SMBUS_READ) ? MDIR : 0) |
>                ((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 100) ? FAST : 0));
>        SSYNC();
> @@ -520,7 +526,7 @@ int bfin_twi_do_smbus_xfer(struct i2c_adapter *adap, u16 addr,
>                else
>                        write_MASTER_CTL(iface, 0x1 << 6);
>                /* Master enable */
> -               write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN |
> +               write_MASTER_CTL(iface, read_MASTER_CTL(iface) | MEN | RSTART |
>                        ((CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ>100) ? FAST : 0));
>                break;
>        default:
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
