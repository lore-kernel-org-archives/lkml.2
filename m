Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576Ab0EEWfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:35:15 -0400
Received: from tex.lwn.net ([70.33.254.29]:50622 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab0EEWfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:35:06 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-media@vger.kernel.org
Subject: [PATCH 1/5] viafb: fold via_io.h into via-core.h
Date: Wed,  5 May 2010 16:34:40 -0600
Message-Id: <1273098884-21848-2-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273098884-21848-1-git-send-email-corbet@lwn.net>
References: <1273098884-21848-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory move toward the ultimate goal of moving pan-subdevice stuff
into include/linux.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/hw.h              |    1 -
 drivers/video/via/share.h           |   11 ++----
 drivers/video/via/via-core.h        |   48 ++++++++++++++++++++++++-
 drivers/video/via/via_io.h          |   67 -----------------------------------
 drivers/video/via/via_modesetting.c |    2 +-
 drivers/video/via/via_utility.c     |    1 +
 drivers/video/via/viamode.c         |    1 +
 7 files changed, 53 insertions(+), 78 deletions(-)
 delete mode 100644 drivers/video/via/via_io.h

diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index a58701f..a109de3 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -24,7 +24,6 @@
 
 #include "viamode.h"
 #include "global.h"
-#include "via_io.h"
 #include "via_modesetting.h"
 
 #define viafb_read_reg(p, i)			via_read_reg(p, i)
diff --git a/drivers/video/via/share.h b/drivers/video/via/share.h
index 861b414..7f0de7f 100644
--- a/drivers/video/via/share.h
+++ b/drivers/video/via/share.h
@@ -43,14 +43,9 @@
 /* Video Memory Size */
 #define VIDEO_MEMORY_SIZE_16M    0x1000000
 
-/* standard VGA IO port
-*/
-#define VIAStatus   0x3DA
-#define VIACR       0x3D4
-#define VIASR       0x3C4
-#define VIAGR       0x3CE
-#define VIAAR       0x3C0
-
+/*
+ * Lengths of the VPIT structure arrays.
+ */
 #define StdCR       0x19
 #define StdSR       0x04
 #define StdGR       0x09
diff --git a/drivers/video/via/via-core.h b/drivers/video/via/via-core.h
index 087c562..7ffb521 100644
--- a/drivers/video/via/via-core.h
+++ b/drivers/video/via/via-core.h
@@ -1,7 +1,8 @@
 /*
  * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
  * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
- * Copyright 2009 Jonathan Corbet <corbet@lwn.net>
+ * Copyright 2009-2010 Jonathan Corbet <corbet@lwn.net>
+ * Copyright 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public
@@ -22,6 +23,8 @@
 
 #ifndef __VIA_CORE_H__
 #define __VIA_CORE_H__
+#include <linux/types.h>
+#include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 
@@ -170,4 +173,47 @@ int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg);
 #define VGA_WIDTH	640
 #define VGA_HEIGHT	480
 
+/*
+ * Indexed port operations.  Note that these are all multi-op
+ * functions; every invocation will be racy if you're not holding
+ * reg_lock.
+ */
+
+#define VIAStatus   0x3DA  /* Non-indexed port */
+#define VIACR       0x3D4
+#define VIASR       0x3C4
+#define VIAGR       0x3CE
+#define VIAAR       0x3C0
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
+#define VIA_MISC_REG_READ	0x03CC
+#define VIA_MISC_REG_WRITE	0x03C2
+
+static inline void via_write_misc_reg_mask(u8 data, u8 mask)
+{
+	u8 old = inb(VIA_MISC_REG_READ);
+	outb((data & mask) | (old & ~mask), VIA_MISC_REG_WRITE);
+}
+
+
 #endif /* __VIA_CORE_H__ */
diff --git a/drivers/video/via/via_io.h b/drivers/video/via/via_io.h
deleted file mode 100644
index a3d2aca..0000000
--- a/drivers/video/via/via_io.h
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
- * Copyright 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-/*
- * basic io functions
- */
-
-#ifndef __VIA_IO_H__
-#define __VIA_IO_H__
-
-#include <linux/types.h>
-#include <linux/io.h>
-
-#define VIA_MISC_REG_READ	0x03CC
-#define VIA_MISC_REG_WRITE	0x03C2
-
-/*
- * Indexed port operations.  Note that these are all multi-op
- * functions; every invocation will be racy if you're not holding
- * reg_lock.
- */
-static inline u8 via_read_reg(u16 port, u8 index)
-{
-	outb(index, port);
-	return inb(port + 1);
-}
-
-static inline void via_write_reg(u16 port, u8 index, u8 data)
-{
-	outb(index, port);
-	outb(data, port + 1);
-}
-
-static inline void via_write_reg_mask(u16 port, u8 index, u8 data, u8 mask)
-{
-	u8 old;
-
-	outb(index, port);
-	old = inb(port + 1);
-	outb((data & mask) | (old & ~mask), port + 1);
-}
-
-static inline void via_write_misc_reg_mask(u8 data, u8 mask)
-{
-	u8 old = inb(VIA_MISC_REG_READ);
-	outb((data & mask) | (old & ~mask), VIA_MISC_REG_WRITE);
-}
-
-#endif /* __VIA_IO_H__ */
diff --git a/drivers/video/via/via_modesetting.c b/drivers/video/via/via_modesetting.c
index 69ff285..b4e735c 100644
--- a/drivers/video/via/via_modesetting.c
+++ b/drivers/video/via/via_modesetting.c
@@ -25,7 +25,7 @@
 
 #include <linux/kernel.h>
 #include "via_modesetting.h"
-#include "via_io.h"
+#include "via-core.h"
 #include "share.h"
 #include "debug.h"
 
diff --git a/drivers/video/via/via_utility.c b/drivers/video/via/via_utility.c
index aefdeee..5757031 100644
--- a/drivers/video/via/via_utility.c
+++ b/drivers/video/via/via_utility.c
@@ -19,6 +19,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include "via-core.h"
 #include "global.h"
 
 void viafb_get_device_support_state(u32 *support_state)
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 6f3bcda..2fdb9e6 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -19,6 +19,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include "via-core.h"
 #include "global.h"
 struct res_map_refresh res_map_refresh_tbl[] = {
 /*hres, vres, vclock, vmode_refresh*/
-- 
1.7.0.1

