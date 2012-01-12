Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab2ALOEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:04:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39433 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2ALODt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:03:49 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-serial@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH RFC 2/2] OMAP : serial : Check for error in get_context_loss_count
Date: Thu, 12 Jan 2012 19:33:39 +0530
Message-ID: <1326377019-23688-2-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1326377019-23688-1-git-send-email-shubhrajyoti@ti.com>
References: <1326377019-23688-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In serial_omap_runtime_resume in case of errors returned by
get_context_loss_count print a warning and do a restore.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
applies on Tony's uart branch

 drivers/tty/serial/omap-serial.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 29fe6fd..6008612 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1602,10 +1602,16 @@ static int serial_omap_runtime_resume(struct device *dev)
 
 	if (up) {
 		if (pdata->get_context_loss_count) {
-			u32 loss_cnt = pdata->get_context_loss_count(dev);
+			int loss_cnt = pdata->get_context_loss_count(dev);
 
-			if (up->context_loss_cnt != loss_cnt)
+			if (loss_cnt < 0) {
+				dev_err(dev,
+					"get_context_loss_count failed : %d\n",
+					loss_cnt);
 				serial_omap_restore_context(up);
+			} else if (up->context_loss_cnt != loss_cnt) {
+				serial_omap_restore_context(up);
+			}
 		}
 
 		/* Errata i291 */
-- 
1.7.1

