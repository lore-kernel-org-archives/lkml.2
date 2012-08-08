Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab2HHSoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:44:01 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:34243 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480Ab2HHSn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:43:59 -0400
X-RZG-AUTH: :IGUKb2CkcrLHmZv+FHarxbxlXmJO7WRQLa+vsyW+4RLunWeioNrxJjHjnSyY
X-RZG-CLASS-ID: mo00
From: Stephan Linz <linz@li-pro.net>
To: monstr@monstr.eu
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        Stephan Linz <linz@li-pro.net>
Subject: [PATCH v2] microblaze: improve failure handling for GPIO reset
Date: Wed,  8 Aug 2012 20:43:52 +0200
Message-Id: <1344451432-30735-1-git-send-email-linz@li-pro.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early exit from of_platform_reset_gpio_probe() if there
was no GPIO reset line configured.

Avoid kernel oops in gpio_system_reset():

[   96.603690] Restarting system.
[   96.606094] Machine restart...
[   96.608810] Oops: kernel access of bad area, sig: 11
[   96.613662]  Registers dump: mode=824C1D1C
[   96.617858]  r1=C000BB0C, r2=00000000, r3=FFFFFEF8, r4=000015B4
[   96.623736]  r5=C0276270, r6=00000001, r7=FFFFFFFF, r8=000015B4
[   96.629597]  r9=000015B3, r10=000015B4, r11=00000000, r12=00000000
[   96.635733]  r13=00000000, r14=0000000F, r15=C0002B04, r16=00000000
[   96.641973]  r17=C011E1A0, r18=80000115, r19=00000010, r20=48184ED8
[   96.648184]  r21=00000000, r22=FFFFFFEA, r23=00000001, r24=FEE1DEAD
[   96.654396]  r25=00000054, r26=1000B1C8, r27=00000000, r28=00000000
[   96.660622]  r29=00000000, r30=00000000, r31=C24A97E0, rPC=C011E1A0
[   96.666849]  msr=000042A2, ear=0000004C, esr=00000872, fsr=362E3639

Signed-off-by: Stephan Linz <linz@li-pro.net>
---
v2 Remove additional printk message from machine_restart()
---
 arch/microblaze/kernel/reset.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/reset.c b/arch/microblaze/kernel/reset.c
index 8d663d9..c021123 100644
--- a/arch/microblaze/kernel/reset.c
+++ b/arch/microblaze/kernel/reset.c
@@ -28,6 +28,7 @@ void of_platform_reset_gpio_probe(void)
 	if (!gpio_is_valid(handle)) {
 		printk(KERN_INFO "Skipping unavailable RESET gpio %d (%s)\n",
 				handle, "reset");
+		return;
 	}
 
 	ret = gpio_request(handle, "reset");
@@ -60,7 +61,10 @@ err:
 
 static void gpio_system_reset(void)
 {
-	gpio_set_value(handle, 1 - reset_val);
+	if (gpio_is_valid(handle))
+		gpio_set_value(handle, 1 - reset_val);
+	else
+		printk(KERN_NOTICE "Reset GPIO unavailable - halting!\n");
 }
 #else
 static void gpio_system_reset(void)
-- 
1.7.0.4

