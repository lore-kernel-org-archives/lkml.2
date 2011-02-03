Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1BCCO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:14:58 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60838 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab1BCCO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:14:56 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/4] RTC: Fix rtc driver ioctl specific shortcutting
Date: Wed,  2 Feb 2011 18:14:41 -0800
Message-Id: <1296699283-6784-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
References: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some RTC drivers enable functionality directly via their ioctl method
instead of using the generic ioctl handling code. With the recent
virtualization of the RTC layer, its now important that the generic
layer always be used.

This patch moved the rtc driver ioctl method call to after the generic
ioctl processing is done. This allows hardware specific features or
ioctls to still function, while relying on the generic code for handling
everything else.

This patch on its own may more obviously break rtc drivers that
implement the alarm irq enablement via their ioctl method instead of
implementing the alarm_irq_enable method. Those drivers will be fixed
in a following patch. Additionaly, those drivers are already likely to
not be functioning reliably even without this patch.

CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-dev.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 212b16e..37c3cc1 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -154,19 +154,7 @@ static long rtc_dev_ioctl(struct file *file,
 	if (err)
 		goto done;
 
-	/* try the driver's ioctl interface */
-	if (ops->ioctl) {
-		err = ops->ioctl(rtc->dev.parent, cmd, arg);
-		if (err != -ENOIOCTLCMD) {
-			mutex_unlock(&rtc->ops_lock);
-			return err;
-		}
-	}
-
-	/* if the driver does not provide the ioctl interface
-	 * or if that particular ioctl was not implemented
-	 * (-ENOIOCTLCMD), we will try to emulate here.
-	 *
+	/*
 	 * Drivers *SHOULD NOT* provide ioctl implementations
 	 * for these requests.  Instead, provide methods to
 	 * support the following code, so that the RTC's main
@@ -329,7 +317,12 @@ static long rtc_dev_ioctl(struct file *file,
 		return err;
 
 	default:
-		err = -ENOTTY;
+		/* Finally try the driver's ioctl interface */
+		if (ops->ioctl) {
+			err = ops->ioctl(rtc->dev.parent, cmd, arg);
+			if (err == -ENOIOCTLCMD)
+				err = -ENOTTY;
+		}
 		break;
 	}
 
-- 
1.7.3.2.146.gca209

