Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1DGJty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:49:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:47466 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab1DGJtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:49:52 -0400
Date: Thu, 7 Apr 2011 09:48:56 GMT
From: tip-bot for Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, torvalds@linux-foundation.org,
        john.stultz@linaro.org, tglx@linutronix.de, feng.tang@intel.com,
        a.zummo@towertech.it, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        john.stultz@linaro.org, tglx@linutronix.de, feng.tang@intel.com,
        a.zummo@towertech.it, mingo@elte.hu
In-Reply-To: <1302140384-27571-1-git-send-email-feng.tang@intel.com>
References: <1302140384-27571-1-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] rtc, x86/mrst/vrtc: Fix boot crash in rtc_read_alarm()
Message-ID: <tip-de97a21a23dda34f1754a748560dede139e6bfc2@git.kernel.org>
Git-Commit-ID: de97a21a23dda34f1754a748560dede139e6bfc2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 09:48:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de97a21a23dda34f1754a748560dede139e6bfc2
Gitweb:     http://git.kernel.org/tip/de97a21a23dda34f1754a748560dede139e6bfc2
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Thu, 7 Apr 2011 09:39:44 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 7 Apr 2011 11:27:42 +0200

rtc, x86/mrst/vrtc: Fix boot crash in rtc_read_alarm()

Commit f44f7f96a20 ("RTC: Initialize kernel state from RTC") caused a
boot regression on the MRST platform.

The reason is that rtc_device_register() calls rtc_read_alarm() after
that change, which function does not have all driver data set up yet.

The rtc-mrst driver needs to call dev_set_drvdata() before rtc_device_register()
gets called.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1302140384-27571-1-git-send-email-feng.tang@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/rtc/rtc-mrst.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index 332a2c4..b2f0968 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -342,6 +342,8 @@ vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 
 	mrst_rtc.irq = rtc_irq;
 	mrst_rtc.iomem = iomem;
+	mrst_rtc.dev = dev;
+	dev_set_drvdata(dev, &mrst_rtc);
 
 	mrst_rtc.rtc = rtc_device_register(driver_name, dev,
 				&mrst_rtc_ops, THIS_MODULE);
@@ -350,8 +352,6 @@ vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 		goto cleanup0;
 	}
 
-	mrst_rtc.dev = dev;
-	dev_set_drvdata(dev, &mrst_rtc);
 	rename_region(iomem, dev_name(&mrst_rtc.rtc->dev));
 
 	spin_lock_irq(&rtc_lock);
@@ -376,9 +376,10 @@ vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 	return 0;
 
 cleanup1:
-	mrst_rtc.dev = NULL;
 	rtc_device_unregister(mrst_rtc.rtc);
 cleanup0:
+	dev_set_drvdata(dev, NULL);
+	mrst_rtc.dev = NULL;
 	release_region(iomem->start, iomem->end + 1 - iomem->start);
 	dev_err(dev, "rtc-mrst: unable to initialise\n");
 	return retval;
