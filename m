Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1BVKdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:33:04 -0500
Received: from blrmail.mistralsolutions.com ([220.227.112.130]:2398 "EHLO
	mistralsolutions.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753165Ab1BVKdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:33:02 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 05:33:00 EST
X-Spam-Processed: mistralsolutions.com, Tue, 22 Feb 2011 15:56:51 +0530
	(not processed: spam filter heuristic analysis disabled)
X-Authenticated-Sender: subhasish@mistralsolutions.com
X-MDRemoteIP: 192.168.13.21
X-Return-Path: subhasish@mistralsolutions.com
X-Envelope-From: subhasish@mistralsolutions.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <A6D1CF0E941748448610BE8874FC586F@subhasishg>
From: "Subhasish" <subhasish@mistralsolutions.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Stalin Srinivasan" <stalin.s@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com><1297435892-28278-14-git-send-email-subhasish@mistralsolutions.com> <20110211162814.6ff274f1@lxorguk.ukuu.org.uk>
In-Reply-To: <20110211162814.6ff274f1@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver
Date: Tue, 22 Feb 2011 15:56:41 +0530
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------------------------------------------
From: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Sent: Friday, February 11, 2011 9:58 PM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>;
<linux-arm-kernel@lists.infradead.org>; <m-watkins@ti.com>;
<nsekhar@ti.com>; <sachi@mistralsolutions.com>; "Greg Kroah-Hartman"
<gregkh@suse.de>; "open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver

> Don't see why it needs its own sub-directory

SG - We have two different layers of implementation. One is the driver
layer, which interacts with the TTY sub-system and the other is the API 
layer,
which interacts with the PRUSS. To maintain this (also explained in the 
other mail),
we used separate files and hence we decided to keep the code in a separate
directory so that the related files can be identified easily.

>
>
>
>> +#ifdef __SUART_DEBUG
>> +#define __suart_debug(fmt, args...) \
>> + printk(KERN_DEBUG "suart_debug: " fmt, ## args)
>> +#else
>> +#define __suart_debug(fmt, args...)
>> +#endif
>> +
>> +#define  __suart_err(fmt, args...) printk(KERN_ERR "suart_err: " fmt, ##
>> args)
>
> Use dev_dbg/dev_err/pr_debug/pr_err

SG - did you mean replace the printks above with dev_dgb/err or the 
suart_dbg/err.

>
>
>> +static void omapl_pru_tx_chars(struct omapl_pru_suart *soft_uart, u32
>> uart_no)
>> +{
>> + struct circ_buf *xmit = &soft_uart->port[uart_no].state->xmit;
>> + struct device *dev = soft_uart->dev;
>> + s32 count = 0;
>> +
>> + if (!(suart_get_duplex(soft_uart, uart_no) & ePRU_SUART_HALF_TX))
>> + return;
>> +
>> + if (down_trylock(&soft_uart->port_sem[uart_no]))
>> + return;
>
> Please use a mutex not a semaphore. We are trying to get almost all the
> kernel using mutexes as it is needed for hard real time.

SG - Have removed, need your feedback.

>
>
>> + pru_softuart_read_data(dev, &soft_uart->suart_hdl[uart_no],
>> +        suart_data, data_len + 1,
>> +        &data_len_read);
>> +
>> + for (i = 0; i <= data_len_read; i++) {
>> + soft_uart->port[uart_no].icount.rx++;
>> + /* check for sys rq */
>> + if (uart_handle_sysrq_char
>> +     (&soft_uart->port[uart_no], suart_data))
>> + continue;
>> + }
>> + /* update the tty data structure */
>> + tty_insert_flip_string(tty, suart_data, data_len_read);
>
> You can avoid a copy here by using tty_prepare_flip_string()

SG - Ok, Thus this look ok ?
==================================================================================
--- a/drivers/tty/serial/da8xx_pruss/pruss_suart.c
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart.c
@@ -170,8 +170,9 @@ static void omapl_pru_rx_chars(struct omapl_pru_suart 
*soft_uart, u32 uart_no)
        s8 flags = TTY_NORMAL;
        u16 rx_status, data_len = SUART_FIFO_LEN;
        u32 data_len_read;
-       u8 suart_data[SUART_FIFO_LEN + 1];
+       u8 *suart_data = NULL;
        s32 i = 0;
+       s32 alloc_len = 0;

        if (!(suart_get_duplex(soft_uart, uart_no) & ePRU_SUART_HALF_RX))
                return;
@@ -199,9 +200,10 @@ static void omapl_pru_rx_chars(struct omapl_pru_suart 
*soft_uart, u32 uart_no)
                soft_uart->port[uart_no].sysrq = 0;
 #endif
        } else {
+               alloc_len = tty_prepare_flip_string(tty, &suart_data, 
data_len + 1);
                pru_softuart_read_data(dev, &soft_uart->suart_hdl[uart_no],
-                                      suart_data, data_len + 1,
-                                      &data_len_read);
+                                               suart_data, alloc_len,
+                                               &data_len_read);

                for (i = 0; i <= data_len_read; i++) {
                        soft_uart->port[uart_no].icount.rx++;
@@ -210,8 +212,6 @@ static void omapl_pru_rx_chars(struct omapl_pru_suart 
*soft_uart, u32 uart_no)
                            (&soft_uart->port[uart_no], suart_data))
                                continue;
                }
