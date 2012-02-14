Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab2BNGOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 01:14:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:57655 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756189Ab2BNGO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 01:14:28 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+fbRMHCaCfLQPuKtN5BuOLzUaovZN+912Jm9kVGL
	pJgHfzA0HWKpXD
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/3] viafb: add auxiliary device management infrastructure
Date: Tue, 14 Feb 2012 06:35:01 +0000
Message-Id: <e75892715db800ee96fe4ac0407b73b57d866a68.1329200232.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329200232.git.FlorianSchandinat@gmx.de>
References: <cover.1329200232.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the basic infrastructure and a few stub drivers for
devices that are connected via I2C busses. The infrastructure will
be used to replace and extend the support that is scattered
throughout viafb. The stub drivers are not very useful yet but they
show how the infrastructure works, provide information about the
chips integrated into a system and maybe gather some testers as it
would be very difficult for a single person to get a sane test
environment.
The only thing this actually does is probing the I2C busses which
will hopefully not cause any regressions.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/Makefile         |    5 ++-
 drivers/video/via/via_aux.c        |   68 ++++++++++++++++++++++++++++
 drivers/video/via/via_aux.h        |   87 ++++++++++++++++++++++++++++++++++++
 drivers/video/via/via_aux_ch7301.c |   50 ++++++++++++++++++++
 drivers/video/via/via_aux_edid.c   |   40 ++++++++++++++++
 drivers/video/via/via_aux_sii164.c |   54 ++++++++++++++++++++++
 drivers/video/via/via_aux_vt1621.c |   44 ++++++++++++++++++
 drivers/video/via/via_aux_vt1622.c |   50 ++++++++++++++++++++
 drivers/video/via/via_aux_vt1625.c |   50 ++++++++++++++++++++
 drivers/video/via/via_aux_vt1631.c |   46 +++++++++++++++++++
 drivers/video/via/via_aux_vt1632.c |   54 ++++++++++++++++++++++
 drivers/video/via/via_aux_vt1636.c |   46 +++++++++++++++++++
 drivers/video/via/viafbdev.c       |   27 +++++++++++
 drivers/video/via/viafbdev.h       |    6 +++
 14 files changed, 626 insertions(+), 1 deletions(-)
 create mode 100644 drivers/video/via/via_aux.c
 create mode 100644 drivers/video/via/via_aux.h
 create mode 100644 drivers/video/via/via_aux_ch7301.c
 create mode 100644 drivers/video/via/via_aux_edid.c
 create mode 100644 drivers/video/via/via_aux_sii164.c
 create mode 100644 drivers/video/via/via_aux_vt1621.c
 create mode 100644 drivers/video/via/via_aux_vt1622.c
 create mode 100644 drivers/video/via/via_aux_vt1625.c
 create mode 100644 drivers/video/via/via_aux_vt1631.c
 create mode 100644 drivers/video/via/via_aux_vt1632.c
 create mode 100644 drivers/video/via/via_aux_vt1636.c

diff --git a/drivers/video/via/Makefile b/drivers/video/via/Makefile
index 5108136..159f26e 100644
--- a/drivers/video/via/Makefile
+++ b/drivers/video/via/Makefile
@@ -6,4 +6,7 @@ obj-$(CONFIG_FB_VIA) += viafb.o
 
 viafb-y	:=viafbdev.o hw.o via_i2c.o dvi.o lcd.o ioctl.o accel.o \
 	via_utility.o vt1636.o global.o tblDPASetting.o viamode.o \
