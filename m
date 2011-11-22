Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab1KVOCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:02:38 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:37013 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab1KVOCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:02:37 -0500
From: Corey Minyard <cminyard@mvista.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] ipmi_watchdog: Restore settings when BMC reset
Date: Tue, 22 Nov 2011 08:01:37 -0600
Message-id: <1321970497-3865-1-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.7.4.1
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the BMC gets reset, it will return 0x80 response errors.  In this case,
it is probably a good idea to restore the IPMI settings.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Tested-by: Arkadiusz Miśkiewicz <a.miskiewicz@gmail.com>
---
 drivers/char/ipmi/ipmi_watchdog.c |   41 ++++++++++++++++++++++++++++++++++--
 1 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index c2917ffa..34767a6 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -139,6 +139,8 @@
 #define IPMI_WDOG_SET_TIMER		0x24
 #define IPMI_WDOG_GET_TIMER		0x25
 
+#define IPMI_WDOG_TIMER_NOT_INIT_RESP	0x80
+
 /* These are here until the real ones get into the watchdog.h interface. */
 #ifndef WDIOC_GETTIMEOUT
 #define	WDIOC_GETTIMEOUT        _IOW(WATCHDOG_IOCTL_BASE, 20, int)
@@ -596,6 +598,7 @@ static int ipmi_heartbeat(void)
 	struct kernel_ipmi_msg            msg;
 	int                               rv;
 	struct ipmi_system_interface_addr addr;
+	int				  timeout_retries = 0;
 
 	if (ipmi_ignore_heartbeat)
 		return 0;
@@ -616,6 +619,7 @@ static int ipmi_heartbeat(void)
 
 	mutex_lock(&heartbeat_lock);
 
+restart:
 	atomic_set(&heartbeat_tofree, 2);
 
 	/*
@@ -653,7 +657,33 @@ static int ipmi_heartbeat(void)
 	/* Wait for the heartbeat to be sent. */
 	wait_for_completion(&heartbeat_wait);
 
-	if (heartbeat_recv_msg.msg.data[0] != 0) {
+	if (heartbeat_recv_msg.msg.data[0] == IPMI_WDOG_TIMER_NOT_INIT_RESP)  {
+		timeout_retries++;
+		if (timeout_retries > 3) {
+			printk(KERN_ERR PFX ": Unable to restore the IPMI"
+			       " watchdog's settings, giving up.\n");
+			rv = -EIO;
+			goto out_unlock;
+		}
+
+		/*
+		 * The timer was not initialized, that means the BMC was
+		 * probably reset and lost the watchdog information.  Attempt
+		 * to restore the timer's info.  Note that we still hold
+		 * the heartbeat lock, to keep a heartbeat from happening
+		 * in this process, so must say no heartbeat to avoid a
+		 * deadlock on this mutex.
+		 */
+		rv = ipmi_set_timeout(IPMI_SET_TIMEOUT_NO_HB);
+		if (rv) {
+			printk(KERN_ERR PFX ": Unable to send the command to"
+			       " set the watchdog's settings, giving up.\n");
+			goto out_unlock;
+		}
+
+		/* We might need a new heartbeat, so do it now */
+		goto restart;
+	} else if (heartbeat_recv_msg.msg.data[0] != 0) {
 		/*
 		 * Got an error in the heartbeat response.  It was already
 		 * reported in ipmi_wdog_msg_handler, but we should return
@@ -662,6 +692,7 @@ static int ipmi_heartbeat(void)
 		rv = -EINVAL;
 	}
 
+out_unlock:
 	mutex_unlock(&heartbeat_lock);
 
 	return rv;
@@ -922,11 +953,15 @@ static struct miscdevice ipmi_wdog_miscdev = {
 static void ipmi_wdog_msg_handler(struct ipmi_recv_msg *msg,
 				  void                 *handler_data)
 {
-	if (msg->msg.data[0] != 0) {
+	if (msg->msg.cmd == IPMI_WDOG_RESET_TIMER &&
+			msg->msg.data[0] == IPMI_WDOG_TIMER_NOT_INIT_RESP)
+		printk(KERN_INFO PFX "response: The IPMI controller appears"
+		       " to have been reset, will attempt to reinitialize"
+		       " the watchdog timer\n");
+	else if (msg->msg.data[0] != 0)
 		printk(KERN_ERR PFX "response: Error %x on cmd %x\n",
 		       msg->msg.data[0],
 		       msg->msg.cmd);
-	}
 
 	ipmi_free_recv_msg(msg);
 }
-- 
1.7.4.1

