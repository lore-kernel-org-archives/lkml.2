Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935695Ab2C3W1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:27:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935615Ab2C3VK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:10:56 -0400
Message-Id: <20120330194842.919336481@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Cahill <ben.m.cahill@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 043/149] iwlwifi: always monitor for stuck queues
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 342bbf3fee2fa9a18147e74b2e3c4229a4564912 upstream.

If we only monitor while associated, the following
can happen:
 - we're associated, and the queue stuck check
   runs, setting the queue "touch" time to X
 - we disassociate, stopping the monitoring,
   which leaves the time set to X
 - almost 2s later, we associate, and enqueue
   a frame
 - before the frame is transmitted, we monitor
   for stuck queues, and find the time set to
   X, although it is now later than X + 2000ms,
   so we decide that the queue is stuck and
   erroneously restart the device

It happens more with P2P because there we can
go between associated/unassociated frequently.

Reported-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-core.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1787,20 +1787,10 @@ void iwl_bg_watchdog(unsigned long data)
 	if (timeout == 0)
 		return;
 
-	/* monitor and check for stuck cmd queue */
-	if (iwl_check_stuck_queue(priv, priv->shrd->cmd_queue))
-		return;
-
-	/* monitor and check for other stuck queues */
-	if (iwl_is_any_associated(priv)) {
-		for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
-			/* skip as we already checked the command queue */
-			if (cnt == priv->shrd->cmd_queue)
-				continue;
-			if (iwl_check_stuck_queue(priv, cnt))
-				return;
-		}
-	}
+	/* monitor and check for stuck queues */
+	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++)
+		if (iwl_check_stuck_queue(priv, cnt))
+			return;
 
 	mod_timer(&priv->watchdog, jiffies +
 		  msecs_to_jiffies(IWL_WD_TICK(timeout)));


