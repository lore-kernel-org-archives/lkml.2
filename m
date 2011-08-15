Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1HOQEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:04:48 -0400
Received: from c60.cesmail.net ([216.154.195.49]:25942 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab1HOQEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:04:47 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] sparse: always enable endian checks
To: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Date: Mon, 15 Aug 2011 12:04:41 -0400
Message-ID: <20110815160440.6296.95762.stgit@mj>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checks enabled by __CHECK_ENDIAN__ produce less than a half of the
sparse warnings.  For instance, the allyesconfig configuration on
linux-next (tag next-20110812) produces on x86_64:

                 no __CHECK_ENDIAN__   with __CHECK_ENDIAN__
stderr bytes:    1155037               1992954 (73% increase)
stderr lines:    10716                 18657   (74% increase)
affected files:  1191                  1458    (22% increase)

It is no longer true that __CHECK_ENDIAN__ produces so many warnings
that other sparse warnings drown in the noise.

Janitors going through the whole tree are already prepared to search for
the warnings they want to fix.

The main point of this patch is to make sure that developers of a
particular driver who use sparse rarely get all the warnings for their
code even if they forget to specify __CHECK_ENDIAN__ or mistype it.

Some developers actually added __CHECK_ENDIAN__ to the driver makefiles
so they don't forget to use it.  Remove them now.

Remove all references to __CHECK_ENDIAN__ from the documentation except
the Chinese version, which would need to be updated separately.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 Documentation/sparse.txt                        |   17 +++++------------
 drivers/net/wireless/iwlegacy/Makefile          |    2 --
 drivers/net/wireless/iwlwifi/Makefile           |    2 --
 drivers/net/wireless/iwmc3200wifi/Makefile      |    2 --
 drivers/net/wireless/orinoco/Makefile           |    3 ---
 drivers/net/wireless/rtlwifi/Makefile           |    2 --
 drivers/net/wireless/rtlwifi/rtl8192c/Makefile  |    2 --
 drivers/net/wireless/rtlwifi/rtl8192ce/Makefile |    2 --
 drivers/net/wireless/rtlwifi/rtl8192cu/Makefile |    2 --
 drivers/net/wireless/rtlwifi/rtl8192de/Makefile |    2 --
 drivers/net/wireless/rtlwifi/rtl8192se/Makefile |    3 ---
 fs/logfs/logfs.h                                |    3 ---
 include/linux/types.h                           |    5 +----
 net/mac80211/Makefile                           |    2 --
 net/wireless/Makefile                           |    2 --
 15 files changed, 6 insertions(+), 45 deletions(-)

diff --git a/Documentation/sparse.txt b/Documentation/sparse.txt
index 4909d41..eb9bbbe 100644
--- a/Documentation/sparse.txt
+++ b/Documentation/sparse.txt
@@ -42,13 +42,6 @@ sure that bitwise types don't get mixed up (little-endian vs big-endian
 vs cpu-endian vs whatever), and there the constant "0" really _is_
 special.
 
-__bitwise__ - to be used for relatively compact stuff (gfp_t, etc.) that
-is mostly warning-free and is supposed to stay that way.  Warnings will
-be generated without __CHECK_ENDIAN__.
-
-__bitwise - noisy stuff; in particular, __le*/__be* are that.  We really
-don't want to drown in noise unless we'd explicitly asked for it.
-
 
 Getting sparse
 ~~~~~~~~~~~~~~
@@ -81,10 +74,10 @@ recompiled, or use "make C=2" to run sparse on the files whether they need to
 be recompiled or not.  The latter is a fast way to check the whole tree if you
 have already built it.
 
-The optional make variable CF can be used to pass arguments to sparse.  The
-build system passes -Wbitwise to sparse automatically.  To perform endianness
-checks, you may define __CHECK_ENDIAN__:
+The optional make variable CF can be used to pass arguments to sparse.  For
+example, use this to enable all sparse warnings:
 
-        make C=2 CF="-D__CHECK_ENDIAN__"
+        make C=2 CF="-Wsparse-all"
 
-These checks are disabled by default as they generate a host of warnings.
+Some sparse checks are disabled by default as they generate a host of warnings
+about minor issues.
diff --git a/drivers/net/wireless/iwlegacy/Makefile b/drivers/net/wireless/iwlegacy/Makefile
index d56aeb3..c98f3d4 100644
--- a/drivers/net/wireless/iwlegacy/Makefile
+++ b/drivers/net/wireless/iwlegacy/Makefile
@@ -21,5 +21,3 @@ iwl4965-$(CONFIG_IWLWIFI_LEGACY_DEBUGFS) += iwl-4965-debugfs.o
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o iwl-3945-led.o
 iwl3945-$(CONFIG_IWLWIFI_LEGACY_DEBUGFS) += iwl-3945-debugfs.o
-
-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 48ab914..8a765c5 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -21,5 +21,3 @@ iwlagn-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 iwlagn-$(CONFIG_IWLWIFI_DEVICE_SVTOOL) += iwl-sv-open.o
 
 CFLAGS_iwl-devtrace.o := -I$(src)
