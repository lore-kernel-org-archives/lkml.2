Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2LJLCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:02:23 -0500
Received: from smtp3.mundo-r.com ([212.51.32.191]:5570 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754679Ab2LJLAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:00:53 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 06:00:40 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApgDAJtkv1BbdWObgWdsb2JhbABEg0e6ZBYOAQEWJieCHgEtUjAfbwESiBTCKZB4A5JQgzOTOg
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, Alberto Garcia <agarcia@igalia.com>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 01/12] ipack/devices/ipoctal: Fix race condition during Tx
Date: Mon, 10 Dec 2012 11:49:57 +0100
Message-Id: <1355136608-22029-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alberto Garcia <agarcia@igalia.com>

In order to transmit data, the driver enables Tx and sleeps until
*board_write is set to 1 by the interrupt handler.

It can happen, though, that the data is sent even before the process
is asleep. In this case *board_write must be set to 1 anyway,
otherwise we will be waiting for a condition that will never be true.

Signed-off-by: Alberto Garcia <agarcia@igalia.com>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/devices/ipoctal.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index c06ab39..b312863 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -195,13 +195,10 @@ static void ipoctal_irq_tx(struct ipoctal_channel *channel)
 	*pointer_write = *pointer_write % PAGE_SIZE;
 	channel->nb_bytes--;
 
-	if ((channel->nb_bytes == 0) &&
-	    (waitqueue_active(&channel->queue))) {
-
-		if (channel->board_id != IPACK1_DEVICE_ID_SBS_OCTAL_485) {
-			*channel->board_write = 1;
-			wake_up_interruptible(&channel->queue);
-		}
+	if (channel->nb_bytes == 0 &&
+	    channel->board_id != IPACK1_DEVICE_ID_SBS_OCTAL_485) {
+		*channel->board_write = 1;
+		wake_up_interruptible(&channel->queue);
 	}
 }
 
-- 
1.7.10.4

