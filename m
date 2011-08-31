Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1HaTvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 15:51:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45060 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab1HaTvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 15:51:05 -0400
MIME-Version: 1.0
In-Reply-To: <1314818699-10873-2-git-send-email-jslaby@suse.cz>
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
	<1314818699-10873-2-git-send-email-jslaby@suse.cz>
Date: Wed, 31 Aug 2011 21:51:04 +0200
X-Google-Sender-Auth: 9I7VDPuTuQ4dC4PypcAhrQRWSsU
Message-ID: <CAMuHMdUBYarp4V_k_8Skr8T-Ow2fc69EpJGi3wm-M_UZNxDLeA@mail.gmail.com>
Subject: Re: [PATCH 2/4] TTY: serial, remove dead code from 68328
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>,
        linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 21:24, Jiri Slaby <jslaby@suse.cz> wrote:
> The code is dead at least since 2002. So remove it to not distort git
> grep output (about port.tty usage).
>
> Remove the whole do_softirq tasklet as it's noop now.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Alan Cox <alan@linux.intel.com>
> ---
> Cc: linux-m68k@lists.linux-m68k.org

This is a uClinux driver.

>  drivers/tty/serial/68328serial.c |   35 -----------------------------------
>  drivers/tty/serial/68328serial.h |    1 -
>  2 files changed, 0 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
> index e0a7754..f549231 100644
> --- a/drivers/tty/serial/68328serial.c
> +++ b/drivers/tty/serial/68328serial.c
> @@ -235,22 +235,6 @@ static void batten_down_hatches(void)
>
>  static void status_handle(struct m68k_serial *info, unsigned short status)
>  {
> -#if 0
> -       if(status & DCD) {
> -               if((info->port.tty->termios->c_cflag & CRTSCTS) &&
> -                  ((info->curregs[3] & AUTO_ENAB)==0)) {
> -                       info->curregs[3] |= AUTO_ENAB;
> -                       info->pendregs[3] |= AUTO_ENAB;
> -                       write_zsreg(info->m68k_channel, 3, info->curregs[3]);
> -               }
> -       } else {
> -               if((info->curregs[3] & AUTO_ENAB)) {
> -                       info->curregs[3] &= ~AUTO_ENAB;
> -                       info->pendregs[3] &= ~AUTO_ENAB;
> -                       write_zsreg(info->m68k_channel, 3, info->curregs[3]);
> -               }
> -       }
> -#endif
>        /* If this is console input and this is a
>         * 'break asserted' status change interrupt
>         * see if we can drop into the debugger
> @@ -340,9 +324,6 @@ static void transmit_chars(struct m68k_serial *info)
>        info->xmit_tail = info->xmit_tail & (SERIAL_XMIT_SIZE-1);
>        info->xmit_cnt--;
>
> -       if (info->xmit_cnt < WAKEUP_CHARS)
> -               schedule_work(&info->tqueue);
> -
>        if(info->xmit_cnt <= 0) {
>                /* All done for now... TX ints off */
>                uart->ustcnt &= ~USTCNT_TX_INTR_MASK;
> @@ -378,21 +359,6 @@ irqreturn_t rs_interrupt(int irq, void *dev_id)
>        return IRQ_HANDLED;
>  }
>
> -static void do_softint(struct work_struct *work)
> -{
> -       struct m68k_serial      *info = container_of(work, struct m68k_serial, tqueue);
> -       struct tty_struct       *tty;
> -
> -       tty = info->tty;
> -       if (!tty)
> -               return;
> -#if 0
> -       if (clear_bit(RS_EVENT_WRITE_WAKEUP, &info->event)) {
> -               tty_wakeup(tty);
> -       }
> -#endif
> -}
> -
>  static int startup(struct m68k_serial * info)
>  {
>        m68328_uart *uart = &uart_addr[info->line];
> @@ -1324,7 +1290,6 @@ rs68328_init(void)
>            info->event = 0;
>            info->count = 0;
>            info->blocked_open = 0;
> -           INIT_WORK(&info->tqueue, do_softint);
>            init_waitqueue_head(&info->open_wait);
>            init_waitqueue_head(&info->close_wait);
>            info->line = i;
> diff --git a/drivers/tty/serial/68328serial.h b/drivers/tty/serial/68328serial.h
> index 8c9c3c0..3d2faab 100644
> --- a/drivers/tty/serial/68328serial.h
> +++ b/drivers/tty/serial/68328serial.h
> @@ -158,7 +158,6 @@ struct m68k_serial {
>        int                     xmit_head;
>        int                     xmit_tail;
>        int                     xmit_cnt;
> -       struct work_struct      tqueue;
>        wait_queue_head_t       open_wait;
>        wait_queue_head_t       close_wait;
>  };
> --
> 1.7.6.1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
