Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2AaItS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:49:18 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64111 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511Ab2AaItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:49:12 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RESEND PATCHv5 10/11] modem_shm: Makefile and Kconfig for M7400 Shared Memory Drivers
Date: Tue, 31 Jan 2012 09:48:45 +0100
Message-Id: <1327999726-8774-11-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Kconfig and Makefile for modem shm.
MODEM_SHM should be selected from architectures supporting
C2C.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/Kconfig            |    2 +
 drivers/Makefile           |    1 +
 drivers/modem_shm/Kconfig  |   62 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/modem_shm/Makefile |    5 +++
 4 files changed, 70 insertions(+), 0 deletions(-)
 create mode 100644 drivers/modem_shm/Kconfig
 create mode 100644 drivers/modem_shm/Makefile

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 5afe5d1..918e943 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -136,4 +136,6 @@ source "drivers/virt/Kconfig"
 
 source "drivers/devfreq/Kconfig"
 
+source "drivers/modem_shm/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index c07be02..a315636 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -120,6 +120,7 @@ obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
 obj-y				+= platform/
 obj-y				+= ieee802154/
+obj-$(CONFIG_MODEM_SHM)	+= modem_shm/
 #common clk code
 obj-y				+= clk/
 
diff --git a/drivers/modem_shm/Kconfig b/drivers/modem_shm/Kconfig
new file mode 100644
index 0000000..7e18801
--- /dev/null
+++ b/drivers/modem_shm/Kconfig
@@ -0,0 +1,62 @@
+#
+# MODEM_SHM Framework
+#
+
+config MODEM_SHM
+	tristate
+	default n
+	depends on EXPERIMENTAL
+
+if MODEM_SHM && NET
+
+menu "Modem Shared Memory"
+
+config DUMMY_C2C
+	tristate "Dummy C2C GENIO driver"
+	depends on !C2C
+	default MODEM_SHM
+	---help---
+	Say "Y" or "M" if you want to compile a dummy C2C driver.
+	Use this if you want to compile without the real
+	C2C driver available.
+	If unsure say N.
+
+config MODEM_SHM_BUS
+	tristate
+	default MODEM_SHM_DEV
+
+config MODEM_SHM_BOOT
+	tristate
+	depends on MODEM_SHM_DEV
+	default MODEM_SHM_DEV
+
+config MODEM_SHM_DEV
+	tristate "SHM Channels for Modem Shared Memory"
+	depends on DUMMY_C2C || C2C
+	select MODEM_SHM_BUS
+	select MODEM_SHM_BOOT
+	default MODEM_SHM
+	---help---
+	Say "Y" to use Modem Shared Memory IPC mechanism.
+	SHM is an IPC protocol used to talk to external device such
+	as modem over a shared memory (e.g. Chip to Chip).
+	Only say "M" here if you want to test MODEM_SHM and need to load
+	and unload its module.
+	If unsure say N.
+
+config MODEM_SHM_CHR
+	tristate "Character device for Modem Shared Memory"
+	depends on MODEM_SHM_DEV
+	default MODEM_SHM_DEV
+	---help---
+	Say "Y" to use a character device for the Modem Shared
+	Memory IPC mechanism. MODEM_SHM is an IPC protocol used to
+	talk to external device such as modem over a shared memory
+	(e.g. Chip to Chip).
+	Only say "M" here if you want to test MODEM_SHM and need to load
+	and unload its module.
+	If unsure say N.
+
+endmenu
+
+endif
diff --git a/drivers/modem_shm/Makefile b/drivers/modem_shm/Makefile
new file mode 100644
index 0000000..3bd2274
--- /dev/null
+++ b/drivers/modem_shm/Makefile
@@ -0,0 +1,5 @@
+obj-$(CONFIG_MODEM_SHM_BUS) += shm_bus.o
+obj-$(CONFIG_MODEM_SHM_BOOT) += shm_boot.o
+obj-$(CONFIG_MODEM_SHM_DEV) += shm_dev.o
+obj-$(CONFIG_MODEM_SHM_CHR) +=  shm_chr.o
+obj-$(CONFIG_DUMMY_C2C) +=  dummy_c2c_genio.o
-- 
1.7.0.4