-
-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/iwmc3200wifi/Makefile b/drivers/net/wireless/iwmc3200wifi/Makefile
index cdc7e07..aeed5cd 100644
--- a/drivers/net/wireless/iwmc3200wifi/Makefile
+++ b/drivers/net/wireless/iwmc3200wifi/Makefile
@@ -6,5 +6,3 @@ iwmc3200wifi-$(CONFIG_IWM_DEBUG) += debugfs.o
 iwmc3200wifi-$(CONFIG_IWM_TRACING) += trace.o
 
 CFLAGS_trace.o := -I$(src)
-
-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/orinoco/Makefile b/drivers/net/wireless/orinoco/Makefile
index bfdefb8..b7ecef8 100644
--- a/drivers/net/wireless/orinoco/Makefile
+++ b/drivers/net/wireless/orinoco/Makefile
@@ -12,6 +12,3 @@ obj-$(CONFIG_TMD_HERMES)	+= orinoco_tmd.o
 obj-$(CONFIG_NORTEL_HERMES)	+= orinoco_nortel.o
 obj-$(CONFIG_PCMCIA_SPECTRUM)	+= spectrum_cs.o
 obj-$(CONFIG_ORINOCO_USB)	+= orinoco_usb.o
-
-# Orinoco should be endian clean.
-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/rtlwifi/Makefile b/drivers/net/wireless/rtlwifi/Makefile
index 97935c5..3255c27 100644
--- a/drivers/net/wireless/rtlwifi/Makefile
+++ b/drivers/net/wireless/rtlwifi/Makefile
@@ -24,5 +24,3 @@ obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
 obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
 obj-$(CONFIG_RTL8192SE)		+= rtl8192se/
 obj-$(CONFIG_RTL8192DE)		+= rtl8192de/
-
-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/Makefile b/drivers/net/wireless/rtlwifi/rtl8192c/Makefile
index aee42d7..0546b75 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/Makefile
@@ -5,5 +5,3 @@ rtl8192c-common-objs :=		\
 		phy_common.o
 
 obj-$(CONFIG_RTL8192C_COMMON) += rtl8192c-common.o
-
-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile b/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
index c0cb0cf..577c7ad 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
@@ -9,5 +9,3 @@ rtl8192ce-objs :=		\
 		trx.o
 
 obj-$(CONFIG_RTL8192CE) += rtl8192ce.o
-
-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile b/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
index ad2de6b..97437da 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
@@ -10,5 +10,3 @@ rtl8192cu-objs :=		\
 		trx.o
 
 obj-$(CONFIG_RTL8192CU) += rtl8192cu.o
-
-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/Makefile b/drivers/net/wireless/rtlwifi/rtl8192de/Makefile
index e3213c8..d0703f2 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/Makefile
@@ -10,5 +10,3 @@ rtl8192de-objs :=		\
 		trx.o
 
 obj-$(CONFIG_RTL8192DE) += rtl8192de.o
-
-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/Makefile b/drivers/net/wireless/rtlwifi/rtl8192se/Makefile
index b7eb138..4f8c1d8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/Makefile
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/Makefile
@@ -10,6 +10,3 @@ rtl8192se-objs :=		\
 		trx.o
 
 obj-$(CONFIG_RTL8192SE) += rtl8192se.o
-
-ccflags-y += -D__CHECK_ENDIAN__
-
diff --git a/fs/logfs/logfs.h b/fs/logfs/logfs.h
index 68e4fd2..24a171c 100644
--- a/fs/logfs/logfs.h
+++ b/fs/logfs/logfs.h
@@ -10,9 +10,6 @@
 #ifndef FS_LOGFS_LOGFS_H
 #define FS_LOGFS_LOGFS_H
 
-#undef __CHECK_ENDIAN__
-#define __CHECK_ENDIAN__
-
 #include <linux/btree.h>
 #include <linux/crc32.h>
 #include <linux/fs.h>
diff --git a/include/linux/types.h b/include/linux/types.h
index 57a9723..b09c5b4 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -168,11 +168,8 @@ typedef u32 dma_addr_t;
 #else
 #define __bitwise__
 #endif
-#ifdef __CHECK_ENDIAN__
+
 #define __bitwise __bitwise__
-#else
-#define __bitwise
-#endif
 
 typedef __u16 __bitwise __le16;
 typedef __u16 __bitwise __be16;
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index fdb54e6..d446aa9 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -57,5 +57,3 @@ rc80211_minstrel_ht-$(CONFIG_MAC80211_DEBUGFS) += rc80211_minstrel_ht_debugfs.o
 mac80211-$(CONFIG_MAC80211_RC_PID) += $(rc80211_pid-y)
 mac80211-$(CONFIG_MAC80211_RC_MINSTREL) += $(rc80211_minstrel-y)
 mac80211-$(CONFIG_MAC80211_RC_MINSTREL_HT) += $(rc80211_minstrel_ht-y)
-
-ccflags-y += -D__CHECK_ENDIAN__
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 55a28ab..fe3fd6b 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -15,8 +15,6 @@ cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 cfg80211-$(CONFIG_CFG80211_INTERNAL_REGDB) += regdb.o
 
-ccflags-y += -D__CHECK_ENDIAN__
-
 $(obj)/regdb.c: $(src)/db.txt $(src)/genregdb.awk
 	@$(AWK) -f $(srctree)/$(src)/genregdb.awk < $< > $@
 
