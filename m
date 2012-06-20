Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2FTUg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:36:56 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:25064 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2FTUgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:36:55 -0400
X-RZG-AUTH: :IGUKb2CkcrLHmZv+FHarxbxlXmJO7WRQLa+vsyW+4RLunWeioNrxLCSDjJ8=
X-RZG-CLASS-ID: mo00
From: Stephan Linz <linz@li-pro.net>
To: monstr@monstr.eu
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        Stephan Linz <linz@li-pro.net>
Subject: [PATCH] microblaze: improve failure handling for GPIO reset
Date: Wed, 20 Jun 2012 22:36:37 +0200
Message-Id: <1340224597-18282-1-git-send-email-linz@li-pro.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early exit from of_platform_reset_gpio_probe() if there
was no GPIO reset line configured.

Avoid kernel oops in gpio_system_reset():

[   27.413294] Restarting system.
[   27.415674] Machine restart...
[   27.418787] Oops: kernel access of bad area, sig: 11
[   27.423252]  Registers dump: mode=83871D1C
[   27.427428]  r1=00000000, r2=00000000, r3=FFFFFEF8, r4=00000000
[   27.433310]  r5=C026AED0, r6=00000001, r7=00000068, r8=00000000
[   27.439189]  r9=C3871DAC, r10=000011A5, r11=00000000, r12=0000000A
[   27.445318]  r13=00000000, r14=0000000F, r15=C00029BC, r16=00000000
[   27.451558]  r17=C011DE8C, r18=80000115, r19=0000000F, r20=48184ED8
[   27.457770]  r21=00000000, r22=FFFFFFEA, r23=00000001, r24=FEE1DEAD
[   27.463982]  r25=00000054, r26=1000B1C8, r27=00000000, r28=00000000
[   27.470208]  r29=00000000, r30=00000000, r31=C32D30C0, rPC=C011DE8C
[   27.476433]  msr=000042A2, ear=0000004B, esr=00000872, fsr=342E3732

Signed-off-by: Stephan Linz <linz@li-pro.net>
---
 arch/microblaze/kernel/reset.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/reset.c b/arch/microblaze/kernel/reset.c
index 88a0163..7a08071 100644
--- a/arch/microblaze/kernel/reset.c
+++ b/arch/microblaze/kernel/reset.c
@@ -28,6 +28,7 @@ void of_platform_reset_gpio_probe(void)
 	if (!gpio_is_valid(handle)) {
 		printk(KERN_INFO "Skipping unavailable RESET gpio %d (%s)\n",
 				handle, "reset");
+		return;
 	}
 
 	ret = gpio_request(handle, "reset");
@@ -60,7 +61,8 @@ err:
 
 static void gpio_system_reset(void)
 {
-	gpio_set_value(handle, 1 - reset_val);
+	if (gpio_is_valid(handle))
+		gpio_set_value(handle, 1 - reset_val);
 }
 #else
 #define gpio_system_reset() do {} while (0)
@@ -74,6 +76,7 @@ void machine_restart(char *cmd)
 {
 	printk(KERN_NOTICE "Machine restart...\n");
 	gpio_system_reset();
+	printk(KERN_NOTICE "Dump stack on machines without reset line ...\n");
 	dump_stack();
 	while (1)
 		;
-- 
1.7.0.4

