Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2DKJPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 05:15:06 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:46538 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2DKJPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 05:15:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Alan Cox <alan@linux.intel.com>,
        Andrea Shepard <andrea@persephoneslair.org>
Subject: [PATCH 1/3] NET: pc300, move to staging as it is broken
Date: Wed, 11 Apr 2012 11:14:57 +0200
Message-Id: <1334135699-30180-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was marked as BROKEN back in 2008. It is because the tty handling
in the driver is really broken.

There was some activity in January 2012 to fix the driver, but the
patch was commented to be bogus:
  https://lkml.org/lkml/2012/1/29/160
and we have not heard back from the author since then:
  https://lkml.org/lkml/2012/3/28/412

So since nobody stepped in and rewrote the driver, it is time to move
it out of line now. And drop it some time later if nobody comes up
with patches to fix the driver in staging.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Andrea Shepard <andrea@persephoneslair.org>
---
 drivers/net/wan/Kconfig                          |   31 ------------------
 drivers/net/wan/Makefile                         |    5 ---
 drivers/staging/Kconfig                          |    2 ++
 drivers/staging/Makefile                         |    1 +
 drivers/staging/net/Kconfig                      |   38 ++++++++++++++++++++++
 drivers/staging/net/Makefile                     |    5 +++
 drivers/staging/net/TODO                         |    5 +++
 drivers/{net/wan => staging/net}/pc300-falc-lh.h |    0
 drivers/{net/wan => staging/net}/pc300.h         |    0
 drivers/{net/wan => staging/net}/pc300_drv.c     |    0
 drivers/{net/wan => staging/net}/pc300_tty.c     |    0
 11 files changed, 51 insertions(+), 36 deletions(-)
 create mode 100644 drivers/staging/net/Kconfig
 create mode 100644 drivers/staging/net/Makefile
 create mode 100644 drivers/staging/net/TODO
 rename drivers/{net/wan => staging/net}/pc300-falc-lh.h (100%)
 rename drivers/{net/wan => staging/net}/pc300.h (100%)
 rename drivers/{net/wan => staging/net}/pc300_drv.c (100%)
 rename drivers/{net/wan => staging/net}/pc300_tty.c (100%)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index d70ede7..d58431e 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -203,37 +203,6 @@ config WANXL_BUILD_FIRMWARE
 
 	  You should never need this option, say N.
 
-config PC300
-	tristate "Cyclades-PC300 support (RS-232/V.35, X.21, T1/E1 boards)"
-	depends on HDLC && PCI && BROKEN
-	---help---
-	  This driver is broken because of struct tty_driver change.
-
-	  Driver for the Cyclades-PC300 synchronous communication boards.
-
-	  These boards provide synchronous serial interfaces to your
-	  Linux box (interfaces currently available are RS-232/V.35, X.21 and
-	  T1/E1). If you wish to support Multilink PPP, please select the
-	  option later and read the file README.mlppp provided by PC300
-	  package.
-
-	  To compile this as a module, choose M here: the module
-	  will be called pc300.
-
-	  If unsure, say N.
-
-config PC300_MLPPP
-	bool "Cyclades-PC300 MLPPP support"
-	depends on PC300 && PPP_MULTILINK && PPP_SYNC_TTY && HDLC_PPP
-	help
-	  Multilink PPP over the PC300 synchronous communication boards.
-
-comment "Cyclades-PC300 MLPPP support is disabled."
-	depends on HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP)
-
-comment "Refer to the file README.mlppp, provided by PC300 package."
-	depends on HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP)
-
 config PC300TOO
 	tristate "Cyclades PC300 RSV/X21 alternative support"
 	depends on HDLC && PCI
diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index 19d14bc..eac709b 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -17,10 +17,6 @@ obj-$(CONFIG_HDLC_FR)		+= hdlc_fr.o
 obj-$(CONFIG_HDLC_PPP)		+= hdlc_ppp.o
 obj-$(CONFIG_HDLC_X25)		+= hdlc_x25.o
 
-pc300-y				:= pc300_drv.o
-pc300-$(CONFIG_PC300_MLPPP)	+= pc300_tty.o
-pc300-objs			:= $(pc300-y)
-
 obj-$(CONFIG_HOSTESS_SV11)	+= z85230.o	hostess_sv11.o
 obj-$(CONFIG_SEALEVEL_4021)	+= z85230.o	sealevel.o
 obj-$(CONFIG_COSA)		+= cosa.o
@@ -35,7 +31,6 @@ obj-$(CONFIG_SDLA)		+= sdla.o
 obj-$(CONFIG_CYCLADES_SYNC)	+= cycx_drv.o cyclomx.o
 obj-$(CONFIG_LAPBETHER)		+= lapbether.o
 obj-$(CONFIG_SBNI)		+= sbni.o
