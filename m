Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0DQThG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:37:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:46233 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752766Ab0DQThD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:37:03 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX195K50Wa4R5Y9+5yNq+4w1CvoDh7WBLaTitp607n6
	RJ1PiaTd2NATrJ
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/7] viafb: package often used basic io functions
Date: Sat, 17 Apr 2010 19:44:51 +0000
Message-Id: <1271533498-3376-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: package often used basic io functions

This patch puts redesigned versions of the basic io functions that
are used overall the driver in an extra header. It is prefixed with
via_ as no framebuffer dependend stuff is in there. They were inlined
as they are really simple which reduced the module size about 2.5%.
The parameter order of read and write was fixed as it really doesn't
make sense to change the order as they are parts of the same address
and not source and destination.
Wrapper which use the new functions were added to hw.h to replicate
the old interface and avoid changing all old code.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/hw.c     |   22 ------------------
 drivers/video/via/hw.h     |    8 ++++--
 drivers/video/via/via_io.h |   53 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 25 deletions(-)
 create mode 100644 drivers/video/via/via_io.h

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index f2583b1..32742dd 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -537,18 +537,6 @@ static void device_on(void);
 static void enable_second_display_channel(void);
 static void disable_second_display_channel(void);
 
-void viafb_write_reg(u8 index, u16 io_port, u8 data)
-{
-	outb(index, io_port);
-	outb(data, io_port + 1);
-	/*DEBUG_MSG(KERN_INFO "\nIndex=%2d Value=%2d", index, data); */
-}
-u8 viafb_read_reg(int io_port, u8 index)
-{
-	outb(index, io_port);
-	return inb(io_port + 1);
-}
-
 void viafb_lock_crt(void)
 {
 	viafb_write_reg_mask(CR11, VIACR, BIT7, BIT7);
@@ -560,16 +548,6 @@ void viafb_unlock_crt(void)
 	viafb_write_reg_mask(CR47, VIACR, 0, BIT0);
 }
 
-void viafb_write_reg_mask(u8 index, int io_port, u8 data, u8 mask)
-{
-	u8 tmp;
-
-	outb(index, io_port);
-	tmp = inb(io_port + 1);
-	outb((data & mask) | (tmp & (~mask)), io_port + 1);
-	/*DEBUG_MSG(KERN_INFO "\nIndex=%2d Value=%2d", index, tmp); */
-}
-
 void write_dac_reg(u8 index, u8 r, u8 g, u8 b)
 {
 	outb(index, LUT_INDEX_WRITE);
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index 12ef32d..f0c202d 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -24,6 +24,11 @@
 
 #include "viamode.h"
 #include "global.h"
+#include "via_io.h"
+
+#define viafb_read_reg(p, i)			via_read_reg(p, i)
+#define viafb_write_reg(i, p, d)		via_write_reg(p, i, d)
+#define viafb_write_reg_mask(i, p, d, m)	via_write_reg_mask(p, i, d, m)
 
 /***************************************************
 * Definition IGA1 Design Method of CRTC Registers *
@@ -870,7 +875,6 @@ extern int viafb_LCD_ON;
 extern int viafb_DVI_ON;
 extern int viafb_hotplug;
 
-void viafb_write_reg_mask(u8 index, int io_port, u8 data, u8 mask);
 void viafb_set_output_path(int device, int set_iga,
 	int output_interface);
 
@@ -885,8 +889,6 @@ void viafb_crt_disable(void);
 void viafb_crt_enable(void);
 void init_ad9389(void);
 /* Access I/O Function */
-void viafb_write_reg(u8 index, u16 io_port, u8 data);
-u8 viafb_read_reg(int io_port, u8 index);
 void viafb_lock_crt(void);
 void viafb_unlock_crt(void);
 void viafb_load_fetch_count_reg(int h_addr, int bpp_byte, int set_iga);
diff --git a/drivers/video/via/via_io.h b/drivers/video/via/via_io.h
new file mode 100644
index 0000000..9dc112b
--- /dev/null
+++ b/drivers/video/via/via_io.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+ * Copyright 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+/*
+ * basic io functions
+ */
+
+#ifndef __VIA_IO_H__
+#define __VIA_IO_H__
+
+#include <linux/types.h>
+#include <linux/io.h>
+
+static inline u8 via_read_reg(u16 port, u8 index)
+{
+	outb(index, port);
+	return inb(port + 1);
+}
+
+static inline void via_write_reg(u16 port, u8 index, u8 data)
+{
+	outb(index, port);
+	outb(data, port + 1);
+}
+
+static inline void via_write_reg_mask(u16 port, u8 index, u8 data, u8 mask)
+{
+	u8 old;
+
+	outb(index, port);
+	old = inb(port + 1);
+	outb((data & mask) | (old & ~mask), port + 1);
+}
+
+#endif /* __VIA_IO_H__ */
-- 
1.6.3.2