-	via-core.o via-gpio.o via_modesetting.o via_clock.o
+	via-core.o via-gpio.o via_modesetting.o via_clock.o \
+	via_aux.o via_aux_edid.o via_aux_vt1636.o via_aux_vt1632.o \
+	via_aux_vt1631.o via_aux_vt1625.o via_aux_vt1622.o via_aux_vt1621.o \
+	via_aux_sii164.o via_aux_ch7301.o
diff --git a/drivers/video/via/via_aux.c b/drivers/video/via/via_aux.c
new file mode 100644
index 0000000..e728b9b
--- /dev/null
+++ b/drivers/video/via/via_aux.c
@@ -0,0 +1,68 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * infrastructure for devices connected via I2C
+ */
+
+#include <linux/slab.h>
+#include "via_aux.h"
+
+
+struct via_aux_bus *via_aux_probe(struct i2c_adapter *adap)
+{
+	struct via_aux_bus *bus;
+
+	if (!adap)
+		return NULL;
+
+	bus = kmalloc(sizeof(*bus), GFP_KERNEL);
+	if (!bus)
+		return NULL;
+
+	bus->adap = adap;
+	INIT_LIST_HEAD(&bus->drivers);
+
+	via_aux_edid_probe(bus);
+	via_aux_vt1636_probe(bus);
+	via_aux_vt1632_probe(bus);
+	via_aux_vt1631_probe(bus);
+	via_aux_vt1625_probe(bus);
+	via_aux_vt1622_probe(bus);
+	via_aux_vt1621_probe(bus);
+	via_aux_sii164_probe(bus);
+	via_aux_ch7301_probe(bus);
+
+	return bus;
+}
+
+void via_aux_free(struct via_aux_bus *bus)
+{
+	struct via_aux_drv *pos, *n;
+
+	if (!bus)
+		return;
+
+	list_for_each_entry_safe(pos, n, &bus->drivers, chain) {
+		list_del(&pos->chain);
+		kfree(pos);
+	}
+
+	kfree(bus);
+}
diff --git a/drivers/video/via/via_aux.h b/drivers/video/via/via_aux.h
new file mode 100644
index 0000000..5a4867a
--- /dev/null
+++ b/drivers/video/via/via_aux.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * infrastructure for devices connected via I2C
+ */
+
+#ifndef __VIA_AUX_H__
+#define __VIA_AUX_H__
+
+
+#include <linux/list.h>
+#include <linux/i2c.h>
+
+
+struct via_aux_bus {
+	struct i2c_adapter *adap;	/* the I2C device to access the bus */
+	struct list_head drivers;	/* drivers for devices on this bus */
+};
+
+struct via_aux_drv {
+	struct list_head chain;		/* chain to support multiple drivers */
+
+	struct via_aux_bus *bus;	/* the I2C bus used */
+	u8 addr;			/* the I2C slave address */
+
+	const char *name;	/* human readable name of the driver */
+	void *data;		/* private data of this driver */
+};
+
+
+struct via_aux_bus *via_aux_probe(struct i2c_adapter *adap);
+void via_aux_free(struct via_aux_bus *bus);
+
+
+static inline bool via_aux_add(struct via_aux_drv *drv)
+{
+	struct via_aux_drv *data = kmalloc(sizeof(*data), GFP_KERNEL);
+
+	if (!data)
+		return false;
+
+	*data = *drv;
+	list_add_tail(&data->chain, &data->bus->drivers);
+	return true;
+}
+
+static inline bool via_aux_read(struct via_aux_drv *drv, u8 start, u8 *buf,
+	u8 len)
+{
+	struct i2c_msg msg[2] = {
+		{.addr = drv->addr, .flags = 0, .len = 1, .buf = &start},
+		{.addr = drv->addr, .flags = I2C_M_RD, .len = len, .buf = buf} };
+
+	return i2c_transfer(drv->bus->adap, msg, 2) == 2;
+}
+
+
+/* probe functions of existing drivers - should only be called in via_aux.c */
+void via_aux_ch7301_probe(struct via_aux_bus *bus);
+void via_aux_edid_probe(struct via_aux_bus *bus);
+void via_aux_sii164_probe(struct via_aux_bus *bus);
+void via_aux_vt1636_probe(struct via_aux_bus *bus);
+void via_aux_vt1632_probe(struct via_aux_bus *bus);
+void via_aux_vt1631_probe(struct via_aux_bus *bus);
+void via_aux_vt1625_probe(struct via_aux_bus *bus);
+void via_aux_vt1622_probe(struct via_aux_bus *bus);
+void via_aux_vt1621_probe(struct via_aux_bus *bus);
+
+
+#endif /* __VIA_AUX_H__ */
diff --git a/drivers/video/via/via_aux_ch7301.c b/drivers/video/via/via_aux_ch7301.c
new file mode 100644
index 0000000..1cbe503
--- /dev/null
+++ b/drivers/video/via/via_aux_ch7301.c
@@ -0,0 +1,50 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * driver for Chrontel CH7301 DVI Transmitter
+ */
+
+#include <linux/slab.h>
+#include "via_aux.h"
+
+
+static const char *name = "CH7301 DVI Transmitter";
+
+
+static void probe(struct via_aux_bus *bus, u8 addr)
+{
+	struct via_aux_drv drv = {
+		.bus	=	bus,
+		.addr	=	addr,
+		.name	=	name};
+	u8 tmp;
+
+	if (!via_aux_read(&drv, 0x4B, &tmp, 1) || tmp != 0x17)
+		return;
+
+	printk(KERN_INFO "viafb: Found %s at address 0x%x\n", name, addr);
+	via_aux_add(&drv);
+}
+
+void via_aux_ch7301_probe(struct via_aux_bus *bus)
+{
+	probe(bus, 0x75);
+	probe(bus, 0x76);
+}
diff --git a/drivers/video/via/via_aux_edid.c b/drivers/video/via/via_aux_edid.c
new file mode 100644
index 0000000..547bff5
--- /dev/null
+++ b/drivers/video/via/via_aux_edid.c
@@ -0,0 +1,40 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * generic EDID driver
+ */
+
+#include <linux/slab.h>
+#include "via_aux.h"
+
+
+static const char *name = "EDID";
+
+
+void via_aux_edid_probe(struct via_aux_bus *bus)
+{
+	struct via_aux_drv drv = {
+		.bus	=	bus,
+		.addr	=	0x50,
+		.name	=	name};
+
+	/* as EDID devices can be connected/disconnected just add the driver */
+	via_aux_add(&drv);
+}
diff --git a/drivers/video/via/via_aux_sii164.c b/drivers/video/via/via_aux_sii164.c
new file mode 100644
index 0000000..ca1b35f
--- /dev/null
+++ b/drivers/video/via/via_aux_sii164.c
@@ -0,0 +1,54 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * driver for Silicon Image SiI 164 PanelLink Transmitter
+ */
+
+#include <linux/slab.h>
+#include "via_aux.h"
+
+
+static const char *name = "SiI 164 PanelLink Transmitter";
+
+
+static void probe(struct via_aux_bus *bus, u8 addr)
+{
+	struct via_aux_drv drv = {
+		.bus	=	bus,
+		.addr	=	addr,
+		.name	=	name};
+	/* check vendor id and device id */
+	const u8 id[] = {0x01, 0x00, 0x06, 0x00}, len = ARRAY_SIZE(id);
+	u8 tmp[len];
+
+	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
+		return;
+
+	printk(KERN_INFO "viafb: Found %s at address 0x%x\n", name, addr);
+	via_aux_add(&drv);
+}
+
+void via_aux_sii164_probe(struct via_aux_bus *bus)
+{
+	u8 i;
+
+	for (i = 0x38; i <= 0x3F; i++)
+		probe(bus, i);
+}
diff --git a/drivers/video/via/via_aux_vt1621.c b/drivers/video/via/via_aux_vt1621.c
new file mode 100644
index 0000000..38eca84
--- /dev/null
+++ b/drivers/video/via/via_aux_vt1621.c
@@ -0,0 +1,44 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * driver for VIA VT1621(M) TV Encoder
+ */
+
+#include <linux/slab.h>
+#include "via_aux.h"
+
+
+static const char *name = "VT1621(M) TV Encoder";
+
+
+void via_aux_vt1621_probe(struct via_aux_bus *bus)
+{
+	struct via_aux_drv drv = {
+		.bus	=	bus,
+		.addr	=	0x20,
+		.name	=	name};
+	u8 tmp;
+
+	if (!via_aux_read(&drv, 0x1B, &tmp, 1) || tmp != 0x02)
+		return;
+
+	printk(KERN_INFO "viafb: Found %s\n", name);
+	via_aux_add(&drv);
+}
diff --git a/drivers/video/via/via_aux_vt1622.c b/drivers/video/via/via_aux_vt1622.c
new file mode 100644
index 0000000..8c79c68
--- /dev/null
+++ b/drivers/video/via/via_aux_vt1622.c
@@ -0,0 +1,50 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * driver for VIA VT1622(M) Digital TV Encoder
+ */
+
+#include <linux/slab.h>
+#include "via_aux.h"
+
+
+static const char *name = "VT1622(M) Digital TV Encoder";
+
+
+static void probe(struct via_aux_bus *bus, u8 addr)
+{
+	struct via_aux_drv drv = {
+		.bus	=	bus,
+		.addr	=	addr,
+		.name	=	name};
+	u8 tmp;
+
+	if (!via_aux_read(&drv, 0x1B, &tmp, 1) ||  tmp != 0x03)
+		return;
+
+	printk(KERN_INFO "viafb: Found %s at address 0x%x\n", name, addr);
+	via_aux_add(&drv);
+}
+
+void via_aux_vt1622_probe(struct via_aux_bus *bus)
+{
+	probe(bus, 0x20);
+	probe(bus, 0x21);
+}
diff --git a/drivers/video/via/via_aux_vt1625.c b/drivers/video/via/via_aux_vt1625.c
new file mode 100644
index 0000000..03eb301
--- /dev/null
+++ b/drivers/video/via/via_aux_vt1625.c
@@ -0,0 +1,50 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * driver for VIA VT1625(M) HDTV Encoder
+ */
+
+#include <linux/slab.h>
+#include "via_aux.h"
+
+
+static const char *name = "VT1625(M) HDTV Encoder";
+
+
+static void probe(struct via_aux_bus *bus, u8 addr)
+{
+	struct via_aux_drv drv = {
+		.bus	=	bus,
+		.addr	=	addr,
+		.name	=	name};
+	u8 tmp;
+
+	if (!via_aux_read(&drv, 0x1B, &tmp, 1) || tmp != 0x50)
+		return;
+
+	printk(KERN_INFO "viafb: Found %s at address 0x%x\n", name, addr);
+	via_aux_add(&drv);
+}
+
+void via_aux_vt1625_probe(struct via_aux_bus *bus)
+{
+	probe(bus, 0x20);
+	probe(bus, 0x21);
+}
diff --git a/drivers/video/via/via_aux_vt1631.c b/drivers/video/via/via_aux_vt1631.c
new file mode 100644
index 0000000..06e742f
--- /dev/null
+++ b/drivers/video/via/via_aux_vt1631.c
@@ -0,0 +1,46 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * driver for VIA VT1631 LVDS Transmitter
+ */
+
+#include <linux/slab.h>
+#include "via_aux.h"
+
+
+static const char *name = "VT1631 LVDS Transmitter";
+
+
+void via_aux_vt1631_probe(struct via_aux_bus *bus)
+{
+	struct via_aux_drv drv = {
+		.bus	=	bus,
+		.addr	=	0x38,
+		.name	=	name};
+	/* check vendor id and device id */
+	const u8 id[] = {0x06, 0x11, 0x91, 0x31}, len = ARRAY_SIZE(id);
+	u8 tmp[len];
+
+	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
+		return;
+
+	printk(KERN_INFO "viafb: Found %s\n", name);
+	via_aux_add(&drv);
+}
diff --git a/drivers/video/via/via_aux_vt1632.c b/drivers/video/via/via_aux_vt1632.c
new file mode 100644
index 0000000..d24f4cd
--- /dev/null
+++ b/drivers/video/via/via_aux_vt1632.c
@@ -0,0 +1,54 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * driver for VIA VT1632 DVI Transmitter
+ */
+
+#include <linux/slab.h>
+#include "via_aux.h"
+
+
+static const char *name = "VT1632 DVI Transmitter";
+
+
+static void probe(struct via_aux_bus *bus, u8 addr)
+{
+	struct via_aux_drv drv = {
+		.bus	=	bus,
+		.addr	=	addr,
+		.name	=	name};
+	/* check vendor id and device id */
+	const u8 id[] = {0x06, 0x11, 0x92, 0x31}, len = ARRAY_SIZE(id);
+	u8 tmp[len];
+
+	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
+		return;
+
+	printk(KERN_INFO "viafb: Found %s at address 0x%x\n", name, addr);
+	via_aux_add(&drv);
+}
+
+void via_aux_vt1632_probe(struct via_aux_bus *bus)
+{
+	u8 i;
+
+	for (i = 0x08; i <= 0x0F; i++)
+		probe(bus, i);
+}
diff --git a/drivers/video/via/via_aux_vt1636.c b/drivers/video/via/via_aux_vt1636.c
new file mode 100644
index 0000000..9e015c1
--- /dev/null
+++ b/drivers/video/via/via_aux_vt1636.c
@@ -0,0 +1,46 @@
+/*
+ * Copyright 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
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
+ * driver for VIA VT1636 LVDS Transmitter
+ */
+
+#include <linux/slab.h>
+#include "via_aux.h"
+
+
+static const char *name = "VT1636 LVDS Transmitter";
+
+
+void via_aux_vt1636_probe(struct via_aux_bus *bus)
+{
+	struct via_aux_drv drv = {
+		.bus	=	bus,
+		.addr	=	0x40,
+		.name	=	name};
+	/* check vendor id and device id */
+	const u8 id[] = {0x06, 0x11, 0x45, 0x33}, len = ARRAY_SIZE(id);
+	u8 tmp[len];
+
+	if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
+		return;
+
+	printk(KERN_INFO "viafb: Found %s\n", name);
+	via_aux_add(&drv);
+}
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index a13c258..6d5b649 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/via-core.h>
+#include <linux/via_i2c.h>
 #include <asm/olpc.h>
 
 #define _MASTER_FILE
