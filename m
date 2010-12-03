Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab0LCPGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:06:53 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:60376 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807Ab0LCPGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:06:49 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 11/20] mfd/tc3589x: fix random interrupt misses
Date: Fri, 3 Dec 2010 20:35:44 +0530
Message-ID: <1291388753-14662-12-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
In-Reply-To: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
References: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the TC35892, a random delayed interrupt clear (GPIO IC) write locks up the
child interrupts. In such a case, the original interrupt is active and not yet
acknowledged. Re-check the IRQST bit for any pending interrupts and handle
those.

Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
---
 drivers/mfd/tc3589x.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index 5672d56..e173f33 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -158,6 +158,7 @@ static irqreturn_t tc3589x_irq(int irq, void *data)
 	struct tc3589x *tc3589x = data;
 	int status;
 
+again:
 	status = tc3589x_reg_read(tc3589x, TC3589x_IRQST);
 	if (status < 0)
 		return IRQ_NONE;
@@ -172,9 +173,12 @@ static irqreturn_t tc3589x_irq(int irq, void *data)
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

