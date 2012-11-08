Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2KHNm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:42:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64060 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab2KHNmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:42:23 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Deepak Sikri <deepak.sikri@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/3] input: spear-keyboard: Fix for balancing the enable_irq_wake
Date: Thu,  8 Nov 2012 19:10:49 +0530
Message-Id: <367241d1362f7b642e223bb7e7b108bc72df0851.1352381962.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
In-Reply-To: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Sikri <deepak.sikri@st.com>

This patch handles the fix for unbalanced irq for the cases when
enable_irq_wake fails, and a warning related to same is displayed
on the console. The workaround is handled at the driver level.

Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/input/keyboard/spear-keyboard.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index 9792924..b8784df 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -60,6 +60,7 @@ struct spear_kbd {
 	struct clk *clk;
 	unsigned int irq;
 	unsigned int mode;
+	unsigned int irq_wake;
 	unsigned short last_key;
 	unsigned short keycodes[NUM_ROWS * NUM_COLS];
 	bool rep;
@@ -327,7 +328,8 @@ static int spear_kbd_suspend(struct device *dev)
 	mode_ctl_reg = readl_relaxed(kbd->io_base + MODE_CTL_REG);
 
 	if (device_may_wakeup(&pdev->dev)) {
-		enable_irq_wake(kbd->irq);
+		if (!enable_irq_wake(kbd->irq))
+			kbd->irq_wake = 1;
 
 		/*
 		 * reprogram the keyboard operating frequency as on some
@@ -373,7 +375,10 @@ static int spear_kbd_resume(struct device *dev)
 	mutex_lock(&input_dev->mutex);
 
 	if (device_may_wakeup(&pdev->dev)) {
-		disable_irq_wake(kbd->irq);
+		if (kbd->irq_wake) {
+			kbd->irq_wake = 0;
+			disable_irq_wake(kbd->irq);
+		}
 	} else {
 		if (input_dev->users)
 			clk_enable(kbd->clk);
-- 
1.7.12.rc2.18.g61b472e

