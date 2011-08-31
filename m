Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1HaKWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:22:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51172 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1HaKWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:22:35 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-33-4e5e0b683ce6
Date: Wed, 31 Aug 2011 19:21:50 +0900
From: Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH] rtc: rtc-s3c: fix no occurrence of alarm interrupt
To: rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com
Message-id: <1314786110-1297-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 31 Aug 2011 10:23:09.0723 (UTC)
 FILETIME=[FB2F36B0:01CC67C7]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver does not generate alarm interrupt
even though time for alarm is set.
This results from disabling rtc_clk after setting time for alarm.
To generate alarm interrupt,
the driver should maintain enabled state for rtc_clk
until alarm interrupt occurs.
This patch allows to generate alarm interrupt.

Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/rtc-s3c.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 4e7c04e..b68697e 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -50,6 +50,27 @@ static bool wake_en;
 static enum s3c_cpu_type s3c_rtc_cpu_type;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
+static DEFINE_SPINLOCK(s3c_rtc_alarm_clk_lock);
+
+static void s3c_rtc_alarm_clk_enable(bool enable)
+{
+	static bool alarm_clk_enabled;
+	unsigned long irq_flags;
+
+	spin_lock_irqsave(&s3c_rtc_alarm_clk_lock, irq_flags);
+	if (enable) {
+		if (!alarm_clk_enabled) {
+			clk_enable(rtc_clk);
+			alarm_clk_enabled = true;
+		}
+	} else {
+		if (alarm_clk_enabled) {
+			clk_disable(rtc_clk);
+			alarm_clk_enabled = false;
+		}
+	}
+	spin_unlock_irqrestore(&s3c_rtc_alarm_clk_lock, irq_flags);
+}
 
 /* IRQ Handlers */
 
@@ -64,6 +85,9 @@ static irqreturn_t s3c_rtc_alarmirq(int irq, void *id)
 		writeb(S3C2410_INTP_ALM, s3c_rtc_base + S3C2410_INTP);
 
 	clk_disable(rtc_clk);
+
+	s3c_rtc_alarm_clk_enable(false);
+
 	return IRQ_HANDLED;
 }
 
@@ -97,6 +121,8 @@ static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
 	clk_disable(rtc_clk);
 
+	s3c_rtc_alarm_clk_enable(enabled);
+
 	return 0;
 }
 
-- 
1.7.4.1

