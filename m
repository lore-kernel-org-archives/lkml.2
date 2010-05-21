Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068Ab0EUQv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:51:59 -0400
Received: from kroah.org ([198.145.64.141]:50276 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934030Ab0EUQv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:51:56 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/25] serial: bfin_sport_uart: work around anomaly 05000473 (make 32bit fifo read atomic)
Date: Fri, 21 May 2010 09:51:30 -0700
Message-Id: <1274460714-11277-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

We cannot let a 32-bit RX FIFO read be interrupted otherwise a fake RX
underflow error might be generated.

URL: http://blackfin.uclinux.org/gf/tracker/5145

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.h |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/serial/bfin_sport_uart.h
index abe0361..9791fcc 100644
--- a/drivers/serial/bfin_sport_uart.h
+++ b/drivers/serial/bfin_sport_uart.h
@@ -37,7 +37,21 @@
 #define SPORT_GET_TFSDIV(sport)		bfin_read16(((sport)->port.membase + OFFSET_TFSDIV))
 #define SPORT_GET_TX(sport)		bfin_read16(((sport)->port.membase + OFFSET_TX))
 #define SPORT_GET_RX(sport)		bfin_read16(((sport)->port.membase + OFFSET_RX))
-#define SPORT_GET_RX32(sport)		bfin_read32(((sport)->port.membase + OFFSET_RX))
+/*
+ * If another interrupt fires while doing a 32-bit read from RX FIFO,
+ * a fake RX underflow error will be generated.  So disable interrupts
+ * to prevent interruption while reading the FIFO.
+ */
+#define SPORT_GET_RX32(sport) \
+({ \
+	unsigned int __ret; \
+	if (ANOMALY_05000473) \
+		local_irq_disable(); \
+	__ret = bfin_read32((sport)->port.membase + OFFSET_RX); \
+	if (ANOMALY_05000473) \
+		local_irq_enable(); \
+	__ret; \
+})
 #define SPORT_GET_RCR1(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR1))
 #define SPORT_GET_RCR2(sport)		bfin_read16(((sport)->port.membase + OFFSET_RCR2))
 #define SPORT_GET_RCLKDIV(sport)	bfin_read16(((sport)->port.membase + OFFSET_RCLKDIV))
-- 
1.7.0.3

