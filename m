Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2LOAUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:20:54 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34264 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab2LOAUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:20:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Jan-Matthias Braun <jan_braun@gmx.net>, Jiri Kosina <jkosina@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [Resend][PATCH] PM: Move disabling/enabling runtime PM to late suspend/early resume
Date: Sat, 15 Dec 2012 01:25:58 +0100
Message-ID: <3307221.dy6xvn45xe@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1988667.JSHu2WyJuF@vostro.rjw.lan>
References: <1988667.JSHu2WyJuF@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently, the PM core disables runtime PM for all devices right
after executing subsystem/driver .suspend() callbacks for them
and re-enables it right before executing subsystem/driver .resume()
callbacks for them.  This may lead to problems when there are
two devices such that the .suspend() callback executed for one of
them depends on runtime PM working for the other.  In that case,
if runtime PM has already been disabled for the second device,
the first one's .suspend() won't work correctly (and analogously
for resume).

To make those issues go away, make the PM core disable runtime PM
for devices right before executing subsystem/driver .suspend_late()
callbacks for them and enable runtime PM for them right after
executing subsystem/driver .resume_early() callbacks for them.  This
way the potential conflitcs between .suspend_late()/.resume_early()
and their runtime PM counterparts are still prevented from happening,
but the subtle ordering issues related to disabling/enabling runtime
PM for devices during system suspend/resume are much easier to avoid.

Reported-and-tested-by: Jan-Matthias Braun <jan_braun@gmx.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/power/runtime_pm.txt |    9 +++++----
 drivers/base/power/main.c          |    9 ++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

Index: linux/drivers/base/power/main.c
===================================================================
--- linux.orig/drivers/base/power/main.c
+++ linux/drivers/base/power/main.c
@@ -513,6 +513,8 @@ static int device_resume_early(struct de
 
  Out:
 	TRACE_RESUME(error);
+
+	pm_runtime_enable(dev);
 	return error;
 }
 
@@ -589,8 +591,6 @@ static int device_resume(struct device *
 	if (!dev->power.is_suspended)
 		goto Unlock;
 
-	pm_runtime_enable(dev);
-
 	if (dev->pm_domain) {
 		info = "power domain ";
 		callback = pm_op(&dev->pm_domain->ops, state);
@@ -930,6 +930,8 @@ static int device_suspend_late(struct de
 	pm_callback_t callback = NULL;
 	char *info = NULL;
 
+	__pm_runtime_disable(dev, false);
+
 	if (dev->power.syscore)
 		return 0;
 
@@ -1133,11 +1135,8 @@ static int __device_suspend(struct devic
 
  Complete:
 	complete_all(&dev->power.completion);
-
 	if (error)
 		async_error = error;
-	else if (dev->power.is_suspended)
-		__pm_runtime_disable(dev, false);
 
 	return error;
 }
Index: linux/Documentation/power/runtime_pm.txt
===================================================================
--- linux.orig/Documentation/power/runtime_pm.txt
+++ linux/Documentation/power/runtime_pm.txt
@@ -642,12 +642,13 @@ out the following operations:
   * During system suspend it calls pm_runtime_get_noresume() and
     pm_runtime_barrier() for every device right before executing the
     subsystem-level .suspend() callback for it.  In addition to that it calls
-    pm_runtime_disable() for every device right after executing the
-    subsystem-level .suspend() callback for it.
+    __pm_runtime_disable() with 'false' as the second argument for every device
+    right before executing the subsystem-level .suspend_late() callback for it.
 
   * During system resume it calls pm_runtime_enable() and pm_runtime_put_sync()
-    for every device right before and right after executing the subsystem-level
-    .resume() callback for it, respectively.
+    for every device right after executing the subsystem-level .resume_early()
+    callback and right after executing the subsystem-level .resume() callback
+    for it, respectively.
 
 7. Generic subsystem callbacks
 

