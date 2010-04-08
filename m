Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab0DHSRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:17:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36682 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084Ab0DHSRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 14:17:19 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, npelly@google.com, pavan_savoy@yahoo.co.in,
       Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] drivers:staging: sources for HCI LL PM protocol
Date: Thu,  8 Apr 2010 13:16:55 -0500
Message-Id: <1270750619-19174-5-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1270750619-19174-4-git-send-email-pavan_savoy@ti.com>
References: <1270750619-19174-1-git-send-email-pavan_savoy@ti.com>
 <1270750619-19174-2-git-send-email-pavan_savoy@ti.com>
 <1270750619-19174-3-git-send-email-pavan_savoy@ti.com>
 <1270750619-19174-4-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Texas Instruments BT, FM and GPS combo chips/drivers
make use of a single TTY to communicate with the chip.
This module constitutes the proprietary power management
protocol from TI for the BT/FM/GPS combo chips

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/st_ll.c |  147 +++++++++++++++++++++++++++++++++++++++++
 drivers/staging/ti-st/st_ll.h |   62 +++++++++++++++++
 2 files changed, 209 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/ti-st/st_ll.c
 create mode 100644 drivers/staging/ti-st/st_ll.h

diff --git a/drivers/staging/ti-st/st_ll.c b/drivers/staging/ti-st/st_ll.c
new file mode 100644
index 0000000..0685a10
--- /dev/null
+++ b/drivers/staging/ti-st/st_ll.c
@@ -0,0 +1,147 @@
+/*
+ *  Shared Transport driver
+ *	HCI-LL module responsible for TI proprietary HCI_LL protocol
+ *  Copyright (C) 2009 Texas Instruments
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#define pr_fmt(fmt) "(stll) :" fmt
+#include "st_ll.h"
+
+/**********************************************************************/
+/* internal functions */
+static void send_ll_cmd(struct st_data_s *st_data,
+	unsigned char cmd)
+{
+
+	pr_info("%s: writing %x", __func__, cmd);
+	st_int_write(st_data, &cmd, 1);
+	return;
+}
+
+static void ll_device_want_to_sleep(struct st_data_s *st_data)
+{
+	pr_info("%s", __func__);
+	/* sanity check */
+	if (st_data->ll_state != ST_LL_AWAKE)
+		pr_err("ERR hcill: ST_LL_GO_TO_SLEEP_IND"
+			  "in state %ld", st_data->ll_state);
+
+	send_ll_cmd(st_data, LL_SLEEP_ACK);
+	/* update state */
+	st_data->ll_state = ST_LL_ASLEEP;
+}
+
+static void ll_device_want_to_wakeup(struct st_data_s *st_data)
+{
+	/* diff actions in diff states */
+	switch (st_data->ll_state) {
+	case ST_LL_ASLEEP:
+		send_ll_cmd(st_data, LL_WAKE_UP_ACK);	/* send wake_ack */
+		break;
+	case ST_LL_ASLEEP_TO_AWAKE:
+		/* duplicate wake_ind */
+		pr_err("duplicate wake_ind while waiting for Wake ack");
+		break;
+	case ST_LL_AWAKE:
+		/* duplicate wake_ind */
+		pr_err("duplicate wake_ind already AWAKE");
+		break;
+	case ST_LL_AWAKE_TO_ASLEEP:
+		/* duplicate wake_ind */
+		pr_err("duplicate wake_ind");
+		break;
+	}
+	/* update state */
+	st_data->ll_state = ST_LL_AWAKE;
+}
+
+/**********************************************************************/
+/* functions invoked by ST Core */
+
+/* called when ST Core wants to
+ * enable ST LL */
+void st_ll_enable(struct st_data_s *ll)
+{
+	ll->ll_state = ST_LL_AWAKE;
+}
+
+/* called when ST Core /local module wants to
+ * disable ST LL */
+void st_ll_disable(struct st_data_s *ll)
+{
+	ll->ll_state = ST_LL_INVALID;
+}
+
+/* called when ST Core wants to update the state */
+void st_ll_wakeup(struct st_data_s *ll)
+{
+	if (likely(ll->ll_state != ST_LL_AWAKE)) {
+		send_ll_cmd(ll, LL_WAKE_UP_IND);	/* WAKE_IND */
+		ll->ll_state = ST_LL_ASLEEP_TO_AWAKE;
+	} else {
+		/* don't send the duplicate wake_indication */
+		pr_err(" Chip already AWAKE ");
+	}
+}
+
+/* called when ST Core wants the state */
+unsigned long st_ll_getstate(struct st_data_s *ll)
+{
+	pr_info(" returning state %ld", ll->ll_state);
+	return ll->ll_state;
+}
+
+/* called from ST Core, when a PM related packet arrives */
+unsigned long st_ll_sleep_state(struct st_data_s *st_data,
+	unsigned char cmd)
+{
+	switch (cmd) {
+	case LL_SLEEP_IND:	/* sleep ind */
+		pr_info("sleep indication recvd");
+		ll_device_want_to_sleep(st_data);
+		break;
+	case LL_SLEEP_ACK:	/* sleep ack */
+		pr_err("sleep ack rcvd: host shouldn't");
+		break;
+	case LL_WAKE_UP_IND:	/* wake ind */
+		pr_info("wake indication recvd");
+		ll_device_want_to_wakeup(st_data);
+		break;
+	case LL_WAKE_UP_ACK:	/* wake ack */
+		pr_info("wake ack rcvd");
+		st_data->ll_state = ST_LL_AWAKE;
+		break;
+	default:
+		pr_err(" unknown input/state ");
+		return ST_ERR_FAILURE;
+	}
+	return ST_SUCCESS;
+}
+
+/* Called from ST CORE to initialize ST LL */
+long st_ll_init(struct st_data_s *ll)
+{
+	/* set state to invalid */
+	ll->ll_state = ST_LL_INVALID;
+	return 0;
+}
+
+/* Called from ST CORE to de-initialize ST LL */
+long st_ll_deinit(struct st_data_s *ll)
+{
+	return 0;
+}
diff --git a/drivers/staging/ti-st/st_ll.h b/drivers/staging/ti-st/st_ll.h
new file mode 100644
index 0000000..77dfbf0
--- /dev/null
+++ b/drivers/staging/ti-st/st_ll.h
@@ -0,0 +1,62 @@
+/*
+ *  Shared Transport Low Level (ST LL)
+ *
+ *  Copyright (C) 2009 Texas Instruments
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#ifndef ST_LL_H
+#define ST_LL_H
+
+#include <linux/skbuff.h>
+#include "st.h"
+#include "st_core.h"
+
+/* ST LL receiver states */
+#define ST_W4_PACKET_TYPE       0
+#define ST_BT_W4_EVENT_HDR      1
+#define ST_BT_W4_ACL_HDR        2
+#define ST_BT_W4_SCO_HDR        3
+#define ST_BT_W4_DATA           4
+#define ST_FM_W4_EVENT_HDR      5
+#define ST_GPS_W4_EVENT_HDR	6
+
+/* ST LL state machines */
+#define ST_LL_ASLEEP               0
+#define ST_LL_ASLEEP_TO_AWAKE      1
+#define ST_LL_AWAKE                2
+#define ST_LL_AWAKE_TO_ASLEEP      3
+#define ST_LL_INVALID		   4
+
+#define LL_SLEEP_IND	0x30
+#define LL_SLEEP_ACK	0x31
+#define LL_WAKE_UP_IND	0x32
+#define LL_WAKE_UP_ACK	0x33
+
+/* initialize and de-init ST LL */
+long st_ll_init(struct st_data_s *);
+long st_ll_deinit(struct st_data_s *);
+
+/* enable/disable ST LL along with KIM start/stop
+ * called by ST Core
+ */
+void st_ll_enable(struct st_data_s *);
+void st_ll_disable(struct st_data_s *);
+
+unsigned long st_ll_getstate(struct st_data_s *);
+unsigned long st_ll_sleep_state(struct st_data_s *, unsigned char);
+void st_ll_wakeup(struct st_data_s *);
+#endif /* ST_LL_H */
-- 
1.5.4.3

