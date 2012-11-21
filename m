Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2KUCiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:38:18 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2KUC0w (ORCPT
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
Subject: [PATCH 03/42] sh-pfc: Merge PFC core and pinctrl
Date: Wed, 21 Nov 2012 03:27:04 +0100
Message-Id: <1353464863-10281-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PFC core is only used by the pinctrl and gpio modules. As the gpio
module depends on the pinctrl module, the pinctrl module will always be
present if the core gets used. There is thus no point in keeping core
and pinctrl in two seperate modules. Merge them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/sh/pfc/Kconfig   |   10 +---------
 drivers/sh/pfc/Makefile  |    4 ++--
 drivers/sh/pfc/core.c    |   15 +++------------
 drivers/sh/pfc/pinctrl.c |    3 +--
 4 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/sh/pfc/Kconfig b/drivers/sh/pfc/Kconfig
index 804f9ad..f33d82a 100644
--- a/drivers/sh/pfc/Kconfig
+++ b/drivers/sh/pfc/Kconfig
@@ -5,18 +5,10 @@ config SH_PFC
 	depends on GENERIC_GPIO
 	select GPIO_SH_PFC if ARCH_REQUIRE_GPIOLIB
 	select PINCTRL_SH_PFC
-	def_bool y
-
-#
-# Placeholder for now, rehome to drivers/pinctrl once the PFC APIs
-# have settled.
-#
-config PINCTRL_SH_PFC
-	tristate "SuperH PFC pin controller driver"
-	depends on SH_PFC
 	select PINCTRL
 	select PINMUX
 	select PINCONF
+	def_bool y
 
 config GPIO_SH_PFC
 	tristate "SuperH PFC GPIO support"
diff --git a/drivers/sh/pfc/Makefile b/drivers/sh/pfc/Makefile
index 7916027..ce6fae3 100644
--- a/drivers/sh/pfc/Makefile
+++ b/drivers/sh/pfc/Makefile
@@ -1,3 +1,3 @@
-obj-y				+= core.o
-obj-$(CONFIG_PINCTRL_SH_PFC)	+= pinctrl.o
+sh-pfc-objs			= core.o pinctrl.o
+obj-y				+= sh-pfc.o
 obj-$(CONFIG_GPIO_SH_PFC)	+= gpio.o
diff --git a/drivers/sh/pfc/core.c b/drivers/sh/pfc/core.c
index 72421a4..30e33db 100644
--- a/drivers/sh/pfc/core.c
+++ b/drivers/sh/pfc/core.c
@@ -8,7 +8,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  */
-#define pr_fmt(fmt) "sh_pfc " KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -497,7 +497,6 @@ int sh_pfc_config_gpio(struct sh_pfc *pfc, unsigned gpio, int pinmux_type,
  out_err:
 	return -1;
 }
-EXPORT_SYMBOL_GPL(sh_pfc_config_gpio);
 
 int register_sh_pfc(struct sh_pfc_platform_data *pdata)
 {
@@ -528,17 +527,9 @@ int register_sh_pfc(struct sh_pfc_platform_data *pdata)
 	/*
 	 * Initialize pinctrl bindings first
 	 */
-	initroutine = symbol_request(sh_pfc_register_pinctrl);
-	if (initroutine) {
-		ret = (*initroutine)(&sh_pfc);
-		symbol_put_addr(initroutine);
-
-		if (unlikely(ret != 0))
-			goto err;
-	} else {
-		pr_err("failed to initialize pinctrl bindings\n");
+	ret = sh_pfc_register_pinctrl(&sh_pfc);
+	if (unlikely(ret != 0))
 		goto err;
-	}
 
 	/*
 	 * Then the GPIO chip
diff --git a/drivers/sh/pfc/pinctrl.c b/drivers/sh/pfc/pinctrl.c
index 5efa36a..0bde9fa 100644
--- a/drivers/sh/pfc/pinctrl.c
+++ b/drivers/sh/pfc/pinctrl.c
@@ -9,7 +9,7 @@
  */
 #define DRV_NAME "pinctrl-sh_pfc"
 
-#define pr_fmt(fmt) DRV_NAME " " KBUILD_MODNAME ": " fmt
+#define pr_fmt(fmt) KBUILD_MODNAME " pinctrl: " fmt
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -523,7 +523,6 @@ int sh_pfc_register_pinctrl(struct sh_pfc *pfc)
 
 	return sh_pfc_pinctrl_init();
 }
-EXPORT_SYMBOL_GPL(sh_pfc_register_pinctrl);
 
 static void __exit sh_pfc_pinctrl_exit(void)
 {
-- 
1.7.8.6

