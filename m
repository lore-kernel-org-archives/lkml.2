Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1HKSlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:41:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58957 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab1HKSlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:41:15 -0400
From: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
        linux@arm.linux.org.uk
Cc: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
Subject: [PATCH] mach-ixp4xx: made gpio functions atomic
Date: Thu, 11 Aug 2011 20:39:02 +0200
Message-Id: <1313087942-2335-1-git-send-email-fransmeulenbroeks@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio_line_set and gpio_line config on ixp4xx were not atomic
This patch fixes this by surrounding them with local_irq_save and
local_irq_restore calls, similar to the way Lennert Buytenhek
implemented this for iop. (see arch/arm/plat-iop/gpio.c)

Signed-off-by: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
---

Note: an alternative solution would be to use the set_bit and 
clear_bit atomic functions, but I felt it better to do things
the same way as Lennert did. Also it could be that this is a few
bytes smaller. Didn't check that.

PS: please Cc me as I am not on the list

--- git/arch/arm/mach-ixp4xx/include/mach/platform.h.orig	2011-08-09 19:16:52.645482269 +0200
+++ git/arch/arm/mach-ixp4xx/include/mach/platform.h	2011-08-09 19:17:39.915482235 +0200
@@ -14,6 +14,8 @@
 #ifndef __ASSEMBLY__
 
 #include <asm/types.h>
+#include <asm/system.h>
+#include <linux/kernel.h>
 
 #ifndef	__ARMEB__
 #define	REG_OFFSET	0
@@ -150,10 +152,14 @@
 
 static inline void gpio_line_config(u8 line, u32 direction)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	if (direction == IXP4XX_GPIO_IN)
 		*IXP4XX_GPIO_GPOER |= (1 << line);
 	else
 		*IXP4XX_GPIO_GPOER &= ~(1 << line);
+	local_irq_restore(flags);
 }
 
 static inline void gpio_line_get(u8 line, int *value)
@@ -163,10 +169,14 @@
 
 static inline void gpio_line_set(u8 line, int value)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	if (value == IXP4XX_GPIO_HIGH)
 	    *IXP4XX_GPIO_GPOUTR |= (1 << line);
 	else if (value == IXP4XX_GPIO_LOW)
 	    *IXP4XX_GPIO_GPOUTR &= ~(1 << line);
+	local_irq_restore(flags);
 }
 
 #endif // __ASSEMBLY__
