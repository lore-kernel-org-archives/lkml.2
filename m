Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2LJTM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:12:58 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55666 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926Ab2LJTMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:12:52 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, benh@kernel.crashing.org, arnd@arndb.de,
        james.hogan@imgtec.com, Matthew Leach <matthew@mattleach.net>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 08/10] musb: tusb6010: use io{read,write}*_rep accessors
Date: Mon, 10 Dec 2012 19:12:40 +0000
Message-Id: <1355166762-15133-9-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
References: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Leach <matthew@mattleach.net>

The {read,write}s{b,w,l} operations are not defined by all
architectures and are being removed from the asm-generic/io.h
interface.

This patch replaces the usage of these string functions in the
tusb6010 accessors with io{read,write}{8,16,32}_rep calls instead.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Matthew Leach <matthew@mattleach.net>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 drivers/usb/musb/tusb6010.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index dc4d75e..0cc2f50 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -22,6 +22,7 @@
 #include <linux/prefetch.h>
 #include <linux/usb.h>
 #include <linux/irq.h>
+#include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/usb/nop-usb-xceiv.h>
@@ -198,7 +199,7 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *buf)
 		/* Best case is 32bit-aligned destination address */
 		if ((0x02 & (unsigned long) buf) == 0) {
 			if (len >= 4) {
-				writesl(fifo, buf, len >> 2);
+				iowrite32_rep(fifo, buf, len >> 2);
 				buf += (len & ~0x03);
 				len &= 0x03;
 			}
@@ -245,7 +246,7 @@ void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *buf)
 		/* Best case is 32bit-aligned destination address */
 		if ((0x02 & (unsigned long) buf) == 0) {
 			if (len >= 4) {
-				readsl(fifo, buf, len >> 2);
+				ioread32_rep(fifo, buf, len >> 2);
 				buf += (len & ~0x03);
 				len &= 0x03;
 			}
-- 
1.8.0

