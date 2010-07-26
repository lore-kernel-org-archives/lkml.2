Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab0GZTRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 15:17:21 -0400
Received: from kroah.org ([198.145.64.141]:45682 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab0GZTRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 15:17:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Huewe <peterhuewe@gmx.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] serial: fix rs485 for atmel_serial on avr32
Date: Mon, 26 Jul 2010 12:17:17 -0700
Message-Id: <1280171837-13049-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100726190900.GB12683@kroah.com>
References: <20100726190900.GB12683@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch fixes a build failure [1-4] in the atmel_serial code introduced by
patch the patch ARM: 6092/1: atmel_serial: support for RS485
communications (e8faff7330a3501eafc9bfe5f4f15af444be29f5)

The build failure was caused by missing struct field and missing defines
for the avr32 board - the patch fixes this.

[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2575242/ - first failure in linux-next, may 11th
[2] http://kisskb.ellerman.id.au/kisskb/buildresult/2816418/ - still exists as of today
[3] http://kisskb.ellerman.id.au/kisskb/buildresult/2617511/ - first failure in Linus' tree - May 20th - did really no one notice this?!
[4] http://kisskb.ellerman.id.au/kisskb/buildresult/2813956/ - still exists in Linus' tree as of today

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/avr32/include/asm/ioctls.h             |    3 +++
 arch/avr32/mach-at32ap/include/mach/board.h |    2 ++
 drivers/serial/atmel_serial.c               |    1 +
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/include/asm/ioctls.h b/arch/avr32/include/asm/ioctls.h
index 0cf2c0a..e6ac0b6 100644
--- a/arch/avr32/include/asm/ioctls.h
+++ b/arch/avr32/include/asm/ioctls.h
@@ -54,6 +54,9 @@
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
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
1.7.2

