Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2GWBwm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:52:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54356 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415Ab2GWBnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:20 -0400
Message-Id: <20120723010659.631554663@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 054/108] iwlegacy: always monitor for stuck queues
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit c2ca7d92ed4bbd779516beb6eb226e19f7f7ab0f upstream.

This is iwlegacy version of:

commit 342bbf3fee2fa9a18147e74b2e3c4229a4564912
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Sun Mar 4 08:50:46 2012 -0800

    iwlwifi: always monitor for stuck queues

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

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust filename, function and variable names]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -1884,14 +1884,12 @@ void iwl_legacy_bg_watchdog(unsigned lon
 		return;
 
 	/* monitor and check for other stuck queues */
-	if (iwl_legacy_is_any_associated(priv)) {
-		for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
-			/* skip as we already checked the command queue */
-			if (cnt == priv->cmd_queue)
-				continue;
-			if (iwl_legacy_check_stuck_queue(priv, cnt))
-				return;
-		}
+	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
+		/* skip as we already checked the command queue */
+		if (cnt == priv->cmd_queue)
+			continue;
+		if (iwl_legacy_check_stuck_queue(priv, cnt))
+			return;
 	}
 
 	mod_timer(&priv->watchdog, jiffies +


