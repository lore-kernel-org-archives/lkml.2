Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2E2LHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 07:07:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36463 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2E2LHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 07:07:14 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Joe Perches <joe@perches.com>,
        Kevin McKinney <klmckinney1@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH V3] [staging] bcm: Replace the BCM_DEBUG_* and BCM_SHOW_* macros with functions
Date: Tue, 29 May 2012 16:37:06 +0530
Message-Id: <1338289626-9021-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is made by following the improvements told by Joe Perches,
replaced the BCM_DEBUG* and BCM_SHOW* macros into functions and added them
in a file and added macros in the Debug.h file. This patch also improves the if
check in bcm_show_debug_bitmap,

the check was
	if ((i == 1) || (i == 2) || (i == 4) || (i == 8));
and used is_power_of_two instead as suggested by Eric Dumazet.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/bcm/Debug.c  |   55 +++++++++++++++++++++++++++++++++++++
 drivers/staging/bcm/Debug.h  |   62 ++++++++++++++----------------------------
 drivers/staging/bcm/Makefile |    2 +-
 3 files changed, 77 insertions(+), 42 deletions(-)
 create mode 100644 drivers/staging/bcm/Debug.c

diff --git a/drivers/staging/bcm/Debug.c b/drivers/staging/bcm/Debug.c
new file mode 100644
index 0000000..6522ad6
--- /dev/null
+++ b/drivers/staging/bcm/Debug.c
@@ -0,0 +1,55 @@
+#include <linux/log2.h>
+#include "headers.h"
+
+void bcm_debug_print(PMINI_ADAPTER Adapter, int Type, int SubType,
+			int dbg_level, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	UINT debug_level = Adapter->stDebugState.debug_level;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (DBG_TYPE_PRINTK == Type)
+		pr_info("%s: %pV", __func__, &vaf);
+	else if (Adapter &&
+		(dbg_level & DBG_LVL_BITMASK) <= debug_level &&
+		(Type & Adapter->stDebugState.type) &&
+		(SubType & Adapter->stDebugState.subtype[Type])) {
+		if (dbg_level & DBG_NO_FUNC_PRINT)
+			printk(KERN_DEBUG "%pV" , &vaf);
+		else
+			printk(KERN_DEBUG "%s: %pV", __func__, &vaf);
+	}
+
+	va_end(args);
+}
+
+void bcm_debug_print_buffer(PMINI_ADAPTER Adapter, int Type, int SubType,
+			    int dbg_level, const void *buffer, size_t bufferlen)
+{
+	if (DBG_TYPE_PRINTK == Type ||
+	   (Adapter &&
+	   (dbg_level & DBG_LVL_BITMASK) <= Adapter->stDebugState.debug_level &&
+	   (Type & Adapter->stDebugState.type) &&
+	   (SubType & Adapter->stDebugState.subtype[Type]))) {
+		printk(KERN_DEBUG "%s:\n", __func__);
+		print_hex_dump(KERN_DEBUG, " ", DUMP_PREFIX_OFFSET,
+			       16, 1, buffer, bufferlen, false);
+	}
+}
+
+void bcm_show_debug_bitmap(PMINI_ADAPTER Adapter)
+{
+	int i;
+	for (i = 0; i < (NUMTYPES * 2) + 1; i++) {
+		if (is_power_of_2(i)) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"subtype[%d] = 0x%08x\n",
+					i, Adapter->stDebugState.subtype[i]);
+		}
+	}
+}
diff --git a/drivers/staging/bcm/Debug.h b/drivers/staging/bcm/Debug.h
index 420382d..030c737 100644
--- a/drivers/staging/bcm/Debug.h
+++ b/drivers/staging/bcm/Debug.h
@@ -203,57 +203,37 @@ typedef struct _S_BCM_DEBUG_STATE {
 	 * corresponding to valid Type values. Hence we use the 'Type' field
 	 * as the index value, ignoring the array entries 0,3,5,6,7 !
 	 */
-	UINT subtype[(NUMTYPES*2)+1];
+	UINT subtype[(NUMTYPES * 2) + 1];
 	UINT debug_level;
 } S_BCM_DEBUG_STATE;
 /* Instantiated in the Adapter structure */
 /* We'll reuse the debug level parameter to include a bit (the MSB) to indicate whether or not
  * we want the function's name printed.  */
-#define DBG_NO_FUNC_PRINT	1 << 31
+#define DBG_NO_FUNC_PRINT	(1 << 31)
 #define DBG_LVL_BITMASK		0xFF
 
 //--- Only for direct printk's; "hidden" to API.
 #define DBG_TYPE_PRINTK		3
 