@@ -1729,6 +1730,29 @@ static struct viafb_pm_hooks viafb_fb_pm_hooks = {
 
 #endif
 
+static void __devinit i2c_bus_probe(struct viafb_shared *shared)
+{
+	/* should be always CRT */
+	printk(KERN_INFO "viafb: Probing I2C bus 0x26\n");
+	shared->i2c_26 = via_aux_probe(viafb_find_i2c_adapter(VIA_PORT_26));
+
+	/* seems to be usually DVP1 */
+	printk(KERN_INFO "viafb: Probing I2C bus 0x31\n");
+	shared->i2c_31 = via_aux_probe(viafb_find_i2c_adapter(VIA_PORT_31));
+
+	/* FIXME: what is this? */
+	printk(KERN_INFO "viafb: Probing I2C bus 0x2C\n");
+	shared->i2c_2C = via_aux_probe(viafb_find_i2c_adapter(VIA_PORT_2C));
+
+	printk(KERN_INFO "viafb: Finished I2C bus probing");
+}
+
+static void i2c_bus_free(struct viafb_shared *shared)
+{
+	via_aux_free(shared->i2c_26);
+	via_aux_free(shared->i2c_31);
+	via_aux_free(shared->i2c_2C);
+}
 
 int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 {
@@ -1762,6 +1786,7 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 		&viaparinfo->shared->lvds_setting_info2;
 	viaparinfo->chip_info = &viaparinfo->shared->chip_info;
 
+	i2c_bus_probe(viaparinfo->shared);
 	if (viafb_dual_fb)
 		viafb_SAMM_ON = 1;
 	parse_lcd_port();
@@ -1915,6 +1940,7 @@ out_fb1_release:
 	if (viafbinfo1)
 		framebuffer_release(viafbinfo1);
 out_fb_release:
+	i2c_bus_free(viaparinfo->shared);
 	framebuffer_release(viafbinfo);
 	return rc;
 }
@@ -1927,6 +1953,7 @@ void __devexit via_fb_pci_remove(struct pci_dev *pdev)
 	if (viafb_dual_fb)
 		unregister_framebuffer(viafbinfo1);
 	viafb_remove_proc(viaparinfo->shared);
+	i2c_bus_free(viaparinfo->shared);
 	framebuffer_release(viafbinfo);
 	if (viafb_dual_fb)
 		framebuffer_release(viafbinfo1);
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index d944063..f6b2ddf 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -26,6 +26,7 @@
 #include <linux/fb.h>
 #include <linux/spinlock.h>
 
+#include "via_aux.h"
 #include "ioctl.h"
 #include "share.h"
 #include "chip.h"
@@ -48,6 +49,11 @@ struct viafb_shared {
 	struct proc_dir_entry *iga2_proc_entry;
 	struct viafb_dev *vdev;			/* Global dev info */
 
+	/* I2C busses that may have auxiliary devices */
+	struct via_aux_bus *i2c_26;
+	struct via_aux_bus *i2c_31;
+	struct via_aux_bus *i2c_2C;
+
 	/* All the information will be needed to set engine */
 	struct tmds_setting_information tmds_setting_info;
 	struct lvds_setting_information lvds_setting_info;
-- 
1.7.9

