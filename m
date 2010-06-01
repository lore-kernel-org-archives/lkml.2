Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab0FAIBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:01:38 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60997 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab0FAIBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:01:35 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] Rename ramzswap files to zram
Date: Tue,  1 Jun 2010 13:31:24 +0530
Message-Id: <1275379286-10453-3-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Related changes:
 - Modify revelant Kconfig and Makefile accordingly.
 - Change include filenames in code.
 - Remove dependency on CONFIG_SWAP in Kconfig as zram usage
is no longer limited to swap disks.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/Kconfig                            |    2 +-
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/ramzswap/Kconfig                   |   21 ---------------
 drivers/staging/ramzswap/Makefile                  |    3 --
 drivers/staging/zram/Kconfig                       |   28 ++++++++++++++++++++
 drivers/staging/zram/Makefile                      |    3 ++
 drivers/staging/{ramzswap => zram}/xvmalloc.c      |    0
 drivers/staging/{ramzswap => zram}/xvmalloc.h      |    0
 drivers/staging/{ramzswap => zram}/xvmalloc_int.h  |    0
 .../{ramzswap/ramzswap.txt => zram/zram.txt}       |    0
 .../{ramzswap/ramzswap_drv.c => zram/zram_drv.c}   |    2 +-
 .../{ramzswap/ramzswap_drv.h => zram/zram_drv.h}   |    2 +-
 .../ramzswap_ioctl.h => zram/zram_ioctl.h}         |    0
 13 files changed, 35 insertions(+), 28 deletions(-)
 delete mode 100644 drivers/staging/ramzswap/Kconfig
 delete mode 100644 drivers/staging/ramzswap/Makefile
 create mode 100644 drivers/staging/zram/Kconfig
 create mode 100644 drivers/staging/zram/Makefile
 rename drivers/staging/{ramzswap => zram}/xvmalloc.c (100%)
 rename drivers/staging/{ramzswap => zram}/xvmalloc.h (100%)
 rename drivers/staging/{ramzswap => zram}/xvmalloc_int.h (100%)
 rename drivers/staging/{ramzswap/ramzswap.txt => zram/zram.txt} (100%)
 rename drivers/staging/{ramzswap/ramzswap_drv.c => zram/zram_drv.c} (99%)
 rename drivers/staging/{ramzswap/ramzswap_drv.h => zram/zram_drv.h} (99%)
 rename drivers/staging/{ramzswap/ramzswap_ioctl.h => zram/zram_ioctl.h} (100%)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index b5c3b30..32d5300 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -117,7 +117,7 @@ source "drivers/staging/sep/Kconfig"
 
 source "drivers/staging/iio/Kconfig"
 
-source "drivers/staging/ramzswap/Kconfig"
+source "drivers/staging/zram/Kconfig"
 
 source "drivers/staging/wlags49_h2/Kconfig"
 
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index e330dd5..cec25b0 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_RAR_REGISTER)	+= rar_register/
 obj-$(CONFIG_MRST_RAR_HANDLER)	+= memrar/
 obj-$(CONFIG_DX_SEP)		+= sep/
 obj-$(CONFIG_IIO)		+= iio/
-obj-$(CONFIG_RAMZSWAP)		+= ramzswap/
+obj-$(CONFIG_ZRAM)		+= zram/
 obj-$(CONFIG_WLAGS49_H2)	+= wlags49_h2/
 obj-$(CONFIG_WLAGS49_H25)	+= wlags49_h25/
 obj-$(CONFIG_BATMAN_ADV)	+= batman-adv/
