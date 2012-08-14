Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2HNVgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:36:12 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39007 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab2HNVgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:36:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/3] PM / Runtime: Fix rpm_resume() return value for power.no_callbacks set
Date: Tue, 14 Aug 2012 23:38:18 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201208142334.45452.rjw@sisk.pl>
In-Reply-To: <201208142334.45452.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208142338.18797.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For devices whose power.no_callbacks flag is set, rpm_resume()
should return 1 if the device's parent is already active, so that
the callers of pm_runtime_get() don't think that they have to wait
for the device to resume (asynchronously) in that case (the core
won't queue up an asynchronous resume in that case, so there's
nothing to wait for anyway).

Modify the code accordingly (and make sure that an idle notification
will be queued up on success, even if 1 is to be returned).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/runtime.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
@@ -584,6 +584,7 @@ static int rpm_resume(struct device *dev
 		    || dev->parent->power.runtime_status == RPM_ACTIVE) {
 			atomic_inc(&dev->parent->power.child_count);
 			spin_unlock(&dev->parent->power.lock);
+			retval = 1;
 			goto no_callback;	/* Assume success. */
 		}
 		spin_unlock(&dev->parent->power.lock);
@@ -664,7 +665,7 @@ static int rpm_resume(struct device *dev
 	}
 	wake_up_all(&dev->power.wait_queue);
 
-	if (!retval)
+	if (retval >= 0)
 		rpm_idle(dev, RPM_ASYNC);
 
  out:

