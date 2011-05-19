Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab1ESSVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:21:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57182 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933927Ab1ESSIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:13 -0400
X-Sasl-enc: QuntaM1gfu8wd2n8UYjAUqB0Mah/L9gvzUcHUvfjhaJh 1305828492
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:56 2011
Message-Id: <20110519180556.304313981@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [21/71] drivers/rtc/rtc-s3c.c: fixup wake support for rtc
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Dooks <ben-linux@fluff.org>

commit 52cd4e5c620af9e21b5298bf01844b98573505a7 upstream.

The driver is not balancing set_irq and disable_irq_wake() calls, so
ensure that it keeps track of whether the wake is enabled.

The fixes the following error on S3C6410 devices:

  WARNING: at kernel/irq/manage.c:382 set_irq_wake+0x84/0xec()
  Unbalanced IRQ 92 wake disable

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-s3c.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -46,6 +46,7 @@ static struct clk *rtc_clk;
 static void __iomem *s3c_rtc_base;
 static int s3c_rtc_alarmno = NO_IRQ;
 static int s3c_rtc_tickno  = NO_IRQ;
+static bool wake_en;
 static enum s3c_cpu_type s3c_rtc_cpu_type;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
@@ -597,8 +598,12 @@ static int s3c_rtc_suspend(struct platfo
 	}
 	s3c_rtc_enable(pdev, 0);
 
-	if (device_may_wakeup(&pdev->dev))
-		enable_irq_wake(s3c_rtc_alarmno);
+	if (device_may_wakeup(&pdev->dev) && !wake_en) {
+		if (enable_irq_wake(s3c_rtc_alarmno) == 0)
+			wake_en = true;
+		else
+			dev_err(&pdev->dev, "enable_irq_wake failed\n");
+	}
 
 	return 0;
 }
@@ -614,8 +619,10 @@ static int s3c_rtc_resume(struct platfor
 		writew(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
 	}
 
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(&pdev->dev) && wake_en) {
 		disable_irq_wake(s3c_rtc_alarmno);
+		wake_en = false;
+	}
 
 	return 0;
 }