-obj-$(CONFIG_PC300)		+= pc300.o
 obj-$(CONFIG_N2)		+= n2.o
 obj-$(CONFIG_C101)		+= c101.o
 obj-$(CONFIG_WANXL)		+= wanxl.o
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 4c99b4c..8d406b5 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -120,6 +120,8 @@ source "drivers/staging/nvec/Kconfig"
 
 source "drivers/staging/media/Kconfig"
 
+source "drivers/staging/net/Kconfig"
+
 source "drivers/staging/omapdrm/Kconfig"
 
 source "drivers/staging/android/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 74662ce..0381958 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -4,6 +4,7 @@
 obj-$(CONFIG_STAGING)		+= staging.o
 
 obj-y				+= media/
+obj-y				+= net/
 obj-$(CONFIG_ET131X)		+= et131x/
 obj-$(CONFIG_SLICOSS)		+= slicoss/
 obj-$(CONFIG_USBIP_CORE)	+= usbip/
diff --git a/drivers/staging/net/Kconfig b/drivers/staging/net/Kconfig
new file mode 100644
index 0000000..a64e56b
--- /dev/null
+++ b/drivers/staging/net/Kconfig
@@ -0,0 +1,38 @@
+if NETDEVICES
+
+if WAN
+
+config PC300
+	tristate "Cyclades-PC300 support (RS-232/V.35, X.21, T1/E1 boards)"
+	depends on HDLC && PCI && BROKEN
+	---help---
+	  This driver is broken because of struct tty_driver change.
+
+	  Driver for the Cyclades-PC300 synchronous communication boards.
+
+	  These boards provide synchronous serial interfaces to your
+	  Linux box (interfaces currently available are RS-232/V.35, X.21 and
+	  T1/E1). If you wish to support Multilink PPP, please select the
+	  option later and read the file README.mlppp provided by PC300
+	  package.
+
+	  To compile this as a module, choose M here: the module
+	  will be called pc300.
+
+	  If unsure, say N.
+
+config PC300_MLPPP
+	bool "Cyclades-PC300 MLPPP support"
+	depends on PC300 && PPP_MULTILINK && PPP_SYNC_TTY && HDLC_PPP
+	help
+	  Multilink PPP over the PC300 synchronous communication boards.
+
+comment "Cyclades-PC300 MLPPP support is disabled."
+	depends on HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP)
+
+comment "Refer to the file README.mlppp, provided by PC300 package."
+	depends on HDLC && PC300 && (PPP=n || !PPP_MULTILINK || PPP_SYNC_TTY=n || !HDLC_PPP)
+
+endif # WAN
+
+endif # NETDEVICES
diff --git a/drivers/staging/net/Makefile b/drivers/staging/net/Makefile
new file mode 100644
index 0000000..0799c43
--- /dev/null
+++ b/drivers/staging/net/Makefile
@@ -0,0 +1,5 @@
+pc300-y				:= pc300_drv.o
+pc300-$(CONFIG_PC300_MLPPP)	+= pc300_tty.o
+pc300-objs			:= $(pc300-y)
+
+obj-$(CONFIG_PC300)		+= pc300.o
diff --git a/drivers/staging/net/TODO b/drivers/staging/net/TODO
new file mode 100644
index 0000000..e3446f2
--- /dev/null
+++ b/drivers/staging/net/TODO
@@ -0,0 +1,5 @@
+PC300
+The driver is very broken and cannot work with the current TTY layer. It is
+inevitable to convert it to the new TTY API.
+
+If no one steps in to adopt the driver, it will be removed in the 3.7 release.
diff --git a/drivers/net/wan/pc300-falc-lh.h b/drivers/staging/net/pc300-falc-lh.h
similarity index 100%
rename from drivers/net/wan/pc300-falc-lh.h
rename to drivers/staging/net/pc300-falc-lh.h
diff --git a/drivers/net/wan/pc300.h b/drivers/staging/net/pc300.h
similarity index 100%
rename from drivers/net/wan/pc300.h
rename to drivers/staging/net/pc300.h
diff --git a/drivers/net/wan/pc300_drv.c b/drivers/staging/net/pc300_drv.c
similarity index 100%
rename from drivers/net/wan/pc300_drv.c
rename to drivers/staging/net/pc300_drv.c
diff --git a/drivers/net/wan/pc300_tty.c b/drivers/staging/net/pc300_tty.c
similarity index 100%
rename from drivers/net/wan/pc300_tty.c
rename to drivers/staging/net/pc300_tty.c
-- 
1.7.9.2


