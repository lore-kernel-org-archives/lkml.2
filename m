Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab2LCOq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:46:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43825 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932250Ab2LCOgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:38 -0500
Message-Id: <20121203143155.305870504@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:42 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bing Zhao <bzhao@marvell.com>, Tim Shepard <shep@laptop.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 56/89] mwifiex: fix system hang issue in cmd timeout error case
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit b1a47aa5e1e159e2cb06d7dfcc17ef5149b09299 upstream.

Reported by Tim Shepard:
I was seeing sporadic failures (wedgeups), and the majority of those
failures I saw printed the printouts in mwifiex_cmd_timeout_func with
cmd = 0xe5 which is CMD_802_11_HS_CFG_ENH.  When this happens, two
minutes later I get notified that the rtcwake thread is blocked, like
this:
      INFO: task rtcwake:3495 blocked for more than 120 seconds.

To get the hung thread unblocked we wake up the cmd wait queue and
cancel the ioctl.

Reported-by: Tim Shepard <shep@laptop.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/cmdevt.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -816,9 +816,6 @@ mwifiex_cmd_timeout_func(unsigned long f
 		return;
 	}
 	cmd_node = adapter->curr_cmd;
-	if (cmd_node->wait_q_enabled)
-		adapter->cmd_wait_q.status = -ETIMEDOUT;
-
 	if (cmd_node) {
 		adapter->dbg.timeout_cmd_id =
 			adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index];
@@ -863,6 +860,14 @@ mwifiex_cmd_timeout_func(unsigned long f
 
 		dev_err(adapter->dev, "ps_mode=%d ps_state=%d\n",
 				adapter->ps_mode, adapter->ps_state);
+
+		if (cmd_node->wait_q_enabled) {
+			adapter->cmd_wait_q.status = -ETIMEDOUT;
+			wake_up_interruptible(&adapter->cmd_wait_q.wait);
+			mwifiex_cancel_pending_ioctl(adapter);
+			/* reset cmd_sent flag to unblock new commands */
+			adapter->cmd_sent = false;
+		}
 	}
 	if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
 		mwifiex_init_fw_complete(adapter);


