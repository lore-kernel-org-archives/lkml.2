Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2DZJXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:23:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51679 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab2DZJXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:23:16 -0400
Date: Thu, 26 Apr 2012 02:23:03 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-e48b5e825f9c471cbcbfd934a4c2df27e9d39635@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1335300215-21427-1-git-send-email-john.stultz@linaro.org>
References: <1335300215-21427-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] rtc:
  Fix possible null pointer dereference in rtc-mpc5121.c
Git-Commit-ID: e48b5e825f9c471cbcbfd934a4c2df27e9d39635
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Apr 2012 02:23:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e48b5e825f9c471cbcbfd934a4c2df27e9d39635
Gitweb:     http://git.kernel.org/tip/e48b5e825f9c471cbcbfd934a4c2df27e9d39635
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Tue, 24 Apr 2012 13:43:35 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 11:17:01 +0200

rtc: Fix possible null pointer dereference in rtc-mpc5121.c

Mark Loard pointed out:
"For example, this beauty from rtc-mpc5121.c in the same update:
   ...
   rtc->rtc = rtc_device_register("mpc5200-rtc", &op->dev,
                                   &mpc5200_rtc_ops, THIS_MODULE);
   ...

   rtc->rtc->uie_unsupported = 1;    // <<<< Ooops NULL pointer >>>>

   if (IS_ERR(rtc->rtc)) {           // <<<< this needs to be earlier >>>>
           err = PTR_ERR(rtc->rtc);
           goto out_free_irq;
   }
   ..."

This patch moves setting the uie_unsupported flag to after we validate
the rtc->rtc pointer to resolve this.

Reported by: Mark Lord <kernel@teksavvy.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/1335300215-21427-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/rtc/rtc-mpc5121.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 42f5f82..029e421 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -360,12 +360,11 @@ static int __devinit mpc5121_rtc_probe(struct platform_device *op)
 						&mpc5200_rtc_ops, THIS_MODULE);
 	}
 
-	rtc->rtc->uie_unsupported = 1;
-
 	if (IS_ERR(rtc->rtc)) {
 		err = PTR_ERR(rtc->rtc);
 		goto out_free_irq;
 	}
+	rtc->rtc->uie_unsupported = 1;
 
 	return 0;
 
