Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2AYLf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:35:57 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48358 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2AYLf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:35:56 -0500
Date: Wed, 25 Jan 2012 12:35:38 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC] regulator: Reverse the disable sequence in
 regulator_bulk_disable()
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com
Cc: linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        Richard Purdie <rpurdie@rpsys.net>, Timur Tabi <timur@freescale.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1327491338-18817-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.7.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Often there is a need for disabling a set of regulators in order opposite
to the enable order. Currently the function regulator_bulk_disable() walks
list of regulators in same order as regulator_bulk_enable(). This may cause
trouble, especially for devices with mixed analogue and digital circuits.
So reverse the disabling sequence of regulator_bulk_disable().
While at it, also correct the comment.

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Steve Glendinning <steve.glendinning@smsc.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Timur Tabi <timur@freescale.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
The alternatives to directly modifying regulator_bulk_disable() could be:

 - re-implement it in modules that need the order reversed; it is not
   really helpful in practice since such code would have to be repeated
   in multiple modules;

 - create new function, e.g. regulator_bulk_disable_reversed() with the
   order reversed - not sure if it is not an overkill though;
---
 drivers/regulator/core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e9a83f8..67db4a6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2463,8 +2463,8 @@ EXPORT_SYMBOL_GPL(regulator_bulk_enable);
  * @return         0 on success, an errno on failure
  *
  * This convenience API allows consumers to disable multiple regulator
- * clients in a single API call.  If any consumers cannot be enabled
- * then any others that were disabled will be disabled again prior to
+ * clients in a single API call.  If any consumers cannot be disabled
+ * then any others that were disabled will be enabled again prior to
  * return.
  */
 int regulator_bulk_disable(int num_consumers,
@@ -2473,7 +2473,7 @@ int regulator_bulk_disable(int num_consumers,
 	int i;
 	int ret;
 
-	for (i = 0; i < num_consumers; i++) {
+	for (i = num_consumers - 1; i >= 0; --i) {
 		ret = regulator_disable(consumers[i].consumer);
 		if (ret != 0)
 			goto err;
@@ -2483,7 +2483,7 @@ int regulator_bulk_disable(int num_consumers,
 
 err:
 	pr_err("Failed to disable %s: %d\n", consumers[i].supply, ret);
-	for (--i; i >= 0; --i)
+	for (++i; i < num_consumers; ++i)
 		regulator_enable(consumers[i].consumer);
 
 	return ret;
-- 
1.7.8.3

