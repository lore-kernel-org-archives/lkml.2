Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2DJHxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 03:53:24 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:54613 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273Ab2DJHxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 03:53:23 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] pinctrl: fix build failure on PPC
Date: Tue, 10 Apr 2012 09:52:37 +0200
Message-ID: <1334044357-14486-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 23289e6ecc6d ("pinctrl: core device tree mapping table
parsing support") caused a build failure on PPC:

drivers/pinctrl/devicetree.c: In function 'dt_free_map':
drivers/pinctrl/devicetree.c:44:42: error: dereferencing pointer to incomplete type
drivers/pinctrl/devicetree.c:45:6: error: dereferencing pointer to incomplete type
drivers/pinctrl/devicetree.c: In function 'dt_to_map_one_config':
drivers/pinctrl/devicetree.c:140:21: error: dereferencing pointer to incomplete type
drivers/pinctrl/devicetree.c:141:10: error: dereferencing pointer to incomplete type
drivers/pinctrl/devicetree.c:146:11: error: dereferencing pointer to incomplete type

This is probably because the Makefile for pinctrl contains this,
that makes a small piece of the implementation build and link
in isolation:

obj-$(CONFIG_OF)                += devicetree.o

So let's use some local Kconfig option that depends on both OF
and PINCTRL so that this file is only compiled if you have
both enabled.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig  |    5 +++++
 drivers/pinctrl/Makefile |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index abfb964..d68c878 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -17,6 +17,11 @@ config PINMUX
 config PINCONF
 	bool "Support pin configuration controllers"
 
+config PINCTRL_OF
+	bool
+	depends on OF
+	default y if OF
+
 config GENERIC_PINCONF
 	bool
 	select PINCONF
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 049c9fb..5412f60 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -5,7 +5,7 @@ ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL)		+= core.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
 obj-$(CONFIG_PINCONF)		+= pinconf.o
-obj-$(CONFIG_OF)		+= devicetree.o
+obj-$(CONFIG_PINCTRL_OF)	+= devicetree.o
 obj-$(CONFIG_GENERIC_PINCONF)	+= pinconf-generic.o
 obj-$(CONFIG_PINCTRL_PXA3xx)	+= pinctrl-pxa3xx.o
 obj-$(CONFIG_PINCTRL_MMP2)	+= pinctrl-mmp2.o
-- 
1.7.9.2

