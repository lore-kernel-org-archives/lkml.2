Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab0HYWQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 18:16:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59068 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab0HYWQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 18:16:20 -0400
From: Ivan Gomez Castellanos <ivan.gomez@ti.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, gregkh@suse.de
Cc: Hiroshi.DOYU@nokia.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, omar.ramirez@ti.com, ohad@wizery.com,
        rene.sapiens@ti.com, nm@ti.com, ernesto@ti.com, x0095078@ti.com,
        Ivan Gomez Castellanos <ivan.gomez@ti.com>
Subject: [PATCH 02/11] staging: tidspbridge: Remove ntfy.c
Date: Wed, 25 Aug 2010 17:08:55 -0500
Message-Id: <1282774144-11628-3-git-send-email-ivan.gomez@ti.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
References: <1282774144-11628-1-git-send-email-ivan.gomez@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the services directory is going to be removed, this patch is needed.

ntfy.c only contained the function dsp_notifier_event(), and since this
function calls sync_set_event(), then the dsp_notifier_event() is moved
to the sync.c file.

Signed-off-by: Ivan Gomez Castellanos <ivan.gomez@ti.com>
---
 drivers/staging/tidspbridge/Makefile        |    2 +-
 drivers/staging/tidspbridge/core/sync.c     |   17 ++++++++++++++
 drivers/staging/tidspbridge/services/ntfy.c |   31 ---------------------------
 3 files changed, 18 insertions(+), 32 deletions(-)
 delete mode 100644 drivers/staging/tidspbridge/services/ntfy.c

diff --git a/drivers/staging/tidspbridge/Makefile b/drivers/staging/tidspbridge/Makefile
index 50be983..8a13982 100644
--- a/drivers/staging/tidspbridge/Makefile
+++ b/drivers/staging/tidspbridge/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_TIDSPBRIDGE)	+= bridgedriver.o
 
 libgen = gen/gb.o gen/gs.o gen/gh.o gen/uuidutil.o
 libservices = services/cfg.o \
-		services/ntfy.o services/services.o
+		services/services.o
 libcore = core/chnl_sm.o core/msg_sm.o core/io_sm.o core/tiomap3430.o \
 		core/tiomap3430_pwr.o core/tiomap_io.o \
 		core/ue_deh.o core/wdt.o core/dsp-clock.o core/sync.o
diff --git a/drivers/staging/tidspbridge/core/sync.c b/drivers/staging/tidspbridge/core/sync.c
index 9010b37..995986a 100644
--- a/drivers/staging/tidspbridge/core/sync.c
+++ b/drivers/staging/tidspbridge/core/sync.c
@@ -21,6 +21,7 @@
 
 /*  ----------------------------------- This */
 #include <dspbridge/sync.h>
+#include <dspbridge/ntfy.h>
 
 DEFINE_SPINLOCK(sync_lock);
 
@@ -102,3 +103,19 @@ func_end:
 	return status;
 }
 
+/**
+ * dsp_notifier_event() - callback function to nofity events
+ * @this:		pointer to itself struct notifier_block
+ * @event:	event to be notified.
+ * @data:		Currently not used.
+ *
+ */
+int dsp_notifier_event(struct notifier_block *this, unsigned long event,
+							void *data)
+{
+	struct  ntfy_event *ne = container_of(this, struct ntfy_event,
+							noti_block);
+	if (ne->event & event)
+		sync_set_event(&ne->sync_obj);
+	return NOTIFY_OK;
+}
diff --git a/drivers/staging/tidspbridge/services/ntfy.c b/drivers/staging/tidspbridge/services/ntfy.c
deleted file mode 100644
index a2ea698..0000000
--- a/drivers/staging/tidspbridge/services/ntfy.c
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * ntfy.c
- *
- * DSP-BIOS Bridge driver support functions for TI OMAP processors.
- *
- * Manage lists of notification events.
- *
- * Copyright (C) 2005-2006 Texas Instruments, Inc.
- *
- * This package is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
- * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
- * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
- */
-
-/*  ----------------------------------- This */
-#include <dspbridge/ntfy.h>
-
-int dsp_notifier_event(struct notifier_block *this, unsigned long event,
-			   void *data)
-{
-	struct  ntfy_event *ne = container_of(this, struct ntfy_event,
-							noti_block);
-	if (ne->event & event)
-		sync_set_event(&ne->sync_obj);
-	return NOTIFY_OK;
-}
-
-- 
1.7.0.3

