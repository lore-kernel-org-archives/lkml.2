Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab1G0HHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 03:07:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1G0HHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 03:07:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=is3W+lf14QFugSdPn+T2aiVfJCTiX7v5/VCKul+7rbYycU6mcc3NAgvimiJLh9wyc
	RppqlYyoLzMZN28p2pfaw==
From: Todd Poynor <toddpoynor@google.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Todd Poynor <toddpoynor@google.com>
Subject: [PATCH 1/2] rtc: twl: Use threaded IRQ, remove IRQ enable in interrupt handler
Date: Wed, 27 Jul 2011 00:07:20 -0700
Message-Id: <1311750441-5559-1-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQs disabled on entry to twl_rtc_interrupt is not a consequence
of LOCKDEP; both twl6030 and twl4030 explicitly disable IRQs
before calling the module IRQ handlers.

The ISR should not be enabling IRQs; use a threaded IRQ handler
instead.

Also fixes warnings:

  WARNING: at kernel/irq/handle.c:130 handle_irq_event_percpu+nnn
  irq nnn handler twl_rtc_interrupt+nnn enabled interrupts

Signed-off-by: Todd Poynor <toddpoynor@google.com>
---
 drivers/rtc/rtc-twl.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 9a81f77..ece41b9 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -362,14 +362,6 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 	int res;
 	u8 rd_reg;
 
-#ifdef CONFIG_LOCKDEP
-	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
-	 * we don't want and can't tolerate.  Although it might be
-	 * friendlier not to borrow this thread context...
-	 */
-	local_irq_enable();
-#endif
-
 	res = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
@@ -462,9 +454,9 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out1;
 
-	ret = request_irq(irq, twl_rtc_interrupt,
-				IRQF_TRIGGER_RISING,
-				dev_name(&rtc->dev), rtc);
+	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
+				   IRQF_TRIGGER_RISING,
+				   dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
 		goto out1;
-- 
1.7.3.1

