Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0JDHko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 03:40:44 -0400
Received: from mail.southpole.se ([193.12.106.18]:41064 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab0JDHkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 03:40:43 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [RFC] Add IO primitives for Wishbone bus
Date: Mon,  4 Oct 2010 09:40:37 +0200
Message-Id: <1286178037-17337-1-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Wishbone bus is an open source hardware bus intended to let the parts of an
integrated circuit communicate with each other.  This bus is primarily used by
the cores hosted by the OpenCores project.

The Linux device I/O model assumes that devices have fixed endianess; however,
as the endianess of the OpenCores cores is determined at synthesis time, these
devices may exist in both little and big endian versions.  Effectively, the
endianess selected at synthesis time sets an implicit bus endianess to which
drivers for these devices must comply.

This patch adds I/O primitives of the form wb_io[read|write][8|16|32] which map
to the underlying io[read|write] functions of the correct endianess.  It is
intended that devices connecting to a Wishbone bus use these primitives for
device I/O in order that the correct endianess be automatically applied.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---

Is this an acceptable solution or is there another way that would be
better?  The problem at hand is how best to write a driver for a device
when the device has the same endianess as the CPU and that endianess is
arbitrary... for soft cores (OpenRISC in my case), this is a relevant problem,
as the device endianess is determined along with the CPU core endianess
at synthesis time...

/Jonas

 include/linux/wishbone.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/wishbone.h

diff --git a/include/linux/wishbone.h b/include/linux/wishbone.h
new file mode 100644
index 0000000..05c5f57
--- /dev/null
+++ b/include/linux/wishbone.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright 2010 South Pole AB.  All Rights Reserved.
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
+ */
+
+#include <asm/io.h>
+
+#ifndef _LINUX_WISHBONE_H
+#define _LINUX_WISHBONE_H
+
+#ifdef CONFIG_WISHBONE_BIG_ENDIAN
+#define wb_ioread8(p)  ioread8(p)
+#define wb_ioread16(p) ioread16be(p)
+#define wb_ioread32(p) ioread32be(p)
+
+#define wb_iowrite8(p)  iowrite8(p)
+#define wb_iowrite16(p) iowrite16be(p)
+#define wb_iowrite32(p) iowrite32be(p)
+
+#else
+
+#define wb_ioread8(p)  ioread8(p)
+#define wb_ioread16(p) ioread16(p)
+#define wb_ioread32(p) ioread32(p)
+
+#define wb_iowrite8(p)  iowrite8(p)
+#define wb_iowrite16(p) iowrite16(p)
+#define wb_iowrite32(p) iowrite32(p)
+
+#endif /* CONFIG_WISHBONE_BIG_ENDIAN */
+
+#endif /* _LINUX_WISHBONE_H */
-- 
1.7.1

