Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab2HUNgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:36:42 -0400
Received: from smtp-out-188.synserver.de ([212.40.185.188]:1298 "EHLO
	smtp-out-188.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2HUNgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:36:40 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3845
From: Lars-Peter Clausen <lars@metafoo.de>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] RTC: JZ4740: Fix IRQ error check
Date: Tue, 21 Aug 2012 15:32:11 +0200
Message-Id: <1345555932-13737-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irq field of the jz4740_irc struct is unsigned. Yet we assign the result of
platform_get_irq() to it. platform_get_irq() may return a negative error code
and the code checks for this condition by checking if 'irq' is less than zero.
But since 'irq' is unsigned this test will always be false. Fix it by making
'irq' signed.

The issue was found using the following coccinelle semantic patch:

//<smpl>
@@
type T;
unsigned T i;
@@
(
*i < 0
|
*i >= 0
)
//</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/rtc/rtc-jz4740.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index 05ab227..1224182 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -42,7 +42,7 @@ struct jz4740_rtc {
 
 	struct rtc_device *rtc;
 
-	unsigned int irq;
+	int irq;
 
 	spinlock_t lock;
 };
-- 
1.7.10.4

