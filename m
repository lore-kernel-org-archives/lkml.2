Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab0ICVtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:49:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60235 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab0ICVtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:49:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DXopVlOaNwjQWqKuX3oBHP6PMstu8K+fkHHSP63yuhKSwH9b1UuBZR7wUfc9mQ8aZp
         lv5cYo1TFR+9QptB0/YgieZaMwwhwsyeRwluBgg7c2soP15sIBXZ1+iXnYMfUtVf4h33
         pcThyFs0rwQejSnAZKSYZ8K1+xYPPlBjhq6gE=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 5/6] ARM: pxa168: added keypad wake clear event support for platform
Date: Thu, 26 Aug 2010 11:27:36 -0400
Message-Id: <1282836457-5651-6-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282836457-5651-1-git-send-email-mark.brown314@gmail.com>
References: <1282836457-5651-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/mach-mmp/include/mach/pxa168.h |    5 +++++
 arch/arm/mach-mmp/pxa168.c              |   10 ++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/include/mach/pxa168.h b/arch/arm/mach-mmp/include/mach/pxa168.h
index f34e663..1801e42 100644
--- a/arch/arm/mach-mmp/include/mach/pxa168.h
+++ b/arch/arm/mach-mmp/include/mach/pxa168.h
@@ -5,6 +5,7 @@ struct sys_timer;
 
 extern struct sys_timer pxa168_timer;
 extern void __init pxa168_init_irq(void);
+extern void pxa168_clear_keypad_wakeup(void);
 
 #include <linux/i2c.h>
 #include <mach/devices.h>
@@ -12,6 +13,7 @@ extern void __init pxa168_init_irq(void);
 #include <plat/pxa3xx_nand.h>
 #include <video/pxa168fb.h>
 #include <plat/pxa27x_keypad.h>
+#include <mach/cputype.h>
 
 extern struct pxa_device_desc pxa168_device_uart1;
 extern struct pxa_device_desc pxa168_device_uart2;
@@ -109,6 +111,9 @@ static inline int pxa168_add_fb(struct pxa168fb_mach_info *mi)
 
 static inline int pxa168_add_keypad(struct pxa27x_keypad_platform_data *data)
 {
+	if (cpu_is_pxa168())
+		data->clear_wakeup_event = pxa168_clear_keypad_wakeup;
+
 	return pxa_register_device(&pxa168_device_keypad, data, sizeof(*data));
 }
 
diff --git a/arch/arm/mach-mmp/pxa168.c b/arch/arm/mach-mmp/pxa168.c
index 2fa16fb..72b4e76 100644
--- a/arch/arm/mach-mmp/pxa168.c
+++ b/arch/arm/mach-mmp/pxa168.c
@@ -136,6 +136,16 @@ struct sys_timer pxa168_timer = {
 	.init	= pxa168_timer_init,
 };
 
+void pxa168_clear_keypad_wakeup(void)
+{
+	uint32_t val;
+	uint32_t mask = APMU_PXA168_KP_WAKE_CLR;
+
+	/* wake event clear is needed in order to clear keypad interrupt */
+	val = __raw_readl(APMU_WAKE_CLR);
+	__raw_writel(val |  mask, APMU_WAKE_CLR);
+}
+
 /* on-chip devices */
 PXA168_DEVICE(uart1, "pxa2xx-uart", 0, UART1, 0xd4017000, 0x30, 21, 22);
 PXA168_DEVICE(uart2, "pxa2xx-uart", 1, UART2, 0xd4018000, 0x30, 23, 24);
-- 
1.7.0.4