diff --git a/drivers/staging/ramzswap/Kconfig b/drivers/staging/ramzswap/Kconfig
deleted file mode 100644
index 127b3c6..0000000
--- a/drivers/staging/ramzswap/Kconfig
+++ /dev/null
@@ -1,21 +0,0 @@
-config RAMZSWAP
-	tristate "Compressed in-memory swap device (ramzswap)"
-	depends on SWAP
-	select LZO_COMPRESS
-	select LZO_DECOMPRESS
-	default n
-	help
-	  Creates virtual block devices which can (only) be used as swap
-	  disks. Pages swapped to these disks are compressed and stored in
-	  memory itself.
-
-	  See ramzswap.txt for more information.
-	  Project home: http://compcache.googlecode.com/
-
-config RAMZSWAP_STATS
-	bool "Enable ramzswap stats"
-	depends on RAMZSWAP
-	default y
-	help
-	  Enable statistics collection for ramzswap. This adds only a minimal
-	  overhead. In unsure, say Y.
diff --git a/drivers/staging/ramzswap/Makefile b/drivers/staging/ramzswap/Makefile
deleted file mode 100644
index 507d7dc..0000000
--- a/drivers/staging/ramzswap/Makefile
+++ /dev/null
@@ -1,3 +0,0 @@
-ramzswap-objs	:=	ramzswap_drv.o xvmalloc.o
-
-obj-$(CONFIG_RAMZSWAP)	+=	ramzswap.o
diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
new file mode 100644
index 0000000..5bcfe16
--- /dev/null
+++ b/drivers/staging/zram/Kconfig
@@ -0,0 +1,28 @@
+config ZRAM
+	tristate "Compressed RAM block device support"
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
+	default n
+	help
+	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
+	  Pages written to these disks are compressed and stored in memory
+	  itself. These disks allow very fast I/O and compression provides
+	  good amounts of memory savings.
+
+	  It has several use cases, for example: /tmp storage, use as swap
+	  disks and maybe many more.
+
+	  See zram.txt for more information.
+	  Project home: http://compcache.googlecode.com/
+
+config ZRAM_STATS
+	bool "Enable statistics for compressed RAM disks"
+	depends on ZRAM
+	default y
+	help
+	  Enable statistics collection for compressed RAM devices. Statistics
+	  are exported through ioctl interface, so you have to use zramconfig
+	  program to get them. This adds only a minimal overhead.
+
+	  If unsure, say Y.
+
diff --git a/drivers/staging/zram/Makefile b/drivers/staging/zram/Makefile
new file mode 100644
index 0000000..b2c087a
--- /dev/null
+++ b/drivers/staging/zram/Makefile
@@ -0,0 +1,3 @@
+zram-objs	:=	zram_drv.o xvmalloc.o
+
+obj-$(CONFIG_ZRAM)	+=	zram.o
diff --git a/drivers/staging/ramzswap/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
similarity index 100%
rename from drivers/staging/ramzswap/xvmalloc.c
rename to drivers/staging/zram/xvmalloc.c
diff --git a/drivers/staging/ramzswap/xvmalloc.h b/drivers/staging/zram/xvmalloc.h
similarity index 100%
rename from drivers/staging/ramzswap/xvmalloc.h
rename to drivers/staging/zram/xvmalloc.h
diff --git a/drivers/staging/ramzswap/xvmalloc_int.h b/drivers/staging/zram/xvmalloc_int.h
similarity index 100%
rename from drivers/staging/ramzswap/xvmalloc_int.h
rename to drivers/staging/zram/xvmalloc_int.h
diff --git a/drivers/staging/ramzswap/ramzswap.txt b/drivers/staging/zram/zram.txt
similarity index 100%
rename from drivers/staging/ramzswap/ramzswap.txt
rename to drivers/staging/zram/zram.txt
diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/zram/zram_drv.c
similarity index 99%
rename from drivers/staging/ramzswap/ramzswap_drv.c
rename to drivers/staging/zram/zram_drv.c
index 7b5cc61..e9b064c 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -30,7 +30,7 @@
 #include <linux/swapops.h>
 #include <linux/vmalloc.h>
 
-#include "ramzswap_drv.h"
+#include "zram_drv.h"
 
 /* Globals */
 static int ramzswap_major;
diff --git a/drivers/staging/ramzswap/ramzswap_drv.h b/drivers/staging/zram/zram_drv.h
similarity index 99%
rename from drivers/staging/ramzswap/ramzswap_drv.h
rename to drivers/staging/zram/zram_drv.h
index ad91726..4d2e48a 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -18,7 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 
-#include "ramzswap_ioctl.h"
+#include "zram_ioctl.h"
 #include "xvmalloc.h"
 
 /*
diff --git a/drivers/staging/ramzswap/ramzswap_ioctl.h b/drivers/staging/zram/zram_ioctl.h
similarity index 100%
rename from drivers/staging/ramzswap/ramzswap_ioctl.h
rename to drivers/staging/zram/zram_ioctl.h
-- 
1.7.0.1

