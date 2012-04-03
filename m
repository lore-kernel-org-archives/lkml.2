Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab2DCMsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 08:48:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49688 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2DCMsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 08:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <1333367693-3244-52-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
	<1333367693-3244-52-git-send-email-jslaby@suse.cz>
Date: Tue, 3 Apr 2012 14:48:17 +0200
X-Google-Sender-Auth: KhNWbjzS3ryEdSWQcYYe60WDWyw
Message-ID: <CAMuHMdWC6r_e1ebpbiGNJQGYmE6grvzt60-zCg2ZJO=Z+bnPMw@mail.gmail.com>
Subject: Re: [PATCH 51/69] TTY: 68328serial, remove serial_state and friends
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Greg as this is m68knommu territory, but I guess he go all 12 patches
  through linux-m68k anyway ]

On Mon, Apr 2, 2012 at 13:54, Jiri Slaby <jslaby@suse.cz> wrote:
> serial_state in 68328serial.h is a duplicated structure. One is
> defined in linux/serial.h. So let us use that instead. And since the
> serial flags are identical, use ones from there too.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: linux-m68k@lists.linux-m68k.org
> ---
>  drivers/tty/serial/68328serial.c |   55 +++++++++++----------------
>  drivers/tty/serial/68328serial.h |   76 --------------------------------------
>  2 files changed, 22 insertions(+), 109 deletions(-)
>
> diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
> index 5ce7825..bf5f811 100644
> --- a/drivers/tty/serial/68328serial.c
> +++ b/drivers/tty/serial/68328serial.c
> @@ -17,6 +17,7 @@
>  #include <asm/dbg.h>
>  #include <linux/module.h>
>  #include <linux/errno.h>
> +#include <linux/serial.h>
>  #include <linux/signal.h>
>  #include <linux/sched.h>
>  #include <linux/timer.h>
> @@ -79,18 +80,6 @@ struct m68k_serial *m68k_consinfo = 0;
>
>  struct tty_driver *serial_driver;
>
> -/* number of characters left in xmit buffer before we ask for more */
> -#define WAKEUP_CHARS 256
> -
> -/* Debugging... DEBUG_INTR is bad to use when one of the zs
> - * lines is your console ;(
> - */
> -#undef SERIAL_DEBUG_INTR
> -#undef SERIAL_DEBUG_OPEN
> -#undef SERIAL_DEBUG_FLOW
> -
> -#define RS_ISR_PASS_LIMIT 256
> -
>  static void change_speed(struct m68k_serial *info);
>
>  /*
> @@ -363,7 +352,7 @@ static int startup(struct m68k_serial * info)
>        m68328_uart *uart = &uart_addr[info->line];
>        unsigned long flags;
>
> -       if (info->flags & S_INITIALIZED)
> +       if (info->flags & ASYNC_INITIALIZED)
>                return 0;
>
>        if (!info->xmit_buf) {
> @@ -404,7 +393,7 @@ static int startup(struct m68k_serial * info)
>
>        change_speed(info);
>
> -       info->flags |= S_INITIALIZED;
> +       info->flags |= ASYNC_INITIALIZED;
>        local_irq_restore(flags);
>        return 0;
>  }
> @@ -419,7 +408,7 @@ static void shutdown(struct m68k_serial * info)
>        unsigned long   flags;
>
>        uart->ustcnt = 0; /* All off! */
> -       if (!(info->flags & S_INITIALIZED))
> +       if (!(info->flags & ASYNC_INITIALIZED))
>                return;
>
>        local_irq_save(flags);
> @@ -432,7 +421,7 @@ static void shutdown(struct m68k_serial * info)
>        if (info->tty)
>                set_bit(TTY_IO_ERROR, &info->tty->flags);
>
> -       info->flags &= ~S_INITIALIZED;
> +       info->flags &= ~ASYNC_INITIALIZED;
>        local_irq_restore(flags);
>  }
>
> @@ -835,11 +824,11 @@ static int set_serial_info(struct m68k_serial * info,
>                if ((new_serial.baud_base != info->baud_base) ||
>                    (new_serial.type != info->type) ||
>                    (new_serial.close_delay != info->close_delay) ||
> -                   ((new_serial.flags & ~S_USR_MASK) !=
> -                    (info->flags & ~S_USR_MASK)))
> +                   ((new_serial.flags & ~ASYNC_USR_MASK) !=
> +                    (info->flags & ~ASYNC_USR_MASK)))
>                        return -EPERM;
> -               info->flags = ((info->flags & ~S_USR_MASK) |
> -                              (new_serial.flags & S_USR_MASK));
> +               info->flags = ((info->flags & ~ASYNC_USR_MASK) |
> +                              (new_serial.flags & ASYNC_USR_MASK));
>                info->custom_divisor = new_serial.custom_divisor;
>                goto check_and_exit;
>        }
> @@ -853,8 +842,8 @@ static int set_serial_info(struct m68k_serial * info,
>         */
>
>        info->baud_base = new_serial.baud_base;
> -       info->flags = ((info->flags & ~S_FLAGS) |
> -                       (new_serial.flags & S_FLAGS));
> +       info->flags = ((info->flags & ~ASYNC_FLAGS) |
> +                       (new_serial.flags & ASYNC_FLAGS));
>        info->type = new_serial.type;
>        info->close_delay = new_serial.close_delay;
>        info->closing_wait = new_serial.closing_wait;
> @@ -1022,13 +1011,13 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
>                local_irq_restore(flags);
>                return;
>        }
> -       info->flags |= S_CLOSING;
> +       info->flags |= ASYNC_CLOSING;
>        /*
>         * Now we wait for the transmit buffer to clear; and we notify
>         * the line discipline to only process XON/XOFF characters.
>         */
>        tty->closing = 1;
> -       if (info->closing_wait != S_CLOSING_WAIT_NONE)
> +       if (info->closing_wait != ASYNC_CLOSING_WAIT_NONE)
>                tty_wait_until_sent(tty, info->closing_wait);
>        /*
>         * At this point we stop accepting input.  To do this, we
> @@ -1064,7 +1053,7 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
>                }
>                wake_up_interruptible(&info->open_wait);
>        }
> -       info->flags &= ~(S_NORMAL_ACTIVE|S_CLOSING);
> +       info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
>        wake_up_interruptible(&info->close_wait);
>        local_irq_restore(flags);
>  }
> @@ -1083,7 +1072,7 @@ void rs_hangup(struct tty_struct *tty)
>        shutdown(info);
>        info->event = 0;
>        info->count = 0;
> -       info->flags &= ~S_NORMAL_ACTIVE;
> +       info->flags &= ~ASYNC_NORMAL_ACTIVE;
>        info->tty = NULL;
>        wake_up_interruptible(&info->open_wait);
>  }
> @@ -1104,10 +1093,10 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
>         * If the device is in the middle of being closed, then block
>         * until it's done, and then try again.
>         */
> -       if (info->flags & S_CLOSING) {
> +       if (info->flags & ASYNC_CLOSING) {
>                interruptible_sleep_on(&info->close_wait);
>  #ifdef SERIAL_DO_RESTART
> -               if (info->flags & S_HUP_NOTIFY)
> +               if (info->flags & ASYNC_HUP_NOTIFY)
>                        return -EAGAIN;
>                else
>                        return -ERESTARTSYS;
> @@ -1122,7 +1111,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
>         */
>        if ((filp->f_flags & O_NONBLOCK) ||
>            (tty->flags & (1 << TTY_IO_ERROR))) {
> -               info->flags |= S_NORMAL_ACTIVE;
> +               info->flags |= ASYNC_NORMAL_ACTIVE;
>                return 0;
>        }
>
> @@ -1147,9 +1136,9 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
>                local_irq_enable();
>                current->state = TASK_INTERRUPTIBLE;
>                if (tty_hung_up_p(filp) ||
> -                   !(info->flags & S_INITIALIZED)) {
> +                   !(info->flags & ASYNC_INITIALIZED)) {
>  #ifdef SERIAL_DO_RESTART
> -                       if (info->flags & S_HUP_NOTIFY)
> +                       if (info->flags & ASYNC_HUP_NOTIFY)
>                                retval = -EAGAIN;
>                        else
>                                retval = -ERESTARTSYS;
> @@ -1158,7 +1147,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
>  #endif
>                        break;
>                }
> -               if (!(info->flags & S_CLOSING) && do_clocal)
> +               if (!(info->flags & ASYNC_CLOSING) && do_clocal)
>                        break;
>                 if (signal_pending(current)) {
>                        retval = -ERESTARTSYS;
> @@ -1176,7 +1165,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
>
>        if (retval)
>                return retval;
> -       info->flags |= S_NORMAL_ACTIVE;
> +       info->flags |= ASYNC_NORMAL_ACTIVE;
>        return 0;
>  }
>
> diff --git a/drivers/tty/serial/68328serial.h b/drivers/tty/serial/68328serial.h
> index 3d2faab..a804ea5 100644
> --- a/drivers/tty/serial/68328serial.h
> +++ b/drivers/tty/serial/68328serial.h
> @@ -11,69 +11,6 @@
>  #ifndef _MC683XX_SERIAL_H
>  #define _MC683XX_SERIAL_H
>
> -
> -struct serial_struct {
> -       int     type;
> -       int     line;
> -       int     port;
> -       int     irq;
> -       int     flags;
> -       int     xmit_fifo_size;
> -       int     custom_divisor;
> -       int     baud_base;
> -       unsigned short  close_delay;
> -       char    reserved_char[2];
> -       int     hub6;  /* FIXME: We don't have AT&T Hub6 boards! */
> -       unsigned short  closing_wait; /* time to wait before closing */
> -       unsigned short  closing_wait2; /* no longer used... */
> -       int     reserved[4];
> -};
> -
> -/*
> - * For the close wait times, 0 means wait forever for serial port to
> - * flush its output.  65535 means don't wait at all.
> - */
> -#define S_CLOSING_WAIT_INF     0
> -#define S_CLOSING_WAIT_NONE    65535
> -
> -/*
> - * Definitions for S_struct (and serial_struct) flags field
> - */
> -#define S_HUP_NOTIFY 0x0001 /* Notify getty on hangups and closes
> -                                  on the callout port */
> -#define S_FOURPORT  0x0002     /* Set OU1, OUT2 per AST Fourport settings */
> -#define S_SAK  0x0004  /* Secure Attention Key (Orange book) */
> -#define S_SPLIT_TERMIOS 0x0008 /* Separate termios for dialin/callout */
> -
> -#define S_SPD_MASK     0x0030
> -#define S_SPD_HI       0x0010  /* Use 56000 instead of 38400 bps */
> -
> -#define S_SPD_VHI      0x0020  /* Use 115200 instead of 38400 bps */
> -#define S_SPD_CUST     0x0030  /* Use user-specified divisor */
> -
> -#define S_SKIP_TEST    0x0040 /* Skip UART test during autoconfiguration */
> -#define S_AUTO_IRQ  0x0080 /* Do automatic IRQ during autoconfiguration */
> -#define S_SESSION_LOCKOUT 0x0100 /* Lock out cua opens based on session */
> -#define S_PGRP_LOCKOUT    0x0200 /* Lock out cua opens based on pgrp */
> -#define S_CALLOUT_NOHUP   0x0400 /* Don't do hangups for cua device */
> -
> -#define S_FLAGS        0x0FFF  /* Possible legal S flags */
> -#define S_USR_MASK 0x0430      /* Legal flags that non-privileged
> -                                * users can set or reset */
> -
> -/* Internal flags used only by kernel/chr_drv/serial.c */
> -#define S_INITIALIZED  0x80000000 /* Serial port was initialized */
> -#define S_CALLOUT_ACTIVE       0x40000000 /* Call out device is active */
> -#define S_NORMAL_ACTIVE        0x20000000 /* Normal device is active */
> -#define S_BOOT_AUTOCONF        0x10000000 /* Autoconfigure port on bootup */
> -#define S_CLOSING              0x08000000 /* Serial port is closing */
> -#define S_CTS_FLOW             0x04000000 /* Do CTS flow control */
> -#define S_CHECK_CD             0x02000000 /* i.e., CLOCAL */
> -
> -/* Software state per channel */
> -
> -#ifdef __KERNEL__
> -
>  /*
>  * I believe this is the optimal setting that reduces the number of interrupts.
>  * At high speeds the output might become a little "bursted" (use USTCNT_TXHE
> @@ -162,25 +99,12 @@ struct m68k_serial {
>        wait_queue_head_t       close_wait;
>  };
>
> -
>  #define SERIAL_MAGIC 0x5301
>
> -/*
> - * The size of the serial xmit buffer is 1 page, or 4096 bytes
> - */
> -#define SERIAL_XMIT_SIZE 4096
> -
> -/*
> - * Events are used to schedule things to happen at timer-interrupt
> - * time, instead of at rs interrupt time.
> - */
> -#define RS_EVENT_WRITE_WAKEUP  0
> -
>  /*
>  * Define the number of ports supported and their irqs.
>  */
>  #define NR_PORTS 1
>  #define UART_IRQ_DEFNS {UART_IRQ_NUM}
>
> -#endif /* __KERNEL__ */
>  #endif /* !(_MC683XX_SERIAL_H) */
> --
> 1.7.9.2

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
