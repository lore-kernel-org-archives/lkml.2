Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3AHVNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:13:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:29241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab3AHVIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243604838"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 01/21] mei: add new hbm.h header to export hbm protocol
Date: Tue,  8 Jan 2013 23:07:12 +0200
Message-Id: <1357679252-12958-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hbm.h provides access host bus messaging functionality
for other MEI layers

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |    1 +
 drivers/misc/mei/hbm.c       |    1 +
 drivers/misc/mei/hbm.h       |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/init.c      |    1 +
 drivers/misc/mei/interface.h |    7 ++-----
 drivers/misc/mei/interrupt.c |    1 +
 drivers/misc/mei/iorw.c      |    1 +
 drivers/misc/mei/mei_dev.h   |   10 ----------
 drivers/misc/mei/wd.c        |    1 +
 9 files changed, 47 insertions(+), 15 deletions(-)
 create mode 100644 drivers/misc/mei/hbm.h

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 6e3cd31..add4254 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -34,6 +34,7 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
+#include "hbm.h"
 #include "interface.h"
 
 const uuid_le mei_amthi_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d, 0xac,
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 6b58b0a..9956aaf 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -20,6 +20,7 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
+#include "hbm.h"
 #include "interface.h"
 
 /**
diff --git a/drivers/misc/mei/hbm.h b/drivers/misc/mei/hbm.h
new file mode 100644
index 0000000..b552afb
--- /dev/null
+++ b/drivers/misc/mei/hbm.h
@@ -0,0 +1,39 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2003-2012, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef _MEI_HBM_H_
+#define _MEI_HBM_H_
+
+void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr);
+
+static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
+{
+	hdr->host_addr = 0;
+	hdr->me_addr = 0;
+	hdr->length = length;
+	hdr->msg_complete = 1;
+	hdr->reserved = 0;
+}
+
+void mei_hbm_start_req(struct mei_device *dev);
+
+int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl);
+int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl);
+int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl);
+
+
+#endif /* _MEI_HBM_H_ */
+
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 418a85f..55895fc 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -22,6 +22,7 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
+#include "hbm.h"
 #include "interface.h"
 
 const char *mei_dev_state_str(int state)
diff --git a/drivers/misc/mei/interface.h b/drivers/misc/mei/interface.h
index 90a3dfd..3d06c08 100644
--- a/drivers/misc/mei/interface.h
+++ b/drivers/misc/mei/interface.h
@@ -72,12 +72,9 @@ void mei_watchdog_unregister(struct mei_device *dev);
 int mei_other_client_is_connecting(struct mei_device *dev, struct mei_cl *cl);
 int mei_flow_ctrl_reduce(struct mei_device *dev, struct mei_cl *cl);
 
-void mei_hbm_start_req(struct mei_device *dev);
+void mei_host_client_init(struct work_struct *work);
+
 
-int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl);
-int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl);
-int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl);
 
-void mei_host_client_init(struct work_struct *work);
 
 #endif /* _MEI_INTERFACE_H_ */
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index a735c8b..2495e35 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -24,6 +24,7 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
+#include "hbm.h"
 #include "interface.h"
 
 
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index d8e08bc..4328c2d 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -36,6 +36,7 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
+#include "hbm.h"
 #include "interface.h"
 
 /**
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 54ddac3..1b54e67 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -445,16 +445,6 @@ void mei_enable_interrupts(struct mei_device *dev);
 void mei_disable_interrupts(struct mei_device *dev);
 
 
-void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr);
-
-static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
-{
-	hdr->host_addr = 0;
-	hdr->me_addr = 0;
-	hdr->length = length;
-	hdr->msg_complete = 1;
-	hdr->reserved = 0;
-}
 
 #define MEI_HDR_FMT "hdr:host=%02d me=%02d len=%d comp=%1d"
 #define MEI_HDR_PRM(hdr)                  \
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 4f2e9db..9814bc1 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -24,6 +24,7 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
+#include "hbm.h"
 #include "interface.h"
 
 static const u8 mei_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
-- 
1.7.4.4

