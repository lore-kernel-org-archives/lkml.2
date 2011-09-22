Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab1IVEMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 00:12:32 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44015 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1IVEMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 00:12:31 -0400
From: tom.leiming@gmail.com
To: rjw@sisk.pl, stern@rowland.harvard.edu
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        Ming Lei <tom.leiming@gmail.com>
Subject: [RFC PATCH 2/2] PM/runtime: replace dev_dbg with trace_rpm_*
Date: Thu, 22 Sep 2011 12:11:41 +0800
Message-Id: <1316664701-15273-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316664701-15273-1-git-send-email-tom.leiming@gmail.com>
References: <1316664701-15273-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch replaces dev_dbg with trace_rpm_* inside
the three important functions:

	rpm_idle
	rpm_suspend
	rpm_resume

Trace points have the below advantages compared with dev_dbg:

	- trace points include much runtime information(such as
	running cpu, current task, ...)

	- most of linux distributions may disable "verbose debug"
	driver debug compile switch, so it is very difficult to
	report/debug runtime pm related problems from distribution
	users without this kind of debug information.

	- for upstream kernel users, enableing the debug switch will
	produce many useless "rpm_resume" output, and it is very noise.

	- dev_dbg inside rpm_suspend/rpm_resume may have some effects
	on runtime pm behaviour of console devicer

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/power/runtime.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index acb3f83..f41469a 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -9,6 +9,7 @@
 
 #include <linux/sched.h>
 #include <linux/pm_runtime.h>
+#include <trace/events/rpm.h>
 #include "power.h"
 
 static int rpm_resume(struct device *dev, int rpmflags);
@@ -171,6 +172,7 @@ static int rpm_idle(struct device *dev, int rpmflags)
 	int (*callback)(struct device *);
 	int retval;
 
+	trace_rpm_idle(dev, rpmflags);
 	retval = rpm_check_suspend_allowed(dev);
 	if (retval < 0)
 		;	/* Conditions are wrong. */
@@ -243,6 +245,7 @@ static int rpm_idle(struct device *dev, int rpmflags)
 	wake_up_all(&dev->power.wait_queue);
 
  out:
+	trace_rpm_return_int(dev, __func__, retval);
 	return retval;
 }
 
@@ -295,7 +298,7 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 	struct device *parent = NULL;
 	int retval;
 
-	dev_dbg(dev, "%s flags 0x%x\n", __func__, rpmflags);
+	trace_rpm_suspend(dev, rpmflags);
 
  repeat:
 	retval = rpm_check_suspend_allowed(dev);
@@ -430,7 +433,7 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 	}
 
  out:
-	dev_dbg(dev, "%s returns %d\n", __func__, retval);
+	trace_rpm_return_int(dev, __func__, retval);
 
 	return retval;
 }
@@ -459,7 +462,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
 	struct device *parent = NULL;
 	int retval = 0;
 
-	dev_dbg(dev, "%s flags 0x%x\n", __func__, rpmflags);
+	trace_rpm_resume(dev, rpmflags);
 
  repeat:
 	if (dev->power.runtime_error)
@@ -615,7 +618,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
 		spin_lock_irq(&dev->power.lock);
 	}
 
-	dev_dbg(dev, "%s returns %d\n", __func__, retval);
+	trace_rpm_return_int(dev, __func__, retval);
 
 	return retval;
 }
-- 
1.7.5.4

