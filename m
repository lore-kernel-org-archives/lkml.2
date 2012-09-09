Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab2IIXXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:23:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51500 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756389Ab2IIXRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:11 -0400
Message-Id: <20120909224156.436235107@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 41/95] PM / Runtime: Clear power.deferred_resume on success in
 rpm_suspend()
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 58a34de7b1a920d287d17d2ca08bc9aaf7e6d35b upstream.

The power.deferred_resume can only be set if the runtime PM status
of device is RPM_SUSPENDING and it should be cleared after its
status has been changed, regardless of whether or not the runtime
suspend has been successful.  However, it only is cleared on
suspend failure, while it may remain set on successful suspend and
is happily leaked to rpm_resume() executed in that case.

That shouldn't happen, so if power.deferred_resume is set in
rpm_suspend() after the status has been changed to RPM_SUSPENDED,
clear it before calling rpm_resume().  Then, it doesn't need to be
cleared before changing the status to RPM_SUSPENDING any more,
because it's always cleared after the status has been changed to
either RPM_SUSPENDED (on success) or RPM_ACTIVE (on failure).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/base/power/runtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 9891a85..b6e9d9b 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -388,7 +388,6 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 		goto repeat;
 	}
 
-	dev->power.deferred_resume = false;
 	if (dev->power.no_callbacks)
 		goto no_callback;	/* Assume success. */
 
@@ -440,6 +439,7 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 	wake_up_all(&dev->power.wait_queue);
 
 	if (dev->power.deferred_resume) {
+		dev->power.deferred_resume = false;
 		rpm_resume(dev, 0);
 		retval = -EAGAIN;
 		goto out;


