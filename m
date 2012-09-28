Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030379Ab2I1TCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:02:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030362Ab2I1TCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:02:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 177/262] PM / Runtime: Clear power.deferred_resume on success in rpm_suspend()
Date: Fri, 28 Sep 2012 11:51:46 -0700
Message-Id: <20120928183018.955444206@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/runtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -388,7 +388,6 @@ static int rpm_suspend(struct device *de
 		goto repeat;
 	}
 
-	dev->power.deferred_resume = false;
 	if (dev->power.no_callbacks)
 		goto no_callback;	/* Assume success. */
 
@@ -440,6 +439,7 @@ static int rpm_suspend(struct device *de
 	wake_up_all(&dev->power.wait_queue);
 
 	if (dev->power.deferred_resume) {
+		dev->power.deferred_resume = false;
 		rpm_resume(dev, 0);
 		retval = -EAGAIN;
 		goto out;


