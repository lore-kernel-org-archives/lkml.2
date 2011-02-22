Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1BVImJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:42:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34111 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1BVImI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:42:08 -0500
Message-ID: <DADE3366197E4479A57F3B967A881C33@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Arnd Bergmann" <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <sachi@mistralsolutions.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, <nsekhar@ti.com>,
        "open list" <linux-kernel@vger.kernel.org>, <m-watkins@ti.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <20110218143500.23b3044b@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1102181917520.2701@localhost6.localdomain6> <201102181951.32631.arnd@arndb.de>
In-Reply-To: <201102181951.32631.arnd@arndb.de>
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver
Date: Tue, 22 Feb 2011 14:13:21 +0530
Organization: Mistral Solutions
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

I agree with the Codingstyle which needs to be fixed and would appreciate 
more feedback on it.

I have also gotten rid of the semaphore completely, please let me know what 
you feel of this implementation:
I have tested this without any problem.
What I am basically doing below is that, I am getting the data from the circ 
buff and then using the interrupt handler to
pump out the data. As the circ buff empties, I am accepting another request 
from the TTY.
Are you noticing any problems with this:

diff --git a/drivers/tty/serial/da8xx_pruss/pruss_suart.c 
b/drivers/tty/serial/da8xx_pruss/pruss_suart.c
index d222e2e..edc3863 100644
--- a/drivers/tty/serial/da8xx_pruss/pruss_suart.c
+++ b/drivers/tty/serial/da8xx_pruss/pruss_suart.c
@@ -72,7 +72,7 @@ struct suart_fifo {
 struct omapl_pru_suart {
        struct uart_port port[NR_SUART];
        struct device *dev; /* pdev->dev */
-       struct semaphore port_sem[NR_SUART];
+       bool tx_empty[NR_SUART];
        struct clk *clk_mcasp;
        struct suart_fifo suart_fifo_addr[NR_SUART];
        const struct firmware *fw;
@@ -122,13 +122,10 @@ static void omapl_pru_tx_chars(struct omapl_pru_suart 
*soft_uart, u32 uart_no)
        if (!(suart_get_duplex(soft_uart, uart_no) & ePRU_SUART_HALF_TX))
                return;

-       if (down_trylock(&soft_uart->port_sem[uart_no]))
-               return;
-
        if (uart_circ_empty(xmit) ||
                        uart_tx_stopped(&soft_uart->port[uart_no])) {
                pruss_suart_stop_tx(&soft_uart->port[uart_no]);
-               up(&soft_uart->port_sem[uart_no]);
+               soft_uart->tx_empty[uart_no] = true;
                return;
        }

@@ -259,7 +256,6 @@ static irqreturn_t pruss_suart_interrupt(s32 irq, void 
*dev_id)
                        pru_intr_clr_isrstatus(dev, uart_num, PRU_TX_INTR);
                        pru_softuart_clr_tx_status(dev, 
&soft_uart->suart_hdl
                                                 [port->line]);
-                       up(&soft_uart->port_sem[port->line]);
                        omapl_pru_tx_chars(soft_uart, port->line);
                }
        } while (txrx_flag & (PRU_RX_INTR | PRU_TX_INTR));
@@ -294,7 +290,10 @@ static void pruss_suart_start_tx(struct uart_port 
*port)

        suart_intr_setmask(dev, soft_uart->suart_hdl[port->line].uart_num,
                           PRU_TX_INTR, CHN_TXRX_IE_MASK_CMPLT);
-       omapl_pru_tx_chars(soft_uart, port->line);
+       if (soft_uart->tx_empty[port->line] == true) {
+               soft_uart->tx_empty[port->line] = false;
+               omapl_pru_tx_chars(soft_uart, port->line);
+       }
 }


--------------------------------------------------
From: "Arnd Bergmann" <arnd@arndb.de>
Sent: Saturday, February 19, 2011 12:21 AM
To: <linux-arm-kernel@lists.infradead.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>; "Alan Cox" 
<alan@lxorguk.ukuu.org.uk>; <sachi@mistralsolutions.com>; 
<davinci-linux-open-source@linux.davincidsp.com>; "Subhasish Ghosh" 
<subhasish@mistralsolutions.com>; "Greg Kroah-Hartman" <gregkh@suse.de>; 
<nsekhar@ti.com>; "open list" <linux-kernel@vger.kernel.org>; 
<m-watkins@ti.com>
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver

> On Friday 18 February 2011 19:23:49 Thomas Gleixner wrote:
>> On Fri, 18 Feb 2011, Alan Cox wrote:
>>
>> > On Fri, 18 Feb 2011 19:17:38 +0530
>> > "Subhasish Ghosh" <subhasish@mistralsolutions.com> wrote:
>> >
>> > > Hello,
>> > >
>> > > Regarding the semaphore to mutex migration.
>> > > We are using down_trylock in interrupt context,
>> > > mutex_trylock cannot be used in interrupt context, so we cannot use 
>> > > mutex in
>> > > our driver.
>> >
>> > Then you probably need to rework your locking. Best bet might be to fix
>> > all the other stuff and report the driver, and people can think about 
>> > the
>> > locking problem.
>>
>> That semaphore is utterly useless to begin with. There are more
>> serious locking problems than this one. Non serialized calls to
>> suart_intr_clrmask/suart_intr_setmask are the most obvious ones.
>>
>> Aside of that the code is complete unreadable.
>
> I think it mostly suffers from the same problem as the CAN driver
> I commented on earlier: One of the files (pruss_suart_api.c) was
> clearly not written with Linux as the target, and the other files
> try to work around this by wrapping a Linux driver around it.
>
> The suart_api HAL stuff clearly needs to go away, so that the rest
> can be rewritten into a proper device driver.
>
> Arnd 