-               /* update the tty data structure */
-               tty_insert_flip_string(tty, suart_data, data_len_read);
        }
============================================================================================

> Also please use the tty_port_tty_get/tty_kref_put interfaces so the tty
> refcounting is right

SG - Ok, Will do.

>
>
>> +static void pruss_suart_set_termios(struct uart_port *port,
>> +   struct ktermios *termios,
>> +   struct ktermios *old)
>> +{
>> + struct omapl_pru_suart *soft_uart =
>> +     container_of(port, struct omapl_pru_suart, port[port->line]);
>> + struct device *dev = soft_uart->dev;
>> + u8 cval = 0;
>> + unsigned long flags = 0;
>> + u32 baud = 0;
>> + u32 old_csize = old ? old->c_cflag & CSIZE : CS8;
>> +
>> +/*
>> + * Do not allow unsupported configurations to be set
>> + */
>> + if (1) {
>> + termios->c_cflag &= ~(HUPCL | CRTSCTS | CMSPAR | CSTOPB
>> +       | PARENB | PARODD | CMSPAR);
>> + termios->c_cflag |= CLOCAL;
>
> No. CLOCAL and HUPCL are user side flags. Apps expect to able to set them
> even if in fact they have no effect, so leave those two alone. The rest
> is fine.

SG -Ok, will do.

>
>
>> +/*
>> + * Characteres to ignore
>
> Typo
>

SG - ok.

>
>
>> diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart_api.c
>> b/drivers/tty/serial/da8xx_pruss/pruss_suart_api.c
>> new file mode 100644
>> index 0000000..d809dd3
>> --- /dev/null
>> +++ b/drivers/tty/serial/da8xx_pruss/pruss_suart_api.c
>> @@ -0,0 +1,2350 @@
>> +/*
>> + * Copyright (C) 2010 Texas Instruments Incorporated
>> + * Author: Jitendra Kumar <jitendra@mistralsolutions.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> it
>> + * under the terms of the GNU General Public License as  published by
>> the
>> + * Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
>> + * whether express or implied; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <linux/mfd/pruss/da8xx_pru.h>
>> +#include <linux/io.h>
>> +#include <mach/hardware.h>
>> +#include "pruss_suart_api.h"
>> +#include "pruss_suart_regs.h"
>> +#include "pruss_suart_board.h"
>> +#include "pruss_suart_utils.h"
>> +#include "pruss_suart_err.h"
>> +
>> +static u8 g_uart_statu_table[8];
> Can you lose the g_, its  a windows naming convention we dont use

SG -- Ok, I can also see the Hungarian style like u32Offset, will get rid of 
these as well.
            Would really appreciate if you may please point me out more such 
problems.

>
>
>> +s16 pru_softuart_open(suart_handle h_suart)
>> +{
>
> If you just used normal integers you could surely make this routine
> trivial and remove all the duplication in the switches

SG -- Ok, will do.

>
>> + s16 status = PRU_SUART_SUCCESS;
>
> And please stick to Linux error codes

SG - Ok, Will do
>
>
>> +/* suart instance close routine */
>> +s16 pru_softuart_close(suart_handle h_uart)
>> +{
>> + s16 status = SUART_SUCCESS;
>> +
>> + if (h_uart == NULL) {
>> + return PRU_SUART_ERR_HANDLE_INVALID;
>
> Which is never checked. Far better to use WARN_ON and the like for such
> cases - or if like this one they don't appear to be possible to simply
> delete them

SG -- OK, does this look ok ?
=================================
if (h_uart == NULL) {
+WARN_ON(1);
- return PRU_SUART_ERR_HANDLE_INVALID;
+return -EINVAL;
}
=================================

>
>> + if ((tx_clk_divisor > 385) || (tx_clk_divisor == 0))
>> + return SUART_INVALID_CLKDIVISOR;
>> + if ((rx_clk_divisor > 385) || (rx_clk_divisor == 0))
>> + return SUART_INVALID_CLKDIVISOR;
>
> [minor] Lots of excess brackets

Ok - Will do.
>
>
>> + u32offset = (u32) (PRUSS_INTC_CHANMAP9 & 0xFFFF);
>> + u32value = PRU_INTC_CHAN_34_SYSEVT_36_39;
>> + s16retval = pruss_writel(dev, u32offset, (u32 *)&u32value, 1);
>> + if (-1 == s16retval)
>> + return -1;
>
> If you fixed the API here you'd be able to just write
>
> if (pruss_writel(dev, PRUSS_INTC_CHANMAP9 & 0xFFFF,
> PRU_INTC_BLAH)
>
> or similar which would clean up a lot of messy code and shrink it
> dramatically. Given you have lots of series of writes some kind of
>
> pruss_writel_multi(dev, array, len)
>
> that took an array of addr/value pairs might also clean up a ton of code
> and turn it into trivial tables

SG -- Will shrink this function.

> 

Please do not print this email unless it is absolutely necessary. Spread environmental awareness.

-------------------------------------------------------DISCLAIMER------------------------------------------------------
The information transmitted herewith is confidential and proprietary information intended only for use by the individual or entity to which it is addressed. If the reader of this message is not the intended recipient, you are hereby notified that any review, retransmission, dissemination, distribution, copying or other use of, or taking of any action in reliance upon this information is strictly prohibited. If you have received this communication in error, please contact the sender and delete the material from your computer.
---------------------------------------------------------------------------------------------------------------------------

