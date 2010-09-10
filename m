Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0IJSsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:48:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40039 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab0IJSrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:47:55 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [RFC 3/3] include:linux: make ti_wilink_st like the rest
Date: Fri, 10 Sep 2010 15:58:58 -0400
Message-Id: <1284148738-21643-5-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1284148738-21643-4-git-send-email-pavan_savoy@ti.com>
References: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-3-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-4-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

ti_wilink_st.h now is similar to other headers in include/linux.
The st_ll dependency on ti_wilink_st is also fixed.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/st_ll.c |    2 +
 include/linux/ti_wilink_st.h  |   51 +++++++++++++++++++++++-----------------
 2 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/ti-st/st_ll.c b/drivers/staging/ti-st/st_ll.c
index e899920..15e4028 100644
--- a/drivers/staging/ti-st/st_ll.c
+++ b/drivers/staging/ti-st/st_ll.c
@@ -19,6 +19,8 @@
  */
 
 #define pr_fmt(fmt) "(stll) :" fmt
+#include <linux/module.h>
+#include <linux/skbuff.h>
 #include <linux/ti_wilink_st.h>
 
 /**********************************************************************/
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index df8d2ee..a563e09 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -26,12 +26,18 @@
 #ifndef ST_H
 #define ST_H
 
-#include <linux/skbuff.h>
+#ifdef __KERNEL__
+#include <linux/skbuff.h>	/* for sk_buff */
+#include <linux/rfkill.h>	/* for rfkill */
+#include <linux/tty.h>		/* for tty_struct */
+#include <linux/tty_ldisc.h>	/* for tty_ldisc_ops */
+
+#endif
 
 /* TODO:
  * Move the following to tty.h upon acceptance
  */
-#define N_TI_WL	20	/* Ldisc for TI's WL BT, FM, GPS combo chips */
+#define N_TI_WL	22	/* Ldisc for TI's WL BT, FM, GPS combo chips */
 
 /**
  * enum kim_gpio_state - Few protocols such as FM have ACTIVE LOW
@@ -292,10 +298,10 @@ void kim_st_list_protocols(struct st_data_s *, void *);
  *	relevant procedure to be called.
  */
 struct bts_header {
-	uint32_t magic;
-	uint32_t version;
-	uint8_t future[24];
-	uint8_t actions[0];
+	unsigned long magic;
+	unsigned long version;
+	unsigned char future[24];
+	unsigned char actions[0];
 } __attribute__ ((packed));
 
 /**
@@ -303,28 +309,28 @@ struct bts_header {
  *	data.
  */
 struct bts_action {
-	uint16_t type;
-	uint16_t size;
-	uint8_t data[0];
+	unsigned short type;
+	unsigned short size;
+	unsigned char data[0];
 } __attribute__ ((packed));
 
 struct bts_action_send {
-	uint8_t data[0];
+	unsigned char data[0];
 } __attribute__ ((packed));
 
 struct bts_action_wait {
-	uint32_t msec;
-	uint32_t size;
-	uint8_t data[0];
+	unsigned long msec;
+	unsigned long size;
+	unsigned char data[0];
 } __attribute__ ((packed));
 
 struct bts_action_delay {
-	uint32_t msec;
+	unsigned long msec;
 } __attribute__ ((packed));
 
 struct bts_action_serial {
-	uint32_t baud;
-	uint32_t flow_control;
+	unsigned long baud;
+	unsigned long flow_control;
 } __attribute__ ((packed));
 
 /**
@@ -334,10 +340,10 @@ struct bts_action_serial {
  *	when it receives request from KIM for ldisc installation.
  */
 struct hci_command {
-	uint8_t prefix;
-	uint16_t opcode;
-	uint8_t plen;
-	uint32_t speed;
+	unsigned char prefix;
+	unsigned short opcode;
+	unsigned char plen;
+	unsigned long speed;
 } __attribute__ ((packed));
 
 /**
@@ -386,6 +392,7 @@ void st_ll_wakeup(struct st_data_s *);
 
 /**
  * structures and declarations used by the st_core for FM packets
+ * and GPS packets
  */
 struct fm_event_hdr {
 	unsigned char plen;
@@ -397,8 +404,8 @@ struct fm_event_hdr {
 
 /* gps stuff */
 struct gps_event_hdr {
-unsigned char opcode;
-unsigned short plen;
+	unsigned char opcode;
+	unsigned short plen;
 } __attribute__ ((packed));
 
 #endif /* ST_H */
-- 
1.6.5

