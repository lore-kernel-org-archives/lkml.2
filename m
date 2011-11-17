Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1KQXel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 18:34:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44816 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab1KQXej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 18:34:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / Sleep: Remove pm_runtime_suspended() from __pm_generic_call()
Date: Fri, 18 Nov 2011 00:37:22 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111180037.22157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The pm_runtime_suspended() check in __pm_generic_call() doesn't
really help and may cause problems to happen, because in some cases
the system suspend callbacks need to be called even if the given
device has been suspended by runtime PM.  For example, if the device
generally supports remote wakeup and is not enabled to wake up
the system from sleep, it should be prevented from generating wakeup
signals during system suspend and that has to be done by the
suspend callbacks that the pm_runtime_suspended() check prevents from
being executed.  For this reason, remove the pm_runtime_suspended()
check from __pm_generic_call().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/generic_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/base/power/generic_ops.c
===================================================================
--- linux.orig/drivers/base/power/generic_ops.c
+++ linux/drivers/base/power/generic_ops.c
@@ -106,7 +106,7 @@ static int __pm_generic_call(struct devi
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int (*callback)(struct device *);
 
-	if (!pm || pm_runtime_suspended(dev))
+	if (!pm)
 		return 0;
 
 	switch (event) {
