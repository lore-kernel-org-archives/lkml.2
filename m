Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2AJVKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 16:10:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56390 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab2AJVKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 16:10:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / Domains: Fix build for CONFIG_PM_SLEEP unset
Date: Tue, 10 Jan 2012 22:13:59 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201102213.59555.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Some callback functions defined in drivers/base/power/domain.c are
only necessary if CONFIG_PM_SLEEP and they call some other functions
that are only available in that case.  For this reason, they should
not be compiled at all when CONFIG_PM_SLEEP is not set.

Reported-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -1429,6 +1429,8 @@ static int pm_genpd_default_restore_stat
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+
 /**
  * pm_genpd_default_suspend - Default "device suspend" for PM domians.
  * @dev: Device to handle.
@@ -1517,6 +1519,19 @@ static int pm_genpd_default_thaw(struct
 	return cb ? cb(dev) : pm_generic_thaw(dev);
 }
 
+#else /* !CONFIG_PM_SLEEP */
+
+#define pm_genpd_default_suspend	NULL
+#define pm_genpd_default_suspend_late	NULL
+#define pm_genpd_default_resume_early	NULL
+#define pm_genpd_default_resume		NULL
+#define pm_genpd_default_freeze		NULL
+#define pm_genpd_default_freeze_late	NULL
+#define pm_genpd_default_thaw_early	NULL
+#define pm_genpd_default_thaw		NULL
+
+#endif /* !CONFIG_PM_SLEEP */
+
 /**
  * pm_genpd_init - Initialize a generic I/O PM domain object.
  * @genpd: PM domain object to initialize.
