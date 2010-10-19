Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab0JSMez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:34:55 -0400
Received: from 199-38.141.95.serverdedicati.seflow.it ([95.141.38.199]:57042
	"EHLO borg.asidev.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758252Ab0JSMex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:34:53 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2010 08:34:53 EDT
Message-ID: <4CBD9066.4090503@evidence.eu.com>
Date: Tue, 19 Oct 2010 14:34:46 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mikael Starvik <mikael.starvik@axis.com>,
        Jesper Nilsson <Jesper.Nilsson@axis.com>
CC: linux-cris-kernel <linux-cris-kernel@axis.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
        Janez Cufer <janez.cufer@cetrtapot.si>,
        Andy Whitcroft <apw@canonical.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dev-etrax <dev-etrax@axis.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH] CRIS RS485: Check SER_RS485_RTS_BEFORE_SEND before delaying.
References: <4C62BD2B.2010508@evidence.eu.com> <4C7B6C9B.2050801@evidence.eu.com> <4BEA3FF3CAA35E408EA55C7BE2E61D05583CAE6AF5@xmail3.se.axis.com>
In-Reply-To: <4BEA3FF3CAA35E408EA55C7BE2E61D05583CAE6AF5@xmail3.se.axis.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Starvik ha scritto:
> Hi!
> 
> Jesper is on vacation but I find this patch ok.
> 
> Acked-by: Mikael Starvik<Starvik@axis.com>

Hi Mikael, Hi Jesper,

	the merge window will be opened very soon. So, please remember
this patch.

I already fixed the atmel_serial driver (commit number
1b6331848b69d1ed165a6bdc75c4046d68767563)
	
Now, it's quite important to fix the Cris driver as well.

Cheers,

       Claudio


CRIS RS485: Check SER_RS485_RTS_BEFORE_SEND before delaying.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Acked-by: Mikael Starvik <Starvik@axis.com>
---
 drivers/serial/crisv10.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index c856905..a2237e7 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -1411,11 +1411,12 @@ e100_enable_rs485(struct tty_struct *tty, struct serial_rs485 *r)
 		       CONFIG_ETRAX_RS485_LTC1387_RXEN_PORT_G_BIT, 1);
 #endif
 
-	info->rs485.flags = r->flags;
-	if (r->delay_rts_before_send >= 1000)
+	info->rs485 = *r;
+
+	/* Maximum delay before RTS equal to 1000 */
+	if (info->rs485.delay_rts_before_send >= 1000)
 		info->rs485.delay_rts_before_send = 1000;
-	else
-		info->rs485.delay_rts_before_send = r->delay_rts_before_send;
+
 /*	printk("rts: on send = %i, after = %i, enabled = %i",
 		    info->rs485.rts_on_send,
 		    info->rs485.rts_after_sent,
@@ -3234,9 +3235,9 @@ rs_write(struct tty_struct *tty,
 		e100_disable_rx(info);
 		e100_enable_rx_irq(info);
 #endif
-
-		if (info->rs485.delay_rts_before_send > 0)
-			msleep(info->rs485.delay_rts_before_send);
+		if ((info->rs485.flags & SER_RS485_RTS_BEFORE_SEND) &&
+			(info->rs485.delay_rts_before_send > 0))
+				msleep(info->rs485.delay_rts_before_send);
 	}
 #endif /* CONFIG_ETRAX_RS485 */
 
@@ -3694,6 +3695,11 @@ rs_ioctl(struct tty_struct *tty, struct file * file,
 
 		rs485data.delay_rts_before_send = rs485ctrl.delay_rts_before_send;
 		rs485data.flags = 0;
+		if (rs485data.delay_rts_before_send != 0)
+			rs485data.flags |= SER_RS485_RTS_BEFORE_SEND;
+		else
+			rs485data.flags &= ~(SER_RS485_RTS_BEFORE_SEND);
+
 		if (rs485ctrl.enabled)
 			rs485data.flags |= SER_RS485_ENABLED;
 		else
@@ -4527,6 +4533,7 @@ static int __init rs_init(void)
 		/* Set sane defaults */
 		info->rs485.flags &= ~(SER_RS485_RTS_ON_SEND);
 		info->rs485.flags |= SER_RS485_RTS_AFTER_SEND;
+		info->rs485.flags &= ~(SER_RS485_RTS_BEFORE_SEND);
 		info->rs485.delay_rts_before_send = 0;
 		info->rs485.flags &= ~(SER_RS485_ENABLED);
 #endif
