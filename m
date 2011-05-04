Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1EDTI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:08:59 -0400
Received: from legolas.restena.lu ([158.64.1.34]:46309 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab1EDTI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:08:58 -0400
Date: Wed, 4 May 2011 21:08:42 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [hid-picolcd] Avoid compile warning/error triggered by
 copy_from_user()
Message-ID: <20110504210842.50edc842@neptune.home>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y compilation of PicoLCD
driver fails on copy_from_user(), without it a warning is generated:

  CC [M]  drivers/hid/hid-picolcd.o
In file included from /usr/src/linux-2.6/arch/x86/include/asm/uaccess.h:571,
                 from /usr/src/linux-2.6/arch/x86/include/asm/sections.h:5,
                 from /usr/src/linux-2.6/arch/x86/include/asm/hw_irq.h:26,
                 from /usr/src/linux-2.6/include/linux/irq.h:359,
                 from /usr/src/linux-2.6/arch/x86/include/asm/hardirq.h:5,
                 from /usr/src/linux-2.6/include/linux/hardirq.h:7,
                 from /usr/src/linux-2.6/include/linux/interrupt.h:12,
                 from /usr/src/linux-2.6/include/linux/usb.h:15,
                 from /usr/src/linux-2.6/drivers/hid/hid-picolcd.c:25:
In function 'copy_from_user',
    inlined from 'picolcd_debug_eeprom_write' at drivers/hid/hid-picolcd.c:1592:
arch/x86/include/asm/uaccess_32.h:212: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct

gcc-4.4.5 is not able to track size calculation when it is stored into
a variable, thus tell copy_from_user() maximum size via
min(*max-size*, *effective-size*) explicitly and inline how much to copy
at most.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
--

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index b2f56a1..9d8710f 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -1585,11 +1585,11 @@ static ssize_t picolcd_debug_eeprom_write(struct file *f, const char __user *u,
 	memset(raw_data, 0, sizeof(raw_data));
 	raw_data[0] = *off & 0xff;
 	raw_data[1] = (*off >> 8) & 0xff;
-	raw_data[2] = s < 20 ? s : 20;
+	raw_data[2] = min((size_t)20, s);
 	if (*off + raw_data[2] > 0xff)
 		raw_data[2] = 0x100 - *off;
 
-	if (copy_from_user(raw_data+3, u, raw_data[2]))
+	if (copy_from_user(raw_data+3, u, min((u8)20, raw_data[2])))
 		return -EFAULT;
 	resp = picolcd_send_and_wait(data->hdev, REPORT_EE_WRITE, raw_data,
 			sizeof(raw_data));
