Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab1ERTVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:21:10 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:51444 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933723Ab1ERTVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:21:02 -0400
Subject: [PATCH 1/2] of: fix race when matching drivers
To: devicetree-discuss@lists.ozlabs.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        sparclinux@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, Josip Rodin <joy@entuzijast.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 18 May 2011 13:21:00 -0600
Message-ID: <20110518192100.28986.94335.stgit@ponder>
In-Reply-To: <20110518185751.28986.69446.stgit@ponder>
References: <20110518185751.28986.69446.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milton Miller <miltonm@bga.com>

If two drivers are probing devices at the same time, both will write
their match table result to the dev->of_match cache at the same time.

Only write the result if the device matches.

In a thread titled "SBus devices sometimes detected, sometimes not",
Meelis reported his SBus hme was not detected about 50% of the time.
>From the debug suggested by Grant it was obvious another driver matched
some devices between the call to match the hme and the hme discovery
failling.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Milton Miller <miltonm@bga.com>
[grant.likely: modified to only call of_match_device() once]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 include/linux/of_device.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 8bfe6c1..b33d688 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -21,8 +21,12 @@ extern void of_device_make_bus_id(struct device *dev);
 static inline int of_driver_match_device(struct device *dev,
 					 const struct device_driver *drv)
 {
-	dev->of_match = of_match_device(drv->of_match_table, dev);
-	return dev->of_match != NULL;
+	const struct of_device_id *match;
+
+	match = of_match_device(drv->of_match_table, dev);
+	if (match)
+		dev->of_match = match;
+	return match != NULL;
 }
 
 extern struct platform_device *of_dev_get(struct platform_device *dev);

