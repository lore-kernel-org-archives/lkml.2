Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab2LLUbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:31:31 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38118 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2LLUba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:31:30 -0500
From: Ido Yariv <ido@wizery.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH] hwspinlock/core: Fix unbalanced module_get on error path
Date: Wed, 12 Dec 2012 22:24:57 +0200
Message-Id: <1355343897-17063-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case pm_runtime_get_sync() fails, __hwspin_lock_request will exit
without calling module_put. As a result, the module could never be
removed. Fix this.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/hwspinlock/hwspinlock_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index db713c0..085e28e 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -415,6 +415,7 @@ static int __hwspin_lock_request(struct hwspinlock *hwlock)
 	/* notify PM core that power is now needed */
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
+		module_put(dev->driver->owner);
 		dev_err(dev, "%s: can't power on device\n", __func__);
 		return ret;
 	}
-- 
1.7.7.6

