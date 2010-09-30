Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0JAAbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 20:31:03 -0400
Received: from gimli.pxnet.com ([89.1.7.7]:34819 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0JAAbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 20:31:00 -0400
X-Greylist: delayed 3367 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Sep 2010 20:30:56 EDT
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20100930-patch-gigaset-06.tilman@imap.cc>
In-Reply-To: <20100930-patch-gigaset-00.tilman@imap.cc>
References: <20100930-patch-gigaset-00.tilman@imap.cc>
Subject: [PATCH 6/9] isdn/gigaset: try USB reset for bas_gigaset error recovery
Date: Fri,  1 Oct 2010 01:35:21 +0200 (CEST)
X-Spam-Score: -1.995 () AWL,BAYES_00,RDNS_DYNAMIC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In error_reset(), if sending HD_RESET_INTERRUPT_PIPE to the device
fails, try performing an USB reset.
Also correct an error in the leading comment.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/bas-gigaset.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index e865c5d..7520bc6 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -350,7 +350,7 @@ static inline void error_hangup(struct bc_state *bcs)
  * reset Gigaset device because of an unrecoverable error
  * This function may be called from any context, and takes care of
  * scheduling the necessary actions for execution outside of interrupt context.
- * cs->lock must not be held.
+ * cs->hw.bas->lock must not be held.
  * argument:
  *	controller state structure
  */
@@ -358,7 +358,9 @@ static inline void error_reset(struct cardstate *cs)
 {
 	/* reset interrupt pipe to recover (ignore errors) */
 	update_basstate(cs->hw.bas, BS_RESETTING, 0);
-	req_submit(cs->bcs, HD_RESET_INTERRUPT_PIPE, 0, BAS_TIMEOUT);
+	if (req_submit(cs->bcs, HD_RESET_INTERRUPT_PIPE, 0, BAS_TIMEOUT))
+		/* submission failed, escalate to USB port reset */
+		usb_queue_reset_device(cs->hw.bas->interface);
 }
 
 /* check_pending
-- 
1.7.3.15.g442cb

