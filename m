Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2LOGEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 01:04:53 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:46031 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750802Ab2LOGDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 01:03:45 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 2/6] staging/fwserial: Remove bandwidth limit logic
Date: Sat, 15 Dec 2012 01:03:16 -0500
Message-Id: <1355551400-8204-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
References: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Self-limiting asynchronous bandwidth (via reducing the payload)
is not necessary and does not work, because
 1) asynchronous traffic will absorb all available bandwidth (less that
    being used for isochronous traffic)
 2) isochronous arbitration always wins.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c |  3 ---
 drivers/staging/fwserial/fwserial.h | 15 ++++++---------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 61ee290..be5db8a 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -40,12 +40,10 @@ static int num_ttys = 4;	    /* # of std ttys to create per fw_card    */
 				    /* - doubles as loopback port index       */
 static bool auto_connect = true;    /* try to VIRT_CABLE to every peer        */
 static bool create_loop_dev = true; /* create a loopback device for each card */
-bool limit_bw;			    /* limit async bandwidth to 20% of max    */
 
 module_param_named(ttys, num_ttys, int, S_IRUGO | S_IWUSR);
 module_param_named(auto, auto_connect, bool, S_IRUGO | S_IWUSR);
 module_param_named(loop, create_loop_dev, bool, S_IRUGO | S_IWUSR);
-module_param(limit_bw, bool, S_IRUGO | S_IWUSR);
 
 /*
  * Threshold below which the tty is woken for writing
@@ -2940,4 +2938,3 @@ MODULE_DEVICE_TABLE(ieee1394, fwserial_id_table);
 MODULE_PARM_DESC(ttys, "Number of ttys to create for each local firewire node");
 MODULE_PARM_DESC(auto, "Auto-connect a tty to each firewire node discovered");
 MODULE_PARM_DESC(loop, "Create a loopback device, fwloop<n>, with ttys");
-MODULE_PARM_DESC(limit_bw, "Limit bandwidth utilization to 20%.");
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index 8b572ed..cb0eea0 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -351,7 +351,6 @@ struct fw_serial {
 #define TTY_DEV_NAME		    "fwtty"	/* ttyFW was taken           */
 static const char tty_dev_name[] =  TTY_DEV_NAME;
 static const char loop_dev_name[] = "fwloop";
-extern bool limit_bw;
 
 struct tty_driver *fwtty_driver;
 
@@ -370,18 +369,16 @@ static inline void fwtty_bind_console(struct fwtty_port *port,
 
 /*
  * Returns the max send async payload size in bytes based on the unit device
- * link speed - if set to limit bandwidth to max 20%, use lookup table
+ * link speed. Self-limiting asynchronous bandwidth (via reducing the payload)
+ * is not necessary and does not work, because
+ *   1) asynchronous traffic will absorb all available bandwidth (less that
+ *	being used for isochronous traffic)
+ *   2) isochronous arbitration always wins.
  */
 static inline int link_speed_to_max_payload(unsigned speed)
 {
-	static const int max_async[] = { 307, 614, 1229, 2458, 4916, 9832, };
-	BUILD_BUG_ON(ARRAY_SIZE(max_async) - 1 != SCODE_3200);
-
 	speed = clamp(speed, (unsigned) SCODE_100, (unsigned) SCODE_3200);
-	if (limit_bw)
-		return max_async[speed];
-	else
-		return 1 << (speed + 9);
+	return 1 << (speed + 9);
 }
 
 #endif /* _FIREWIRE_FWSERIAL_H */
-- 
1.8.0.1

