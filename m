Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab2HNVgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:36:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39004 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab2HNVgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:36:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/3] PM / Runtime: Check device PM QoS setting before "no callbacks" check
Date: Tue, 14 Aug 2012 23:41:50 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201208142334.45452.rjw@sisk.pl>
In-Reply-To: <201208142334.45452.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208142341.50852.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If __dev_pm_qos_read_value(dev) returns a negative value,
rpm_suspend() should return -EPERM for dev even if its
power.no_callbacks flag is set.  For this to happen, the device's
power.no_callbacks flag has to be checked after the PM QoS check,
so modify the code accordingly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/runtime.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/drivers/base/power/runtime.c
===================================================================
--- linux.orig/drivers/base/power/runtime.c
+++ linux/drivers/base/power/runtime.c
@@ -388,6 +388,12 @@ static int rpm_suspend(struct device *de
 		goto repeat;
 	}
 
+	if (__dev_pm_qos_read_value(dev) < 0) {
+		/* Negative PM QoS constraint means "never suspend". */
+		retval = -EPERM;
+		goto out;
+	}
+
 	if (dev->power.no_callbacks)
 		goto no_callback;	/* Assume success. */
 
@@ -402,12 +408,6 @@ static int rpm_suspend(struct device *de
 		goto out;
 	}
 
-	if (__dev_pm_qos_read_value(dev) < 0) {
-		/* Negative PM QoS constraint means "never suspend". */
-		retval = -EPERM;
-		goto out;
-	}
-
 	__update_runtime_status(dev, RPM_SUSPENDING);
 
 	if (dev->pm_domain)

