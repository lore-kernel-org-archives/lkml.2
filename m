Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0F2RgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:36:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:44720 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932232Ab0F2Rf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:35:59 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/mC4kWVrPm652MAEyJ8i/zkgSvj8W8iMTb2sDx96
	dknkZfJLYHIyUR
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Claudio Scordino <claudio@evidence.eu.com>
Subject: [PATCH] serial: fix rs485 for atmel_serial on avr32
Date: Tue, 29 Jun 2010 19:35:39 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Howard Chu <hyc@symas.com>,
       Peter Ma <pma@mediamatech.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Alan Cox <alan@linux.intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       Bernhard Roth <br@pwrnet.de>, Ryan Mallon <ryan@bluewatersys.com>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Rick Bronson <rick@efn.org>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291935.40229.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a build failure [1-4] in the atmel_serial code introduced by
patch the patch ARM: 6092/1: atmel_serial: support for RS485
communications (e8faff7330a3501eafc9bfe5f4f15af444be29f5)

The build failure was caused by missing struct field and missing defines
for the avr32 board - the patch fixes this.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Despite so many reviewers of the original patch no one seemed to 
notice this issue :/

KernelVersion: linux-next-20100629

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2575242/ - first failure
in linux-next, may 11th
[2] http://kisskb.ellerman.id.au/kisskb/buildresult/2816418/ - still
exists as of today
[3] http://kisskb.ellerman.id.au/kisskb/buildresult/2617511/ - first
failure in Linus' tree - May 20th - did really no one notice this?!
[4] http://kisskb.ellerman.id.au/kisskb/buildresult/2813956/ - still
exists in Linus' tree as of today

 arch/avr32/include/asm/ioctls.h             |    3 +++
 arch/avr32/mach-at32ap/include/mach/board.h |    2 ++
 drivers/serial/atmel_serial.c               |    1 +
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/include/asm/ioctls.h b/arch/avr32/include/asm/ioctls.h
index bb32b6f..b7dd324 100644
--- a/arch/avr32/include/asm/ioctls.h
+++ b/arch/avr32/include/asm/ioctls.h
@@ -55,6 +55,9 @@
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 #define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
+#define TIOCGRS485      0x542E
+#define TIOCSRS485      0x542F
+
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
 #define FIOASYNC	0x5452
diff --git a/arch/avr32/mach-at32ap/include/mach/board.h b/arch/avr32/mach-at32ap/include/mach/board.h
index c7f25bb..6174020 100644
--- a/arch/avr32/mach-at32ap/include/mach/board.h
+++ b/arch/avr32/mach-at32ap/include/mach/board.h
@@ -5,6 +5,7 @@
 #define __ASM_ARCH_BOARD_H
 
 #include <linux/types.h>
+#include <linux/serial.h>
 
 #define GPIO_PIN_NONE	(-1)
 
@@ -35,6 +36,7 @@ struct atmel_uart_data {
 	short		use_dma_tx;	/* use transmit DMA? */
 	short		use_dma_rx;	/* use receive DMA? */
 	void __iomem	*regs;		/* virtual base address, if any */
+	struct serial_rs485	rs485;		/* rs485 settings */
 };
 void at32_map_usart(unsigned int hw_id, unsigned int line, int flags);
 struct platform_device *at32_add_device_usart(unsigned int id);
diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index eed3c2d..a182def 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -41,6 +41,7 @@
 #include <linux/uaccess.h>
 
 #include <asm/io.h>
+#include <asm/ioctls.h>
 
 #include <asm/mach/serial_at91.h>
 #include <mach/board.h>
-- 
1.7.1

