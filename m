Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab2GRAKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:10:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48754 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab2GRAEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 16/37] iwlegacy: always monitor for stuck queues
Date: Tue, 17 Jul 2012 17:02:53 -0700
Message-Id: <20120717232432.678570654@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlegacy/common.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4767,14 +4767,12 @@ il_bg_watchdog(unsigned long data)
 		return;
 
 	/* monitor and check for other stuck queues */
-	if (il_is_any_associated(il)) {
-		for (cnt = 0; cnt < il->hw_params.max_txq_num; cnt++) {
-			/* skip as we already checked the command queue */
-			if (cnt == il->cmd_queue)
-				continue;
-			if (il_check_stuck_queue(il, cnt))
-				return;
-		}
+	for (cnt = 0; cnt < il->hw_params.max_txq_num; cnt++) {
+		/* skip as we already checked the command queue */
+		if (cnt == il->cmd_queue)
+			continue;
+		if (il_check_stuck_queue(il, cnt))
+			return;
 	}
 
 	mod_timer(&il->watchdog,


