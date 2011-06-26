Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab1FZU63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 16:58:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59223 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046Ab1FZU6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 16:58:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/2] PM / Runtime: Improve documentation of enable, disable and barrier
Date: Sun, 26 Jun 2011 22:58:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <201106262257.10769.rjw@sisk.pl>
In-Reply-To: <201106262257.10769.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106262258.00401.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The runtime PM documentation in Documentation/power/runtime_pm.txt
doesn't say that pm_runtime_enable() and pm_runtime_disable() work by
operating on power.disable_depth, which is wrong, because the
possibility of nesting disables doesn't follow from the description
of these functions.  Also, there is no description of
pm_runtime_barrier() at all in the document, which is confusing.
Improve the documentation by fixing those issues.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -369,17 +369,27 @@ drivers/base/power/runtime.c and include
       pm_runtime_autosuspend(dev) and return its result
 
   void pm_runtime_enable(struct device *dev);
-    - enable the run-time PM helper functions to run the device bus type's
-      run-time PM callbacks described in Section 2
+    - decrement the device's 'power.disable_depth' field; if that field is equal
+      to zero, the run-time PM helper functions can execute subsystem-level
+      callbacks described in Section 2 for the device
 
   int pm_runtime_disable(struct device *dev);
-    - prevent the run-time PM helper functions from running subsystem-level
-      run-time PM callbacks for the device, make sure that all of the pending
+    - increment the device's 'power.disable_depth' field (if the value of that
+      field was previously zero, this prevents subsystem-level runtime PM
+      callbacks from being run for the device), make sure that all of the pending
       run-time PM operations on the device are either completed or canceled;
       returns 1 if there was a resume request pending and it was necessary to
       execute the subsystem-level resume callback for the device to satisfy that
       request, otherwise 0 is returned
 
+  int pm_runtime_barrier(struct device *dev);
+    - check if there's a resume request pending for the device and resume it
+      (synchronously) in that case, cancel any other pending runtime PM requests
+      regarding it and wait for all runtime PM operations on it in progress to
+      complete; returns 1 if there was a resume request pending and it was
+      necessary to execute the subsystem-level resume callback for the device to
+      satisfy that request, otherwise 0 is returned
+
   void pm_suspend_ignore_children(struct device *dev, bool enable);
     - set/unset the power.ignore_children flag of the device
 

