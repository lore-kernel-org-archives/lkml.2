Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482Ab2EJNvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:51:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48101 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab2EJNvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:51:04 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>, <andrew@lunn.ch>,
        Shubhrajyoti D <shubhrajyoti@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH RFC] spi: Dont call prepare/unprepare transfer if not populated
Date: Thu, 10 May 2012 19:20:41 +0530
Message-ID: <1336657841-2306-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the prepare/unprepare transfer are called unconditionally.
The assumption is that every driver using the spi core queue infrastructure
has to populate the prepare and unprepare functions. This encourages
drivers to populate empty functions to prevent crashing.
This patch prevents the call to prepare/unprepare if not populated.

Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---

 drivers/spi/spi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 37c555e..30e114c 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -532,7 +532,7 @@ static void spi_pump_messages(struct kthread_work *work)
 	/* Lock queue and check for queue work */
 	spin_lock_irqsave(&master->queue_lock, flags);
 	if (list_empty(&master->queue) || !master->running) {
-		if (master->busy) {
+		if (master->busy &&  master->unprepare_transfer_hardware) {
 			ret = master->unprepare_transfer_hardware(master);
 			if (ret) {
 				spin_unlock_irqrestore(&master->queue_lock, flags);
@@ -562,7 +562,7 @@ static void spi_pump_messages(struct kthread_work *work)
 		master->busy = true;
 	spin_unlock_irqrestore(&master->queue_lock, flags);
 
-	if (!was_busy) {
+	if (!was_busy && master->prepare_transfer_hardware) {
 		ret = master->prepare_transfer_hardware(master);
 		if (ret) {
 			dev_err(&master->dev,
-- 
1.7.5.4

