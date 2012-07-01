Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2GASS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:18:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47027 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001Ab2GASQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:48 -0400
Message-Id: <20120701172012.213943044@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mandeep Singh Baines <msb@chromium.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 39/48] PM / Sleep: Prevent waiting forever on asynchronous suspend after
 abort
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mandeep Singh Baines <msb@chromium.org>

commit 1f758b23177d588a71b96ad02990e715949bb82f upstream.

__device_suspend() must always send a completion. Otherwise, parent
devices will wait forever.

Commit 1e2ef05b, "PM: Limit race conditions between runtime PM and
system sleep (v2)", introduced a regression by short-circuiting the
complete_all() for certain error cases.

This patch fixes the bug by always signalling a completion.

Addresses http://crosbug.com/31972

Tested by injecting an abort.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/base/power/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index e0fb5b0..9cb845e 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1031,7 +1031,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	dpm_wait_for_children(dev, async);
 
 	if (async_error)
-		return 0;
+		goto Complete;
 
 	pm_runtime_get_noresume(dev);
 	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
@@ -1040,7 +1040,7 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	if (pm_wakeup_pending()) {
 		pm_runtime_put_sync(dev);
 		async_error = -EBUSY;
-		return 0;
+		goto Complete;
 	}
 
 	device_lock(dev);
@@ -1097,6 +1097,8 @@ static int __device_suspend(struct device *dev, pm_message_t state, bool async)
 	}
 
 	device_unlock(dev);
+
+ Complete:
 	complete_all(&dev->power.completion);
 
 	if (error) {


