Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab2K3TTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:19:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:58610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992797Ab2K3S4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tim Shepard <shep@laptop.org>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 14/56] mwifiex: fix system hang issue in cmd timeout error case
Date: Fri, 30 Nov 2012 10:55:06 -0800
Message-Id: <20121130185119.792867202@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -864,6 +861,14 @@ mwifiex_cmd_timeout_func(unsigned long f
 
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


