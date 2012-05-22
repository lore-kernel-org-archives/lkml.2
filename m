Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2EVLv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 07:51:27 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59497 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2EVLv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 07:51:26 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] remoteproc: block premature rproc booting
Date: Tue, 22 May 2012 14:51:12 +0300
Message-Id: <1337687472-23009-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an rproc instance is registered, remoteproc asynchronously
loads its firmware in order to tell which vdevs it supports.

Later on those vdevs are registered, and when probed, their drivers
usually trigger powering on of the remote processor.

OTOH, non-standard scenarios might involve early invocation of
rproc_boot even before the asynchronous fw loading has completed.

We're not sure we really want to support those scenarios, but right
now we do (e.g. via rproc_get_by_name), so let's simply fix this race
by blocking those premature rproc_boot() flows until the async fw
loading is completed.

Reported-and-tested-by: Sjur Brandeland <sjur.brandeland@stericsson.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/remoteproc_core.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 40e2b2d..464ea4f 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1141,6 +1141,18 @@ int rproc_boot(struct rproc *rproc)
 
 	dev = rproc->dev;
 
+	/*
+	 * if asynchronoush fw loading is underway, wait up to 65 secs
+	 * (just a bit more than the firmware request's timeout)
+	 */
+	ret = wait_for_completion_interruptible_timeout(
+					&rproc->firmware_loading_complete,
+					msecs_to_jiffies(65000));
+	if (ret <= 0) {
+		dev_err(dev, "async fw loading isn't complete: %d\n", ret);
+		return ret ? ret : -ETIMEDOUT;
+	}
+
 	ret = mutex_lock_interruptible(&rproc->lock);
 	if (ret) {
 		dev_err(dev, "can't lock rproc %s: %d\n", rproc->name, ret);
-- 
1.7.5.4

