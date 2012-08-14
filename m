Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2HNVgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:36:09 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:38997 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab2HNVgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:36:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/3] PM / Runtime: Clear power.deferred_resume on success in rpm_suspend()
Date: Tue, 14 Aug 2012 23:40:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201208142334.45452.rjw@sisk.pl>
In-Reply-To: <201208142334.45452.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208142340.45153.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The power.deferred_resume can only be set if the runtime PM status
of device is RPM_SUSPENDING and it should be cleared after its
status has been changed, regardless of whether or not the runtime
suspend has been successful.  However, it only is cleared on suspend
failure, while it may remain set after successful suspend and is
happily leaked to rpm_resume() executed in that case.

That shouldn't happen, so if power.deferred_resume is set in
rpm_suspend() after the status has been changed to RPM_SUSPENDED,
clear it before calling rpm_resume().  Then, it doesn't need to be
cleared before changing the status to RPM_SUSPENDING any more,
because it's always cleared after the status has been changed to
either RPM_SUSPENDED (on success) or RPM_ACTIVE (on failure).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/runtime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
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

