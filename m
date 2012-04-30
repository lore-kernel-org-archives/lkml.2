Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab2D3Gnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:43:40 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:52322 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab2D3Gni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:43:38 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz2dh2a8h668h839h93fhd24hd2bhbe9i)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH] Watchdog: Fix for settimeout issue
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>, <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Apr 2012 12:10:31 +0530
Message-ID: <1335768031.9546.20.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices have a fixed minimum elapse time and a ping before this
elapse time causes error condition. This patch fix this issue in the
settimeout operation.
---
 drivers/watchdog/watchdog_dev.c |    7 ++++++-
 include/linux/watchdog.h        |    3 +++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 8558da9..fb6076c 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -41,6 +41,7 @@
 #include <linux/miscdevice.h>	/* For handling misc devices */
 #include <linux/init.h>		/* For __init/__exit/... */
 #include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
+#include <linux/delay.h>	/* For delay (like mdelay) */
 
 /* make sure we only register one /dev/watchdog device */
 static unsigned long watchdog_dev_busy;
@@ -228,7 +229,11 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 			return err;
 		/* If the watchdog is active then we send a keepalive ping
 		 * to make sure that the watchdog keep's running (and if
-		 * possible that it takes the new timeout) */
+		 * possible that it takes the new timeout) Also we care
+		 * for watchdog which needs min elapse time before a ping.
+		 */
+		if (wdd->min_elapse_time)
+			mdelay(wdd->min_elapse_time);
 		watchdog_ping(wdd);
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index ac40716..37d25b8 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -95,6 +95,8 @@ struct watchdog_ops {
  * @timeout:	The watchdog devices timeout value.
  * @min_timeout:The watchdog devices minimum timeout value.
  * @max_timeout:The watchdog devices maximum timeout value.
+ * @min_elapse_time: The watchdog devices minimum elapse time before
+ *		the ping.
  * @driver-data:Pointer to the drivers private data.
  * @status:	Field that contains the devices internal status bits.
  *
@@ -111,6 +113,7 @@ struct watchdog_device {
 	unsigned int timeout;
 	unsigned int min_timeout;
 	unsigned int max_timeout;
+	unsigned int min_elapse_time;
 	void *driver_data;
 	unsigned long status;
 /* Bit numbers for status flags */


