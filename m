Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1FGBTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 21:19:41 -0400
Received: from d1.icnet.pl ([212.160.220.21]:32905 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab1FGBTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:19:39 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: [PATCH 3.0-rc2] OMAP: ams-delta: fix broken uevent sysfs entries
Date: Tue, 7 Jun 2011 03:16:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; i686; ; )
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106070316.41099.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6d3163ce86dd386b4f7bda80241d7fea2bc0bb1d, "mm: check if any 
page in a pageblock is reserved before marking it MIGRATE_RESERVE", 
exhibited a bug on my Amstrad Delta resulting in reading 
/sys/device/platform/*/uevent for selected devices, namely "omap-
keypad", "lcd_ams_delta", "ams-delta-led" and "soc-camera-pdrv", always 
ending up with segmentation faults:

[   77.499568] Unable to handle kernel paging request at virtual address 20676e69
[   77.561984] pgd = c1004000
[   77.583731] [20676e69] *pgd=00000000
[   77.587515] Internal error: Oops: 15 [#1] PREEMPT
[   77.592324] Modules linked in:
[   77.595521] CPU: 0    Not tainted  (3.0.0-rc2 #4)
[   77.600404] PC is at strlen+0x18/0x2c
[   77.604256] LR is at get_kobj_path_length+0x28/0x44
[   77.609286] pc : [<c01586c4>]    lr : [<c0154010>]    psr: 20000013
[   77.609344] sp : c1bf7e10  ip : c1bf7e20  fp : c1bf7e1c
[   77.620976] r10: c1020000  r9 : 00000000  r8 : c0359ab0
[   77.626323] r7 : c1945608  r6 : c1945608  r5 : 00000018  r4 : c00243b0
[   77.632988] r3 : 20676e69  r2 : 20676e69  r1 : 000000d0  r0 : 20676e69
[   77.639659] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   77.646942] Control: 0000317f  Table: 11004000  DAC: 00000015
[   77.652823] Process udevadm (pid: 551, stack limit = 0xc1bf6270)
[   77.658959] Stack: (0xc1bf7e10 to 0xc1bf8000)
[   77.663455] 7e00:                                     c1bf7e34 c1bf7e20 c0154010 c01586bc
[   77.671835] 7e20: 000000d0 00000003 c1bf7e54 c1bf7e38 c01542f4 c0153ff8 c180f340 00000001
[   77.680214] 7e40: 00000003 c180f340 c1bf7eb4 c1bf7e58 c0154c70 c01542e8 c1bf7ec4 c1bf7e68
[   77.688591] 7e60: c00ad9f4 c00acbd4 00000000 c03ebbd0 c1bf7e84 c040065c c00aeb48 00000000
[   77.696966] 7e80: 00000010 000280d0 c1bf7ec4 c1945600 00000003 c1be2780 c0359af8 00000003
[   77.705352] 7ea0: c1bf6000 c1be2798 c1bf7ec4 c1bf7eb8 c0155040 c0154ab8 c1bf7ee4 c1bf7ec8
[   77.713731] 7ec0: c019d6e4 c015503c c1bf6000 00000000 c1941360 c1945608 c1bf7ef4 c1bf7ee8
[   77.722108] 7ee0: c019cc50 c019d6b8 c1bf7f1c c1bf7ef8 c00ee5c4 c019cc38 00000003 00000003
[   77.730486] 7f00: 00000003 c1be2780 c1b31b00 c1bf7f78 c1bf7f44 c1bf7f20 c00ee970 c00ee580
[   77.738863] 7f20: c1b31b00 00013474 00000003 c1bf7f78 c0028128 00000000 c1bf7f74 c1bf7f48
[   77.747240] 7f40: c00a10b0 c00ee92c c1bf7f94 c1bf7f58 c009ef78 00000000 00000000 c1b31b00
[   77.755618] 7f60: 00000004 c0028128 c1bf7fa4 c1bf7f78 c00a16bc c00a1004 00000000 00000000
[   77.763994] 7f80: c0028128 00000000 c1bf7fa4 00000003 00013474 beb42150 00000000 c1bf7fa8
[   77.772366] 7fa0: c0027f80 c00a1680 00000003 00013474 00000003 00013474 00000003 00000000
[   77.780739] 7fc0: 00000003 00013474 beb42150 00000004 00009350 000099d1 0000000d 00000000
[   77.789113] 7fe0: 0001f180 beb42140 0000be2d 400bcfa4 00000010 00000003 11ffe831 11ffec31
[   77.797420] Backtrace: 
[   77.800118] [<c01586ac>] (strlen+0x0/0x2c) from [<c0154010>] (get_kobj_path_length+0x28/0x44)
[   77.808916] [<c0153fe8>] (get_kobj_path_length+0x0/0x44) from [<c01542f4>] (kobject_get_path+0x1c/0x58)
[   77.818489]  r5:00000003 r4:000000d0
[   77.822292] [<c01542d8>] (kobject_get_path+0x0/0x58) from [<c0154c70>] (kobject_uevent_env+0x1c8/0x584)
[   77.831857]  r6:c180f340 r5:00000003 r4:00000001
[   77.836747] [<c0154aa8>] (kobject_uevent_env+0x0/0x584) from [<c0155040>] (kobject_uevent+0x14/0x18)
[   77.846172] [<c015502c>] (kobject_uevent+0x0/0x18) from [<c019d6e4>] (store_uevent+0x3c/0x5c)
[   77.854970] [<c019d6a8>] (store_uevent+0x0/0x5c) from [<c019cc50>] (dev_attr_store+0x28/0x2c)
[   77.863659]  r5:c1945608 r4:c1941360
[   77.867533] [<c019cc28>] (dev_attr_store+0x0/0x2c) from [<c00ee5c4>] (flush_write_buffer+0x54/0x68)
[   77.876882] [<c00ee570>] (flush_write_buffer+0x0/0x68) from [<c00ee970>] (sysfs_write_file+0x54/0x7c)
[   77.886279]  r8:c1bf7f78 r7:c1b31b00 r6:c1be2780 r5:00000003 r4:00000003
[   77.893456] [<c00ee91c>] (sysfs_write_file+0x0/0x7c) from [<c00a10b0>] (vfs_write+0xbc/0x148)
[   77.902255] [<c00a0ff4>] (vfs_write+0x0/0x148) from [<c00a16bc>] (sys_write+0x4c/0x7c)
[   77.910335]  r8:c0028128 r7:00000004 r6:c1b31b00 r5:00000000 r4:00000000
[   77.917453] [<c00a1670>] (sys_write+0x0/0x7c) from [<c0027f80>] (ret_fast_syscall+0x0/0x2c)
[   77.925972]  r6:beb42150 r5:00013474 r4:00000003
[   77.930842] Code: e24cb004 e1a02000 ea000000 e2800001 (e5d03000) 
[   77.941934] ---[ end trace dd9983793dca7d8c ]---

Removing __initdata tags, introduced by commit 
bdc58fb950a3a1b0bc3cbd8e23d21ecdde2ac9a2, "arm: omap1: fix a bunch of 
section mismatches", from corresponding platform_device structures 
declared in arch/arm/mach-omap1/board-ams-delta.c, corrects the problem 
for me, which may indicate that their members (.name ?) are still 
referred to during runtime so they shouldn't be freed after boot.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 arch/arm/mach-omap1/board-ams-delta.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- git/arch/arm/mach-omap1/board-ams-delta.c.orig	2011-06-06 18:06:57.000000000 +0200
+++ git/arch/arm/mach-omap1/board-ams-delta.c	2011-06-07 02:51:36.000000000 +0200
@@ -215,7 +215,7 @@ static struct omap_kp_platform_data ams_
 	.delay		= 9,
 };
 
-static struct platform_device ams_delta_kp_device __initdata = {
+static struct platform_device ams_delta_kp_device = {
 	.name		= "omap-keypad",
 	.id		= -1,
 	.dev		= {
@@ -225,12 +225,12 @@ static struct platform_device ams_delta_
 	.resource	= ams_delta_kp_resources,
 };
 
-static struct platform_device ams_delta_lcd_device __initdata = {
+static struct platform_device ams_delta_lcd_device = {
 	.name	= "lcd_ams_delta",
 	.id	= -1,
 };
 
-static struct platform_device ams_delta_led_device __initdata = {
+static struct platform_device ams_delta_led_device = {
 	.name	= "ams-delta-led",
 	.id	= -1
 };
@@ -267,7 +267,7 @@ static struct soc_camera_link ams_delta_
 	.power		= ams_delta_camera_power,
 };
 
-static struct platform_device ams_delta_camera_device __initdata = {
+static struct platform_device ams_delta_camera_device = {
 	.name   = "soc-camera-pdrv",
 	.id     = 0,
 	.dev    = {