-#define BCM_DEBUG_PRINT(Adapter, Type, SubType, dbg_level, string, args...) \
-	do {								\
-		if (DBG_TYPE_PRINTK == Type)				\
-			pr_info("%s:" string, __func__, ##args);	\
-		else if (Adapter &&					\
-			 (dbg_level & DBG_LVL_BITMASK) <= Adapter->stDebugState.debug_level && \
-			 (Type & Adapter->stDebugState.type) &&		\
-			 (SubType & Adapter->stDebugState.subtype[Type])) { \
-			if (dbg_level & DBG_NO_FUNC_PRINT)		\
-				printk(KERN_DEBUG string, ##args);	\
-			else						\
-				printk(KERN_DEBUG "%s:" string, __func__, ##args);	\
-		}							\
-	} while (0)
-
-#define BCM_DEBUG_PRINT_BUFFER(Adapter, Type, SubType, dbg_level,  buffer, bufferlen) do { \
-	if (DBG_TYPE_PRINTK == Type ||					\
-	    (Adapter &&							\
-	     (dbg_level & DBG_LVL_BITMASK) <= Adapter->stDebugState.debug_level  && \
-	     (Type & Adapter->stDebugState.type) &&			\
-	     (SubType & Adapter->stDebugState.subtype[Type]))) {	\
-		printk(KERN_DEBUG "%s:\n", __func__);			\
-		print_hex_dump(KERN_DEBUG, " ", DUMP_PREFIX_OFFSET,	\
-			       16, 1, buffer, bufferlen, false);	\
-	}								\
-} while(0)
-
-
-#define BCM_SHOW_DEBUG_BITMAP(Adapter)	do { \
-	int i;									\
-	for (i=0; i<(NUMTYPES*2)+1; i++) {		\
-		if ((i == 1) || (i == 2) || (i == 4) || (i == 8)) {		\
-		/* CAUTION! Forcefully turn on ALL debug paths and subpaths!	\
-		Adapter->stDebugState.subtype[i] = 0xffffffff;	*/ \
-		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "subtype[%d] = 0x%08x\n", 	\
-		i, Adapter->stDebugState.subtype[i]);	\
-		}	\
-	}		\
-} while (0)
+struct _MINI_ADAPTER;
+
+__printf(5, 6)
+
+void bcm_debug_print(struct _MINI_ADAPTER *Adapter, int Type, int SubType,
+			int dbg_level, const char *fmt, ...);
+void bcm_debug_print_buffer(struct _MINI_ADAPTER *Adapter, int Type, int SubType,
+			int dbg_level, const void *buffer, size_t bufferlen);
+void bcm_show_debug_bitmap(struct _MINI_ADAPTER *Adapter);
+
+#define BCM_DEBUG_PRINT(Adapter, Type, SubType, dbg_level, fmt, ...)	\
+	bcm_debug_print(Adapter, Type, SubType, dbg_level, fmt, ##__VA_ARGS__)
+
+#define BCM_DEBUG_PRINT_BUFFER(Adapter, Type, SubType, dbg_level,	\
+				buffer, bufferlen)			\
+	bcm_debug_print_buffer(Adapter, Type, SubType, dbg_level,	\
+				buffer, bufferlen)
+#define BCM_SHOW_DEBUG_BITMAP(Adapter)					\
+	bcm_show_debug_bitmap(Adapter)
 
 #endif
 
diff --git a/drivers/staging/bcm/Makefile b/drivers/staging/bcm/Makefile
index 652b7f8..85b134d 100644
--- a/drivers/staging/bcm/Makefile
+++ b/drivers/staging/bcm/Makefile
@@ -7,6 +7,6 @@ obj-$(CONFIG_BCM_WIMAX) +=	bcm_wimax.o
 bcm_wimax-y :=  InterfaceDld.o InterfaceIdleMode.o InterfaceInit.o InterfaceRx.o \
 		InterfaceIsr.o InterfaceMisc.o InterfaceTx.o \
 		CmHost.o IPv6Protocol.o Qos.o Transmit.o\
-		Bcmnet.o DDRInit.o HandleControlPacket.o\
+		Debug.o Bcmnet.o DDRInit.o HandleControlPacket.o\
 		LeakyBucket.o Misc.o sort.o Bcmchar.o hostmibs.o PHSModule.o\
 		led_control.o nvm.o vendorspecificextn.o
-- 
1.7.9.5

