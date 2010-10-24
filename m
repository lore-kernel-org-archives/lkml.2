Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab0JXK61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 06:58:27 -0400
Received: from borg.asidev.net ([95.141.38.199]:50013 "EHLO borg.asidev.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab0JXK60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 06:58:26 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Oct 2010 06:58:26 EDT
Message-ID: <4CC40EFD.8070000@evidence.eu.com>
Date: Sun, 24 Oct 2010 12:48:29 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: =?UTF-8?B?QXJrYWRpdXN6IEJ1YmHFgmE=?= <arkadiusz.bubala@gmail.com>,
        linux@maxim.org.za,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: atmel_serial: fix RTS high after initialization in RS485 mode
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

	when working in RS485 mode, the atmel_serial driver keeps RTS
high after the initialization of the serial port. It goes low only after
the first character has been sent. 

This patch fixes this behavior. It has been already tested by Arkadiusz (CC:-ed).

Best regards,

	Claudio


atmel_serial: RTS line low after initialization of the serial port

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Arkadiusz Bubala <arkadiusz.bubala@gmail.com>
---
 drivers/serial/atmel_serial.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 3892666..85aa66f 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1732,6 +1732,15 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 1);
 	platform_set_drvdata(pdev, port);
 
+	if (port->rs485.flags & SER_RS485_ENABLED) {
+		unsigned int control = 0;
+		unsigned int mode = 0;
+		control |= ATMEL_US_RTSEN;
+		mode |= ATMEL_US_USMODE_NORMAL;
+		UART_PUT_MR(&port->uart, mode);
+		UART_PUT_CR(&port->uart, control);
+	}
+
 	return 0;
 
 err_add_port:
-- 
1.6.0.4

