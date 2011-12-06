Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab1LFHYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:24:12 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:24108 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434Ab1LFHYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:24:10 -0500
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-serial@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 2/2] serial: bfin-sport-uart: Request CTS GPIO PIN when the sport emulated serial device starts up.
Date: Tue, 6 Dec 2011 15:16:34 +0800
Message-ID: <1323155794-14696-2-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323155794-14696-1-git-send-email-sonic.adi@gmail.com>
References: <1323155794-14696-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

This patch is similar to that for bfin-uart hardware flow control.
Sport emulated serial device may be probed earlier before GPIOLIB is initialized.
Requesting and configuring CTS GPIO PIN fails in that early stage.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 drivers/tty/serial/bfin_sport_uart.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
index ee101c0..f650526 100644
--- a/drivers/tty/serial/bfin_sport_uart.c
+++ b/drivers/tty/serial/bfin_sport_uart.c
@@ -299,8 +299,13 @@ static int sport_startup(struct uart_port *port)
 			dev_info(port->dev, "Unable to attach BlackFin UART over SPORT CTS interrupt. So, disable it.\n");
 		}
 	}
-	if (up->rts_pin >= 0)
-		gpio_direction_output(up->rts_pin, 0);
+	if (up->rts_pin >= 0) {
+		if (gpio_request(up->rts_pin, DRV_NAME)) {
+			dev_info(port->dev, "fail to request RTS PIN at GPIO_%d\n", up->rts_pin);
+			up->rts_pin = -1;
+		} else
+			gpio_direction_output(up->rts_pin, 0);
+	}
 #endif
 
 	return 0;
@@ -445,6 +450,8 @@ static void sport_shutdown(struct uart_port *port)
 #ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
 	if (up->cts_pin >= 0)
 		free_irq(gpio_to_irq(up->cts_pin), up);
+	if (up->rts_pin >= 0)
+		gpio_free(up->rts_pin);
 #endif
 }
 
@@ -811,9 +818,6 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 			sport->rts_pin = -1;
 		else
 			sport->rts_pin = res->start;
-
-		if (sport->rts_pin >= 0)
-			gpio_request(sport->rts_pin, DRV_NAME);
 #endif
 	}
 
@@ -853,10 +857,6 @@ static int __devexit sport_uart_remove(struct platform_device *pdev)
 
 	if (sport) {
 		uart_remove_one_port(&sport_uart_reg, &sport->port);
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-		if (sport->rts_pin >= 0)
-			gpio_free(sport->rts_pin);
-#endif
 		iounmap(sport->port.membase);
 		peripheral_free_list(
 			(unsigned short *)pdev->dev.platform_data);
-- 
1.7.0.4


