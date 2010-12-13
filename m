Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab0LMEEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 23:04:52 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:55650 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754206Ab0LMEED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 23:04:03 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: <linux-kernel@vger.kernel.org>, Sundar Iyer <sundar.iyer@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v2 6/8] mfd/tc3589x: fix random interrupt misses
Date: Mon, 13 Dec 2010 09:33:16 +0530
Message-ID: <1292212998-13066-7-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
References: <1292212998-13066-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the TC35892, a random delayed interrupt clear (GPIO IC) write locks up the
child interrupts. In such a case, the original interrupt is active and not yet
acknowledged. Re-check the IRQST bit for any pending interrupts and handle
those.

Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/mfd/tc3589x.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 0ed9669..708349a 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -142,6 +142,7 @@ static irqreturn_t tc3589x_irq(int irq, void *data)
 	struct tc3589x *tc3589x = data;
 	int status;
 
+again:
 	status = tc3589x_reg_read(tc3589x, TC3589x_IRQST);
 	if (status < 0)
 		return IRQ_NONE;
@@ -156,9 +157,12 @@ static irqreturn_t tc3589x_irq(int irq, void *data)
 	/*
 	 * A dummy read or write (to any register) appears to be necessary to
 	 * have the last interrupt clear (for example, GPIO IC write) take
-	 * effect.
+	 * effect. In such a case, recheck for any interrupt which is still
+	 * pending.
 	 */
-	tc3589x_reg_read(tc3589x, TC3589x_IRQST);
+	status = tc3589x_reg_read(tc3589x, TC3589x_IRQST);
+	if (status)
+		goto again;
 
 	return IRQ_HANDLED;
 }
-- 
1.7.2.dirty

