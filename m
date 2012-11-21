Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2KUCie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:38:34 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab2KUC0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:52 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 02/42] sh-pfc: Move private definitions and declarations to private header
Date: Wed, 21 Nov 2012 03:27:03 +0100
Message-Id: <1353464863-10281-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all private structure definitions and function declarations from
include/linux/sh_pfc.h to drivers/sh/pfc/core.h.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/sh/pfc/core.c    |    2 ++
 drivers/sh/pfc/core.h    |   44 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/sh/pfc/gpio.c    |    2 ++
 drivers/sh/pfc/pinctrl.c |    2 ++
 include/linux/sh_pfc.h   |   29 -----------------------------
 5 files changed, 50 insertions(+), 29 deletions(-)
 create mode 100644 drivers/sh/pfc/core.h

diff --git a/drivers/sh/pfc/core.c b/drivers/sh/pfc/core.c
index ecbe51d..72421a4 100644
--- a/drivers/sh/pfc/core.c
+++ b/drivers/sh/pfc/core.c
@@ -21,6 +21,8 @@
 #include <linux/ioport.h>
 #include <linux/pinctrl/machine.h>
 
+#include "core.h"
+
 static struct sh_pfc sh_pfc __read_mostly;
 
 static void pfc_iounmap(struct sh_pfc *pfc)
diff --git a/drivers/sh/pfc/core.h b/drivers/sh/pfc/core.h
new file mode 100644
index 0000000..b07ae25
--- /dev/null
+++ b/drivers/sh/pfc/core.h
@@ -0,0 +1,44 @@
+/*
+ * SuperH Pin Function Controller support.
+ *
+ * Copyright (C) 2012  Renesas Solutions Corp.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#ifndef __SH_PFC_CORE_H__
+#define __SH_PFC_CORE_H__
+
+#include <linux/compiler.h>
+#include <linux/sh_pfc.h>
+#include <linux/types.h>
+
+struct pfc_window {
+	phys_addr_t phys;
+	void __iomem *virt;
+	unsigned long size;
+};
+
+struct sh_pfc {
+	struct sh_pfc_platform_data *pdata;
+	spinlock_t lock;
+
+	struct pfc_window *window;
+};
+
+int sh_pfc_register_gpiochip(struct sh_pfc *pfc);
+
+int sh_pfc_register_pinctrl(struct sh_pfc *pfc);
+
+int sh_pfc_read_bit(struct pinmux_data_reg *dr, unsigned long in_pos);
+void sh_pfc_write_bit(struct pinmux_data_reg *dr, unsigned long in_pos,
+		      unsigned long value);
+int sh_pfc_get_data_reg(struct sh_pfc *pfc, unsigned gpio,
+			struct pinmux_data_reg **drp, int *bitp);
+int sh_pfc_gpio_to_enum(struct sh_pfc *pfc, unsigned gpio, int pos,
+			pinmux_enum_t *enum_idp);
+int sh_pfc_config_gpio(struct sh_pfc *pfc, unsigned gpio, int pinmux_type,
+		       int cfg_mode);
+
+#endif /* __SH_PFC_CORE_H__ */
diff --git a/drivers/sh/pfc/gpio.c b/drivers/sh/pfc/gpio.c
index 9b7e45c..94c5489 100644
--- a/drivers/sh/pfc/gpio.c
+++ b/drivers/sh/pfc/gpio.c
@@ -19,6 +19,8 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/sh_pfc.h>
 
+#include "core.h"
+
 struct sh_pfc_chip {
 	struct sh_pfc		*pfc;
 	struct gpio_chip	gpio_chip;
diff --git a/drivers/sh/pfc/pinctrl.c b/drivers/sh/pfc/pinctrl.c
index 447fb60..5efa36a 100644
--- a/drivers/sh/pfc/pinctrl.c
+++ b/drivers/sh/pfc/pinctrl.c
@@ -24,6 +24,8 @@
 #include <linux/pinctrl/pinmux.h>
 #include <linux/pinctrl/pinconf-generic.h>
 
+#include "core.h"
+
 struct sh_pfc_pinctrl {
 	struct pinctrl_dev *pctl;
 	struct sh_pfc *pfc;
diff --git a/include/linux/sh_pfc.h b/include/linux/sh_pfc.h
index 58587f9..f7f01b2 100644
--- a/include/linux/sh_pfc.h
+++ b/include/linux/sh_pfc.h
@@ -88,12 +88,6 @@ struct pinmux_range {
 	pinmux_enum_t force;
 };
 
-struct pfc_window {
-	phys_addr_t phys;
-	void __iomem *virt;
-	unsigned long size;
-};
-
 struct sh_pfc_platform_data {
 	char *name;
 	pinmux_enum_t reserved_id;
@@ -123,35 +117,12 @@ struct sh_pfc_platform_data {
 	unsigned long unlock_reg;
 };
 
-struct sh_pfc {
-	struct sh_pfc_platform_data *pdata;
-	spinlock_t lock;
-
-	struct pfc_window *window;
-};
-
 /* XXX compat for now */
 #define pinmux_info sh_pfc_platform_data
 
-/* drivers/sh/pfc/gpio.c */
-int sh_pfc_register_gpiochip(struct sh_pfc *pfc);
-
-/* drivers/sh/pfc/pinctrl.c */
-int sh_pfc_register_pinctrl(struct sh_pfc *pfc);
-
 /* drivers/sh/pfc/core.c */
 int register_sh_pfc(struct sh_pfc_platform_data *pfc);
 
-int sh_pfc_read_bit(struct pinmux_data_reg *dr, unsigned long in_pos);
-void sh_pfc_write_bit(struct pinmux_data_reg *dr, unsigned long in_pos,
-		      unsigned long value);
-int sh_pfc_get_data_reg(struct sh_pfc *pfc, unsigned gpio,
-			struct pinmux_data_reg **drp, int *bitp);
-int sh_pfc_gpio_to_enum(struct sh_pfc *pfc, unsigned gpio, int pos,
-			pinmux_enum_t *enum_idp);
-int sh_pfc_config_gpio(struct sh_pfc *pfc, unsigned gpio, int pinmux_type,
-		       int cfg_mode);
-
 /* xxx */
 static inline int register_pinmux(struct pinmux_info *pip)
 {
-- 
1.7.8.6

