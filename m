Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135Ab2I1VYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:24:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838Ab2I1U3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:29:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 142/218] PM / Runtime: Fix rpm_resume() return value for power.no_callbacks set
Date: Fri, 28 Sep 2012 13:15:59 -0700
Message-Id: <20120928201517.784759676@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 7f321c26c04807834fef4c524d2b21573423fc74 upstream.

For devices whose power.no_callbacks flag is set, rpm_resume()
should return 1 if the device's parent is already active, so that
the callers of pm_runtime_get() don't think that they have to wait
for the device to resume (asynchronously) in that case (the core
won't queue up an asynchronous resume in that case, so there's
nothing to wait for anyway).

Modify the code accordingly (and make sure that an idle notification
will be queued up on success, even if 1 is to be returned).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/runtime.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -652,6 +652,7 @@ static int rpm_resume(struct device *dev
 		    || dev->parent->power.runtime_status == RPM_ACTIVE) {
 			atomic_inc(&dev->parent->power.child_count);
 			spin_unlock(&dev->parent->power.lock);
+			retval = 1;
 			goto no_callback;	/* Assume success. */
 		}
 		spin_unlock(&dev->parent->power.lock);
@@ -735,7 +736,7 @@ static int rpm_resume(struct device *dev
 	}
 	wake_up_all(&dev->power.wait_queue);
 
-	if (!retval)
+	if (retval >= 0)
 		rpm_idle(dev, RPM_ASYNC);
 
  out:


